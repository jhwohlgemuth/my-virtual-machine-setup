![Geki](/assets/img/geki.jpg "Geki: Security, penetration testing, and OSCP")
====

> Resources for security, penetration testing and the OSCP certification

Background
----------

> *geki* (撃) is *attack* in [Japanese](https://translate.google.com/#auto/ja/attack).

As I work toward earning the
[Offensive Security Certified Professional (OSCP) certification](https://www.offensive-security.com/information-security-certifications/oscp-offensive-security-certified-professional/),
I will collect and maintain my links, lessons learned, and resources in this repo.

##VM Penetration Lab

###:computer: Requirements

- [ ] You have adminstrator privileges
- [ ] [Git for Windows](https://git-scm.herokuapp.com/download/win) is installed
- [ ] ```<path to Git software directory>/bin/ssh.exe``` is in ```%PATH%``` variable
- [ ] [Virtualbox](https://www.virtualbox.org/wiki/Downloads) is installed
- [ ] [Vagrant](https://www.vagrantup.com/) is installed
- [ ] [vagrant-hostmanager](https://github.com/smdahlen/vagrant-hostmanager) plugin [is installed](https://docs.vagrantup.com/v2/plugins/usage.html)

###:wrench: Set-up

- [ ] Clone geki repo locally (or just [download the zip file](https://github.com/jhwohlgemuth/geki/archive/master.zip)): 

    ```> git clone https://github.com/jhwohlgemuth/geki.git```

- [ ] Change into geki directory:

    ```> cd geki```
    
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

###:question: Help

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

##:clipboard: To-do

- [ ] Inventory components for penetration lab
- [ ] Collect necessary components for lab (Operating systems, routers, WiFi devices, SD cards, etc...)
- [ ] Set-up virtual environments
- [ ] Practice assessing, exploiting, and reporting
