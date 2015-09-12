<div align="center">
    <a href="http://jhwohlgemuth.github.com/techtonic"><img src="http://images.jhwohlgemuth.com/original/logo/tech/techtonic.png?v=1" alt="techtonic"/></a>
</div>

Data Store &nbsp;[![MongoDB](https://img.shields.io/badge/use-mongo-brightgreen.svg)](#using-mongodb)&nbsp;[![redis](https://img.shields.io/badge/use-redis-c6302b.svg)](#using-redis)&nbsp;[![CouchDB](https://img.shields.io/badge/use-couchdb-brightgreen.svg)](#using-couchdb)
==========
> Leverage Vagrant to start developing with the latest and greatest data stores

Requirements
------------
<a href="https://nodejs.org/"><img src="http://images.jhwohlgemuth.com/web/node.png" height="60" alt="Node.js"/></a>
<a href="https://www.virtualbox.org/wiki/Downloads"><img src="http://images.jhwohlgemuth.com/web/virtualbox.png" height="60" alt="VirtualBox"/></a>
<a href="https://www.vagrantup.com/"><img src="http://images.jhwohlgemuth.com/web/vagrant.png" height="60" alt="Vagrant"/></a>
- [Node.js](https://nodejs.org/) is installed
- [Virtualbox](https://www.virtualbox.org/wiki/Downloads) is installed
- [Vagrant](https://www.vagrantup.com/) is installed

Using [MongoDB](http://docs.mongodb.org/manual/)
-----
* In command line:
  * `npm install`
  * `npm start` > Choose `MongoDB` and press **ENTER**
*  [Install Mongo for windows](https://github.com/jhwohlgemuth/techtonic/wiki#mongodb-setup-on-windows)
*  In a mongo console on the host, execute `mongo 10.10.10.11`

> **Tip:** The default port for MongoDB is 27017.  It can be changed by editing `/etc/mongod.conf`.

Using [Redis](http://redis.io/documentation/)
-----
* In command line:
  * `npm install`
  * `npm start` > Choose `Redis` and press **ENTER**
  *  Start Redis Commander with ```redis-commander --redis-host 10.10.10.11```
*  Navigate to [localhost:8081](http://localhost:8081)

> **Tip** The default port for Redis is 6379.  It can be changed by editing `/etc/redis/redis.conf`.

Using [CouchDB](http://docs.couchdb.org/en/1.6.1/)
-----
* In command line:
  * `npm install`
  * `npm start` > Choose `CouchDB` and press **ENTER**
  * Once vagrant is done, execute `grunt exec:couch` (password: `vagrant`)
* Navigate to [localhost:5984/_utils](http://localhost:5984/_utils)

> **Tip:** The default port for CouchDB is 5984.  It can be changed by editing `/etc/couchdb/local.ini`

Tools, References & Resources
-----------------------------
- See wiki page, [Front-end Link Library](https://github.com/jhwohlgemuth/techtonic/wiki/Front-end-Link-Library)
