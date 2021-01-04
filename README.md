![Travis (.com) branch](https://img.shields.io/travis/com/H2CK/webtrees/master?label=multi-arch%20build&style=plastic) ![Docker Pulls](https://img.shields.io/docker/pulls/dtjs48jkt/webtrees?style=plastic) ![GitHub tag (latest by date)](https://img.shields.io/github/v/tag/H2CK/webtrees?style=plastic)

# docker-webtrees

[webtrees](http://www.webtrees.net) is a free open source web-based genealogy application intended for collaborative use.
It is compatible with standard 5.5.1-GEDCOM files. In this docker image based on phusion webtrees is provided. A database is not embedded in this image.

Since 12/07/19 version 2.0 is officially released and also provided by this repository as docker image.

This container now supports multiple architectures. That allows to run this image for example also on a Raspberry Pi.
Please use the corresponding newly introduced image tags using the following syntax: ```<webtrees version>-<build version>-<architecture>```
Supported architectures are: amd64, arm32v7, arm64v8, i386, ppc64le, s390x

## Usage

```sh
docker run -d -p 8088:8079 --name webtrees --link mysql:db -v /webtrees/data:/var/www/html/data -e GROUP_ID=999 -e PORT=8079 --restart always dtjs48jkt/webtrees
```

After starting the docker container go to:

https://server or https://server:port if you have defined an alternative port

## Update Functionality

This docker image is based on Ubuntu. On each start of the container an update of the used Ubuntu packages could be performed. Due to the running update it might take a little longer until the application webtrees is available. This auto-update functionality has (now) to be activated explicitly (-e UPDATE_ON_START=TRUE).

## Persistent storage of data

Configuration and media files should be stored outside the container. Therefor you should create a directories that is mapped to the container internal directory /var/www/html/data.
In the container apache is running under user www-data [33] (group www-data[33]). The directory must therfore be read- and writable for this user. If this is not possible you can use the alternative and use the parameter GROUP_ID to inform the container about the group that has read and write access to those folders.

## Database

The image does not contain a MySQL database. Instead you have to use a separate MySQL instance. For example you could use the [MySQL Docker Image](https://store.docker.com/images/mysql). Using the --link parameter a direct connection to the database in an other container could be established.
If you use the --link parameter it is sufficient to set as database hostname db and port 3306. This can be set during the initial setup in the wizard or directly in the file config.ini.php (in data directory /var/www/html/data). The database user must have all access rights to create the necessary database and tables.

## Logging

Log data of the contained web-server is written in the files in the folder /var/log/apache2/. If access to those files is necessary this location could be mapped to an external volume.

## Port of Apache web server / Encryption

This image supports per default https based communication on port 443. Alternatively you can use this image also only using http, e.g. if you only use it within your home network.

### Details on encryption

If it is necessary to change the default port (e.g. in case of collisions) you can set the optional parameter PORT to a different value.
The https communication is based on a self signed certificate. It is possible to use an alternative certificate. Therfore you have to map the internal folder /crt to an external location. This folder should contain the two files webtrees.key (Key without password protection) und webtrees.crt (certificate). It is not possible to change further encryption settings from outside the container.
If you want a more sofisticated encryption you should use a reverse proxy in front of the webtrees container.

### Using http only

It is possible to use the image without https support. For that you have to start the container with the following environament variables set.

```sh
docker run -d -p 80:80 --name webtrees --link mysql:db -v /webtrees/data:/var/www/html/data -e DISABLE_SSL=TRUE -e PORT=80 --restart always dtjs48jkt/webtrees
```

## Usage of additional 3rd party modules

It is possible to use additional 3rd party modules of webtrees with this container. To use such modules it is necessary to mount those folders containing the module into the following location `-v /var/www/html/modules_v4/<modulexxx>`

## Using Pretty URLs

It is possible to use pretty urls with this image. You can set in the config.ini.php file the following attributes:

```none
redirect_urls="1"
base_url="http://localhost"
```

When using pretty urls it is necessary to set also the base_url. Otherwise you will end up with an error "Too many redirects".

It is also possible to active pretty urls by using environment variables. You could set `-e PRETTYURLS=TRUE` and `-e BASE_URL=http://localhost`. This will set the necessary settings in the config.ini.php.

## Automatic initialization of database

For MySQL or MariaDB it is possible to use an automatical initalization of the database within the application. User the parameters to DB_* and WT_* to set the corresponding values. To possible error of the initialization start the container in interactve mode using -it.

## Support for PostgreSQL or SQLServer

This image contains now the necessary libraries to optionally also select PostgreSQL or SQLServer as db storage in the setup wizard.

## Parameters

* `-v /var/www/html/data` - Where webtrees server stores its config files
* `-v /etc/localtime` - Set to use the correct time of host
* `-e GROUP_ID` - allow access to mapped volumes
* `-e PORT` - change port web server listens on
* `-e UPDATE_ON_START` - if set to TRUE the auto-update functionality on restart is activated
* `-e ENABLE_REMOTE_USER` - if set to TRUE use REMOTE_USER for authentication
* `-e DISABLE_SSL` - if set to TRUE the image only provides an http entpoint. You should also set the port, because default port 443 is not modifed by this setting.
* `-e DB_USER` - can only be used at first instantiation to set the db username. Password (DB_PASSWORD) must also be set (see below), otherwise no initial setup is performed. If not present (only DB_PASSWORD is present) the default will be root.
* `-e DB_PASSWORD` - can only be used at first instantiation to set the db setting during instantiation and perform initial application setup.
* `-e DB_HOST` - can only be used at first instantiation to set the db hostname (or ip). Password (DB_PASSWORD) must also be set (see above), otherwise no initial setup is performed. If not present (only DB_PASSWORD is present) the default will be localhost.
* `-e DB_PORT` - can only be used at first instantiation to set the db port. Password (DB_PASSWORD) must also be set (see above), otherwise no initial setup is performed. If not present (only DB_PASSWORD is present) the default will be 3306.
* `-e DB_NAME` - can only be used at first instantiation to set the db name. Password (DB_PASSWORD) must also be set (see above), otherwise no initial setup is performed. If not present (only DB_PASSWORD is present) the default will be webtrees.
* `-e WT_ADMIN` - can only be used at first instantiation to set the initial webtrees admin user account name. Password (DB_PASSWORD) must also be set (see above), otherwise no initial setup is performed. If not present (only DB_PASSWORD is present) the default will be admin.
* `-e WT_ADMINPW` - can only be used at first instantiation to set the initial webtrees admin user account password. Password (DB_PASSWORD) must also be set (see above), otherwise no initial setup is performed. If not present (only DB_PASSWORD is present) the default will be admin123.
* `-e WT_ADMINMAIL` - can only be used at first instantiation to set the initial webtrees admin user account mail address. Password (DB_PASSWORD) must also be set (see above), otherwise no initial setup is performed. If not present (only DB_PASSWORD is present) the default will be noreply@webtrees.net.
`-e PRETTYURLS` - set to TRUE to allow usage of pretty urls.
`-e BASE_URL` - set to the correct url to allow usage of pretty urls.

## Versions

* **2017/10/13:** Initial release. webtrees 1.7.9
* **2018/06/27:** Webtrees 1.7.9 - Added switch to active/deactive auto update functionality
* **2018/08/30:** Webtrees 1.7.10 - Now using baseimage Ubuntu 18.04 / Added possibility to use external authentication using REMOTE_USER
* **2019/01/13:** Webtrees 1.7.12
* **2019/05/08:** Webtrees 1.7.14
* **2019/12/10:** Webtrees 1.7.16
* **2019/12/10:** Webtrees 2.0.0
* **2020/01/06:** Webtrees 2.0.1
* **2020/01/13:** Webtrees 2.0.1 - Added possibility to use image without https (only http) for local networks
* **2020/01/16:** Webtrees 2.0.1 - Added multi arch support
* **2020/02/01:** Webtrees 2.0.2
* **2020/03/06:** Webtrees 2.0.2 - Added support to automatically initialize db and webtrees. Provided K8S template for example deployment.
* **2020/03/18:** Webtrees 2.0.3 - Update to Webtrees 2.0.3
* **2020/05/18:** Webtrees 2.0.4 - Update to Webtrees 2.0.4
* **2020/05/18:** Webtrees 1.7.17 - Update to Webtrees 1.7.17
* **2020/06/04:** Webtrees 2.0.5 - Update to Webtrees 2.0.5
* **2020/06/08:** Webtrees 2.0.5 - Fixed PGSQL support
* **2020/06/14:** Webtrees 2.0.5 - Security Fix: Forbid access to data folder by apache
* **2020/06/18:** Webtrees 2.0.6
* **2020/07/27:** Webtrees 2.0.7
* **2020/08/11:** Webtrees 2.0.7 - Fixed documentation, removed separate media folder from v1.x and updated module path for version v2.x.
* **2020/10/04:** Webtrees 2.0.8
* **2020/10/10:** Webtrees 2.0.9
* **2020/10/18:** Webtrees 2.0.9 - Fixed auto setup of MySQL/MariaDB. (Added missing files - Issue #25)
* **2020/10/24:** Webtrees 2.0.10
* **2021/01/04:** Webtrees 2.0.11 - Added support for pretty urls
