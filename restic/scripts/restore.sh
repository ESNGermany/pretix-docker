restic dump --tag db latest dump.sql | psql -h postgres
restic restore --tag app latest --target /app
