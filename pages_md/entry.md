% Data entry

# Data entry


 * Once per week, the data entry staff visits each clinic,
              and enters the new data in the database
 * After each data entry session, make a <a
              href="cgi/run">backup</a>. Copy the backup file to
              Flashdrive 1. This file (ending in <tt>.sql.gz.asc</tt>)
              is encrypted. Only Yudi and Cam have the keys to decrypt
              it. Therefore, the data on the flashdrive cannot be read
              if the flashdrive is lost or stolen.
 * After each data entry session, also copy the new patient
              CSV file to the clinic computer, and open in Excel.
 * Once a month, copy the latest backup to Flashdrive
              2. Keep Flashdrive 2 somewhere different than Flashdrive
              1.

## Pharmacy

 * For each generic kind of drug ("Obat"), there can be
       many distribution formats (tablets of different size,
              syrups of different concentration, etc.: "Satuan").
 * These formats can be prescribed for each patient ("Kasih
              obat" in the patient view), with a number of units and a
              frequency of consumption per day.
 * For managing pharmacy stock: each of these "satuan"
              arrives in the pharmacy in some package (box, bottle,
              tin: "susunan") than contains some number of
              "satuan".
 * This "susunan" is the object that is tracked: When a
              package is emptied in the pharmacy, place it in a
              special location. On a regular basis, count the empty
              containers and add this information to the database
              ("susunan" -> "stock" -> "pakai").
 * For each "susunan", you can enter a minimum number to
              keep in stock. If the total number falls below this
              minimum, the package will appear in the list of things
              to order, under the "Tools" menu.
 * You can also keep track of the expiry date for
              medicines. Enter the <i>oldest</i> expiry date for any
              of the packages of a single type under the "susunan"
              form. Then under "Tools" you can generate a report that
              lists all the medicines with an oldest expiry date less
              that 6 months from the present. You can then review
              these and order newer medicines, or just discard the
              soon-to-expire medicines. Remember to update the "oldest
              expiry date" to reflect the new situation.



