#!/usr/bin/env bash

CONF=$PGDATA/postgresql.conf
RESULT_FILE=res.csv
TEMP_LOG=temp.txt
DB=pgbench_test

restart_db() {
	pg_ctl -D $PGDATA restart
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
	BUF=$5
	EXT=$6

	pgbench -c $CLIENTS -j $THREADS -t $TR -d $DB -P 100000 > $TEMP_LOG
	TPS=$( grep "tps =" $TEMP_LOG | awk '{print $3}')
	LAT_AVG=$( grep "latency average =" $TEMP_LOG | awk '{print $4}')
	LAT_STD=$( grep "latency stddev =" $TEMP_LOG | awk '{print $4}')
	echo "$CLIENTS,$THREADS,$TR,$RUN,$BUF,$EXT,$TPS,$LAT_AVG,$LAT_STD" >> $RESULT_FILE
};

test_cycle() {
for cl in 2 4 8 16 32 64
do
	echo "Clients: $cl"
	for n in {1..3}
	do
		run_and_save $cl 2 1000 $n $1 $2
	done
done
};

echo "clients,threads,transactions,run,buffer,ext,tps,lat_avg,lat_std" > $RESULT_FILE

echo "==== pg_stat on ===="
echo "==== 500MB ===="
set_option shared_buffers "500MB"
set_option shared_preload_libraries "'pg_stat_statements'"
restart_db
echo "==== start test ===="
test_cycle 500 1

echo "==== pg_stat on ===="
echo "==== 1000MB ===="
set_option shared_buffers "1000MB"
set_option shared_preload_libraries "'pg_stat_statements'"
restart_db
echo "==== start test ===="
test_cycle 1000 1

test_cyclecho "==== pg_stat off ===="
echo "==== 500MB ===="
set_option shared_buffers "500MB"
set_option shared_preload_libraries "''"
restart_db
echo "==== start test ===="
test_cycle 500 0

test_cyclecho "==== pg_stat off ===="
echo "==== 1000MB ===="
set_option shared_buffers "1000MB"
set_option shared_preload_libraries "''"
restart_db
echo "==== start test ===="
test_cycle 1000 0
