BEGIN{
  while ((getline < "../sql/klinikDB.sql") > 0) {
    if ($0 ~ /CREATE TABLE/) {
      table = gensub(/^[^`]+`([^`]+)`[^`]+$/,"\\1","G",$0)
      print table "||\n"
    }      
    else if ($0 ~ /^ +`/) {
      field = gensub(/^[^`]+`([^`]+)`[^`]+$/,"\\1","G",$0)
      print table "|" field "|\n"
    }
  }
}
