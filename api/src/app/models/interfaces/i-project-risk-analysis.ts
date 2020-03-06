import { IRiskQuestions } from './i-risk-questions';
import { IRiskAnswers } from './i-risk-answers';
import { IProjectIntake } from './i-project-intake';
export interface IProjectRiskAnalysis {
  id: string;
  question: IRiskQuestions;
  answer: IRiskAnswers;
  score: number;
  intake: IProjectIntake;
}
