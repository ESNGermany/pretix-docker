restic backup --tag db --stdin-filename dump.sql --stdin-from-command -- pg_dumpall -h postgres
restic backup --tag app /data
