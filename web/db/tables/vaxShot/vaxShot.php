<?php

class tables_vaxShot {

    // date format
    function date__display(&$record) {
        return $record->strval('date');
    } 

    // date format
    function nextvisit__display(&$record) {
        return $record->strval('nextvisit');
    } 
}

?>
