SELECT	count(*)*100/(SELECT current_setting('max_connections')::int)
FROM	pg_stat_activity
