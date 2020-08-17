# Based on the default steam profile

# Persistent local customizations
include games.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.wine

# Allow java (blacklisted by disable-devel.inc)
include allow-java.inc

# Allow python (blacklisted by disable-interpreters.inc)
include allow-python2.inc
include allow-python3.inc

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include whitelist-var-common.inc

# allow-debuggers needed for running some games with proton
allow-debuggers
caps.drop all
netfilter
nodvd
nogroups
nonewprivs
noroot
notv
nou2f
protocol unix,inet,inet6,netlink

private-tmp

private ${HOME}/.local/opt/games
