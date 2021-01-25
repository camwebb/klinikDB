<?php

class conf_ApplicationDelegate {

    function getPermissions(&$record){
        $auth =& Dataface_AuthenticationTool::getInstance();
        $user =& $auth->getLoggedInUser();
        // if ( !isset($user) ) return Dataface_PermissionsTool::READ_ONLY();
        if ( !isset($user) ) return Dataface_PermissionsTool::NO_ACCESS();
        $role = $user->val('Role');
        return Dataface_PermissionsTool::getRolePermissions($role);
    }

    function beforeHandleRequest(){
        $app =& Dataface_Application::getInstance();
        $auth =& Dataface_AuthenticationTool::getInstance();
        $user =& $auth->getLoggedInUser();
        $query =& $app->getQuery();
        if ( isset($user) ) {
            // set access to tables
            //   http://xataface.com/forum/viewtopic.php?t=4445#21970
            if ($user->val('Role') == 'MEDICAL') {
                // Remove tables from NavMenu (does not work to hide from
                //   standard menu, so need to make own menu) 
                unset($app->_conf['_tables']['Users']);
                unset($app->_conf['_tables']['dusun']);
                // This role cannot access the tables from browser
                $app->_conf['_disallowed_tables']['hide1'] = 'doc';
                $app->_conf['_disallowed_tables']['hide2'] = 'Users';
                $app->_conf['_disallowed_tables']['hide3'] = 'icd10';
                $app->_conf['_disallowed_tables']['hide4'] = 'visitType';
                $app->_conf['_disallowed_tables']['hide5'] = 'dusun';
                // not working, always 'patient' from conf.ini
                // $app->_conf['default_table'] = 'patient';
            }
            if ($user->val('Role') == 'PHARMACY') {
                // Remove tables from NavMenu
                unset($app->_conf['_tables']['patient']);
                unset($app->_conf['_tables']['visit']);
                unset($app->_conf['_tables']['visitType']);
                unset($app->_conf['_tables']['diagnoses']);
                unset($app->_conf['_tables']['doc']);
                unset($app->_conf['_tables']['icd10']);
                unset($app->_conf['_tables']['dusun']);
                unset($app->_conf['_tables']['drugDispense']);
                unset($app->_conf['_tables']['Users']);
                // This role cannot access the tables from browser
                $app->_conf['_disallowed_tables']['hide1'] = 'patient';
                $app->_conf['_disallowed_tables']['hide2'] = 'visit';
                $app->_conf['_disallowed_tables']['hide3'] = 'visitType';
                $app->_conf['_disallowed_tables']['hide4'] = 'diagnoses';
                $app->_conf['_disallowed_tables']['hide5'] = 'doc';
                $app->_conf['_disallowed_tables']['hide6'] = 'icd10';
                $app->_conf['_disallowed_tables']['hide7'] = 'Users';
                $app->_conf['_disallowed_tables']['hide8'] = 'dusun';
                $app->_conf['_disallowed_tables']['hide8'] = 'drugDispense';
                // fix
                if ($query['-table'] == 'patient')
                    $query['-table'] = 'drug';
            }
            // Else, for ADMIN, see all
        }
    
        // CSS
        Dataface_Application::getInstance()->addHeadContent(
            sprintf('<link rel="stylesheet" type="text/css" href="%s"/>',
                    htmlspecialchars(DATAFACE_SITE_URL.'/css/style.css')));
        Dataface_Application::getInstance()->addHeadContent(
            sprintf('<link rel="icon" type="image/png" href="../img/favicon.ico"/>'));
    }

    // Make menus
    function block__before_main_table(){
        echo '<div id="my_menu">Goto table:&nbsp;&nbsp;';
        $app =& Dataface_Application::getInstance();
        $tables =& $app->_conf['_tables'];
        foreach ( $tables as $k=>$v){
            echo '<a href="index.php?-table='.$k.'">'.$v
                    .'</a>&nbsp;&nbsp;&nbsp;';
        }
        echo '</div>';
    }
    
    function block__after_xf_logo()
    {
        // if user logged in, see link to summary data
        // not needed now since no app is visible without login
        $auth =& Dataface_AuthenticationTool::getInstance();
        $user =& $auth->getLoggedInUser();
        if ( isset($user) ) 
            echo "<a href=\"../cgi/do\"><b>TOOLS</b></a> &#160;&#160;&#160;&#160; <a href=\"../\"><b>HOME</b></a>";
    }
    
    // change the logo, see https://xataface-tips.blogspot.com/2013/05/ \
    //   how-to-use-chrome-and-css-to-customize.html

}
?>
