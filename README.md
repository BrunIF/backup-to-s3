## Install duplicity from PPA

Install **Duplicity** from [PPA:Duplicity-team](https://launchpad.net/~duplicity-team/+archive/ubuntu/ppa)

```
sudo apt-get install software-properties-common
sudo apt-add-repository -y ppa:duplicity-team/ppa && sudo apt update
```

## Install additional software

```
sudo apt install -y duplicity git python-pip mailutils
```

To configure ssmtp follow [this link](https://rianjs.net/2013/08/send-email-from-linux-server-using-gmail-and-ubuntu-two-factor-authentication)

## Install PIP

```
apt-get install python-pip
```

## Install Python modules

```
pip install awscli
pip install boto
```

## Install Backup system

```
git clone https://github.com/BrunIF/backup-to-s3.git /root/backup
cd /root/backup
```

## Configure

You must change default variable values to own in *backup.conf*. Before copy from example

```
cp backup.conf.example backup.conf
vim backup.conf
```

## Cron schedule

For example run backup every night at 4:00. Run `crontab -e`

```
0 4 * * * /root/backup/backup-to-s3.sh
```

## Restore files or/and folder

```
restore.sh "2017-10-24" database-backup /folder-to-extract
```


