% Overview

# History and Overview

KlinikDB was developed to meet the needs of a rural medical clinic
([ASRI][1]) in Indonesia.  When the clinic first opened (in 2007) all
medical records were collected on paper, but as the number of patients
grew, it became harder to:

 1. Find the record for a returning patient,
 2. Keep track of patient payments for services, and patient debt, and
 3. Generate statistics for government reporting and fundraising.

The first two tables of the database were ‘patients’ and ‘patient
events’.  The patient table holds basic data (name, DOB, phone number,
village). Each patient event has a single type (e.g., doctor visit,
dentist visit, nurse wound cleaning, medication, cash payment) and is
associated with a price. Several events may take place in a single day
(e.g., consultation, procedure, medication and payment).  The database
view of a patient shows any outstanding debt.

We soon discovered we should not expect patients to hold onto a
registration card with their accession number.  However, we found that
a combination of name, village, mother’s name, father’s name was
almost always sufficient to locate a patient in the database. At ASRI
we also store a photo of the patient in the database for
confirmation, but this is generally not referred to.

Soon other patient-related tables were added: diagnoses (using the
WHO’s [ICD10][] codes), antenatal visit data, lab results.

Managing medications is a major task for a small clinic: keeping key
drugs in stock, and keeping track of expiration dates.  We soon added
a drugs subsystem to the database, which also permitted drug
prescriptions to be linked to patient records.  The drugs subsystem is
organized around three tables: the drug unit (e.g., acetylsalicylic
acid tablet of 100 mg), its drug package (e.g., a bottle of 500 such
tablets), and a stock flow of these packages (bought, used up).

Because the original ASRI clinic was also part of a forest
conservation program, we also added conservation tables to the
database (illegal activities in each village, reports from village
conservation staff, seedling species arriving as patient payments).
These were integrated with the patient table and village tables.

Throughout the development of KlinikDB, we would often look into
commercial hospital software options in Indonesia, and at free systems
(such as [OpenMRS][] and [OpenEMR][]). While these products can be
more sophisticated and easier to use, none met the needs or our
idiosyncratic program as well as our ‘roll-your-own’ solution, and
ASRI is still using KlinikDB after 13 years.

## Software history

The first ASRI database was a single OpenOffice Base file. Since
OpenOffice Base was built on the Java database HSQLDB, it was easy to
switch the same database into server mode, with OpenOffice Base acting
as a client on clinic laptops. Finally a move was made to a MySQL
database, accessed via a web browser. This made access easier (no
special client software, and ability to run CGI scripts for
reporting, etc.).

[ICD10]: https://en.wikipedia.org/wiki/ICD-10
[OpenMRS]: https://openmrs.org/
[OpenEMR]: https://www.open-emr.org/
[1]: https://www.alamsehatlestari.org
