# Generate User Report

```sql
SELECT * FROM timesheet ts
LEFT JOIN public.user u ON "u"."id"="ts"."userId"
LEFT JOIN contact c ON "c"."id"="u"."contactId"
LEFT JOIN mou m on "m"."id"="ts"."mouId"
ORDER BY c."fullName"
```