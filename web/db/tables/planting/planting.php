<?php

class tables_planting {

    // date format
    function date__display(&$record) {
        return $record->strval('date');
    } 
}

?>
