# Generate User Report


```sql
-- Create from the "timesheet" (weekly) perspective 
SELECT * FROM timesheet ts
LEFT JOIN public.user u ON "u"."id"="ts"."userId"
LEFT JOIN contact c ON "c"."id"="u"."contactId"
LEFT JOIN mou m on "m"."id"="ts"."mouId"
ORDER BY c."fullName"

-- Create from the timesheetentry (daily) perspective
SELECT * FROM timesheet_entry tse
LEFT JOIN timesheet ts ON "tse"."timesheetId"="ts"."id"
LEFT JOIN public.user u ON "u"."id"="ts"."userId"
LEFT JOIN contact c ON "c"."id"="u"."contactId"
LEFT JOIN mou m on "m"."id"="ts"."mouId"
ORDER BY c."fullName"
```