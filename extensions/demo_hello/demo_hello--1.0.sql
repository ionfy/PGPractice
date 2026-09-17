\echo Use "CREATE EXTENSION dict_int" to load this file. \quit

CREATE FUNCTION hello_world()
        RETURNS void
        AS 'MODULE_PATHNAME'
        LANGUAGE C STRICT;
