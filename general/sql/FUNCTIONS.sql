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

CREATE OR REPLACE FUNCTION encrypt_password()
RETURNS TRIGGER AS $$
BEGIN
    NEW.password = crypt(NEW.password, gen_salt('bf'));
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- -------------------------------------------------------------

CREATE TRIGGER trigger_encrypt_password
BEFORE INSERT ON public.users
FOR EACH ROW
EXECUTE FUNCTION encrypt_password();