DROP TABLE IF EXISTS duplicatedUsers;
CREATE TEMP TABLE duplicatedUsers (
	dupUserId uuid,
	dupReferenceId varchar,
	dupContactId uuid
);

do $$
declare
   referenceId varchar; 
   userId uuid;
   contactId uuid;
begin			
	-- Gets duplicated users
	select "referenceId" 
		into referenceId
	from public.user as u
		left join contact c on u."contactId" = c.id
	group by "referenceId"
	having count("referenceId") > 1;

	raise notice 'referenceId found: %', referenceId;

	-- Gets oldest user and contact based on referenceId
	select u.id as userId, c.id as contactId
		into userId, contactId
	from public.user as u
		left join contact c on u."contactId" = c.id
	where "referenceId" = referenceId
	order by c."dateCreated" asc
	limit 1;

	raise notice 'oldest user userId: %, contactId: %', userId, contactId;

	-- insert records into temp table
	insert into duplicatedUsers
	select u.id as userId, u."referenceId", c.id as contactId
	from public.user as u
		left join contact c on u."contactId" = c.id
	where "referenceId" = referenceId;

	-- CURRENTLY UPDATES ONLY TABLES
	-- TIMESHEET, PROJECT 
	-- OTHER TABLES UPDATES MIGHT BE NEEDED
	update public.timesheet
		set "userId" = userId
	where "userId" in (select dupUserId from duplicatedUsers);

	update public.project
		set "leadUserId" = userId
	where "leadUserId" in (select dupUserId from duplicatedUsers);

	update public.project
		set "backupUserId" = userId
	where "backupUserId" in (select dupUserId from duplicatedUsers);

	delete from public.user
	where 
		"id" != userId AND
		"id" in (select dupUserId from duplicatedUsers);

	delete from public.contact 
	where 
		"id" != contactId AND
		"id" in (select dupContactId from duplicatedUsers);
		
end; $$;

select * from duplicatedUsers;
