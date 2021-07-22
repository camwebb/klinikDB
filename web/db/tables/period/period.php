<?php

class tables_period {

    function startDate__display(&$record) {
        return $record->strval('startDate');
    } 

    function endDate__display(&$record) {
        return $record->strval('endDate');
    } 

}
?>
