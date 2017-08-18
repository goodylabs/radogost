# radogost
[![Stories in Ready](https://badge.waffle.io/goodylabs/radogost.svg?label=ready&title=Ready)](http://waffle.io/goodylabs/radogost)
[![Stories in Progress](https://badge.waffle.io/goodylabs/radogost.svg?label=in%20progress&title=In%20Progress)](http://waffle.io/goodylabs/radogost)

[![Throughput Graph](http://graphs.waffle.io/goodylabs/radogost/throughput.svg)](https://waffle.io/goodylabs/radogost/metrics)

[Radogost](http://en.wikipedia.org/wiki/Radegast_%28god%29) 
is an old god of hospitality in the Slavic mythology.

This project is a set of scripts to:
* fetch backup from remote machines using [scp](http://en.wikipedia.org/wiki/Secure_copy) 

## Download (both on source server and on backup machine)

``` 
cd $HOME
git clone https://github.com/goodylabs/radogost.git
```

## Configure the database backup procedure on source server (optional)

Example for MySQL for smaller databases with default table locking and UTF-8 with emojis for data consistency (leave last 3 backups):

```bash
{ crontab -l ; echo '30 5 * * * CURR_DATE=`date +\%Y\%m\%d\%H\%M\%S` && /bin/mkdir -p /root/backup && /usr/bin/mysqldump --lock-tables=true --default-character-set=utf8mb4 -u root project_x > /root/backup/backup_${CURR_DATE}_project_x.sql && /bin/gzip -9r /root/backup/backup_${CURR_DATE}_project_x.sql && /root/radogost/scripts/rotate_latest_backups.sh /root/backup *.sql.gz 3'; } | crontab -
```
Example for MySQL for larger databases with UTF-8 encoding with emojis but without default table locking that can cause a database speed downgrade on a heavily used production server (leave last 3 backups):

```bash
{ crontab -l ; echo '30 5 * * * CURR_DATE=`date +\%Y\%m\%d\%H\%M\%S` && /bin/mkdir -p /root/backup && /usr/bin/mysqldump --lock-tables=false --default-character-set=utf8mb4 -u root project_x > /root/backup/backup_${CURR_DATE}_project_x.sql && /bin/gzip -9r /root/backup/backup_${CURR_DATE}_project_x.sql && /root/radogost/scripts/rotate_latest_backups.sh /root/backup *.sql.gz 3'; } | crontab -
```


Example for Redis (leave last 3 backups):

```bash
{ crontab -l ; echo '30 5 * * * CURR_DATE=`date +\%Y\%m\%d\%H\%M\%S` && /bin/mkdir -p /root/backup && /bin/cp /var/lib/redis/dump.rdb /root/backup/backup_${CURR_DATE}_dump.rdb && /bin/gzip -9r /root/backup/backup_${CURR_DATE}_dump.rdb && /root/radogost/scripts/rotate_latest_backups.sh /root/backup *.rdb.gz 3'; } | crontab -
```

## Install in crontab on backup machine

The following will install a crontab entry with fetching:
* files that match regexp: backup_*.sql.gz
* from a remote directory /home/some_remote_user/backup
* from a remote machine somehost.com:22 

and put it in $HOME/project_x into local user.
It will autorotate old backups and only latest 3 will remain in that directory.

```bash
{ crontab -l ; echo '38 5 * * * $HOME/radogost/scripts/fetch_latest_backups.sh root somehost.com 22 /root/backup "backup_*.sql.gz" $HOME/project_x 3'; } | crontab -
```
