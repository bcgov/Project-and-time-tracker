INSERT INTO ministry("ministryName") VALUES ('Education');
INSERT INTO ministry("ministryName") VALUES ('Energy, Mines & Petroleum Resources');
INSERT INTO ministry("ministryName") VALUES ('Environment & Climate Change Strategy');
INSERT INTO ministry("ministryName") VALUES ('Finance');
INSERT INTO ministry("ministryName") VALUES ('Forests, Lands, Natural Resource Operations & Rural Development');
INSERT INTO ministry("ministryName") VALUES ('Health');
INSERT INTO ministry("ministryName") VALUES ('Indigenous Relations & Reconciliation');
INSERT INTO ministry("ministryName") VALUES ('Jobs, Trade & Technology');
INSERT INTO ministry("ministryName") VALUES ('Labour');
INSERT INTO ministry("ministryName") VALUES ('Mental Health & Addictions');
INSERT INTO ministry("ministryName") VALUES ('Municipal Affairs & Housing');
INSERT INTO ministry("ministryName") VALUES ('Public Safety & Solicitor General & Emergency B.C.');
INSERT INTO ministry("ministryName") VALUES ('Social Development & Poverty Reduction');
INSERT INTO ministry("ministryName") VALUES ('Tourism, Arts & Culture');
INSERT INTO ministry("ministryName") VALUES ('Transportation & Infrastructure');

-- Imported from UNSPSC https://www.ungm.org/Public/UNSPSC
INSERT INTO project_sector("projectSectorName") VALUES ('Raw Materials, Chemicals, Paper, Fuel');
INSERT INTO project_sector("projectSectorName") VALUES ('Industrial Equipment & Tools');
INSERT INTO project_sector("projectSectorName") VALUES ('Components & Supplies');
INSERT INTO project_sector("projectSectorName") VALUES ('Construction, Transportation & Facility Equipment & Supplies');
INSERT INTO project_sector("projectSectorName") VALUES ('Medical, Laboratory & Test Equipment & Supplies & Pharmaceuticals');
INSERT INTO project_sector("projectSectorName") VALUES ('Food, Cleaning & Service Industry Equipment & Supplies');
INSERT INTO project_sector("projectSectorName") VALUES ('Business, Communication & Technology Equipment & Supplies');
INSERT INTO project_sector("projectSectorName") VALUES ('Defense, Security & Safety Equipment & Supplies');
INSERT INTO project_sector("projectSectorName") VALUES ('Personal, Domestic & Consumer Equipment & Supplies');
INSERT INTO project_sector("projectSectorName") VALUES ('Services');
INSERT INTO project_sector("projectSectorName") VALUES ('Other');

INSERT INTO rfx_type("rfxTypeName") VALUES ('ITQ (Invitation to Quote)');
INSERT INTO rfx_type("rfxTypeName") VALUES ('ITT (Invitation to Tender');
INSERT INTO rfx_type("rfxTypeName") VALUES ('JSRFP (Joint Solution Request for Proposals)');
INSERT INTO rfx_type("rfxTypeName") VALUES ('NRFP (Negotiated Request for Proposals)');
INSERT INTO rfx_type("rfxTypeName") VALUES ('NOI (Notice of Intent)');
INSERT INTO rfx_type("rfxTypeName") VALUES ('RFQ (Request for Qualifications)');
INSERT INTO rfx_type("rfxTypeName") VALUES ('RFEI (Request for Expression of Interest)');
INSERT INTO rfx_type("rfxTypeName") VALUES ('RFI (Request for Information)');
INSERT INTO rfx_type("rfxTypeName") VALUES ('RFP (Request for Proposals)');
INSERT INTO rfx_type("rfxTypeName") VALUES ('RSO (Request for Standing Offer)');
INSERT INTO rfx_type("rfxTypeName") VALUES ('SRFP (Short-form Request for Proposal)');
INSERT INTO rfx_type("rfxTypeName") VALUES ('SA (Standing Agreement)');
INSERT INTO rfx_type("rfxTypeName") VALUES ('SOW (Statement of Work)');
INSERT INTO rfx_type("rfxTypeName") VALUES ('Pre-Qualification List');
INSERT INTO rfx_type("rfxTypeName") VALUES ('Direct Award');

--Making edits to the existing project phases
---INSERT INTO rfx_phase("rfxPhaseName") VALUES ('On-boarding');
INSERT INTO rfx_phase("rfxPhaseName") VALUES ('Planning');
INSERT INTO rfx_phase("rfxPhaseName") VALUES ('Drafting');
INSERT INTO rfx_phase("rfxPhaseName") VALUES ('Posted');
-- INSERT INTO rfx_phase("rfxPhaseName") VALUES ('Evaluation');
INSERT INTO rfx_phase("rfxPhaseName") VALUES ('Award');
-- INSERT INTO rfx_phase("rfxPhaseName") VALUES ('Contract Management');
INSERT INTO rfx_phase("rfxPhaseName") VALUES ('Closed Out');
INSERT INTO rfx_phase("rfxPhaseName") VALUES ('Suspended');
INSERT INTO rfx_phase("rfxPhaseName") VALUES ('Cancelled');
INSERT INTO rfx_phase("rfxPhaseName") VALUES ('Completed');
