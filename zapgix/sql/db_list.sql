SELECT	datname, oid
FROM	pg_database
WHERE	NOT datistemplate
	AND datallowconn
	AND datname!='postgres'

