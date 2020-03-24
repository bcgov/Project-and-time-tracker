import { getRepository, Repository } from 'typeorm';
import { RiskQuestions } from '../../models/entities/riskQuestions.entity';
import { RiskAnswers } from '../../models/entities/riskAnswers.entity';
import { ProjectRiskAnalysis } from '../../models/entities/projectRiskAnalysis.entity';
import { ProjectIntake } from '../../models/entities/projectIntake.entity';
import { IProjectRiskAnalysis } from '../../models/interfaces/i-project-risk-analysis';

const riskRepo = (): Repository<RiskQuestions> => {
  return getRepository(RiskQuestions);
};
const riskAnsRespo = (): Repository<RiskAnswers> => {
  return getRepository(RiskAnswers);
};
const riskAnalysisRespo = (): Repository<ProjectRiskAnalysis> => {
  return getRepository(ProjectRiskAnalysis);
};
const intakeRepo = (): Repository<ProjectIntake> => {
  return getRepository(ProjectIntake);
};
export const retrieveQuestions = async () => {
  const repo = riskRepo();

  const res = await repo
    .createQueryBuilder('q')
    .orderBy('q.category', 'ASC')
    .addOrderBy('q.questionNo', 'ASC')
    .select([
      'q.id AS "id"',
      'q.question AS "question"',
      'q.category AS "category"',
      'q.is_PSB AS "is_PSB"',
      'q.riskLevel AS "riskLevel"',
      'q.questionNo AS "questionNo"'
    ])
    .where ('q."is_PSB" = :is_PSB', {is_PSB : false})
    .getRawMany();
  for (let index = 0; index < res.length; index++) {
    res[index].answer = await retrieveAnswersByQuestionId(res[index].id);
  }
  return res;
};

export const retrieveAnswersByQuestionId = async (id: string) => {
  const repo = riskAnsRespo();

  const res = await repo
    .createQueryBuilder('ans')

    .orderBy('ans.order_id', 'ASC')
    .innerJoinAndSelect(RiskQuestions, 'q', 'ans."questionId" = q.id')
    .where('ans."questionId" = :id', { id: id })
    .getMany();
  if (!res) {
    throw Error(`Answers not found for the id specified: ${id}`);
  }
  return res;
};
export const retrieveProjectQuestions = async (id: string) => {
  const repo = riskAnalysisRespo();

  const res = await repo
    .createQueryBuilder('an')
    .innerJoinAndSelect('an.question', 'q')
    .innerJoinAndSelect('an.answer', 'a')
    .innerJoinAndSelect('an.intake', 'i')
    .orderBy('q.riskLevel', 'ASC')
    .addOrderBy('q.questionNo', 'ASC')
    .select([
      'an.id AS "id"',
      'q.question AS "question"',
      'a.answer AS "answer"',
      'q.id AS "questionId"',
      'a.id AS "answerid"',
      'a.score AS "score"',
      'a.order_id AS "order_id"',
      'q.riskLevel AS "riskLevel"',
      'q.questionNo AS "questionNo"',
      'i.id AS "intakeId"'
    ])
    .where('i.projectId = :id', { id: id })
    .getRawMany();
  return res;
};
export const CreateRiskAnalysis = async (
  obj: IProjectRiskAnalysis | IProjectRiskAnalysis[]
) => {
  if (Array.isArray(obj)) {
    const arr: any = [];
    for (let index = 0; index < obj.length; index++) {
      arr.push(await CreateRiskAnalysis(obj[index]));
    }
    return arr;
  }
  const ProjectRisk: ProjectRiskAnalysis = riskAnalysisRespo().create(obj);
  ProjectRisk.dateCreated = new Date();
  ProjectRisk.dateModified = new Date();
  await riskAnalysisRespo().save(ProjectRisk);
  return ProjectRisk;
};

export const updateRiskAnalysis = async (obj, projectId) => {
  const repoIntake = intakeRepo();
  const intakeRes = await repoIntake
    .createQueryBuilder('i')
    .where('i.projectId = :id', { id: projectId })
    .getOne();
  if (!intakeRes)
    throw Error(`Intake entry not found for project : ${projectId}`);
  for (let index = 0; index < obj.length; index++) {
    const repo = riskAnalysisRespo();
    if (obj[index].id) {
      const res = await repo
        .createQueryBuilder('an')
        .innerJoinAndSelect('an.question', 'q')
        .leftJoinAndSelect('an.answer', 'a')
        .innerJoinAndSelect('an.intake', 'i')
        .where('an.id = :id and an.intake = :intakeId', {
          id: obj[index].id,
          intakeId: intakeRes.id
        })
        .getOne();
      if (!res) {
        throw Error(`risk analysis not found for : ${obj[index].id}`);
      }
      res.answer = obj[index].answerId;
      res.score = obj[index].score;
      await riskAnalysisRespo().save(res);
    } else if (obj[index].answerId != null) {
      let ProjectRisk: ProjectRiskAnalysis = riskAnalysisRespo().create();
      ProjectRisk.answer = obj[index].answerId;
      ProjectRisk.intake = intakeRes;
      ProjectRisk.question = obj[index].questionId;
      ProjectRisk.score = obj[index].score;
      ProjectRisk.dateCreated = new Date();
      ProjectRisk.dateModified = new Date();
      await riskAnalysisRespo().save(ProjectRisk);
    }
  }
};
