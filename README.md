# UPDATE: I'm currently redesigning the app by writing an API on top of Dokku Daemon. Dokku Man will interact with the HTTP API instead of connecting it through SSH. No ETA but hang tight! https://github.com/beydogan/dokku-api

# dokku-man [![Status](https://img.shields.io/badge/stability-experimental-green.svg?style=flat-square)]()
Web interface to manage your dokku servers. Its **work in progress**

# Screenshots

## Dashboard
![SS](http://i.imgur.com/pUH0X4U.png)

* Manage your servers

## Server Dashboard
![SS](http://i.imgur.com/TCuSjDS.jpg)

* Manage a server. 
* Create apps on the server
* Install plugins to the server.
* Create plugin instances on the server
* Sync the server


## App Dashboard
![SS](http://i.imgur.com/FZA4Wly.jpg)

* Manage an app. 
* CRUD environment variables
* CRUD linked plugins. (redis, postgresql)
* List process list.
* ~~Scale processes~~(TODO)
