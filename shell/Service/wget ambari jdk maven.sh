wget ambari jdk maven(3.0.5) wget
#ambari-1.4.2.tar.gz
#apache-maven-3.1.1-bin.tar.gz
#jdk-7u21-linux-x64.rpm
rpm -ivh jdk-7u21-linux-x64.rpm
echo "M2_HOME=/usr/local/apache-maven/apache-maven-3.1.1
M2=$M2_HOME/bin
MAVEN_OPTS="-Xms256m -Xmx512m"
export PATH=$M2:$PATH
" >>  /etc/profile

rpm -ivh  epel***.rpm
yum install -y rpm-build  npm nodejs git 
npm install -g brunch

wget http://peak.telecommunity.com/dist/ez_setup.py　
python ez_setup.py
cd ambari
mvn -X -B -e clean install package rpm:rpm -DskipTests -Dpython.ver="python >= 2.6"
