<?xml version="1.0"?>
<queryset>

<fullquery name="preference::get_preference_type_id.select_preference_type_id">
<querytext>
select preference_type_id from user_preference_types
where short_name= :preference_type
</querytext>
</fullquery>

</queryset>
