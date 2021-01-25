% Data entry

# Data entry

After [data collection](workflow.html), data should be added to the
database as often as possible, so as not to fall behind (the patient
record folders become hard to find if many of them are in the ‘To Be
Entered’ pile).  See the [usage](usage.html) document for general
information about using the database.

## Patient data

 * If the patient is new, create a new patient record with all data on
   the Basic Data form. If the patient is returning to to clinic,
   search for the patient’s record using the Patient Record Number
   (PRN) on the folder.
 * Open the ‘Record view’ for the patient (by clicking on the
   patient’s PRN in the grid/table view).
 * First add data for ‘Antenatal visits’, ‘Diagnoses’, and ‘Drug
   prescriptions’. Click the respective tab (to the right of ‘View’),
   and then ‘New ...’. Enter date, doctor, and other information. The
   red squares indicate that a field must be filled.
 * Then the various patient events with costs. Click the ‘Events’ tab,
   and then ‘New Event’. Enter date, type of event, location, doctor,
   and price. Note that for most services, use a positive (+) value
   (greater than 0), but for payment, use a negative (-) value. Save,
   and click Cancel to return to the main patient record view. Make
   sure that all doctor consultations, labs, nurse actions, and drug
   purchases on the paper ‘Visit form’ have been entered in the Events
   table. Consult the separate (non-database) costs printout for
   prices. If a drug or service is being provided free, you _must
   still create an event_, but enter ‘0’ for the cost. This is vital
   for reporting purposes.
 * If a new village, doctor, or event type is needed, you must ask
   someone with [‘admin’ level access](roles.html) to the database to
   add it for you.

## Pharmacy data

**Creating new units and packages**

 * Either find, or create the generic drug name in the ‘Drug’ table.
   Click on the name to open the record view. Click the ‘Units’
   tab. 
 * Add a new unit if needed.
 * To add a new package, click on the ‘Open this record in the drug
   table’ link at the bottom and then the ‘Packaged as’ tab. Click
   ‘New packaged a’ button. Enter a new package. When adding a
   package, enter the ‘Minimum number to keep in stock’; this will
   permit you to know when you need to reorder this drug.

**Stock management**

During the course of a day in the pharmacy, put emptied packages in a
large box. E.g., a box (the _package_) of 20 bottles of Acetaminophen
syrup, 60 ml of concentration 160mg/5ml (the _unit_). Or: A bottles
(_the package_) of 1000 tablets of aspirin, 100 mg (the _unit_). In
rare cases, the whole dispensed unit is both a _unit_ and a _package_
(indicated by ‘individual’ in the ‘Packaging’ field), and a paper slip
must be placed in the ‘Used’ box indicating that a package has been
used. At the end of each day, the used packages must be entered into
the database:

 * Go to the ‘Drug packages’ table, and search for the generic or
   trade name. Find the correct package; **note** there may be several
   packages for the same drug unit, with different manufacturers and
   tradenames. Click on the trade name to enter the record view.
 * Update the ‘Earliest date of expiration’ for all the packages on
   the shelf (this will require a physical visit to the drug closet).
 * Click on the ‘Add/use’ tab, and then the ‘New Add/use’
   button. Enter date and number: a negative number if the stock has
   been used.
 * The new total will now be reflected in the ‘View’ tab for that
   package.
 
When new stock arrives:

 * Go to the ‘Drug packages’ table, and search for the generic or
   trade name. Find the correct package. Click on the trade name to
   enter the record view.
 * If necessary, update the ‘Earliest date of expiration’ for all the
   packages on the shelf; usually this will not be necessary because
   new stock will generally have expiration dates further in the
   future than existing stock.
 * Click on the ‘Add/use’ tab, and then the ‘New Add/use’
   button. Enter date and number: a positive number for new stock.  If
   desired, also enter a Batch code, a price, and the supplier. Add a
   new supplier if needed. Note the supplier is not the same as the
   manufacturer; the ‘supplier’ is the distributor company that you
   buy your drugs from.
 * The new total will now be reflected in the ‘View’ tab for that
   package.

Once every six months or so, you will need to do a stock-taking, to
make sure the the physical stock matches the database.  When the
physical number in stock does not match the database:

 * Find the package, as above.
 * Click on the ‘Add/use’ tab, and then the ‘New Add/use’
   button. Enter date and number, and click the ‘correction’
   checkbox. For number, use a positive number when you have more
   physical stock than DB stock. Use a negative number when you have
   less physical stock than DB stock.



