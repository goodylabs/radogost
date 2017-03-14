# radogost
[![Stories in Ready](https://badge.waffle.io/goodylabs/radogost.svg?label=ready&title=Ready)](http://waffle.io/goodylabs/radogost)
[![Stories in Progress](https://badge.waffle.io/goodylabs/radogost.svg?label=in%20progress&title=In%20Progress)](http://waffle.io/goodylabs/radogost)

[![Throughput Graph](http://graphs.waffle.io/goodylabs/radogost/throughput.svg)](https://waffle.io/goodylabs/radogost/metrics)

[Radogost](http://en.wikipedia.org/wiki/Radegast_%28god%29) 
is an old god of hospitality in the Slavic mythology.

This project is a set of scripts to:
* fetch backup from remote machines using [scp](http://en.wikipedia.org/wiki/Secure_copy) 

## Download 

``` 
cd $HOME
git clone https://github.com/goodylabs/radogost.git
```

## Configure the backup procedure on the server (optional)

Example for MySQL:

```bash
{ crontab -l ; echo '30 5 * * * /bin/mkdir -p /root/backup && CURR_DATE=`date +%Y%m%d` /usr/bin/mysqldump -u root project_x > /root/backup/backup_${CURR_DATE}_project_x.sql && /bin/gzip -9r /root/backup/backup_${CURR_DATE}_project_x.sql; } | crontab -
```

## Install in crontab

The following will install a crontab entry with fetching:
* files that match regexp: backup_*.sql.gz
* from a remote directory /home/some_remote_user/backup
* from a remote machine somehost.com:22 

and put it in $HOME/project_x into local user.
It will autorotate old backups and only latest 3 will remain in that directory.

```bash
{ crontab -l ; echo '38 5 * * * $HOME/radogost/scripts/fetch_latest_backups.sh somehost.com 22 /home/some_remote_user/backup "backup_*.sql.gz" $HOME/project_x 3'; } | crontab -
```
