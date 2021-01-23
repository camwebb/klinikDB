<?php

class tables_antenatal {

    // date format
    function birth_date__display(&$record) {
        return $record->strval('birth_date');
    } 

    // date format
    function date__display(&$record) {
        return $record->strval('date');
    } 

    // date format
    function last_period__display(&$record) {
        return $record->strval('last_period');
    } 
}

?>
