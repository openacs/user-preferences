
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

-- we would use acs_attributes if it wasn't so braindead in tying
-- everything to acs_object_types (ben)

create table user_preference_types (
       preference_type_id               integer not null
                                        constraint user_pref_type_id_pk primary key
                                        constraint user_pref_type_id_fk references acs_objects(object_id),
       package_key                      varchar(100)
                                        constraint user_pref_type_pack_key_fk
                                        references apm_package_types(package_key),
       short_name                       varchar(100) not null,
       constraint user_pref_un unique (package_key, short_name),
       pretty_name                      varchar(250) not null,
       datatype                         varchar(20) default 'text' not null
                                        constraint user_pref_datatype_ch
                                        check (datatype in ('text','number','enum')),
       -- denormalized options if the datatype is choice
       -- we really don't need a table of these. They are separated by "|"
       options                          varchar(2000),
       -- preference-type wide default value
       default_value                    varchar(200)
);


-- These are the default values for package-instance specific stuff
create table user_preference_default_values (
       preference_type_id                   integer not null
                                            constraint user_pref_def_val_type_id_fk
                                            references user_preference_types(preference_type_id),
       package_id                           integer not null
                                            constraint user_pref_def_val_pack_id_fk
                                            references apm_packages(package_id),
       constraint user_pref_def_val_pk
       primary key (preference_type_id, package_id),
       default_value                        varchar(200) not null
);


-- These are the user preferences
create table user_preference_values (
       preference_type_id               integer not null
                                        constraint user_pref_val_type_id_fk
                                        references user_preference_types(preference_type_id),
       user_id                          integer not null
                                        constraint user_pref_val_user_id_fk
                                        references users(user_id),
       package_id                       integer
                                        constraint user_pref_val_pack_id_fk
                                        references apm_packages(package_id),
       constraint user_pref_val_pk
       primary key (preference_type_id, user_id, package_id),
       value                            varchar(200)
);



--
-- Object Types
--

declare
begin
        acs_object_type.create_type (
            supertype => 'acs_object',
            object_type => 'user_pref_type',
            pretty_name => 'User Preference Type',
            pretty_plural => 'User Preference Types',
            table_name => 'user_preference_types',
            id_column => 'preference_type_id',
            package_name => 'user_pref_type'
        );
end;
/
show errors
