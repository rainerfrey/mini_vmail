hosts = localhost
user = mini_vmail
dbname = mini_vmail
query = SELECT d.name FROM domains d WHERE d.active=TRUE AND d.name='%s'