SELECT	coalesce(extract(epoch FROM max(age(now(), prepared))), 0)
FROM	pg_prepared_xacts
