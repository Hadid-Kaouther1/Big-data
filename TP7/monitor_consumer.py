import json
from kafka import KafkaConsumer

# استهلاك البيانات
consumer = KafkaConsumer(
    "machines-data",
    bootstrap_servers='localhost:9092',
    auto_offset_reset='latest',
    value_deserializer=lambda m: json.loads(m.decode('utf-8'))
)

print("🔥 Monitoring system started...")

for msg in consumer:
    data = msg.value
    temp = data["temperature"]
    vib = data["vibration"]

    alert = ""

    if temp > 60:
        alert += "⚠️ High Temperature! "

    if vib > 1.0:
        alert += "⚠️ High Vibration! "

    if alert == "":
        alert = "✔ Machine OK"

    print(f"Machine {data['machine_id']} | Temp={temp} | Vib={vib} | {alert}")
