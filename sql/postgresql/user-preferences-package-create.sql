
--
-- The User Preferences package
--
-- Ported to PostgreSQL by: Gabriel Burca <gburca-openacs@ebixio.com>
-- Based on the Oracle version by: ben@openforce
--
-- distributed under the GPL v2
--
-- Jan. 1 2004
-- 

-- package
select define_function_args('user_pref_type__new', 'preference_type_id,object_type;user_pref_type,package_key,short_name,pretty_name,datatype;text,options,default_value,creation_date;now(),creation_user,creation_ip,context_id');

create or replace function user_pref_type__new (integer, varchar, varchar, varchar, varchar,
		varchar, varchar, varchar, timestamptz, integer, varchar, integer)
returns int4 as '
declare
           p_preference_type_id           alias for $1;		-- default null
           p_object_type                  alias for $2;		-- default ''user_pref_type''
           p_package_key                  alias for $3;
           p_short_name                   alias for $4;
           p_pretty_name                  alias for $5;
           p_datatype                     alias for $6;		-- default ''text''
           p_options                      alias for $7;		-- default null
           p_default_value                alias for $8;		-- default null
           p_creation_date                alias for $9;		-- default sysdate
           p_creation_user                alias for $10;
           p_creation_ip                  alias for $11;
           p_context_id                   alias for $12;

           v_pref_type_id		user_preference_types.preference_type_id%TYPE;
begin
                v_pref_type_id := acs_object__new (
                                        p_preference_type_id,
                                        p_object_type,
                                        p_creation_date,
                                        p_creation_user,
                                        p_creation_ip,
                                        p_context_id
                                  );

                insert into user_preference_types
                (preference_type_id, package_key, short_name, pretty_name, datatype, options, default_value)
                values
                (v_pref_type_id, p_package_key, p_short_name, p_pretty_name, p_datatype, p_options, p_default_value);

                return v_pref_type_id;

end;' language 'plpgsql';

select define_function_args('user_pref_type__get_user_pref', 'preference_type,package_id,user_id');

create or replace function user_pref_type__get_user_pref (varchar, integer, integer)
returns varchar as '
declare
           p_preference_type              alias for $1;
           p_package_id                   alias for $2;
           p_user_id                      alias for $3;

           v_type_id                    user_preference_types.preference_type_id%TYPE;
           v_pref                       user_preference_values.value%TYPE;
        begin
           select preference_type_id into v_type_id
           from user_preference_types where short_name = p_preference_type;

           -- if there is no such preference type
           if NOT FOUND then return NULL; end if;

           -- check direct user pref for package_id not null
           select value into v_pref from user_preference_values
           where preference_type_id = v_type_id
           and package_id = p_package_id
           and user_id = p_user_id;

           if FOUND then return v_pref; end if;

           -- check user pref with package_id NULL
           select value into v_pref from user_preference_values
           where preference_type_id = v_type_id
           and package_id is NULL
           and user_id = p_user_id;

           if FOUND then return v_pref; end if;

           -- if not found, check package default
           select default_value into v_pref from user_preference_default_values
           where preference_type_id = v_type_id
           and package_id = p_package_id;

           if FOUND then return v_pref; end if;

           -- if not found check default value for preference type
           select default_value into v_pref from user_preference_types
           where preference_type_id = v_type_id;

           return v_pref;
           
end;' language 'plpgsql';


select define_function_args('user_pref_type__set_package_default', 'preference_type_id,package_id,default_value');

create or replace function user_pref_type__set_package_default (integer, integer, varchar)
returns int4 as '
declare
           p_preference_type_id           alias for $1;
           p_package_id                   alias for $2;
           p_default_value                alias for $3;
	   
           v_count      integer;
begin
	   select count(*) into v_count from user_preference_default_values
	   where preference_type_id = p_preference_type_id
	   and package_id = p_package_id;

	   if v_count > 0 then

		   update user_preference_default_values
		   set default_value= p_default_value
		   where preference_type_id= p_preference_type_id
		   and package_id= p_package_id;
	else

                insert into user_preference_default_values
                (preference_type_id, package_id, default_value) values
                (p_preference_type_id, p_package_id, p_default_value);
           end if;

	   return 0;

end;' language 'plpgsql';


select define_function_args('user_pref_type__set_user_pref', 'preference_type,package_id,user_id,value');

create or replace function user_pref_type__set_user_pref (varchar, integer, integer, varchar)
returns int4 as '
declare
           p_preference_type              alias for $1;
           p_package_id                   alias for $2;
           p_user_id                      alias for $3;
           p_value                        alias for $4;

	   v_type_id			user_preference_types.preference_type_id%TYPE;
           v_count      integer;
begin
	select preference_type_id into v_type_id
	from user_preference_types where short_name = p_preference_type;

	-- if there is no such preference type
	if NOT FOUND then return NULL; end if;

	   select count(*) into v_count from user_preference_values
           where preference_type_id= v_type_id
           and package_id= p_package_id
           and user_id= p_user_id;

	   if v_count > 0 then
		   update user_preference_values
		   set value= p_value
		   where preference_type_id= v_type_id
		   and package_id= p_package_id
		   and user_id= p_user_id;
           else
                insert into user_preference_values
                (preference_type_id, package_id, user_id, value) values
                (v_type_id, p_package_id, p_user_id, p_value);
           end if;

	   return 0;

end;' language 'plpgsql';


select define_function_args('user_pref_type__del', 'preference_type_id');

create or replace function user_pref_type__del (integer)
returns int4 as '
declare
           p_preference_type_id           alias for $1;
begin
       PERFORM acs_object__del(p_preference_type_id);
	   return 0;
end;' language 'plpgsql';

