SELECT	n.nspname,c.relname
FROM	pg_catalog.pg_class c
	LEFT JOIN pg_catalog.pg_namespace n ON n.oid = c.relnamespace
WHERE	c.relkind IN ('r','s','')
	AND n.nspname NOT IN ('^pg_toast','information_schema','pg_catalog')
