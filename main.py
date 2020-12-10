import geomesa_pyspark
conf = geomesa_pyspark.configure(
         jars=['/home/dsmillerrunfol@campus.wm.edu/geoMesa_gB_Import/geomesa/target/geoMesa-1.0.jar'],
         packages=['geomesa_pyspark','pytz'],
         spark_home='/opt/cloudera/parcels/CDH-6.2.0-1.cdh6.2.0.p0.967373/lib/spark').\
       setAppName('DanTest')
conf.get('spark.master')

from pyspark.sql import SparkSession
spark = ( SparkSession
    .builder
    .config(conf=conf)
    .enableHiveSupport()
    .getOrCreate() )
params = {
"hbase.catalog":"geodata:geoquery-demo.geoboundaries"
}
feature = "default"
#spec - geoboundaries; feature name = "default"
df = ( spark
    .read
    .format("geomesa")
    .options(**params)
    .option("geomesa.feature", feature)
    .load() )
df.createOrReplaceTempView("adm")
spark.sql("show tables").show()

spark.sql("""select * from adm""").show()

spark.sql("""select * from adm where st_contains(st_makeBBOX(-180.0, -90.0, 180.0, 90.0), geometry)""").show()