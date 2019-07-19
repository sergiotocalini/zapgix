# zapgix
Zabbix Agent - PostgreSQL

# Dependencies
## Packages
* ksh
* sudo

### Debian/Ubuntu

```
#~ sudo apt install ksh sudo
#~
```

### Red Hat

```
#~ sudo yum install ksh sudo
#~
```

# Deploy
## PostgreSQL
We may need to enable some extensions.
```
postgres=# CREATE EXTENSION pg_buffercache;
CREATE EXTENSION
postgres=# \dx pg_buffercache
                    List of installed extensions
      Name      | Version | Schema |           Description           
----------------+---------+--------+---------------------------------
 pg_buffercache | 1.0     | public | examine the shared buffer cache
(1 row)
postgres=#
```

## Zabbix

Zabbix user has to have sudo privileges.

```
#~ cat /etc/sudoers.d/user_zabbix
# Allow the user zabbix to execute any command without password
Defaults:zabbix !requiretty
zabbix  ALL=(ALL:ALL) NOPASSWD:ALL
```

Then you can run the deploy_zabbix script

```
#~ git clone https://github.com/sergiotocalini/zapgix.git
#~ sudo ./zapgix/deploy_zabbix.sh
#~ sudo systemctl restart zabbix-agent
```

*Note: the installation has to be executed on the zabbix agent host and you have to import the template on the zabbix web. The default installation directory is /etc/zabbix/scripts/agentd/zapgix/*
