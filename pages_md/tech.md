% Core technologies

# Core technologies

## Database

KlinikDB uses an insustry-standard ‘LAMP’ stack: Linux OS, Apache
Webserver, MySQL (or MariaDB) database, PHP.  On top of this stack,
KlinikDB uses the [Xataface][] framework, built by Steve
Hannah. Xataface provides an easy way to view database tables, and can
be run with either minimum configuration, or with great
customization. KlinikDB has grown to use a wide range of the options
in Xataface.

## Reporting and Backup

A single CGI, [Gawk][] script (`cgi/do`) queries the database via
`mysql-client` and formats the output as HTML or CSV.  The script can
also trigger a backup via `mysqldump`, which is then encrypted using
`gpg` and can be safely copied to a flash drive.

[Xataface]: http://xataface.com/
[Gawk]: https://www.gnu.org/software/gawk/
