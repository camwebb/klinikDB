BEGIN{
  # Combines the schema, which is live and frequently changed and
  # without per-column notes, with documentation notes in this directory.
  # See ../sql/README.md for details on preparing the SQL schema

  system("rm -f schema.md")
  system("cp schemapre.md schema.md")
  
  # read the documentation
  RS=""
  while ((getline < "schema.txt") > 0) {
    split($0, part, "|")
    gsub(/\n/, " ", part[3])
    gsub(/^ /, "", part[3])
    doc[part[1]][part[2]] = part[3]
  }
  
  # read the schema
  RS="\n"
  while ((getline < "../sql/klinikDB.sql") > 0) {
    if ($0 ~ /CREATE TABLE/) {
      table = gensub(/^[^`]+`([^`]+)`[^`]+$/,"\\1","G",$0)
      print "\n### `" table "`\n" >> "schema.md"
      if (doc[table][""])
        print doc[table][""] "\n"  >> "schema.md"
    }      
    else if ($0 ~ /^ +`/) {
      field = gensub(/^[^`]+`([^`]+)`[^`]+$/,"\\1","G",$0)
      if (doc[table][field])
        print " * `" field "`: " doc[table][field]  >> "schema.md"
    }
  }
}
