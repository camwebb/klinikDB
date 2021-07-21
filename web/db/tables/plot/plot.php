<?php

class tables_plot {

    // date format
    function harvest_date__display(&$record) {
        return $record->strval('harvest_date');
    } 

}

?>
