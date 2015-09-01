<<<<<<< HEAD
VM Penetration Lab
==================

> Resources for security, penetration testing and the OSCP certification

###Requirements

- [ ] You have administrator privileges
- [ ] [Git for Windows](https://git-scm.herokuapp.com/download/win) is installed
- [ ] ```<path to Git software directory>/bin/ssh.exe``` is in ```%PATH%``` variable
- [ ] [Virtualbox](https://www.virtualbox.org/wiki/Downloads) is installed
- [ ] [Vagrant](https://www.vagrantup.com/) is installed
- [ ] [vagrant-hostmanager](https://github.com/smdahlen/vagrant-hostmanager) plugin [is installed](https://docs.vagrantup.com/v2/plugins/usage.html)

###Set-up

- [ ] Clone pentest-lab repo locally (or just [download the zip file](https://github.com/jhwohlgemuth/geki/archive/master.zip)): 

    ```> git clone https://github.com/jhwohlgemuth/pentest-lab.git```

- [ ] Change into pentest-lab directory:

    ```> cd pentest-lab```
    
- [ ] Create Vagrant VM environment: 

    ```> vagrant up```

> **Note:** You will have to acknowledge Windows UAC dialogues twice during this step to set the host names of the VMs

- [ ] Access the kali client with

    ```> vagrant ssh kali-client```
    
- [ ] Navigate to [dvwa.server.io/setup.php](http://dvwa.server.io/setup.php) in you favorite browser and click "Create / Reset Database"
- [ ] Administer the DVWA from [dvwa.server.io](http://dvwa.server.io)

    **Username:** ```admin```
    
    **Password:** ```password```
    
- [ ] [PWN](https://en.wikipedia.org/wiki/Pwn) [DVWA](http://www.dvwa.co.uk/) [FTW](http://www.urbandictionary.com/define.php?term=FTW)!!! :trollface:

###Help

- [Vagrant](https://docs.vagrantup.com/v2/)
- [DVWA](https://github.com/RandomStorm/DVWA)

##Links

- [Sample Penetration Report from offensive-security.com](https://www.offensive-security.com/reports/penetration-testing-sample-report-2013.pdf)
- [Listing of publicly available Vagrant Kali Linux boxes](https://atlas.hashicorp.com/boxes/search?utf8=%E2%9C%93&sort=&provider=&q=kali)
- [Guide for installing Kali on cubox-i computer](http://docs.kali.org/kali-on-arm/install-kali-arm-on-a-cubox)
- [Kali Linux Downloads page](https://www.offensive-security.com/kali-linux-vmware-arm-image-download/)
- [Sandcat Browser](http://www.syhunt.com/sandcat/)
- [Vulnerable by Design](https://www.vulnhub.com/)
- [Mantra Hackery](http://www.getmantra.com/hackery/)

##To-do

- [ ] Inventory components for penetration lab
- [ ] Collect necessary components for lab (Operating systems, routers, WiFi devices, SD cards, etc...)
- [ ] Set-up virtual environments
- [ ] Practice assessing, exploiting, and reporting
=======
<div align="center">
    <a href="http://jhwohlgemuth.github.com/techtonic"><img src="http://images.jhwohlgemuth.com/original/logo/tech/techtonic.png?v=1" alt="techtonic"/></a>
</div>

Data Store &nbsp;[![MongoDB](https://img.shields.io/badge/use-mongo-brightgreen.svg)](#using-mongodb)&nbsp;[![redis](https://img.shields.io/badge/use-redis-brightgreen.svg)](#using-redis)&nbsp;[![CouchDB](https://img.shields.io/badge/use-couchdb-brightgreen.svg)](#using-couchdb)
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
- vagrant hostmanager plugin is installed ```vagrant plugin install vagrant-hostmanager```

###Using [MongoDB](http://docs.mongodb.org/manual/)

**&#x02713;** Set ```inline``` to ```$install_mongo``` on [line 27](Vagrantfile#L27).

**&#x02713;** Execute ```vagrant up```

**&#x02713;** [Install Mongo for windows](https://github.com/jhwohlgemuth/techtonic/wiki#mongodb-setup-on-windows)

**&#x02713;** In a mongo console, execute ```mongo db.server```

> **Tip:** The default port for MongoDB is 27017.  It can be changed by editing ```/etc/mongod.conf```.

###Using [redis](http://redis.io/documentation/)

**&#x02713;** Set ```inline``` to ```$install_redis``` on [line 27](Vagrantfile#L27).

**&#x02713;** Execute ```vagrant up```

**&#x02713;** Install a redis client.  I like [Redis Commander](https://joeferner.github.io/redis-commander/).

> Install Redis Commander with ```npm install redis-commander --global```

**&#x02713;** Start Redis Commander with ```redis-commander --redis-host db.server```

**&#x02713;** Open your favorite browser and navigate to [localhost:8081](http://localhost:8081)

> **Tip** The default port for redis is 6379.  It can be changed by editing ```/etc/redis/redis.conf```.

###Using [CouchDB](http://docs.couchdb.org/en/1.6.1/)
**&#x02713;** Set  ```inline``` to ```$install_couch``` on [line 27](Vagrantfile#L27).

**&#x02713;** Execute ```vagrant up```

**&#x02713;** Create a ssh tunnel on your host machine (input ```yes```, then ```vagrant```):

    ssh -f -L localhost:5984:127.0.0.1:5984 vagrant@db.server -N

**&#x02713;** Open your favorite browser and navigate to [localhost:5984/_utils](http://localhost:5984/_utils)

> **Tip:** The default port for CouchDB is 5984.  It can be changed by editing ```/etc/couchdb/local.ini```

Tools, References & Resources
-----------------------------
- See wiki page, [Front-end Link Library](https://github.com/jhwohlgemuth/techtonic/wiki/Front-end-Link-Library)
>>>>>>> origin/master
