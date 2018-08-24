SELECT	greatest(0,pg_xlog_location_diff(pg_current_xlog_location(), replay_location))
FROM	pg_stat_replication
WHERE	client_addr = :p1
