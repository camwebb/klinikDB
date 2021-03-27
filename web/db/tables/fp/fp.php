<?php

class tables_fp {

    // date format
    function date__display(&$record) {
        return $record->strval('date');
    } 

    // date format
    function last_period__display(&$record) {
        return $record->strval('last_period');
    }
    
    // date format
    function nextvisit__display(&$record) {
        return $record->strval('nextvisit');
    } 
}

?>
