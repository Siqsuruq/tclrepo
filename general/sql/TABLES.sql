-- CREATE  TABLE "platform" -------------------------------------
CREATE  TABLE "platform" ( 
	"id" BIGSERIAL,
	"uuid_platform" UUid DEFAULT gen_random_uuid() NOT NULL,
	"name" Text UNIQUE NOT NULL,
	"description" Text NOT NULL,
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
	"name" Text UNIQUE NOT NULL,
	"description" Text NOT NULL,
	"uuid_category" UUid NOT NULL,
	"path" Text NOT NULL,
	"extra" "hstore" DEFAULT ''::hstore NOT NULL,
	PRIMARY KEY ( "id", "uuid_package" ) );
 ;
-- -------------------------------------------------------------

-- CREATE INDEX "idx_package" ----------------------------------
CREATE INDEX "idx_package_id" ON "package" USING btree( "id" Asc NULLS Last );
CREATE INDEX "idx_package_uuid" ON "package" USING btree( "uuid_package" Asc NULLS Last );
-- -------------------------------------------------------------


-- CREATE  TABLE "pkg_version" --------------------------------------
CREATE TABLE "pkg_version" (
	"id" BIGSERIAL,
	"uuid_pkg_version" UUID DEFAULT gen_random_uuid() NOT NULL,
	"uuid_package" UUID NOT NULL REFERENCES "package"("uuid_package") ON DELETE CASCADE,
	"uuid_license" UUid NOT NULL,
	"version" TEXT NOT NULL,
	"uuid_platform" UUid NOT NULL,
	"uploaded_timestamp" TIMESTAMP DEFAULT NOW(),
	"path" TEXT NOT NULL,
	"extra" "hstore" DEFAULT ''::hstore NOT NULL,
	PRIMARY KEY ( "id", "uuid_pkg_version" ) );
 ;
-- -------------------------------------------------------------

-- CREATE INDEX "idx_pkg_version" ---------------------------------
CREATE INDEX "idx_pkg_version_id" ON "pkg_version" USING btree( "id" ASC NULLS LAST );
CREATE INDEX "idx_pkg_version_uuid" ON "pkg_version" USING btree( "uuid_pkg_version" ASC NULLS LAST );
-- -------------------------------------------------------------



-- CREATE  TABLE "author" --------------------------------------
CREATE TABLE "author" (
	"id" BIGSERIAL,
	"uuid_author" UUID DEFAULT gen_random_uuid() NOT NULL UNIQUE,
	"name" TEXT NOT NULL,
	"email" TEXT NOT NULL,
	"public_pem" TEXT NOT NULL,
	"extra" "hstore" DEFAULT ''::hstore NOT NULL,
	"approved" Boolean DEFAULT 'false' NOT NULL,
	PRIMARY KEY ( "id" ) );
 ;
-- -------------------------------------------------------------

-- CREATE INDEX "idx_author" ---------------------------------
CREATE INDEX "idx_author_id" ON "author" USING btree( "id" ASC NULLS LAST );
CREATE INDEX "idx_author_uuid" ON "author" USING btree( "uuid_author" ASC NULLS LAST );
-- -------------------------------------------------------------


-- CREATE  TABLE "package_author" --------------------------------------
CREATE TABLE "package_author" (
	"uuid_package" UUID NOT NULL REFERENCES "package"("uuid_package") ON DELETE CASCADE,
	"uuid_author" UUID NOT NULL REFERENCES "author"("uuid_author") ON DELETE CASCADE,
	PRIMARY KEY ( "uuid_package", "uuid_author" ) );
 ;
-- -------------------------------------------------------------

-- CREATE INDEX "idx_package_author" ---------------------------------
CREATE INDEX "idx_package_author_package" ON "package_author" USING btree( "uuid_package" ASC NULLS LAST );
CREATE INDEX "idx_package_author_author" ON "package_author" USING btree( "uuid_author" ASC NULLS LAST );
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
	"created_at" Timestamp With Time Zone DEFAULT now() NOT NULL,
	"updated_at" Timestamp With Time Zone DEFAULT now() NOT NULL,
	"status" Text DEFAULT 'active'::text NOT NULL,
	"last_login" Timestamp With Time Zone,
	PRIMARY KEY ( "id", "uuid_users" ),
	CONSTRAINT "unique_users_email" UNIQUE( "email" ),
	CONSTRAINT "unique_users_username" UNIQUE( "username" ) );
 ;
-- -------------------------------------------------------------

-- CREATE INDEX "users_idx" -------------------------------------
CREATE INDEX "users_idx" ON "public"."users" USING btree( "id" Asc NULLS Last );
-- -------------------------------------------------------------

-- CREATE INDEX "users_email_idx" ------------------------------
CREATE INDEX "users_email_idx" ON "public"."users" USING btree( "email" Asc NULLS Last );
-- -------------------------------------------------------------

-- CREATE INDEX "users_username_idx" ---------------------------
CREATE INDEX "users_username_idx" ON "public"."users" USING btree( "username" Asc NULLS Last );
-- -------------------------------------------------------------

-- CREATE TABLE "filestorage" ----------------------------------
CREATE TABLE "public"."filestorage" ( 
	"id" BIGSERIAL NOT NULL,
	"uuid_filestorage" UUid DEFAULT gen_random_uuid() NOT NULL,
	"path" Text NOT NULL,
	"ext" Text NOT NULL,
	"uuid_user" UUid NOT NULL,
	"original_name" Text,
	"ts" Timestamp With Time Zone DEFAULT now() NOT NULL,
	PRIMARY KEY ( "id", "uuid_filestorage" ) );
 ;
-- -------------------------------------------------------------

-- CREATE TABLE "repository_type" -----------------------------
CREATE TABLE "public"."repository_type" ( 
	"id" BIGSERIAL,
	"uuid_repository_type" UUid DEFAULT gen_random_uuid() NOT NULL UNIQUE,
	"name" Text UNIQUE NOT NULL,
	"extra" "public"."hstore" DEFAULT ''::hstore NOT NULL,
	PRIMARY KEY ( "id", "uuid_repository_type" ) );
 ;
-- -------------------------------------------------------------

-- CREATE INDEX "idx_package_metadata" -------------------------
CREATE INDEX "idx_repository_type" ON "public"."repository_type" USING btree( "id" Asc NULLS Last );
-- -------------------------------------------------------------

-- CREATE TABLE "repository" -----------------------------
CREATE TABLE "public"."repository" ( 
	"id" BIGSERIAL,
	"uuid_repository" UUid DEFAULT gen_random_uuid() NOT NULL,
    "url" Text NOT NULL,
    "uuid_repository_type" UUID NOT NULL,
	"extra" "public"."hstore" DEFAULT ''::hstore NOT NULL,
	PRIMARY KEY ( "id", "uuid_repository" ),
	FOREIGN KEY ("uuid_repository_type") REFERENCES "public"."repository_type"("uuid_repository_type")
	);
-- -------------------------------------------------------------

-- CREATE INDEX "idx_repository" ------------------------------
CREATE INDEX "idx_repository" ON "public"."repository" USING btree ("id" ASC NULLS LAST);
-- -------------------------------------------------------------