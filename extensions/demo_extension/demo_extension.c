#include "postgres.h"

#include "fmgr.h"

PG_MODULE_MAGIC_EXT(
					.name = "demo_extension",
					.version = "1.0"
);

PG_FUNCTION_INFO_V1(sum2num);

Datum
sum2num(PG_FUNCTION_ARGS)
{
	if (PG_ARGISNULL(0) || PG_ARGISNULL(1)) {
		PG_RETURN_NULL();
	}
	int64 a = PG_GETARG_INT64(0);
	int64 b = PG_GETARG_INT64(1);
	int64 res = a + b;
	PG_RETURN_INT64(res);
}
