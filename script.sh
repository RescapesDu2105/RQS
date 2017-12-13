mkdir /home/oracle/sgbd/$2
cp -ra $1 /home/oracle/sgbd/$2
cd /home/oracle/sgbd/$2
mv ords.war $2.war
java -jar $2.war install advanced
java -jar $2.war setup --database rqs
java -jar $2.war map-url --type base-path /rqs rqs
cd config/$2/conf
rm apex.xml
cp /home/oracle/sgbd/$2/$2.war /home/oracle/sgbd/apache-tomcat-8.5.23/webapps/