<?xml version="1.0"?>
<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="preference::set_package_default.set_package_default">
<querytext>
select user_pref_type__set_package_default(
       :preference_type_id,
       :package_id,
       :default_value
);
</querytext>
</fullquery>

<fullquery name="preference::set_user_pref__set_user_pref">
<querytext>
select user_pref_type.set_user_pref(
        :preference_type_id,
        :package_id,
        :user_id,
        :value
);
</querytext>
</fullquery>

<fullquery name="preference::get_user_pref.get_user_pref">
<querytext>
select user_pref_type__get_user_pref (
           :preference_type_id,
           :package_id,
           :user_id
      );
</querytext>
</fullquery>
 
</queryset>
