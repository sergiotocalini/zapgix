SELECT	count(*)
FROM	pg_buffercache
WHERE	reldatabase IS NOT NULL
