# ansible_slurm

## Description

Vagrant virtualbox configuration to use Ansible to configure a Lab SLURM cluster with head node and two compute nodes

## Environments

- Red Hat 7 (tested using centos/7 vagrant box)
- Red Hat 8 (tested using almalinux/8 vagrant box)
- Red Hat 9 (tested using almalinux/9 vagrant box)

> Manually change the box used in the Vagrantfile

## Requirements

- virtualbox
- vagrant

## Usage

```
vagrant up
vagrant ssh slhn
```
```
[vagrant@slhn ~]$ sbatch run_mpiexample
```

### Additional playbooks:

```
./runansible R.yml
vagrant ssh slhn
```
```
[vagrant@slhn ~]$ Rscript Rexample.r
```

## Using without vagrant

The Ansible inventory file created by vagrant is below. This is what is needed to use the ansible playbooks away from vagrant. The playbooks need to run in the following order:
- site.yml
- openmpi.yml
- keyscan.yml
- startautofs.yml

> keyscan and startautofs are seperate from site in the vagrant configuration because they need all the machines running

> openmpi.yml is optional. The order shown is the order vagrant runs the playbooks.


### Example inventory file:
> Taken from inventory file created by vagrant
```
slcn1
slcn2
slhn

[headnodes]
slhn

[computenodes]
slcn1
slcn2

[headnodes:vars]
host_domain=lab.local

[computenodes:vars]
noderange=slcn[1-2]
headnode=slhn
headnodeip=172.16.2.100
host_domain=lab.local
host_net=172.16.2.0/24
```
