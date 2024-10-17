-- CREATE FUNCTION "tbl_view_exists( text )" -------------------
CREATE OR REPLACE FUNCTION public.tbl_view_exists(text)
 RETURNS boolean
 LANGUAGE pltcl
AS $function$
    spi_exec "SELECT EXISTS (SELECT FROM pg_tables WHERE schemaname='public' AND tablename='${1}') AS tbl"
    spi_exec "SELECT EXISTS (SELECT FROM pg_views WHERE schemaname='public' AND viewname='${1}') AS view"
    if {$tbl || $view} {
        return 1
    } else {
        return 0
    }
$function$;
-- -------------------------------------------------------------