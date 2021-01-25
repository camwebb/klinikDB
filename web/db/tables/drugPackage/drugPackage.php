<?php

  class tables_drugPackage {

      // function unitID__renderCell(&$record){
      //     return '<span style="float:left;"><a href="'.DATAFACE_SITE_HREF.'?-table=drug&-action=browse&id='.$record->val('unitID').'">'.$record->display('unitID').'</a></span>';
      // }

      function unitID__renderCell(&$record){
          return '<span style="float:left;">'.$record->display('unitID').'</span>';
       }

      function manufID__renderCell(&$record){
          return '<span style="float:left;">' . substr($record->display('manufID'),0,15).'</span>';
      }

      function tradeName__renderCell(&$record){
          return '<span style="float:left;">' . substr($record->display('tradeName'),0,15).'</span>';
      }

      function oldestExpiry__display(&$record) {
          return $record->strval('oldestExpiry');
      } 

}

?>
