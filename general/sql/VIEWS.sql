BEGIN;

-- CREATE VIEW "v_package_versions" ----------------------------
CREATE OR REPLACE VIEW "public"."v_package_versions" AS
SELECT
	pv.id,
	pv.uuid_pkg_version,
	pv.uuid_package,
	pv.uuid_platform,
	pv.version,
	pv.release_date,
	pv.path,
	pv.extra,
	p.name AS platform_name,
	pa.name AS package_name,
	pa.description AS package_description,
	c.name AS package_category
FROM
  ((pkg_version pv
    JOIN platform p ON (pv.uuid_platform = p.uuid_platform))
    JOIN package pa ON (pv.uuid_package = pa.uuid_package))
    LEFT JOIN category c ON (pa.uuid_category = c.uuid_category);
-- -------------------------------------------------------------

-- CREATE VIEW "iv_package_versions_with_rn" ----------------------
CREATE OR REPLACE VIEW "public"."iv_package_versions_with_rn" AS  SELECT v_package_versions.id,
    v_package_versions.uuid_pkg_version,
    v_package_versions.uuid_package,
    v_package_versions.uuid_platform,
    v_package_versions.version,
    v_package_versions.release_date,
    v_package_versions.path,
    v_package_versions.extra,
    v_package_versions.platform_name,
    v_package_versions.package_name,
	v_package_versions.package_description,
	v_package_versions.package_category,
    row_number() OVER (PARTITION BY v_package_versions.uuid_package, v_package_versions.uuid_platform ORDER BY (string_to_array(v_package_versions.version, '.'::text))::integer[] DESC) AS rn
   FROM v_package_versions;;
-- -------------------------------------------------------------

-- CREATE VIEW "v_latest_package_versions" -----------------------
CREATE OR REPLACE VIEW "public"."v_latest_package_versions" AS  SELECT iv_package_versions_with_rn.id,
    iv_package_versions_with_rn.uuid_pkg_version,
    iv_package_versions_with_rn.uuid_package,
    iv_package_versions_with_rn.uuid_platform,
    iv_package_versions_with_rn.version,
    iv_package_versions_with_rn.release_date,
    iv_package_versions_with_rn.path,
    iv_package_versions_with_rn.extra,
    iv_package_versions_with_rn.platform_name,
    iv_package_versions_with_rn.package_name,
	iv_package_versions_with_rn.package_description,
	iv_package_versions_with_rn.package_category,
    iv_package_versions_with_rn.rn
   FROM iv_package_versions_with_rn
  WHERE (iv_package_versions_with_rn.rn = 1);;
-- -------------------------------------------------------------

-- CREATE VIEW "v_download" ------------------------------------
CREATE OR REPLACE VIEW "public"."v_download" AS  SELECT v_latest_package_versions.id,
    v_latest_package_versions.uuid_pkg_version,
    v_latest_package_versions.uuid_package,
    v_latest_package_versions.uuid_platform,
    v_latest_package_versions.version,
    v_latest_package_versions.release_date,
    v_latest_package_versions.path,
    v_latest_package_versions.extra,
    v_latest_package_versions.platform_name,
    v_latest_package_versions.package_name,
    v_latest_package_versions.package_description,
    v_latest_package_versions.package_category,
    v_latest_package_versions.rn,
    concat('<a href="', dz_conf.val, '/api/v2/download/package/', v_latest_package_versions.uuid_package, '/', v_latest_package_versions.platform_name, '/', v_latest_package_versions.version, '">Download</a>') AS link
   FROM v_latest_package_versions,
    dz_conf
  WHERE (dz_conf.var = 'domain_name'::text);;
-- -------------------------------------------------------------

COMMIT;