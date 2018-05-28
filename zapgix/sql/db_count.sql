SELECT	COUNT(*)
FROM	pg_database
WHERE	datistemplate = false
AND	datname NOT IN ('postgres', 'repmgr');
