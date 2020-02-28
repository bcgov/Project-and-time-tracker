import { IRiskQuestions } from "./i-risk-questions";
import { IRiskAnswers } from "./i-risk-answers";
export interface IProjectRiskAnalysis {
  id: string;
  question: IRiskQuestions;
  answer: IRiskAnswers;
  score: number;
  projectId: string;
  IntakeId: string;
}
