ad_library {

    User Preferences Types 

    @creation-date 2002-05-24
    @author Ben Adida <ben@openforce.biz>
    @cvs-id $Id$

}

namespace eval preference::type {

    ad_proc -public new {
        {-preference_type_id ""}
        {-package_key:required}
        {-short_name:required}
        {-pretty_name:required}
        {-datatype "text"}
        {-options ""}
        {-default_value ""}
    } {
	Create a new preference type. The preference can be set at four
	different levels. See get_user_pref for more details.

	@param short_name This is the name that will be used to set or retrieve
	the preference using set_user_pref or get_user_pref.

    	@see preference::set_user_pref
    	@see preference::get_user_pref
	@see preference::set_package_default
    } {
        # Set up the vars
        set extra_vars [ns_set create]
        oacs_util::vars_to_ns_set -ns_set $extra_vars -var_list {preference_type_id package_key short_name pretty_name datatype options default_value}

        # Instantiate the pref
        set preference_type_id [package_instantiate_object -extra_vars $extra_vars user_pref_type]

        return $preference_type_id
    }

    ad_proc -public delete {
        {-preference_type:required}
    } {
	This deletes a preference type. This is not yet implemented.

	@param preference_type Corresponds to the short_name parameter to preference::type::new
    } {
        # FIXME: implement
    }

    

}
