
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

-- the drop scripts

drop table user_preference_default_values;

drop table user_preference_values;

drop table user_preference_types;


--
-- Object Types
--

select acs_object_type__drop_type ('user_pref_type');
