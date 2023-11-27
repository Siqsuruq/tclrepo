-- CREATE  TABLE "platform" -------------------------------------
CREATE  TABLE "platform" ( 
	"id" BIGSERIAL,
	"uuid_platform" UUid DEFAULT gen_random_uuid() NOT NULL,
	"name" Text UNIQUE NOT NULL,
	"extra" "hstore" DEFAULT ''::hstore NOT NULL,
	PRIMARY KEY ( "id", "uuid_platform" ) );
 ;
-- -------------------------------------------------------------

-- CREATE INDEX "idx_platform" ---------------------------------
CREATE INDEX "idx_platform_id" ON "platform" USING btree( "id" Asc NULLS Last );
CREATE INDEX "idx_platform_uuid" ON "platform" USING btree( "uuid_platform" Asc NULLS Last );
-- -------------------------------------------------------------

-- CREATE  TABLE "category" -------------------------------------
CREATE  TABLE "category" ( 
	"id" BIGSERIAL,
	"uuid_category" UUid DEFAULT gen_random_uuid() NOT NULL,
	"name" Text UNIQUE NOT NULL,
	"parent_category" UUid,
	"extra" "hstore" DEFAULT ''::hstore NOT NULL,
	PRIMARY KEY ( "id","uuid_category" ) );
 ;
-- -------------------------------------------------------------

-- CREATE INDEX "idx_category" ---------------------------------
CREATE INDEX "idx_category_id" ON "category" USING btree( "id" Asc NULLS Last );
CREATE INDEX "idx_category_uuid" ON "category" USING btree( "uuid_category" Asc NULLS Last );
-- -------------------------------------------------------------

-- CREATE  TABLE "license" --------------------------------------
CREATE  TABLE "license" ( 
	"id" BIGSERIAL,
	"uuid_license" UUid DEFAULT gen_random_uuid() NOT NULL,
	"name" Text UNIQUE NOT NULL,
	"extra" "hstore" DEFAULT ''::hstore NOT NULL,
	"link" Text,
	"lic_text" Text,
	PRIMARY KEY ( "id", "uuid_license" ) );
 ;
-- -------------------------------------------------------------

-- CREATE INDEX "idx_license" ----------------------------------
CREATE INDEX "idx_license_id" ON "license" USING btree( "id" Asc NULLS Last );
CREATE INDEX "idx_license_uuid" ON "license" USING btree( "uuid_license" Asc NULLS Last );
-- -------------------------------------------------------------

-- CREATE  TABLE "package" --------------------------------------
CREATE  TABLE "package" ( 
	"id" BIGSERIAL,
	"uuid_package" UUid DEFAULT gen_random_uuid() NOT NULL UNIQUE,
	"name" Text NOT NULL,
	"description" Text NOT NULL,
	"uuid_category" UUid NOT NULL,
	"uuid_license" UUid NOT NULL,
	"path" Text NOT NULL,
	"extra" "hstore" DEFAULT ''::hstore NOT NULL,
	PRIMARY KEY ( "id", "uuid_package" ) );
 ;
-- -------------------------------------------------------------

-- CREATE INDEX "idx_package" ----------------------------------
CREATE INDEX "idx_package_id" ON "package" USING btree( "id" Asc NULLS Last );
CREATE INDEX "idx_package_uuid" ON "package" USING btree( "uuid_package" Asc NULLS Last );
-- -------------------------------------------------------------


-- CREATE  TABLE "package_versions" --------------------------------------
CREATE TABLE "package_versions" (
	"id" BIGSERIAL,
	"uuid_version" UUID DEFAULT gen_random_uuid() NOT NULL,
	"uuid_package" UUID NOT NULL REFERENCES "package"("uuid_package") ON DELETE CASCADE,
	"uuid_platform" UUid NOT NULL,
	"version" TEXT NOT NULL,
	"release_date" TIMESTAMP,
	"path" TEXT NOT NULL,
	"extra" "hstore" DEFAULT ''::hstore NOT NULL,
	PRIMARY KEY ( "id", "uuid_version" ) );
 ;
-- -------------------------------------------------------------

-- CREATE INDEX "idx_package_versions" ---------------------------------
CREATE INDEX "idx_package_versions_id" ON "package_versions" USING btree( "id" ASC NULLS LAST );
CREATE INDEX "idx_package_versions_uuid" ON "package_versions" USING btree( "uuid_version" ASC NULLS LAST );
-- -------------------------------------------------------------



-- CREATE  TABLE "authors" --------------------------------------
CREATE TABLE "authors" (
	"id" BIGSERIAL,
	"uuid_author" UUID DEFAULT gen_random_uuid() NOT NULL UNIQUE,
	"name" TEXT NOT NULL,
	"email" TEXT,
	"public_pem" TEXT NOT NULL,
	"extra" "hstore" DEFAULT ''::hstore NOT NULL,
	"approved" Boolean DEFAULT 'false' NOT NULL,
	PRIMARY KEY ( "id" ) );
 ;
-- -------------------------------------------------------------

-- CREATE INDEX "idx_authors" ---------------------------------
CREATE INDEX "idx_authors_id" ON "authors" USING btree( "id" ASC NULLS LAST );
CREATE INDEX "idx_authors_uuid" ON "authors" USING btree( "uuid_author" ASC NULLS LAST );
-- -------------------------------------------------------------


-- CREATE  TABLE "package_authors" --------------------------------------
CREATE TABLE "package_authors" (
	"uuid_package" UUID NOT NULL REFERENCES "package"("uuid_package") ON DELETE CASCADE,
	"uuid_author" UUID NOT NULL REFERENCES "authors"("uuid_author") ON DELETE CASCADE,
	PRIMARY KEY ( "uuid_package", "uuid_author" ) );
 ;
-- -------------------------------------------------------------

-- CREATE INDEX "idx_package_authors" ---------------------------------
CREATE INDEX "idx_package_authors_package" ON "package_authors" USING btree( "uuid_package" ASC NULLS LAST );
CREATE INDEX "idx_package_authors_author" ON "package_authors" USING btree( "uuid_author" ASC NULLS LAST );
-- -------------------------------------------------------------




-- CREATE  TABLE "package_metadata" -----------------------------
CREATE  TABLE "package_metadata" ( 
	"id" BIGSERIAL,
	"uuid_package_metadata" UUid DEFAULT gen_random_uuid() NOT NULL,
	"uuid_package" UUid NOT NULL REFERENCES "package"("uuid_package") ON DELETE CASCADE,
	"creator" Text NOT NULL,
	"contributor" Text,
	"rights" Text,
	"URL" Text,
	"extra" "hstore" DEFAULT ''::hstore NOT NULL,
	PRIMARY KEY ( "id", "uuid_package_metadata" ) );
 ;
-- -------------------------------------------------------------
-- CREATE INDEX "idx_package_metadata" ----------------------------------
CREATE INDEX "idx_package_metadata" ON "package_metadata" USING btree( "id" Asc NULLS Last );
-- -------------------------------------------------------------



-- CREATE TABLE "dz_conf" --------------------------------------
CREATE TABLE "public"."dz_conf" ( 
	"id" BIGSERIAL,
	"module" Character Varying( 32 ),
	"var" Text NOT NULL,
	"val" Text,
	PRIMARY KEY ( "id" ) );
 ;
-- -------------------------------------------------------------

-- CREATE INDEX "dz_conf_id_idx" -------------------------------
CREATE INDEX "dz_conf_id_idx" ON "public"."dz_conf" USING btree( "id" Asc NULLS Last );
-- -------------------------------------------------------------

-- CREATE TABLE "users" -----------------------------------------
CREATE TABLE "public"."users" ( 
	"id" BIGSERIAL,
	"username" Text NOT NULL,
	"password" Text NOT NULL,
	"realname" Text NOT NULL,
	"email" Text NOT NULL,
	"uuid_users" UUid DEFAULT gen_random_uuid() NOT NULL,
	"uuid_author" UUid,
	PRIMARY KEY ( "id", "uuid_users" ) );
 ;
-- -------------------------------------------------------------

-- CREATE INDEX "users_idx" -------------------------------------
CREATE INDEX "users_idx" ON "public"."users" USING btree( "id" Asc NULLS Last );
-- -------------------------------------------------------------