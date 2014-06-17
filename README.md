[Hanlon](https://github.com/csc/Hanlon) Vagrant[ified]
==============
Please note that the provisioning shell "script" is being ported to chef-solo, puppet and ansible.


Getting Started
=====

Install Vagrant + VirtualBox
---
Requires [Vagrant](http://www.vagrantup.com/) and [VirtualBox](https://www.virtualbox.org/wiki/Downloads) - pick installers appropriate for your OS.

Set up Hanlon Server
---
Clone this repo:

```
git clone https://github.com/ap1kenobi/hanlon-vagrant ~/hanlon
cd ~/hanlon
vagrant up
```
Once it's finished provisioning (hopefully without errors), ssh to the VM:

```
vagrant ssh

```

and fire up Hanlon:

```
cd /opt/hanlon/script
./run-tri.sh
```

Notes
---
Only Hanlon Server and a couple of pre-requisites such as ipxe, tftpd and dhcpd, are deployed and configured.  See ```bootstrap.sh``` for details.

What still remains is automation of image and model creation - see manual steps below... 

Set up provisioning
---
Open a second ssh connection:

```
vagrant ssh
cd /opt/hanlon
```

Create iPXE configuration:

```
./cli/hanlon config ipxe > /tftpboot/hanlon.ipxe
```

Get Hanlon Microkernel and add it to the image repo:

```
wget https://github.com/csc/Hanlon-Microkernel/releases/download/v1.0/hnl_mk_prod-image.1.0.iso
./cli/hanlon image add -t mk -p hnl_mk_prod-image.1.0.iso

```

Add CentOS ISO to the image repo:

```
wget http://reflector.westga.edu/repos/CentOS/6.5/isos/x86_64/CentOS-6.5-x86_64-minimal.iso
./cli/hanlon image add -t os -p CentOS-6.5-x86_64-minimal.iso -n CentOS65 -v 6.5

```

Create model:

```
./cli/hanlon model add -t centos_6 -l centos65-model -i K3v2suiIkSYNEdx1CTKqs

```
Create the policy:

```
./cli/hanlon policy add --template=linux_deploy -l centos65-policy -m 2J5Vb2ztkks9pz1iLrCxks -t memsize_1GiB --enabled true
```

Credits
===

```bootstrap.sh``` and the manual steps are based on Joe's work outlined in his wiki page: [here](https://github.com/jcpowermac/hanlon-wiki/blob/master/detailed-hanlon-install.md) 
