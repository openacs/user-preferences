ad_library {

    User Preferences

    @creation-date 2002-05-24
    @author Ben Adida <ben@openforce.biz>
    @cvs-id $Id$

}

namespace eval preference {

    ad_proc -public get_preference_type_id {
        {-preference_type:required}
    } {
        get the ID from the short name
    } {
        # This will eventually be cached
        return [db_string select_preference_type_id {} -default {}]
    }

    ad_proc -public set_package_default {
        {-preference_type:required}
        {-package_id:required}
        {-default_value:required}
    } {
        sets the default value for a package ID
    } {
        # get the preference type id
        set preference_type_id [get_preference_type_id -preference_type $preference_type]
        
        # simply exec the PL/SQL
        db_exec_plsql set_package_default {}
    }

    ad_proc -public set_user_pref {
        {-preference_type:required}
        {-package_id ""}
        {-user_id:required}
        {-value:required}
    } {
        set a user pref
    } {
        # get the preference type id
        set preference_type_id [get_preference_type_id -preference_type $preference_type]

        # exec the PL/SQL
        db_exec_plsql set_user_pref {}
    }

    ad_proc -public get_user_pref {
        {-preference_type:required}
        {-package_id:required}
        {-user_id:required}
    } {
        get a user pref
    } {
        # get the preference type id
        set preference_type_id [get_preference_type_id -preference_type $preference_type]

        # exec the PL/SQL
        set pref [db_exec_plsql get_user_pref {}]

        return $pref
    }        
}
