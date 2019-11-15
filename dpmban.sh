#!/bin/bash

#copy old ban list
cp /var/lib/fetch-ban/fetch-ban.db /var/lib/fetch-ban/fetch-ban.db.old

#run fetch-ban
/usr/local/bin/fetch-ban.py

if [ $? -ne 0 ]

then
exit 2
fi

#generate dpm userlist
dmlite-shell -e 'userinfo' > /var/lib/fetch-ban/dpm-userlist

#unban loop
cat /var/lib/fetch-ban/fetch-ban.db.old | while read ubDN;
do
#check to see if DN is still in the ban list
grep -q "$ubDN" /var/lib/fetch-ban/fetch-ban.db
if [ $? -ne 0 ]
then
#unban
echo unbanning "$ubDB"
dmlite-shell -e "userban `echo $ubDN | sed 's/ /\\\\ /g'` 0"
fi
#close unban loop
done

#hidious ban loop that does the work

cat /var/lib/fetch-ban/fetch-ban.db | while read DN; 
do 
#echo "$DN"; 

##prefix whitespace with escape character to create clean DN

# if not in userlist need to add it
grep -q "$DN" /var/lib/fetch-ban/dpm-userlist
if [ $? -ne 0 ]
then
echo Adding "$DN"
dmlite-shell -e "useradd `echo $DN | sed 's/ /\\\\ /g'`"
fi

#BAN that user
grep "$DN" /var/lib/fetch-ban/dpm-userlist | grep -q ARGUS_BAN
#only ban if not already banned
if [ $? -ne 0 ]
then
echo Banning "$DN"
dmlite-shell -e "userban `echo $DN | sed 's/ /\\\\ /g'` ARGUS_BAN"
fi

#close the hideous loop
done

exit 0

