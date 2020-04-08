INSERT INTO public.risk_questions (id,question,category,"riskLevel","questionNo","is_PSB","isStrategicContact") VALUES 
('2d4fd180-ef23-4134-8014-be2ec8ed1ec5','Will there be high public interest in the project?',4,2,2,false,true)
,('a19f05bd-8172-4994-b991-fc717b0e46f2','Are there any unique socio-economic considerations that must be taken into account?',4,2,1,false,false)
,('7867249a-657a-489a-9203-1754ed8885cc','How many separate contracts are estimated as a result this procurement project?',1,1,2,false,false)
,('1f71e8bc-5b88-40c3-ab99-553368ebf685','How many Ministries or BPS Entities are directly involved in the procurement project?',2,2,2,false,true)
,('c81159f4-42bb-48b1-8338-592df3b43eff','Will the services being procured be public facing?',2,2,4,true,true)
,('ec300240-d516-40d4-b9b3-8a23d8f4e951','Will the resulting contract offer government an opportunity for innovation or modernization?',2,2,3,false,true)
,('94ec86da-f955-4e3d-b0ba-932b3044abdb','When is the expected date of the contract execution or start date?',2,2,1,false,false)
,('e11046b5-dfcf-4343-aff8-651670cc783f','Does the organization anticipate a shortage of available internal personnel with appropriate skills during a significant period of the project? (i.e. SME''s, PM''s, Change Management, etc.)',3,2,2,false,false)
,('a08e56db-b334-4270-affc-a8f6e2c0fd0a','What level of priority is the project to the owning Ministry?',3,2,1,false,false)
,('183b80f2-4688-41fd-ae1c-5a6e7f777c3f','Does this procurement project have a documented project plan with clearly identified Roles & Responsibilities?',1,2,3,true,false)
;
INSERT INTO public.risk_questions (id,question,category,"riskLevel","questionNo","is_PSB","isStrategicContact") VALUES 
('e969a6eb-2819-445f-a3f5-1aad40ad75b4','What is the estimated Total Contract Value of this procurement project?',1,1,1,false,false)
;




INSERT INTO public.risk_answers (id,answer,score,order_id,"questionId") VALUES 
('4ddd151e-751c-43e3-9f07-794b1003de70','Potentially',2,2,'2d4fd180-ef23-4134-8014-be2ec8ed1ec5')
,('cb3d0fec-11c3-467e-a688-0307910225f7','Yes',3,3,'2d4fd180-ef23-4134-8014-be2ec8ed1ec5')
,('2d8b22af-1b06-4728-830a-2fb0726b85ca','No',1,1,'2d4fd180-ef23-4134-8014-be2ec8ed1ec5')
,('cf38beb1-58af-43c3-be69-0706a0806df8','Five or more contracts',10,5,'7867249a-657a-489a-9203-1754ed8885cc')
,('2cc39349-373b-4aa6-9046-9bd23fa24610','One contract',2,1,'7867249a-657a-489a-9203-1754ed8885cc')
,('e6379225-7cd4-48e9-9d3b-7fee086dd006','Two contracts',4,2,'7867249a-657a-489a-9203-1754ed8885cc')
,('88ea130f-75dd-4dc1-a12d-4f0d6c4e81e5','Three contracts',6,3,'7867249a-657a-489a-9203-1754ed8885cc')
,('07b9cbd0-719b-4f07-8713-ff220267239c','Four contracts',8,4,'7867249a-657a-489a-9203-1754ed8885cc')
,('1836784b-ed08-44b7-a898-8cf3f5119fe4','Potentially',2,2,'a19f05bd-8172-4994-b991-fc717b0e46f2')
,('f45d442e-ab56-4067-ab93-86ee3fa0d595','Yes',3,3,'a19f05bd-8172-4994-b991-fc717b0e46f2')
;
INSERT INTO public.risk_answers (id,answer,score,order_id,"questionId") VALUES 
('848bd7de-d59d-4175-8851-04c5c104ab9a','No',1,1,'a19f05bd-8172-4994-b991-fc717b0e46f2')
,('af07c63d-4c96-40ad-83e5-a9e06ab64fb6','over $10 million',10,5,'e969a6eb-2819-445f-a3f5-1aad40ad75b4')
,('78500ca2-c957-4999-96a2-360e5ec78f45','>50k',2,1,'e969a6eb-2819-445f-a3f5-1aad40ad75b4')
,('41a02614-dae7-4c48-b1d6-b4c241e2d62f','>250k',4,2,'e969a6eb-2819-445f-a3f5-1aad40ad75b4')
,('f24e1de4-824b-4eec-aac0-5dade4d3c2b9','500k-1 million',6,3,'e969a6eb-2819-445f-a3f5-1aad40ad75b4')
,('23a93640-3a41-44b9-9f9a-71ee45f7bffb','$1-10 million',8,4,'e969a6eb-2819-445f-a3f5-1aad40ad75b4')
,('9c5029ec-f3c0-4a28-be70-433f1a1122cb','No opportunity for innovation',1,1,'ec300240-d516-40d4-b9b3-8a23d8f4e951')
,('5641fe2c-a6d2-4434-9d0b-15a1c99bbb22','Potential opportunity',2,2,'ec300240-d516-40d4-b9b3-8a23d8f4e951')
,('6c175262-5a0e-4120-b1ac-1fd3d65943ba','Some opportunity',3,3,'ec300240-d516-40d4-b9b3-8a23d8f4e951')
,('e047e857-e7d8-468e-8380-d2990f3bc384','Definite opportunity for innovation',4,4,'ec300240-d516-40d4-b9b3-8a23d8f4e951')
;
INSERT INTO public.risk_answers (id,answer,score,order_id,"questionId") VALUES 
('c581d97e-a8de-4456-b124-2b988262a81f','Yes or Not Required',1,1,'183b80f2-4688-41fd-ae1c-5a6e7f777c3f')
,('b36e7eff-a464-4417-89b8-0a11ce629fe7','Partially',2,2,'183b80f2-4688-41fd-ae1c-5a6e7f777c3f')
,('c21977d3-6311-447b-aea5-0fb7d725326a','No',3,3,'183b80f2-4688-41fd-ae1c-5a6e7f777c3f')
,('d0abe350-e32f-427d-b6cc-b22ad1fc9893','In over 24 months',5,5,'94ec86da-f955-4e3d-b0ba-932b3044abdb')
,('464f4657-85c0-47b3-8a09-4097d0df174f','In under 1 month',1,1,'94ec86da-f955-4e3d-b0ba-932b3044abdb')
,('df250e69-b749-46b8-9aaa-97fca80ce0b0','In 2-6 months',2,2,'94ec86da-f955-4e3d-b0ba-932b3044abdb')
,('0c8e249f-bc3a-4b7c-ab30-bebc1b95d0d0','In 7-12 months',3,3,'94ec86da-f955-4e3d-b0ba-932b3044abdb')
,('576e0081-9202-47c0-b888-686dd29f820a','In 12-24 months',4,4,'94ec86da-f955-4e3d-b0ba-932b3044abdb')
,('beeb71d9-b976-483d-a00b-070d5b648f92','The project involves only one Ministry or Entity.',1,1,'1f71e8bc-5b88-40c3-ab99-553368ebf685')
,('ff3978b8-3025-4e2e-aac3-7873b6cc74d9','The project involves two other Ministries or Entities.',2,2,'1f71e8bc-5b88-40c3-ab99-553368ebf685')
;
INSERT INTO public.risk_answers (id,answer,score,order_id,"questionId") VALUES 
('0eeae774-9273-4fa1-bcf4-a0072bf69821','The project involves three other Ministries or Entities.',3,3,'1f71e8bc-5b88-40c3-ab99-553368ebf685')
,('7e5e6063-6e37-415e-9367-b2f9ab1c7f5f','The project involves at least four other Ministries or Entities.',4,4,'1f71e8bc-5b88-40c3-ab99-553368ebf685')
,('77cb51a1-66e4-4f5e-a2ce-5b8e6600753c','Yes',4,4,'c81159f4-42bb-48b1-8338-592df3b43eff')
,('f6319753-11fe-4e28-8ed4-6195a6b9bbb7','No',1,1,'c81159f4-42bb-48b1-8338-592df3b43eff')
,('19dc1942-b79f-447b-9004-29f0a299ac6a','Limited',2,2,'c81159f4-42bb-48b1-8338-592df3b43eff')
,('087c00f6-9541-413b-b300-a8f3f6e5bd69','Some',3,3,'c81159f4-42bb-48b1-8338-592df3b43eff')
,('7748816d-ab15-448d-a4b7-a14476d247d1','The project is a critical priority: all resources necessary will be allocated to it.',1,1,'a08e56db-b334-4270-affc-a8f6e2c0fd0a')
,('917b957a-4614-4421-bb32-25f317028005','The project is a normal priority: resources may be shared with a project of equal or higher priority.',3,2,'a08e56db-b334-4270-affc-a8f6e2c0fd0a')
,('cd589aa2-f653-4121-abb0-746c54b42a1b','The project is a not a priority: resources may be diverted to a project of equal or higher priority.',5,3,'a08e56db-b334-4270-affc-a8f6e2c0fd0a')
,('efe7a811-e2b2-4136-ac76-ad5754236d5c','No',1,1,'e11046b5-dfcf-4343-aff8-651670cc783f')
;
INSERT INTO public.risk_answers (id,answer,score,order_id,"questionId") VALUES 
('c94f6e3a-f9d0-4347-9786-46c439664e99','Yes',3,2,'e11046b5-dfcf-4343-aff8-651670cc783f')
;