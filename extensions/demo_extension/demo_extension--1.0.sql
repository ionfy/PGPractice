\echo Use "CREATE EXTENSION demo_extension" to load this file. \quit

CREATE FUNCTION sum2num(int8, int8)
        RETURNS int8
        AS 'MODULE_PATHNAME'
        LANGUAGE C;
