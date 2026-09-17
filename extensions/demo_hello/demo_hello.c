#include "postgres.h"

#include "fmgr.h"

PG_MODULE_MAGIC_EXT(
					.name = "demo_hello",
					.version = PG_VERSION
);

PG_FUNCTION_INFO_V1(hello_world);

Datum
hello_world(PG_FUNCTION_ARGS)
{
	ereport(NOTICE,
			(errmsg("Hello, World from extension!")));
	PG_RETURN_VOID();
}
