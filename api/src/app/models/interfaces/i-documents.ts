import { BinaryData } from 'fs';

export interface IDocuments {
  id: string;
  mimetype: string;
  data: BinaryData;
  version: string;
}
