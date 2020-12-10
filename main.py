import geomesa_pyspark
from pyspark.sql import SparkSession, Row

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
"hbase.catalog":"default:gb.adm"
}
feature = "adm"
#spec - geoboundaries; feature name = "default"
df = ( spark
    .read
    .format("geomesa")
    .options(**params)
    .option("geomesa.feature", feature)
    .load() )

from geomesa_pyspark import types
from collections import OrderedDict

data = [OrderedDict([
   ("__fid__", None),
   ("src", "geoboundaries.org/data/whatever.geojson"),
   ("group", "AFG"),
   ("level", "ADM0"),
   ("gbid", "7A"),
   ("name", "theName"),
   ("geometry", geomesa_pyspark.types.MultiPolygon(0,0))
])]

col_order = ["__fid__", "src", "group", "level", "gbid", "name", "geometry"]

df_data = []
for i in data:
    tmp = i.copy()
    tmp["__fid__"] = i["name"]
    df_data.append(tmp)
sdf = spark.createDataFrame(Row(**x) for x in df_data)
sdf = sdf.select(col_order)
sdf.write.format("geomesa").options(**params).option("geomesa.feature", feature).save()

#sdf = spark.read.json(sc.parallelize(df_data))
#./bin/geomesa-hbase ingest --catalog ${project}-demo.geoboundaries --spec geoboundaries --feature-name default --converter geoboundaries-converter geoBoundaries-3_0_0-AFG-ADM1.geojson
#df.createOrReplaceTempView("adm")
#spark.sql("show tables").show()
#spark.sql("""select * from adm""").show()
#spark.sql("""select * from adm where st_contains(st_makeBBOX(-180.0, -90.0, 180.0, 90.0), geometry)""").show()