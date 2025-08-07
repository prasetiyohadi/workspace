# Saltstack

[Getting started](https://docs.saltstack.com/en/getstarted/)

## Concepts

### Grains

Grains are static information SaltStack collects about the underlying managed system. SaltStack collects grains for the operating system,
domain name, IP address, kernel, OS type, memory, and many other system properties.

You can add your own grains to a Salt minion by placing them in the /etc/salt/grains file on the Salt master, or in the Salt minion
configuration file under the grains section.

List all of the grains on a salt minion `salt 'minion1' grains.ls`

### States

Saltstack master serve a simple file server in default base path in **/srv/salt** to store states files to the minions.

State file example **/srv/salt/nettools.sls**

```
install_network_packages:
  pkg.installed:
    - pkgs:
      - rsync
      - lftp
      - curl
```

Apply state nettools state `salt 'minion2' state.sls nettools`

Highstate
: A highstate causes all targeted minions to download the /srv/salt/top.sls file and find any matching targets.

Update your top file **/srv/salt/top.sls**

```
base:
  '*':
    - common
  'minion1':
    - nettools
```

Apply the Top file `salt --batch-size 10 '*' state.apply`

Apply the Top file in batches for large minions `salt --batch-size 10 '*' state.apply`

## Commands

### Keys management

View all keys `salt-key --list-all`

Accept a specific key `salt-key --accept=<key>`

Accept all keys `salt-key --accept-all`

### Execute commands

Send a command `salt '*' test.ping`

Command structure

```
salt '*' pkg.install cowsay
salt <target> <module.function> <arguments>
```

Documentation

```
salt '*' sys.doc
salt '*' sys.doc pkg
salt '*' sys.doc pkg.install
```

Run a shell command `salt '*' cmd.run 'ls -l /etc'`

Show disk usage `salt '*' disk.usage`

Install a package `salt '*' pkg.install cowsay`

List network interfaces `salt '*' network.interfaces`

### Targeting hosts

Target single host `salt 'minion1' disk.usage`

Globbing `salt 'minion*' disk.usage`

Using Grains system `salt -G 'os:Ubuntu' test.ping`

Using regex `salt -E 'minion[0-9]' test.ping`

Using list `salt -L 'minion1,minion2' test.ping`

Multiple target types `salt -C 'G@os:Ubuntu and minion* or S@192.168.50.*' test.ping`

## Terminology

Formula
: A collection of Salt state and Salt pillar files that configure an application or system component. Most formulas are made up of several Salt states spread across multiple Salt state files.

State
: A reusable declaration that configures a specific part of a system. Each Salt state is defined using a state declaration.

State Declaration
: A top level section of a state file that lists the state function calls and arguments that make up a state. Each state declaration starts with a unique ID.

State Functions
: Commands that you call to perform a configuration task on a system.

State File
: A file with an SLS extension that contains one or more state declarations.

Pillar File
: A file with an SLS extension that defines custom variables and data for a system.
