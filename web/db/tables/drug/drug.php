<?php

  class tables_drug {

      function genericID__renderCell(&$record){
          return '<span style="float:left;">'.$record->display('genericID').'</span>';
      }


}

?>
