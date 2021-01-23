<?php

class tables_drugDispense {

    function date__display(&$record) {
        return $record->strval('date');
    }

}

?>
