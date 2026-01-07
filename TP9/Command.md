تثبيت java,maven,hadoop,spark
تهيئةHDFS لاول مرة:hdfs namenode -format
1. تشغيل Hadoop (HDFS + YARN)

### تشغيل HDFS:
start-dfs.sh
### تشغيل YARN:
start-yarn.sh
### التأكد:
jps
النتائج التي ظهرت
kaouther@DESKTOP-ICKP84C:~$ jps
976 DataNode
1217 SecondaryNameNode
833 NameNode
2226 SparkSubmit
1434 ResourceManager
1579 NodeManager
9342 Jps

2. رفع ملف إلى HDFS
### إنشاء الملف:
echo "Hello Spark Wordcount!" > file1.txt
echo "Hello Hadoop Also :)" >> file1.txt
### رفع الملف:
hdfs dfs -put file1.txt /
### التأكد:
hdfs dfs -ls /

3. WordCount عبر Spark-shell (RDD)
### تشغيل Spark-shell:spark-shell
~$ spark-submit --version
26/01/07 09:08:41 WARN Utils: Your hostname, DELL5400 resolves to a loopback address: 127.0.1.1; using 172.27.66.221 instead (on interface eth0)
26/01/07 09:08:41 WARN Utils: Set SPARK_LOCAL_IP if you need to bind to another address
Welcome to
      ____              
     / /  ___ _____/ /
    _\ \/ _ \/ _ `/ /  '_/
   /___/ ./\_,_/_/ /_/\_\   version 3.3.1
      /_/

Using Scala version 2.12.15, OpenJDK 64-Bit Server VM, 11.0.29
Branch HEAD
Compiled by user yumwang on 2022-10-15T09:47:01Z
Revision fbbcf9434ac070dd4ced4fb9efe32899c6db12a9
Url https://github.com/apache/spark
### تنفيذ WordCount:
val lines = sc.textFile("hdfs://localhost:9000/file1.txt")
val words = lines.flatMap(_.split("\\s+"))
val wc = words.map(w => (w, 1)).reduceByKey(_ + _)
wc.saveAsTextFile("hdfs://localhost:9000/file1.count")
### الخروج:
:quit
### عرض النتائج:
**kaouther@DESKTOP-ICKP84C:~$ hdfs dfs -ls /
drwxr-xr-x   - kaouther supergroup          0 2026-01-05 22:58 /file1.count
-rw-r--r--   3 kaouther supergroup         23 2026-01-05 22:36 /file1.txt
**kaouther@DESKTOP-ICKP84C:~$ hdfs dfs -ls /file1.count
Found 3 items
-rw-r--r--   3 kaouther supergroup          0 2026-01-05 22:58 /file1.count/_SUCCESS
-rw-r--r--   3 kaouther supergroup         25 2026-01-05 22:58 /file1.count/part-00000
-rw-r--r--   3 kaouther supergroup         10 2026-01-05 22:58 /file1.count/part-00001
**kaouther@DESKTOP-ICKP84C:~$ hdfs dfs -cat /file1.count/part-00000
(Hello,1)
(Wordcount!,1)
**kaouther@DESKTOP-ICKP84C:~$ hdfs dfs -cat /file1.count/part-00001
(Spark,1)

 4. Spark Batch – Java + Maven
 ### إنشاء مشروع Maven:
 mvn archetype:generate -DgroupId=spark.batch \
-DartifactId=wordcount-spark \
-DarchetypeArtifactId=maven-archetype-quickstart \
-DinteractiveMode=false
### الدخول للمشروع:
cd wordcount-spark
### حذف test الافتراضي:
rm src/test/java/spark/batch/AppTest.java
ملف Java الأساسي: WordCountTask.java
موجود في src/main/java/spark/batch/WordCountTask.java
package spark.batch;

import org.apache.spark.SparkConf;
import org.apache.spark.api.java.JavaPairRDD;
import org.apache.spark.api.java.JavaRDD;
import org.apache.spark.api.java.JavaSparkContext;

import scala.Tuple2;
import java.util.Arrays;

public class WordCountTask {

    public static void main(String[] args) {

        if (args.length < 2) {
            System.err.println("Usage: WordCountTask <input> <output>");
            System.exit(1);
        }

        String inputPath = args[0];
        String outputPath = args[1];

        SparkConf conf = new SparkConf().setAppName("WordCountTask").setMaster("local[*]");
        JavaSparkContext sc = new JavaSparkContext(conf);

        JavaRDD<String> textFile = sc.textFile(inputPath);

        JavaPairRDD<String, Integer> counts = textFile
                .flatMap(s -> Arrays.asList(s.split("\\s+")).iterator())
                .mapToPair(word -> new Tuple2<>(word, 1))
                .reduceByKey((a, b) -> a + b);

        counts.saveAsTextFile(outputPath);

        sc.close();
    }
}
## بناء المشروع:
mvn package
## تشغيل التطبيق:
spark-submit --class spark.batch.WordCountTask \
  target/wordcount-spark-1.0-SNAPSHOT.jar \
  hdfs://localhost:9000/file1.txt \
  hdfs://localhost:9000/wc-output
##  عرض النتائج:
**kaouther@DESKTOP-ICKP84C:~$ hdfs dfs -cat /file1.count/part-00000
(Hello,1)
(Wordcount!,1)
**kaouther@DESKTOP-ICKP84C:~$ hdfs dfs -cat /file1.count/part-00001
(Spark,1)
##5. Spark Structured Streaming + Netcat
##  إنشاء ملف streaming.py داخل المشروع:
wordcount-spark/streaming.py

from pyspark.sql import SparkSession
from pyspark.sql.functions import explode, split

spark = SparkSession.builder \
    .appName("StructuredStreamingWordCount") \
    .getOrCreate()

lines = spark.readStream \
    .format("socket") \
    .option("host", "localhost") \
    .option("port", 9999) \
    .load()

words = lines.select(
    explode(
        split(lines.value, " ")
    ).alias("word")
)

wordCounts = words.groupBy("word").count()

query = wordCounts.writeStream \
    .outputMode("complete") \
    .format("console") \
    .start()

query.awaitTermination()
##  تشغيل netcat (نافذة 1):nc -lk 9999
kaouther@DESKTOP-ICKP84C:~$ nc -lk 9999
hello
hello
hark
##  تشغيل الـ Streaming (نافذة 2):
cd ~/wordcount-spark
spark-submit streaming.py
+-----+-----+
| word|count|
+-----+-----+
|hello|    2|
| hark|    1|
+-----+-----+
