import geomesa_pyspark
from pyspark.sql import SparkSession, Row
from geomesa_pyspark import types
from collections import OrderedDict
import urllib.request
import json
from shapely.geometry import shape, mapping
import operator


#Variables (feature is from spec)
gbVersion = "3_0_0"
gbTyp = "HPSCU"

#Probably won't need to change these:
feature = "adm"
params = {
"hbase.catalog":"default:gb.adm"
}


#Spark Init
conf = geomesa_pyspark.configure(
         jars=['/home/dsmillerrunfol@campus.wm.edu/geoMesa_gB_Import/geomesa/target/geoMesa-1.0.jar'],
         packages=['geomesa_pyspark','pytz'],
         spark_home='/opt/cloudera/parcels/CDH-6.2.0-1.cdh6.2.0.p0.967373/lib/spark').setAppName('gbIngest' + gbVersion + gbTyp)
conf.get('spark.master')
conf.set("hbase.client.keyvalue.maxsize","500000000")

from pyspark.sql import SparkSession
spark = ( SparkSession
    .builder
    .config(conf=conf)
    .enableHiveSupport()
    .getOrCreate() )



df = ( spark
    .read
    .format("geomesa")
    .options(**params)
    .option("geomesa.feature", feature)
    .load() )

col_order = ["__fid__", "src", "group", "level", "gbid", "name", "geometry"]



#We're going to batch by ISO on the driver.
#This is to avoid overwhelming the API with too many requests.
#Request all available boundary data for a specific version.
allgb = urllib.request.urlopen("https://www.geoboundaries.org/gbRequest.html?ISO=ALL&ADM=ALL&TYP="+gbTyp+"&VER="+gbVersion)
aGb = allgb.read()
jGb = json.loads(aGb)


#Build lists for each geoJSON we need to download, for each ISO.
isoDLs = {}
for i in range(0, len(jGb)):
    if(jGb[i]["boundaryISO"] in isoDLs):
        isoDLs[jGb[i]["boundaryISO"]].append(jGb[i]["gjDownloadURL"])
    else:
        isoDLs[jGb[i]["boundaryISO"]] = []
        isoDLs[jGb[i]["boundaryISO"]].append(jGb[i]["gjDownloadURL"])

for iso in isoDLs:
    featureData = []
    for url in isoDLs[iso]:
        print("\n")
        print("================")
        print("Ingesting " + iso)
        print("\nDownloading: " + url)
        r = urllib.request.urlopen(url)
        
        print("\nReading...")
        c = r.read()
        gB = json.loads(c)
        
        print("\nAdding ISO features to ISO set...")

        for i in range(0, len(gB["features"])):
            featureData.append(OrderedDict([
            ("__fid__", gB["features"][i]["properties"]["shapeID"]),
            ("src", url),
            ("group", gB["features"][i]["properties"]["shapeGroup"]),
            ("level",  gB["features"][i]["properties"]["shapeType"]),
            ("gbid", gB["features"][i]["properties"]["shapeID"]),
            ("name", gB["features"][i]["properties"]["shapeName"]),
            ("geometry", shape(gB["features"][i]["geometry"]))
            ]))
        
        print("Feature ingest complete for file " + url)

    print("\nAll features ingested for ISO " + iso + ". Total Features: " + str(len(featureData)) )
    print("Loading into geoMesa catalog: " + params['hbase.catalog'])

    sdf = spark.createDataFrame(featureData)
    sdf = sdf.select(col_order)
    sdf.show()
    sdf.write.format("geomesa").options(**params).option("geomesa.feature", feature).save()
    
    print(iso + " complete.  Total features written: " + str(len(featureData)))
    #spark.sql("""select * from adm""").show()

#sdf = spark.read.json(sc.parallelize(df_data))
#./bin/geomesa-hbase ingest --catalog ${project}-demo.geoboundaries --spec geoboundaries --feature-name default --converter geoboundaries-converter geoBoundaries-3_0_0-AFG-ADM1.geojson
#df.createOrReplaceTempView("adm")
#spark.sql("show tables").show()
#spark.sql("""select * from adm""").show()
#spark.sql("""select * from adm where st_contains(st_makeBBOX(-180.0, -90.0, 180.0, 90.0), geometry)""").show()