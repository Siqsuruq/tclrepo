-- CREATE VIEW "v_package" -------------------------------------
CREATE OR REPLACE VIEW "public"."v_package" AS  SELECT package.id,
    package.uuid_package,
    package.name AS package,
    package.description,
    package.uuid_category,
    category.name AS category,
    license.uuid_license,
    license.name
   FROM package,
    category,
    license
  WHERE ((package.uuid_category = category.uuid_category) AND (package.uuid_license = license.uuid_license));;
-- -------------------------------------------------------------
