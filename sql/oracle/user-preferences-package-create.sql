
--
-- The User Preferences package
--
-- Copyright 2002, OpenForce
-- ben@openforce
--
-- distributed under the GPL v2
--
-- May 21st 2002
-- 

-- package

create or replace package user_pref_type
as
        function new (
           preference_type_id           in user_preference_types.preference_type_id%TYPE default null,
           object_type                  in acs_objects.object_type%TYPE default 'user_pref_type',
           package_key                  in user_preference_types.package_key%TYPE,
           short_name                   in user_preference_types.short_name%TYPE,
           pretty_name                  in user_preference_types.pretty_name%TYPE,
           datatype                     in user_preference_types.datatype%TYPE default 'text',
           options                      in user_preference_types.options%TYPE default null,
           default_value                in user_preference_types.default_value%TYPE default null,
           creation_date                in acs_objects.creation_date%TYPE default sysdate,
           creation_user                in acs_objects.creation_user%TYPE,
           creation_ip                  in acs_objects.creation_ip%TYPE,
           context_id                   in acs_objects.context_id%TYPE
        ) return user_preference_types.preference_type_id%TYPE;

        function get_user_pref (
           preference_type              in user_preference_types.short_name%TYPE,
           package_id                   in user_preference_values.package_id%TYPE default null,
           user_id                      in user_preference_values.user_id%TYPE
        ) return user_preference_values.value%TYPE;

        procedure set_package_default (
           preference_type_id           in user_preference_default_values.preference_type_id%TYPE,
           package_id                   in user_preference_default_values.package_id%TYPE,
           default_value                in user_preference_default_values.default_value%TYPE
        );

        procedure set_user_pref (
           preference_type_id           in user_preference_default_values.preference_type_id%TYPE,
           package_id                   in user_preference_default_values.package_id%TYPE,
           user_id                      in user_preference_values.user_id%TYPE,
           value                        in user_preference_default_values.default_value%TYPE
        );

        procedure delete (
           preference_type_id           in user_preference_types.preference_type_id%TYPE
        );
end user_pref_type;
/
show errors



create or replace package body user_pref_type
as
        function new (
           preference_type_id           in user_preference_types.preference_type_id%TYPE default null,
           object_type                  in acs_objects.object_type%TYPE default 'user_pref_type',
           package_key                  in user_preference_types.package_key%TYPE,
           short_name                   in user_preference_types.short_name%TYPE,
           pretty_name                  in user_preference_types.pretty_name%TYPE,
           datatype                     in user_preference_types.datatype%TYPE default 'text',
           options                      in user_preference_types.options%TYPE default null,
           default_value                in user_preference_types.default_value%TYPE default null,
           creation_date                in acs_objects.creation_date%TYPE default sysdate,
           creation_user                in acs_objects.creation_user%TYPE,
           creation_ip                  in acs_objects.creation_ip%TYPE,
           context_id                   in acs_objects.context_id%TYPE
        ) return user_preference_types.preference_type_id%TYPE
        is
                v_pref_type_id          user_preference_types.preference_type_id%TYPE;
        begin
                v_pref_type_id := acs_object.new (
                                        object_id => preference_type_id,
                                        object_type => object_type,
                                        creation_date => creation_date,
                                        creation_user => creation_user,
                                        creation_ip => creation_ip,
                                        context_id => context_id
                                  );

                insert into user_preference_types
                (preference_type_id, package_key, short_name, pretty_name, datatype, options, default_value)
                values
                (v_pref_type_id, package_key, short_name, pretty_name, datatype, options, default_value);

                return v_pref_type_id;
        end new;

        function get_user_pref (
           preference_type              in user_preference_types.short_name%TYPE,
           package_id                   in user_preference_values.package_id%TYPE,
           user_id                      in user_preference_values.user_id%TYPE
        ) return user_preference_values.value%TYPE
        is
           v_type_id                    user_preference_types.preference_type_id%TYPE;
           v_pref                       user_preference_values.value%TYPE;
        begin
           select preference_type_id into v_type_id
           from user_preference_types where short_name = preference_type;

           -- if there is no such preference type
           if SQL%NOTFOUND then return NULL; end if;

           -- check direct user pref for package_id not null
           select value into v_pref from user_preference_values
           where preference_type_id = v_type_id
           and package_id = get_user_pref.package_id
           and user_id = get_user_pref.user_id;

           if SQL%FOUND then return v_pref; end if;

           -- check user pref with package_id NULL
           select value into v_pref from user_preference_values
           where preference_type_id = v_type_id
           and package_id is NULL
           and user_id = get_user_pref.user_id;

           if SQL%FOUND then return v_pref; end if;

           -- if not found, check package default
           select default_value into v_pref from user_preference_default_values
           where preference_type_id = v_type_id
           and package_id = get_user_pref.package_id;

           if SQL%FOUND then return v_pref; end if;

           -- if not found check default value for preference type
           select default_value into v_pref from user_preference_types
           where preference_type_id = v_type_id;

           return v_pref;
           
        end get_user_pref;

        procedure set_package_default (
           preference_type_id           in user_preference_default_values.preference_type_id%TYPE,
           package_id                   in user_preference_default_values.package_id%TYPE,
           default_value                in user_preference_default_values.default_value%TYPE
        )
        is
           v_count      integer;
        begin
           update user_preference_default_values
           set default_value= set_package_default.default_value
           where preference_type_id= set_package_default.preference_type_id
           and package_id= set_package_default.package_id;

           v_count:= SQL%ROWCOUNT;

           if v_count = 0
           then
                insert into user_preference_default_values
                (preference_type_id, package_id, default_value) values
                (preference_type_id, package_id, default_value);
           end if;

        end set_package_default;

        procedure set_user_pref (
           preference_type_id           in user_preference_default_values.preference_type_id%TYPE,
           package_id                   in user_preference_default_values.package_id%TYPE,
           user_id                      in user_preference_values.user_id%TYPE,
           value                        in user_preference_default_values.default_value%TYPE
        )
        is
           v_count      integer;
        begin
           update user_preference_values
           set value= set_user_pref.value
           where preference_type_id= set_user_pref.preference_type_id
           and package_id= set_user_pref.package_id
           and user_id= set_user_pref.user_id;

           v_count:= SQL%ROWCOUNT;

           if v_count = 0
           then
                insert into user_preference_values
                (preference_type_id, package_id, user_id, value) values
                (preference_type_id, package_id, user_id, value);
           end if;

        end set_user_pref;        

        procedure delete (
           preference_type_id           in user_preference_types.preference_type_id%TYPE
        )
        is
        begin
           acs_object.delete(preference_type_id);
        end delete; 

end user_pref_type;
/
show errors

