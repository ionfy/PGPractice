import csv
import matplotlib.pyplot as plt

RUN_N = 3

rows = []

with open('results/ext_buf_res.csv', mode='r', newline='', encoding='utf-8') as file:
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

tps15 = list(item['tps'] for item in result if item['ext'] == '1' and item['buffer'] == '500')
tps11 = list(item['tps'] for item in result if item['ext'] == '1' and item['buffer'] == '1000')
tps05 = list(item['tps'] for item in result if item['ext'] == '0' and item['buffer'] == '500')
tps01 = list(item['tps'] for item in result if item['ext'] == '0' and item['buffer'] == '1000')

lata15 = list(item['lat_avg'] for item in result if item['ext'] == '1' and item['buffer'] == '500')
lata11 = list(item['lat_avg'] for item in result if item['ext'] == '1' and item['buffer'] == '1000')
lata05 = list(item['lat_avg'] for item in result if item['ext'] == '0' and item['buffer'] == '500')
lata01 = list(item['lat_avg'] for item in result if item['ext'] == '0' and item['buffer'] == '1000')

lats15 = list(item['lat_std'] for item in result if item['ext'] == '1' and item['buffer'] == '500')
lats11 = list(item['lat_std'] for item in result if item['ext'] == '1' and item['buffer'] == '1000')
lats05 = list(item['lat_std'] for item in result if item['ext'] == '0' and item['buffer'] == '500')
lats01 = list(item['lat_std'] for item in result if item['ext'] == '0' and item['buffer'] == '1000')

clients = [2, 4, 8, 16, 32, 64]

_, plots = plt.subplots(1, 3, figsize=(18, 5))

plots[0].set_title("tps")
plots[0].plot(clients, tps15, label="ext on / 500MB")
plots[0].plot(clients, tps11, label="ext on / 1000MB")
plots[0].plot(clients, tps05, label="ext off / 500MB")
plots[0].plot(clients, tps01, label="ext off / 1000MB")
plots[0].legend()

plots[1].set_title("latency average")
plots[1].plot(clients, lata15, label="ext on / 500MB")
plots[1].plot(clients, lata11, label="ext on / 1000MB")
plots[1].plot(clients, lata05, label="ext off / 500MB")
plots[1].plot(clients, lata01, label="ext off / 1000MB")
plots[1].legend()

plots[2].set_title("latency stddev")
plots[2].plot(clients, lats15, label="ext on / 500MB")
plots[2].plot(clients, lats11, label="ext on / 1000MB")
plots[2].plot(clients, lats05, label="ext off / 500MB")
plots[2].plot(clients, lats01, label="ext off / 1000MB")
plots[2].legend()

plt.show()
