restic backup --tag db --stdin-filename db.dump --stdin-from-command -- pg_dump -Fc
restic backup --tag app /data
