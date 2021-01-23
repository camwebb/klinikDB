<?php

class tables_diagnoses {

    // date format
    function date__display(&$record) {
        return $record->strval('date');
    } 

}

?>
