<?php

class tables_visit {

    // date format
    function date__display(&$record) {
        return $record->strval('date');
    } 

    
    function amount__renderCell(&$record){
        // return number_format($record->strval('amount'));
        return '<span style="text-align:right;">' . number_format($record->strval('amount')) . '</span>';
    }
    
}

?>
