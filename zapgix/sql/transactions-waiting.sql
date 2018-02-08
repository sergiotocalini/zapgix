SELECT	coalesce(extract(epoch FROM max(age(now(), query_start))), 0)
FROM	pg_stat_activity
WHERE	wait_event IS NOT NULL
