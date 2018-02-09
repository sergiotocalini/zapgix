SELECT	count(*)
FROM	pg_buffercache
WHERE	NOT isdirty
