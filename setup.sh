#!bin/sh

chmod +x setup.sh
chmod +x main.py

wget -nc https://mirrors.ocf.berkeley.edu/apache/maven/maven-3/3.6.3/binaries/apache-maven-3.6.3-bin.tar.gz
tar -xf apache-maven-3.6.3-bin.tar.gz

cd geomesa
../apache-maven-3.6.3/bin/mvn package

wget -nc https://repo1.maven.org/maven2/org/locationtech/geomesa/geomesa_pyspark/3.1.0/geomesa_pyspark-3.1.0.tar.gz

touch ~/geoMesa_gB_Import/conda_env.yml

cat << EOF > ~/geoMesa_gB_Import/conda_env.yml
name: ${env}
channels:
  - conda-forge
  - defaults
dependencies:
  - python=3
  - ipython==6.2.1
  - gdal==2.4.4
  - numpy>=1.17.3,<2.0
  - pandas>=0.25.3,<1.0
  - shapely>=1.6.4,<1.7
  - rasterio>=1.1.1,<1.2
  - folium>=0.10.1,<0.11
  - geopandas>=0.6.2,<0.7
  - descartes>=1.1.0,<1.2
  - pytz
  - matplotlib
  - rtree
  - Pillow
  - deprecation
EOF

cd ..
wget -nc https://repo.continuum.io/archive/Anaconda3-2018.12-Linux-x86_64.sh
bash Anaconda3-2018.12-Linux-x86_64.sh

conda clean --all

conda config --add channels main
conda config --set channel_priority no
conda env create --name gB --file conda_env.yml
echo ". /home/dsmillerrunfol@campus.wm.edu/anaconda3/etc/profile.d/conda.sh" >> ~/.bashrc
source activate gB
python -m pip install ./geomesa/geomesa_pyspark-3.1.0.tar.gz
conda_dir=${HOME}
wd=$(pwd)

cd ${conda_dir}/anaconda3/envs
zip -r ${wd}/gB.zip gB
cd ${wd}

touch ~/geoMesa_gB_Import/spark-submit.sh
cat << EOF > ~/geoMesa_gB_Import/spark-submit.sh
pyspark \
--driver-memory=50g \
--conf spark.rpc.message.maxSize=2047 \
--conf spark.kryo.registrationRequired=false \
--conf spark.serializer=org.apache.spark.serializer.KryoSerializer \
--conf spark.kryoserializer.buffer.max=2047m \
--conf spark.kryo.registrator=org.locationtech.geomesa.spark.GeoMesaSparkKryoRegistrator \
--packages org.apache.hbase:hbase-client:2.1.3 \
--files ./log4j.properties#log4j.properties \
--conf spark.driver.extraJavaOptions='-Dlog4j.configuration=file:log4j.properties' \
--conf spark.executor.extraClassPath="/etc/hbase/conf" \
--conf spark.driver.extraClassPath="/etc/hbase/conf" \
--conf spark.pyspark.driver.python=/home/dsmillerrunfol@campus.wm.edu/anaconda3/envs/gB/bin/python \
--conf spark.pyspark.python=./ENV/gB/bin/python \
--archives ${wd}/gB.zip#ENV,/opt/cloudera/parcels/CDH-6.2.0-1.cdh6.2.0.p0.967373/lib/spark/python/lib/py4j-0.10.7-src.zip \
--jars ${wd}/geomesa/target/geoMesa-1.0.jar,/opt/cloudera/parcels/CDH-6.2.0-1.cdh6.2.0.p0.967373/jars/httpclient-4.5.3.jar,/opt/cloudera/parcels/CDH-6.2.0-1.cdh6.2.0.p0.967373/jars/commons-httpclient-3.1.jar
EOF

cd /home/dsmillerrunfol@campus.wm.edu/geoMesa_gB_Import/geomesa-hbase_2.11-3.1.0

cp /etc/hbase/conf/hbase-site.xml conf/

sed -i 's|</configuration>|<property><name>hbase.geomesa.principal</name><value>dsmillerrunfol@CAMPUS.WM.EDU</value></property><property><name>hbase.geomesa.keytab</name><value>~/.kerberos/dsmillerrunfol.keytab</value></property></configuration>|g' ./conf/hbase-site.xml

export HADOOP_HOME=/opt/cloudera/parcels/CDH/lib/hadoop
export HADOOP_CONF_DIR=/etc/hadoop/conf
export HADOOP_HDFS_HOME=/opt/cloudera/parcels/CDH/lib/hadoop-hdfs
export YARN_HOME=/opt/cloudera/parcels/CDH/lib/hadoop-yarn
export HADOOP_MAPRED_HOME=/opt/cloudera/parcels/CDH/lib/hadoop-mapreduce
export HBASE_HOME=/opt/cloudera/parcels/CDH/lib/hbase
export HBASE_CONF_DIR=/etc/hbase/conf
export GEOMESA_HBASE_HOME=/home/dsmillerrunfol@campus.wm.edu/geoMesa_gB_Import/geomesa-hbase_2.11-3.1.0

./geomesa-hbase_2.11-3.1.0/bin/geomesa-hbase create-schema --catalog gb.adm --spec geoboundaries  --feature-name adm


#pip3 install geomesa_pyspark-3.1.0.tar.gz