<?xml version="1.0"?>
<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="preference::set_package_default.set_package_default">
<querytext>
declare begin
  user_pref_type.set_package_default(
       preference_type_id => :preference_type_id,
       package_id => :package_id,
       default_value => :default_value
  );
end;
</querytext>
</fullquery>

<fullquery name="preference::set_user_pref.set_user_pref">
<querytext>
declare begin
   user_pref_type.set_user_pref(
        preference_type_id => :preference_type_id,
        package_id => :package_id,
        user_id => :user_id,
        value => :value
   );
end;
</querytext>
</fullquery>

<fullquery name="preference::get_user_pref.get_user_pref">
<querytext>
declare begin
:1 := user_pref_type.get_user_pref (
           preference_type_id => :preference_type_id,
           package_id => :package_id,
           user_id => :user_id
      );
end;
</querytext>
</fullquery>
 
</queryset>
