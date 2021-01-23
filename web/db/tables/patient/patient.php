<?php

class tables_patient {

    // function getPermissions(&$record){
    //     $auth =& Dataface_AuthenticationTool::getInstance();
    //     $user =& $auth->getLoggedInUser();
    //     if ($user and (($user->val('Role') == 'MEDICAL') or
    //                    ($user->val('Role') == 'ADMIN')))
    //         return Dataface_PermissionsTool::ALL();
    //     return Dataface_PermissionsTool::NO_ACCESS();
    // }

    // date format
    function birthdate__display(&$record) {
        return $record->strval('birthdate');
    } 
    
    function dusunID__renderCell(&$record){
        return '<a href="'.DATAFACE_SITE_HREF.'?-table=dusun&-action=browse&id='.$record->val('dusunID').'">'.$record->display('dusunID').'</a>';
    }

    function balance__htmlValue(&$record){
        $app =& Dataface_Application::getInstance();
        $result = xf_db_query('SELECT SUM( `amount` ) FROM  `visit` WHERE patientID = ' . $record->val('id') . ' GROUP BY patientID;', $app->db());
        $row = xf_db_fetch_row($result);
        return '<b>' . number_format($row[0]) . '</b>' ;
    }

    // function mystatus__htmlValue(&$record){
    //     $app =& Dataface_Application::getInstance();
    //     $result = xf_db_query('SELECT  `status` FROM  `status` WHERE periodID = ( SELECT id FROM `period` WHERE startDate = ( SELECT MAX( `startDate` ) FROM `period` ) ) AND dusunID = ( SELECT dusunID FROM patient WHERE id = ' . $record->val('id') . ') ;', $app->db());
    //     $row = xf_db_fetch_row($result);
    //     return '<b>' . $row[0] . '</b>' ;
    // }

    // function photo__htmlValue(&$record){
    //     if (!empty($record->val('photo')))
    //         return '<img src="'. $record->display('photo').
    //                            '" height="200"/>';
    // }
}

?>
