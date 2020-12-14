spark-submit --driver-memory=50g --conf spark.rpc.message.maxSize=2047 --conf spark.kryo.registrationRequired=false --conf spark.serializer=org.apache.spark.serializer.KryoSerializer --conf spark.kryoserializer.buffer.max=2047m --conf spark.kryo.registrator=org.locationtech.geomesa.spark.GeoMesaSparkKryoRegistrator --packages org.apache.hbase:hbase-client:2.1.3 --files ./log4j.properties#log4j.properties --conf spark.driver.extraJavaOptions='-Dlog4j.configuration=file:log4j.properties' --conf spark.executor.extraClassPath="/etc/hbase/conf" --conf spark.driver.extraClassPath="/etc/hbase/conf" --conf hbase.client.keyvalue.maxsize=500000000 --conf spark.pyspark.driver.python=/home/dsmillerrunfol@campus.wm.edu/anaconda3/envs/gB/bin/python --conf spark.pyspark.python=/home/dsmillerrunfol@campus.wm.edu/anaconda3/envs/gB/bin/python --archives /home/dsmillerrunfol@campus.wm.edu/geoMesa_gB_Import/gB.zip#gB --jars /home/dsmillerrunfol@campus.wm.edu/geoMesa_gB_Import/geomesa/target/geoMesa-1.0.jar,/opt/cloudera/parcels/CDH-6.2.0-1.cdh6.2.0.p0.967373/jars/httpclient-4.5.3.jar,/opt/cloudera/parcels/CDH-6.2.0-1.cdh6.2.0.p0.967373/jars/commons-httpclient-3.1.jar main.py
