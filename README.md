### Simplified Puppet Script for IPA

After cloning this repo, you can run these scripts one of two ways:

1. [Vagrant](#Vagrant)
2. [via Puppet directly on the machine(s)](#Puppet)

#### Vagrant

##### Requirements:

* VirtualBox
* vagrant

##### To Run

0. Clone this repo locally.
1. `cd Puppet_IPA`
2. Optional: Edit `Vagrantfile` and both `server/params.pp` and `client/params.pp` for desired parameters.
2. Either `vagrant up` to bring both machines up (server will be installed first, then client), or individually with `vagrant up server` followed by `vagrant up client`.
3. To play around in the VM created after it’s/they’re all set up, do `vagrant ssh $NAME`
4. `vagrant suspend ($NAME)` will stop the VM(s) from running and save the current state of the VM(s).
5. `vagrant reload ($NAME)`, done after suspending, will bring up the original VM(s), throw away previous configurations, and rerun the setup/installation process (for when adjustments are made to scripts/Vagrantfile).

#### Puppet

##### Requirements

* two VMs, remote or local
* Fedora 18

##### To Run

0. Clone this repo within both of the VMs.
1. On Server VM:
	2. `yum install puppet -y`
	1. `cd` into the repository
	3. Edit `server/params.pp` as necessary.
	3. `puppet module install puppetlabs/stdlib --verbose`
	4. `cp server/params.pp /etc/puppet/modules/ipa/manifests/params.pp`
	5. `puppet apply --verbose /etc/puppet/modules/ipa/manifests/init.pp -e 'include ipa'`
2. Repeat previous step on client, replacing the `server` foldername with `client` in step 2.3 and 2.4
