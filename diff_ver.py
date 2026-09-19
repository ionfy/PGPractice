import csv
import matplotlib.pyplot as plt

RUN_N = 3

rows = []

with open('res_184.csv', mode='r', newline='', encoding='utf-8') as file:
    reader = csv.DictReader(file)
    
    for row in reader:
        rows.append(row)

with open('res_master.csv', mode='r', newline='', encoding='utf-8') as file:
    reader = csv.DictReader(file)
    
    for row in reader:
        rows.append(row)

result = []

for i in range (0, len(rows), RUN_N):
    tmp = rows[i]
    tmp['tps'] = sum(float(item['tps']) for item in rows[i:i+RUN_N])/RUN_N
    tmp['lat_avg'] = sum(float(item['lat_avg']) for item in rows[i:i+RUN_N])/RUN_N
    tmp['lat_std'] = sum(float(item['lat_std']) for item in rows[i:i+RUN_N])/RUN_N
    result.append(tmp)

tps18 = list(item['tps'] for item in result if item['ver'] == '184')
tpsm = list(item['tps'] for item in result if item['ver'] == 'master')

lata18 = list(item['lat_avg'] for item in result if item['ver'] == '184')
latam = list(item['lat_avg'] for item in result if item['ver'] == 'master')

lats18 = list(item['lat_std'] for item in result if item['ver'] == '184')
latsm = list(item['lat_std'] for item in result if item['ver'] == 'master')

clients = [2, 4, 8, 16, 32, 64]

_, plots = plt.subplots(1, 3, figsize=(18, 5))

plots[0].set_title("tps")
plots[0].plot(clients, tps18, label="18.4")
plots[0].plot(clients, tpsm, label="master")
plots[0].legend()

plots[1].set_title("latency average")
plots[1].plot(clients, lata18, label="18.4")
plots[1].plot(clients, latam, label="master")
plots[1].legend()

plots[2].set_title("latency stddev")
plots[2].plot(clients, lats18, label="18.4")
plots[2].plot(clients, latsm, label="master")
plots[2].legend()

plt.show()
