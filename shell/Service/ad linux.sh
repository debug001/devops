workgroup = PMAIL
server string = Mail-GateWay
realm = PMAIL.IDV.TW
netbios name = mail-gx
security = ads
password server = dc.mis888.com
encrypt passwords = yes
idmap uid = 16777000-33550000
idmap gid = 16777000-33550000
winbind enum users = yes
winbind enum group = yes
winbind separator = +
winbind use default domain = yes
template shell = /bin/bash
template homedir =  /home/%D/%U