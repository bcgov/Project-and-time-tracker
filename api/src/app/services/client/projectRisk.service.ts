import { getRepository, Repository } from 'typeorm';
import { RiskQuestions } from '../../models/entities/riskQuestions.entity';
import { RiskAnswers } from '../../models/entities/riskAnswers.entity';
// import { IRiskQuestions } from "../../models/interfaces/i-risk-questions";

const riskRepo = (): Repository<RiskQuestions> => {
  return getRepository(RiskQuestions);
};
const riskAnsRespo = (): Repository<RiskAnswers> => {
  return getRepository(RiskAnswers);
};

export const retrieveQuestions = async () => {
  const repo = riskRepo();
  
  const res =  await repo
    .createQueryBuilder('q')
    .orderBy('q.questionNo', 'ASC')    
    .select([
      'q.id AS "id"',
      'q.question AS "question"',
      'q.category AS "category"',
      'q.riskLevel AS "riskLevel"',
      'q."questionNo" AS "questionNo"'
    ])
    .getRawMany();   
   for (let index = 0; index < res.length; index++) {   
      res[index].answer = await retrieveAnswersByQuestionId(res[index].id);       
    }
  return res

};

export const retrieveAnswersByQuestionId = async (id: string) => {
  const repo = riskAnsRespo();
  
  const res = await repo
    .createQueryBuilder('ans')
    
    .orderBy('ans.score', 'ASC')
    .innerJoinAndSelect(RiskQuestions, 'q', 'ans."questionId" = q.id')                
    .where('ans."questionId" = :id', { id: id })                      
    .getMany();
  if (!res) {
    throw Error(`Answers not found for the id specified: ${id}`);
  }
  return res;
};



