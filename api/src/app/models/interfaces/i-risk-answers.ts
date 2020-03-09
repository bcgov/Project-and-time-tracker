import { IRiskQuestions } from './i-risk-questions';
export interface IRiskAnswers {
  id: string;
  question: IRiskQuestions;
  answer: string;
  score: number;
}
