<?php

class tables_general {

    // date format
    function date__display(&$record) {
        return $record->strval('date');
    } 

}

?>
