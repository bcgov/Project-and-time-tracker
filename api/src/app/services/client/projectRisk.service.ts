import { getRepository, Repository } from "typeorm";
import { RiskQuestions } from "../../models/entities/riskQuestions.entity";
// import { IRiskQuestions } from "../../models/interfaces/i-risk-questions";

const riskRepo = (): Repository<RiskQuestions> => {
  return getRepository(RiskQuestions);
};

export const retrieveQuestions = async () => {
  const repo = riskRepo();
  return await repo
    .createQueryBuilder("q")
    .orderBy("q.questionNo", "DESC")
    .select([
      'q.id AS "id"',
      'q.question AS "question"',
      'q.category AS "category"',
      'q.riskLevel AS "riskLevel"',
      'q."questionNo" AS "questionNo"'
    ])
    .getRawMany();
};


