SELECT	coalesce(:p2, 0)
FROM	pg_statio_user_tables
WHERE	(schemaname || '.' || relname) = :p1
