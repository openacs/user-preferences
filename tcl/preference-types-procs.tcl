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
        create a new preference type
    } {
        # Set up the vars
        set extra_vars [ns_set create]
        oacs_util::vars_to_ns_set -ns_set $extra_vars -var_list {preference_type_id package_key short_name pretty_name datatype options default_value}

        # Instantiate the pref
        set preference_type_id [package_instantiate_object -extra_vars $extra_vars user_preference_type]

        return $preference_type_id
    }

    ad_proc -public delete {
        {-preference_type:required}
    } {
        this deletes a preference type
    } {
        # FIXME: implement
    }

    

}
