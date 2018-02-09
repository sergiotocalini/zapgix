SELECT	count(*)
FROM	pg_stat_activity
WHERE	wait_event IS NOT NULL
