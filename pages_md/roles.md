% Roles

# Roles in the database

In order to use KlinikDB, the operator must login in. Each login name
has a ‘role’ which determines how much of the database can be seen and
edited.  These roles are set in the `Users` table. The roles are:

 * **ADMIN**: Read and write access to all tables, including the
     ability to add and delete `Users`.
 * **MEDICAL**: Read and write access to all tables, except `Doctors`,
     `ICD10`, `Patient event type`, `Village` and `Users`. Physicians
     and data entry staff should be given this role.  In order to add
     a new record to `Doctor` or `Village`, the data entry staff must
     ask a DB admin.
 * **PHARMACY**: Only read and write access to medication tables; no
     access to patient data.

Each user must be given their own login name and a random, 8-character
password. These logins and passwords must now be shared with other
users.
