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
        Get the preference ID given the short name

	@param preference_type Corresponds to the short_name parameter to preference::type::new
    } {
        # This will eventually be cached
        return [db_string select_preference_type_id {} -default {}]
    }

    ad_proc -public set_package_default {
        {-preference_type:required}
        {-package_id:required}
        {-default_value:required}
    } {
        Sets the default preference value for a package ID

	@param preference_type Corresponds to the short_name parameter to preference::type::new
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
        Set a user preference.

	@param preference_type Corresponds to the short_name parameter to preference::type::new
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
	Get a user, package, or default preference. The preference can be
	obtained at four different levels:
	<p>
	<table border=1>
	<tr><th>package_id</th>	<th>user_id</th><th>Returns</th></tr>
	<tr><td>package_id</td>	<td>user_id</td><td>User preference for package_id (set with set_user_pref)</td></tr>
	<tr><td>null</td>	<td>user_id</td><td>User preference for all packages (set with set_user_pref)</td></tr>
	<tr><td>package_id</td>	<td>null</td><td>Package default (set with set_package_default)</td></tr>
	<tr><td>null</td>	<td>null</td><td>System default (set with preference::type::new)</td></tr>
	</table>

	Note: null == empty string (""), ...
	
	@param preference_type A short string that identifies the preference.
	This corresponds to the short_name parameter passed to
	preference::type::new.
	
	@param package_id This can be the real package id, or an empty string.

	@param user_id This can be the real user id, or an empty string.

	@see preference::type::new
	@see preference::set_package_default
	@see preference::set_user_pref

    } {
        # get the preference type id
        set preference_type_id [get_preference_type_id -preference_type $preference_type]

        # exec the PL/SQL
        set pref [db_exec_plsql get_user_pref {}]

        return $pref
    }        
}
