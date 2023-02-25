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
CREATE INDEX "idx_platform" ON "platform" USING btree( "id" Asc NULLS Last );
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
CREATE INDEX "idx_category" ON "category" USING btree( "uuid_category" Asc NULLS Last );
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
CREATE INDEX "idx_license" ON "license" USING btree( "id" Asc NULLS Last );
-- -------------------------------------------------------------

-- CREATE  TABLE "package" --------------------------------------
CREATE  TABLE "package" ( 
	"id" BIGSERIAL,
	"uuid_package" UUid DEFAULT gen_random_uuid() NOT NULL,
	"name" Text NOT NULL,
	"uuid_platform" UUid NOT NULL,
	"description" Text NOT NULL,
	"uuid_category" UUid NOT NULL,
	"uuid_license" UUid NOT NULL,
	"path" Text NOT NULL,
	"extra" "hstore" DEFAULT ''::hstore NOT NULL,
	PRIMARY KEY ( "id", "uuid_package" ) );
 ;
-- -------------------------------------------------------------

-- CREATE INDEX "idx_package" ----------------------------------
CREATE INDEX "idx_package" ON "package" USING btree( "id" Asc NULLS Last );
-- -------------------------------------------------------------

-- CREATE  TABLE "package_metadata" -----------------------------
CREATE  TABLE "package_metadata" ( 
	"id" BIGSERIAL,
	"uuid_package_metadata" UUid DEFAULT gen_random_uuid() NOT NULL,
	"uuid_package" UUid NOT NULL,
	"identifier" Text NOT NULL,
	"version" Text NOT NULL,
	"title" Text NOT NULL,
	"creator" Text NOT NULL,
	"contributor" Text NOT NULL,
	"rights" Text NOT NULL,
	"URL" Text NOT NULL,
	PRIMARY KEY ( "id", "uuid_package_metadata" ) );
 ;
-- -------------------------------------------------------------
-- CREATE INDEX "idx_package_metadata" ----------------------------------
CREATE INDEX "idx_package_metadata" ON "package_metadata" USING btree( "id" Asc NULLS Last );
-- -------------------------------------------------------------