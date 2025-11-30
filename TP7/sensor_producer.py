import json
import time
import random
from kafka import KafkaProducer

# اتصال ب Kafka
producer = KafkaProducer(
    bootstrap_servers='localhost:9092',
    value_serializer=lambda v: json.dumps(v).encode('utf-8')
)

machine_id = 1

while True:
    data = {
        "machine_id": machine_id,
        "temperature": round(random.uniform(20, 80), 2),
        "vibration": round(random.uniform(0.1, 1.5), 2),
        "status": "OK"
    }

    producer.send("machines-data", value=data)
    print(f"Sent: {data}")

    time.sleep(1)   # capteur يرسل كل ثانية
