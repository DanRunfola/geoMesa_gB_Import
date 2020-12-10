#! /bin/bash

#spark-submit \
pyspark \
    --name "Disaster (DSMR)" \
    --driver-memory 1G \
    --executor-memory 1G --executor-cores 2 \
    --conf spark.sql.shuffle.partitions=100 \
    --conf spark.executor.memoryOverhead=1000 \
    --conf spark.kryoserializer.buffer.max=500m \
    --conf spark.serializer=org.apache.spark.serializer.KryoSerializer \
    --conf spark.kryo.registrator=org.locationtech.geomesa.spark.GeoMesaSparkKryoRegistrator \
    --packages org.apache.hbase:hbase-client:2.1.3 \
    --jars ./geomesa/target/geoMesa-1.0.jar,/etc/hbase/conf/ \
    --py-files ./geomesa/geomesa_pyspark-3.1.0.tar.gz \
    --driver-class-path ./geomesa/target/geoMesa-1.0.jar:/etc/hbase/conf/ \
    --files ./log4j.properties#log4j.properties \
    --conf spark.driver.extraJavaOptions='-Dlog4j.configuration=file:log4j.properties' \
    --conf spark.executor.extraClassPath="/etc/hbase/conf" \
    #/home/dsmillerrunfol@campus.wm.edu/geoMesa_gB_Import/main.py

