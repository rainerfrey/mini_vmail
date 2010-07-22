hosts = localhost
user = mini_vmail
dbname = mini_vmail
query = SELECT u.name FROM mailboxes u JOIN domains d on u.domain_id=d.id WHERE u.active=TRUE AND d.active=TRUE AND u.name = '%u' AND d.name = '%d'