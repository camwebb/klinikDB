% Usage

# General use of database

Once the user has logged in, they will see a default table view. Other
tables can be reached by clicking the table names at the top of the
page.  Actions for all tables are similar.

## Table view

 * A grid of up to 30 rows (‘records’) with selected columns (‘fields’)
   is shown. 
 * If there are more that 30 records in the table, subsequent
   batches of records can be accessed with the green arrows.
 * Records can be sorted by clicking the sort column name at the top
   of the table. Clicking a second time reverses the sort order.
 * A selection box can be clicked to select multiple rows. These can
   then be deleted, or the value of one of their fields can be
   updated, using the ‘Update’ or ‘Delete’ buttons above the column
   names.
 * Clicking on a pale blue field in a row will take you to the record view.

## Record view and related tables

 * The fields for which there is data are shown.
 * The ‘Edit’ button at the top switches to the New/Edit form.
 * The large ‘New...’ _on the left_ will add a new record in this table. 
 * A vital element of the database is the **related table**. If there
   are related tables for a record, they will appear as tabs above the
   ‘Details’ and to the right of the ‘View’ tab. For example, if the
   record view is of a patient, the will be a related table tab for
   patient ‘Events’. Clicking this tab will show a _grid view_ of
   records in the other table that relate to the main record being
   viewed. 
 * New related records can be created by clicking the small ‘New...’
   button _under the related table tabs_.
   
## New/Edit form

 * When creating a new record, a form will appear with empty boxes,
   drop downs, etc.
 * The mandatory fields are marked with a red square.
 * When selecting from a dropdown the necessary value may not already
   be present. Clicking on the ‘Other..’ link will open a subform that
   will permit the addition of a new value (but only if the user has
   write access to the table in which this value is stored).
 * Click ‘Save’ when finished. Note that the same form will reload
   after saving. To return to the Record view, click ‘Cancel’.
   
## Searching

 * The simple search box at the top of the page will search for
   entries in all fields of the table currently chosen.
 * Click on Advanced Search to search on multiple fields (two or more
   search boxes filled implies ‘AND’), or on related table fields. To
   specify an exact match (not just partial) use `=` at the beginning
   of your search term. Numeric ranges can also be specified; see
   [here][1].


## More info on user interface

See the Xataface pages:

 * <https://shannah.github.io/xataface-manual/>
 * <http://xataface.com/wiki/>

[1]: https://shannah.github.io/xataface-manual/#_finding_records_using_the_url
