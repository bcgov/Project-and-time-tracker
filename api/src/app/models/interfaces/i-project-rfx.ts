import { IProject } from './i-project';
import { IRfxType } from './i-rfx-type';
import { IRfxPhase } from './i-rfx-phase';

export interface IProjectRfx {
  id: string;  
  project: IProject;
  rfxType: IRfxType;
  rfxPhase: IRfxPhase;
  rfxOverview: string;
  clientResponsibilities: string;
  psdResponsibilities: string;
}
