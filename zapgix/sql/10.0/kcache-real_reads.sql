SELECT	1 - k.reads_blks/d.blks_read
FROM	(SELECT SUM(reads_blks) as reads_blks FROM pg_stat_kcache) k,
	(SELECT SUM(blks_read) as blks_read FROM pg_stat_database) d
