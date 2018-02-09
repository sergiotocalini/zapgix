SELECT	count(*)
FROM	pg_trigger
WHERE	tgenabled='O'
AND	tgname='$2'
