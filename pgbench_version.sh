#!/usr/bin/env bash

CONF=$PGDATA/postgresql.conf
RESULT_FILE=results/${1-"res.csv"}
VERSION=${2-"none"}
TEMP_LOG=temp.txt
DB=pgbench_test
LOG_DIR="$HOME/postgres/log/debug"
TRANSACTIONS=3000

restart_db() {
	pg_ctl -D $PGDATA -l $LOG_DIR/postgres.log restart
};

set_option() {
	OPTION=$1
	VALUE=$2
	sed -i "s/^$OPTION.*/$OPTION = $VALUE/" "$CONF"
};

run_and_save() {
	CLIENTS=$1
	THREADS=$2
	TR=$3
	RUN=$4

	pgbench -c $CLIENTS -j $THREADS -t $TR -d $DB -P 100000 > $TEMP_LOG 2>&1
	TPS=$( grep "tps =" $TEMP_LOG | awk '{print $3}')
	LAT_AVG=$( grep "latency average =" $TEMP_LOG | awk '{print $4}')
	LAT_STD=$( grep "latency stddev =" $TEMP_LOG | awk '{print $4}')
	echo "$CLIENTS,$THREADS,$TR,$RUN,$VERSION,$TPS,$LAT_AVG,$LAT_STD" >> $RESULT_FILE
};

test_cycle() {
for cl in 2 4 8 16 32 64
do
	echo "Clients: $cl"
	for n in {1..3}
	do
		run_and_save $cl 2 $TRANSACTIONS $n
	done
done
};

echo "clients,threads,transactions,run,ver,tps,lat_avg,lat_std" > $RESULT_FILE

restart_db
test_cycle
