INSERT INTO "platform" ("uuid_platform", "name", "description") VALUES
( 'd1a5ad90-2534-471f-9a7f-b9eae64f0e7e', 'Tcl', 'Packages that work with the Tcl scripting language, regardless of platform.' ),
( '9bb9da21-a628-4cca-8e94-5ab9317b6747', 'Tk', 'Requires the Tk toolkit for graphical user interfaces (GUI) alongside Tcl.' ),
( '99810a9b-2759-4bb5-a6d0-7b4f04b2668c', 'Linux32', 'Packages compatible only with 32-bit Linux operating systems.' ),
( '3c1e96e2-f130-4d5c-b206-63623007ca58', 'Linux64', 'Packages compatible only with 64-bit Linux operating systems.' ),
( '13df1bad-20e6-4891-ac94-aad937c80bd1', 'Win32', 'Packages compatible only with 32-bit Windows operating systems.' ),
( '9c8237da-68ea-46c2-971f-2c59ce888329', 'Win64', 'Packages compatible only with 64-bit Windows operating systems.' ),
( '255506df-6f5f-416b-be9f-9f2315db4eae', 'Mac', 'Packages compatible only with macOS desktop and laptop systems.' ),
( '5eadbc58-e23a-4e33-96ce-b1b20aded4a4', 'AIX', 'Packages compatible only with IBM AIX, a UNIX operating system commonly used in enterprise environments.' ),
( 'c1a632bb-5425-45a8-8254-4dfd0f88e712', 'Solaris', 'Packages compatible only with Solaris, an operating system from Oracle, often used on SPARC systems.' ),
( 'e57c7ff7-6e48-4b78-9624-65deacb41fd3', 'BSD', 'Packages compatible with BSD-based operating systems such as FreeBSD, OpenBSD, and NetBSD.' ),
( '5bc52275-33bf-4a9a-a8cb-d6af25deaf63', 'Android', 'Packages that can be used only on Android devices, typically requiring mobile-friendly dependencies.' ),
( '0e0e72cf-cab6-41db-a982-b72dc101bd83', 'ARM', 'Packages designed only for ARM architecture, commonly used in devices like Raspberry Pi and embedded systems.' ),
( '4dcee4bd-f48f-4fdd-9f83-711b63b019ef', 'iOS', 'Packages compatible only with Apple iOS mobile devices such as iPhones and iPads.' );


INSERT INTO "category" ("uuid_category","name") VALUES 
( '1611ab61-626c-4070-8f1a-f63e9af1a0e1','Essentials' ),
( '7bc6bb01-f6e7-4d1e-91b1-b98ef52dd110','Database' ),
( '57f2b402-e605-4e0e-a8d2-11c9f000356b','Networking' ),
( '7696807e-c339-4c08-ba73-ec7f06f25dc7','Web' ),
( 'b7c11cbf-6a16-4ebb-8e12-b403ac17dff6','XML' ),
( '65657bfb-663b-4784-a437-f1cfc92f09a0','GUI' ),
( 'af5bd1fb-1001-4c43-a221-b43100529eab','Widgets' ),
( '0f434733-b639-4864-a48f-0032adbf7313','Cryptography' ),
( '6925c028-8fa0-470d-a08d-955ede949441','OO' ),
( 'f5fd64c2-cff0-4c8c-81d5-154eb04a6369','Images' ),
( 'd433f81c-298e-4514-bc35-efd55e4dda0f','Audio' ),
( '17ef93bd-ddee-40fe-a148-923135238348','Video' ),
( '8563bb67-63cc-460b-9787-0fb29cb675e3','Miscellaneous' ),
( 'a21e8d07-c467-4e64-a126-929825e166c5', 'Security'),
( '000c872d-9282-4e98-bc1d-d19a00f28ba3', 'Testing'),
( 'c768c55c-8e06-446f-98d6-6b0c743db72f', 'Logging'),
( 'ebdd5475-3cf5-4509-891b-fabd6efa2972', 'Integration'),
( '75912dbc-5dd0-46e2-85d7-ce89acb01510', 'Performance'),
( '9b2006dd-76c9-4c2e-9613-e08e45dc258a', 'Business'),
( '42643c52-74d0-4a7f-9c9b-c0afa1267c7b', 'Standard Libraries');

INSERT INTO "dz_conf"("module","var","val") VALUES
	(NULL, 'domain_name', 'https://tclrepo.daidze.org'),
	(NULL, 'repo_path', '/opt/ns/client/repo'),
	(NULL, 'language', 'en'),
	('date_time', 'date_format', '%d-%m-%Y'),
	('date_time', 'now_date_time_format', '%d-%m-%Y_%H-%M-%S'),
	('date_time', 'time_format', '%H:%M:%S'),
	('date_time', 'time_hm_format', '%H:%M'),
	('date_time', 'timestamp_format', '%d-%m-%Y %H:%M:%S'),
	('date_time', 'timezone', 'Atlantic/Cape_Verde');

INSERT INTO "repository_type"(
    "uuid_repository_type",
    "name"
) VALUES 
    ('2c123327-e0f9-41d6-908d-d2ede221acb6'::uuid, 'Fossil'),
    ('7ee87d5e-d432-47bb-930b-eb19f00669bb'::uuid, 'Bitbucket'),
    ('98466483-5792-4fd1-a37e-c9644ab1ecc0'::uuid, 'GitHub'),
    ('eb5de458-6e94-487b-94e1-32dbf5517818'::uuid, 'GitLab'),
    ('4cd0490b-ac12-4475-88e6-df19ed60d534'::uuid, 'SVN'),
    ('8bf1dbd4-0817-4fa3-aad4-cce9b2241fe5'::uuid, 'Perforce Helix Core'),
    ('0e576e32-c983-45ae-ab2f-811b9d2fdd9a'::uuid, 'Azure Repos'),
    ('65e05a6d-c7ee-41a2-8697-e56041fe95d3'::uuid, 'SourceForge'),
    ('5dd4421d-c4c6-4d49-9a5a-beb8b2684d5e'::uuid, 'Mercurial'),
    ('27923dab-e784-4ab5-8bca-9e0729f8d263'::uuid, 'Apache Subversion'),
    ('2bf91f99-1a9e-408b-a2f2-dca82ce71a1d'::uuid, 'Team Foundation Version Control'),
    ('2e7f58f5-80a4-4535-b822-b8b659f575d9'::uuid, 'Concurrent Versions System'),
    ('79f0cc65-fd2a-49c6-a4a5-9ae3bee5aaf1'::uuid, 'AWS CodeCommit');

INSERT INTO "license"( "name", "link")  VALUES
	('Apache-2.0', 'https://opensource.org/license/apache-2-0'),
	('BSD-2-Clause', 'https://opensource.org/license/bsd-2-clause'),
	('BSD-3-Clause', 'https://opensource.org/license/bsd-3-clause'),
	('MIT', 'https://opensource.org/license/mit'),
	('GPL-2.0', 'https://opensource.org/license/gpl-2-0'),
	('GPL-3.0-only', 'https://opensource.org/license/gpl-3-0'),
	('LGPL-2.1', 'https://opensource.org/license/lgpl-2-1'),
	('LGPL-3.0-only', 'https://opensource.org/license/lgpl-3-0'),
	('MPL-1.1', 'https://opensource.org/license/mpl-1-1'),
	('MPL-2.0', 'https://opensource.org/license/mpl-2-0'),
	('Tcl/Tk License', 'https://www.tcl-lang.org/software/tcltk/license.html');