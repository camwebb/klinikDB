<?php

class tables_training {

    // date format
    function date__display(&$record) {
        return $record->strval('date');
    } 

    // date format
    function grad_date__display(&$record) {
        return $record->strval('grad_date');
    } 
}

?>
