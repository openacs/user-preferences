
--
-- The User Preferences package
--
-- Copyright (C) 2000 MIT
-- ben@openforce
--
-- distributed under the GPL v2
--
-- May 21st 2002
-- 

-- the drop scripts

drop table user_preference_default_values;

drop table user_preference_values;

drop table user_preference_types;


--
-- Object Types
--

declare
begin
        acs_object_type.drop_type (
            object_type => 'user_pref_type'
        );
end;
/
show errors
