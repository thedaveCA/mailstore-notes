#!/bin/sh
###

for FILE in *_*.md; do
echo $FILE
sed -i "/description: \"\"/d" $FILE

sed -i "/hero: .*defaultHero.jpg/d" $FILE

sed -i -E "s/title: '(.*)'/title: \1/" $FILE

sed -i -E "s/(categories: )\"(.*)\"/tags: \2/" $FILE

sed -i -E "s/(tags:.*)outlook connector(.*)/\1outlookconnector\2/i" $FILE

for PRODUCT in mdaemon ldaemon ldap outlookconnector securitygateway webpop worldclient webadmin; do
sed -i -E "s/(tags:.*)$PRODUCT(, )?(.*)/categoriez: $PRODUCT\n\1 \3/i" $FILE
done

VAR1=0
VAR2=1
while [ "$VAR1" != "$VAR2" ];
do
#echo 1
    VAR1=$(sha1sum $FILE)
    sed -i -E "s/tags:(.*),(.*)/tags: \1\2 /" $FILE
    VAR2=$(sha1sum $FILE)
done

VAR1=0
VAR2=1
while [ "$VAR1" != "$VAR2" ];
do
#echo 2
    VAR1=$(sha1sum $FILE)
    sed -i "s/  / /" $FILE
    VAR2=$(sha1sum $FILE)
done

VAR1=0
VAR2=1
while [ "$VAR1" != "$VAR2" ];
do
#echo 3
    VAR1=$(sha1sum $FILE)
    sed -i -E "s/(tags:.* )([a-zA-Z]+)/\1\n - \2/i" $FILE
    VAR2=$(sha1sum $FILE)
done
sed -i -E "s/ - https:\/\/www.everything-mdaemon.com/ - /" $FILE
sed -i "s/categoriez: /categories: /" $FILE
done

rename 's/(\d{4}-\d{2}-\d{2})_(.*)/$1-$2/' *_*
