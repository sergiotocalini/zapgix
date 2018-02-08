SELECT round((sum(total_time) / sum(calls))::numeric,2)
FROM   pg_stat_statements
