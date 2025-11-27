Microsoft Windows [Version 10.0.19045.6456]
(c) Microsoft Corporation. All rights reserved.

C:\Users\INFOLAB>docker pull cassandra:latest
latest: Pulling from library/cassandra
d127e9af0f85: Pull complete
7e27b670a0f5: Pull complete
070c1638c21b: Pull complete
c48c21d441c7: Pull complete
248c2e9e4d9f: Pull complete
b5e329fb7a0e: Pull complete
aaaa5c9cd791: Pull complete
87de823001cd: Pull complete
4e292c31f904: Pull complete
7e49dc6156b0: Pull complete
Digest: sha256:5e2c85d2d5db759c28c3efb50905f8d237f958321d6dfd8c176cb148700d9ade
Status: Downloaded newer image for cassandra:latest
docker.io/library/cassandra:latest

C:\Users\INFOLAB>
C:\Users\INFOLAB>docker run --name mon-cassandra -d -p 9042:9042 cassandra:latest
d910619e2c58b3a5afa49df9bed5347e463f48edd12965d22c4897e470981ff3

C:\Users\INFOLAB>docker ps
CONTAINER ID   IMAGE              COMMAND                  CREATED          STATUS          PORTS                                         NAMES
d910619e2c58   cassandra:latest   "docker-entrypoint.s…"   25 seconds ago   Up 23 seconds   0.0.0.0:9042->9042/tcp, [::]:9042->9042/tcp   mon-cassandra
3d75971ca314   python:3.10        "bash"                   47 minutes ago   Up 47 minutes                                                 upbeat_hopper

C:\Users\INFOLAB>
C:\Users\INFOLAB>docker exec -it mon-cassandra cqlsh
Connected to Test Cluster at 127.0.0.1:9042
[cqlsh 6.2.0 | Cassandra 5.0.6 | CQL spec 3.4.7 | Native protocol v5]
Use HELP for help.
cqlsh>
cqlsh> CREATE KEYSPACE IF NOT EXISTS resto_NY
   ... WITH REPLICATION = { 'class' : 'SimpleStrategy', 'replication_factor': 1 };
cqlsh> USE resto_NY;
cqlsh:resto_ny> CREATE TABLE Restaurant (
            ...     id INT,
            ...     Name VARCHAR,
            ...     borough VARCHAR,
            ...     BuildingNum VARCHAR,
            ...     Street VARCHAR,
            ...     ZipCode INT,
            ...     Phone text,
            ...     CuisineType VARCHAR,
            ...     PRIMARY KEY (id)
            ... );
cqlsh:resto_ny>
cqlsh:resto_ny> CREATE INDEX fk_Restaurant_cuisine ON Restaurant (CuisineType);
cqlsh:resto_ny> CREATE TABLE Inspection (
            ...     idRestaurant INT,
            ...     InspectionDate date,
            ...     ViolationCode VARCHAR,
            ...     ViolationDescription VARCHAR,
            ...     CriticalFlag VARCHAR,
            ...     Score INT,
            ...     GRADE VARCHAR,
            ...     PRIMARY KEY (idRestaurant, InspectionDate)
            ... );
cqlsh:resto_ny>
cqlsh:resto_ny> CREATE INDEX fk_Inspection_Restaurant ON Inspection (Grade);
cqlsh:resto_ny> DESC Restaurant;

CREATE TABLE resto_ny.restaurant (
    id int PRIMARY KEY,
    borough text,
    buildingnum text,
    cuisinetype text,
    name text,
    phone text,
    street text,
    zipcode int
) WITH additional_write_policy = '99p'
    AND allow_auto_snapshot = true
    AND bloom_filter_fp_chance = 0.01
    AND caching = {'keys': 'ALL', 'rows_per_partition': 'NONE'}
    AND cdc = false
    AND comment = ''
    AND compaction = {'class': 'org.apache.cassandra.db.compaction.SizeTieredCompactionStrategy', 'max_threshold': '32', 'min_threshold': '4'}
    AND compression = {'chunk_length_in_kb': '16', 'class': 'org.apache.cassandra.io.compress.LZ4Compressor'}
    AND memtable = 'default'
    AND crc_check_chance = 1.0
    AND default_time_to_live = 0
    AND extensions = {}
    AND gc_grace_seconds = 864000
    AND incremental_backups = true
    AND max_index_interval = 2048
    AND memtable_flush_period_in_ms = 0
    AND min_index_interval = 128
    AND read_repair = 'BLOCKING'
    AND speculative_retry = '99p';

CREATE INDEX fk_restaurant_cuisine ON resto_ny.restaurant (cuisinetype);
cqlsh:resto_ny> DESC Inspection;

CREATE TABLE resto_ny.inspection (
    idrestaurant int,
    inspectiondate date,
    criticalflag text,
    grade text,
    score int,
    violationcode text,
    violationdescription text,
    PRIMARY KEY (idrestaurant, inspectiondate)
) WITH CLUSTERING ORDER BY (inspectiondate ASC)
    AND additional_write_policy = '99p'
    AND allow_auto_snapshot = true
    AND bloom_filter_fp_chance = 0.01
    AND caching = {'keys': 'ALL', 'rows_per_partition': 'NONE'}
    AND cdc = false
    AND comment = ''
    AND compaction = {'class': 'org.apache.cassandra.db.compaction.SizeTieredCompactionStrategy', 'max_threshold': '32', 'min_threshold': '4'}
    AND compression = {'chunk_length_in_kb': '16', 'class': 'org.apache.cassandra.io.compress.LZ4Compressor'}
    AND memtable = 'default'
    AND crc_check_chance = 1.0
    AND default_time_to_live = 0
    AND extensions = {}
    AND gc_grace_seconds = 864000
    AND incremental_backups = true
    AND max_index_interval = 2048
    AND memtable_flush_period_in_ms = 0
    AND min_index_interval = 128
    AND read_repair = 'BLOCKING'
    AND speculative_retry = '99p';

CREATE INDEX fk_inspection_restaurant ON resto_ny.inspection (grade);
cqlsh:resto_ny> USE resto_NY;
cqlsh:resto_ny>
cqlsh:resto_ny> COPY Restaurant (id, name, borough, buildingnum, street, zipcode, phone, cuisinetype)
            ... FROM '/restaurants.csv' WITH DELIMITER=',';
Using 3 child processes

Starting copy of resto_ny.restaurant with columns [id, name, borough, buildingnum, street, zipcode, phone, cuisinetype].
Failed to import 20 rows: WriteTimeout - Error from server: code=1100 [Coordinator node timed out waiting for replica nodes' responses] message="Operation timed out - received only 0 responses." info={'consistency': 'ONE', 'required_responses': 1, 'received_responses': 0, 'write_type': 'UNLOGGED_BATCH'},  will retry later, attempt 1 of 5

Failed to import 20 rows: WriteTimeout - Error from server: code=1100 [Coordinator node timed out waiting for replica nodes' responses] message="Operation timed out - received only 0 responses." info={'consistency': 'ONE', 'required_responses': 1, 'received_responses': 0, 'write_type': 'UNLOGGED_BATCH'},  will retry later, attempt 1 of 5
Failed to import 20 rows: WriteTimeout - Error from server: code=1100 [Coordinator node timed out waiting for replica nodes' responses] message="Operation timed out - received only 0 responses." info={'consistency': 'ONE', 'required_responses': 1, 'received_responses': 0, 'write_type': 'UNLOGGED_BATCH'},  will retry later, attempt 1 of 5
Processed: 25624 rows; Rate:    6580 rows/s; Avg. rate:    3328 rows/s
25624 rows imported from 1 files in 0 day, 0 hour, 0 minute, and 7.702 seconds (0 skipped).
cqlsh:resto_ny>
cqlsh:resto_ny> COPY Inspection (idrestaurant, inspectiondate, violationcode, violationdescription, criticalflag, score, grade)
            ... FROM '/restaurants_inspections.csv' WITH DELIMITER=',';
Using 3 child processes

Starting copy of resto_ny.inspection with columns [idrestaurant, inspectiondate, violationcode, violationdescription, criticalflag, score, grade].
Processed: 441712 rows; Rate:    6984 rows/s; Avg. rate:    9344 rows/s
441712 rows imported from 1 files in 0 day, 0 hour, 0 minute, and 47.273 seconds (0 skipped).
cqlsh:resto_ny> SELECT count(*) FROM Restaurant;

 count
-------
 25624

(1 rows)

Warnings :
Aggregation query used without partition key

cqlsh:resto_ny> SELECT count(*) FROM Inspection;
ReadTimeout: Error from server: code=1200 [Coordinator node timed out waiting for replica nodes' responses] message="Operation timed out - received only 0 responses." info={'consistency': 'ONE', 'required_responses': 1, 'received_responses': 0}
cqlsh:resto_ny> SELECT count(*) FROM Inspection WHERE idrestaurant = 41569764;

 count
-------
     8

(1 rows)
cqlsh:resto_ny> SELECT * FROM Restaurant LIMIT 10;

 id       | borough       | buildingnum | cuisinetype                                                      | name                              | phone      | street             | zipcode
----------+---------------+-------------+------------------------------------------------------------------+-----------------------------------+------------+--------------------+---------
 40786914 | STATEN ISLAND |        1465 |                                                         American |                     BOSTON MARKET | 7188151198 |      FOREST AVENUE |   10302
 40366162 |        QUEENS |       11909 |                                                         American |                  LENIHAN'S SALOON | 7188469770 |    ATLANTIC AVENUE |   11418
 41692194 |     MANHATTAN |         360 |                                                             Thai |                     BANGKOK HOUSE | 2125415943 |   WEST   46 STREET |   10036
 41430956 |      BROOKLYN |        2225 |                                                        Caribbean |                 TJ'S TASTY CORNER | 7184844783 |      TILDEN AVENUE |   11226
 41395531 |        QUEENS |         126 |                                                         American |                 NATHAN'S HOT DOGS | 7185958100 |   ROOSEVELT AVENUE |   11368
 50005384 | STATEN ISLAND |         271 |                                                          Chinese |                       YUMMY YUMMY | 7184425888 |  PORT RICHMOND AVE |   10302
 50005858 |      BROOKLYN |        6005 |                                                          Chinese |                    KING'S KITCHEN | 7188531388 | FORT HAMILTON PKWY |   11219
 40962612 |     MANHATTAN |         164 |                                                          Italian |                             CESCA | 2127876300 |   WEST   75 STREET |   10023
 40995404 |     MANHATTAN |        4195 | Latin (Cuban, Dominican, Puerto Rican, South & Central American) | EL GUANACO RESTAURANT & PUPUSERIA | 2127955400 |           BROADWAY |   10033
 40368763 |     MANHATTAN |         111 |                                                         American |                         THE BROOK | 2127537020 |   EAST   54 STREET |   10022

(10 rows)
cqlsh:resto_ny> SELECT name FROM Restaurant LIMIT 10;

 name
-----------------------------------
                     BOSTON MARKET
                  LENIHAN'S SALOON
                     BANGKOK HOUSE
                 TJ'S TASTY CORNER
                 NATHAN'S HOT DOGS
                       YUMMY YUMMY
                    KING'S KITCHEN
                             CESCA
 EL GUANACO RESTAURANT & PUPUSERIA
                         THE BROOK

(10 rows)
cqlsh:resto_ny> COPY Restaurant (name) TO '/restaurant_names.csv' WITH DELIMITER=',';
Using 3 child processes

Starting copy of resto_ny.restaurant with columns [name].
Processed: 25624 rows; Rate:   69956 rows/s; Avg. rate:   59051 rows/s
25624 rows exported to 1 files in 0.459 seconds.
cqlsh:resto_ny> SELECT name, borough FROM Restaurant
            ... WHERE id = 41569764;

 name    | borough
---------+----------
 BACCHUS | BROOKLYN

(1 rows)
cqlsh:resto_ny> SELECT inspectiondate, grade FROM Inspection
            ... WHERE idRestaurant = 41569764;

 inspectiondate | grade
----------------+-------
     2013-06-27 |  null
     2013-07-08 |     A
     2013-12-26 |  null
     2014-02-05 |     A
     2014-07-17 |  null
     2014-08-06 |     A
     2015-01-08 |     A
     2016-02-25 |     A

(8 rows)
cqlsh:resto_ny> SELECT * FROM Inspection
            ... WHERE idRestaurant = 41569764;

 idrestaurant | inspectiondate | criticalflag | grade | score | violationcode | violationdescription
--------------+----------------+--------------+-------+-------+---------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
     41569764 |     2013-06-27 | Not Critical |  null |  null |           15L |                                                                                                                                                                                                               Smoke free workplace smoking policy inadequate, not posted, not provided to employees.
     41569764 |     2013-07-08 | Not Critical |     A |     8 |           10F |                      Non-food contact surface improperly constructed. Unacceptable material used. Non-food contact surface or equipment improperly maintained and/or not properly sealed, raised, spaced or movable to allow accessibility for cleaning on all sides, above and underneath the unit.
     41569764 |     2013-12-26 | Not Critical |  null |    19 |           10H |                                                                                                                                                                                                                                 Proper sanitization not provided for utensil ware washing operation.
     41569764 |     2014-02-05 |     Critical |     A |     5 |           06D |                                                                                                                                                       Food contact surface not properly washed, rinsed and sanitized after each use and following any activity when contamination may have occurred.
     41569764 |     2014-07-17 | Not Critical |  null |  null |           22C |                                                                                                                                                                                                               Smoke free workplace smoking policy inadequate, not posted, not provided to employees.
     41569764 |     2014-08-06 | Not Critical |     A |    10 |           08A | Filth flies or food/refuse/sewage-associated (FRSA) flies present in facility\x1as food and/or non-food areas. Filth flies include house flies, little house flies, blow flies, bottle flies and flesh flies. Food/refuse/sewage-associated flies include fruit flies, drain flies and Phorid flies.
     41569764 |     2015-01-08 | Not Critical |     A |     7 |           10H |                                                                                                                                                                                                                                 Proper sanitization not provided for utensil ware washing operation.
     41569764 |     2016-02-25 | Not Critical |     A |     8 |           10F |                      Non-food contact surface improperly constructed. Unacceptable material used. Non-food contact surface or equipment improperly maintained and/or not properly sealed, raised, spaced or movable to allow accessibility for cleaning on all sides, above and underneath the unit.

(8 rows)
cqlsh:resto_ny> SELECT name FROM Restaurant
            ... WHERE cuisinetype = 'French' ALLOW FILTERING;

 name
--------------------------------
                        MATISSE
                        ALMANAC
                   TOUT VA BIEN
                          FELIX
             CREPES ON COLUMBUS
               THE BARONESS BAR
                     THE SIMONE
                      FP BAKERY
                  VIN ET FLEURS
       CAFE BOULUD/BAR PLEIADES
                        COCOTTE
                  Bourgeois Pig
              DELICE & SARRASIN
               LA TARTE FLAMBEE
                   JEAN GEORGES
                     MAISON MAY
                         DANIEL
                    SAJU BISTRO
              LE PAIN QUOTIDIEN
                     CAFE CLUNY
                         BIN 71
                 CREPES CELSTES
                 JOYCE BAKESHOP
         THE FOX AND THE CREPES
                      CAFE LOUP
                   ROUGE TOMATE
                    LE PERIGORD
                 NOGLU NEW YORK
               BLISS 46  BISTRO
                       PASCALOU
                        BUVETTE
              LE PAIN QUOTIDIEN
 UNION CLUB OF CITY OF NEW YORK
                CAFE LUXEMBOURG
                       TISSERIE
              LE PAIN QUOTIDIEN
                      BAGATELLE
                 PARIS BAGUETTE
              LE PAIN QUOTIDIEN
                  CAFE D'ALSACE
                       KING BEE
                   LA BERGAMOTE
         TOCQUEVILLE RESTAURANT
               BISTRO CHAT NOIR
                 MADISON BISTRO
               57TH BELLE HOUSE
        LA MIRABELLE RESTAURANT
         LE TRAIN BLEU & B CAFE
              HUDSON CLEARWATER
                          CHERI
                       VAUCLUSE
               PARDON MY FRENCH
                 L' ANTAGONISTE
                 MADAME SOU SOU
                     THE BOUNTY
                 DUET BRASSERIE
                  MAISON KAYSER
           DIRTY PIERRES BISTRO
  L'AILE OU LA CUISSE (L'A.O.C)
                     ABC COCINA
           FRENCH CAFE GOURMAND
                 BISTRO VENDOME
                    LE COQ RICO
              THE LITTLE PRINCE
                      LE COUCOU
                  TURKS & FROGS
                     MAISON MAY
                     Le Village
               DOMAINE WINE BAR
                         B CAFE
             LUCIEN RESTAURAUNT
       SEL ET POIVRE RESTAURANT
                 PETITE ABEILLE
                         RAMONA
                         BOULEY
                QUATORZE BISTRO
          BONJOUR CREPES & WINE
                         CAMAJE
               CHICKEN PROVENCE
                      LAFAYETTE
                  VIVE LA CREPE
                          ORSAY
                  CHEZ NAPOLEAN
                 CHEZ JOSEPHINE
          LA BONNE SOUPE BISTRO
           BALTHAZAR RESTAURANT
                   LA MANGEOIRE
               LA BOITE EN BOIS
                     PETIT OVEN
            CHOKOLAT PATISSERIE
                    VAN LEEUWEN
            CANNELLE PATISSERIE
                      BISTRO SK
                     MONTMARTRE
                  VIN SUR VINGT
              HEADLESS HORSEMAN
            PETROSSIAN BOUTIQUE
            BREUKELEN BRASSERIE
                  GOLDEN CREPES
                     LE BARATIN

---MORE---
 name
---------------------------
                 LE CIRQUE
                   OLIVIER
      PERGOLA DES ARTISTES
         DB BISTRO MODERNE
            VIVE LA CREPE!
           OPIA RESTAURANT
       LE RELAIS DE VENISE
                  LANDMARC
         LE PAIN QUOTIDIEN
               XO CREPERIE
           BISTRO LES AMIS
                 MOMINETTE
                 TOURNESOL
                 MARSEILLE
                 BAR TABAC
             CLUB BONAFIDE
          DOMINIQUE BISTRO
      ART HOUSE RESTAURANT
                  26 SEATS
 CHEFS CLUB BY FOOD & WINE
             VIVE LA CREPE
               MAISON HUGO
              CASIMIR & CO
                    AMELIE
                LE PADDOCK
                    PANAME
                LA CIGOGNE
 LE PARIS BISTROT FRANCAIS
             VIN SUR VINGT
             MAISON KAYSER
                  Poulette
                   PARIGOT
         HARLEM BLUES CAFE
           MONTE-CARLO NYC
             CROISSANTERIA
          CANELE BY CELINE
    LA RIPAILLE RESTAURANT
              BISTRO PETIT
      MANILA  SOCIAL  CLUB
                 L'EXPRESS
                  CHEZ MOI
               BIG ROLLAND
   DEMARCHELIER RESTAURANT
                     MAMAM
                      TREE
                   RACINES
     BRANDY LIBRARY LOUNGE
             MAISON KAYSER
                 HILL CAFE
        BRASSERIE RUHLMANN
              PONTY BISTRO
              DAVID'S CAFE
            CAFE LAFAYETTE
          LE POISSON ROUGE
        CREPES AND DELICES
        CAFE UN DEUX TROIS
      B & K FRENCH CUISINE
      FINANCIER PATISSERIE
     LES ENSANTS DE BOHEME
            PETITE ABEILLE
                 OLEANDERS
               CAFE GITANE
            MINETTA TAVERN
               LE BARRICOU
                   JUBILEE
                 LA CARAFE
                  CASSETTE
                 DEUX AMIS
             LA GRENOUILLE
           UPHOLSTRY STORE
                  AMARANTH
                 BISTRO 61
            LE PARIS DAKAR
                      GLOO
             T SWIRL CREPE
          Jaques Brasserie
                Le Charlot
              Cannelle LIC
               LE VEAU DOR
              MACARON CAFE
                 THE ODEON
              JULES BISTRO
               LE DISTRICT
             MAISON KAYSER
     LES CREPES & TAQUERIA
                WALLFLOWER
                PAPA POULE
          CREPE 'N' TEARIA
            CAFE DU SOLEIL
              GALLOW GREEN
                      FIKA
                    LA VUE
           MACARON PARLOUR
                     JO JO
          Bouley Botanical
 JEAN CLAUDE FRENCH BISTRO
             VIN SUR VINGT
              FRENCH ROAST
            ANTIBES BISTRO
              LA BERGAMOTE

---MORE---
 name
----------------------------------------------------
                                  BELGIUM BEER CAFE
                                     LE MIDI BISTRO
                           MAISON HARLEM RESTAURANT
                                            BACCHUS
                                    WAFELS & DINGES
                                               TRIX
                                  VANGUARD WINE BAR
                                  TAUREAU LA SIRENE
                                   GABRIEL KREUTHER
                                         LA DEFENSE
                               CUISINE BY CLAUDETTE
                                    LANGE NOIR CAFE
                               LA BARAKA RESTAURANT
                          PATISSERIE DES AMBASSADES
                                            PIGALLE
                                    PARLOR CLUB NYC
                                      GOLDEN CREPES
                                     CHEZ JAQUELINE
                                           TASTINGS
                                          BISTRO 33
                                  LE PAIN QUOTIDIEN
                                 DBGB KITCHEN & BAR
                                     PETIT CREVETTE
                                       ATRIUM DUMBO
                                      CAFE TRISKELL
                                      LE SINGE VERT
                                           APERITIF
                                             LE PIF
                                             RUE 57
                             DOMINIQUE ANSEL BAKERY
                                        VOL DE NUIT
                                          ROUGE NYC
                                   EIGHT TURN CREPE
                                            BEL AMI
                                  PROVENCE EN BOITE
                                            SAUVAGE
                                       LADUREE SOHO
                                      CHEZ LUCIENNE
                               MILLE-FEUILLE BAKERY
                                      cafe paulette
                                    BRASSERIE SEOUL
                                          ARTISANAL
                                    BISTRO LE STEAK
                                           BAR OMAR
                                   JADIS RESTAURANT
                                         BAR BOULUD
                               BRASSERIE LES HALLES
                                       PONTY BISTRO
 LOTTE NEW YORK PALACE Second Floor Banquet Kitchen
                                         BY SUZETTE
                                    FRESCA LA CREPE
                           CLANDESTINO CAFE AND BAR
                                      JOLIE CANTINA
                                              FREUD
                                  LE PETIT PARISIEN
                                       HAPPY ENDING
                                          BO CA PHE
                                        LE PARISIEN
                                           RACLETTE
                                    Esperanto Fonda
                                        ROSE BAKERY
                                  LE PAIN QUOTIDIEN
                               LA MAISON DU MACARON
                                           BXL EAST
                                               MIMI
                                      BISTRO CITRON
                               SEBASTIAN - CHLOE 81
                                      BENOIT BISTRO
                                         THE MODERN
                                       FRENCH ROAST
                                     MON PETIT CAFE
                                       MACARON CAFE
                                   EXCUSE MY FRENCH
                                   THE CROOKED TREE
                                             WITLOF
                                     LE BATEAU IVRE
                             PETROSSIAN RESTAURAUNT
                                 LE BISTRO D'A COTE
                           BY SUZETTE FRENCH CREPES
                                        COTE SOLEIL
                                       LE BERNARDIN
                                       JACQUES 1534
                                            REBELLE
                       Le Bernardin PrivÃ©/Wine Bar
                                           LE GAMIN
                                           JULIETTE
                              LE P'TIT PARIS BISTRO
                                       FRENCH LOUIE
                                         BY SUZETTE
                                            BAR SIX
                                      FP PATISSERIE
                                        AU BON PAIN
                                    LE GRAINNE CAFE
                               FINANCIER PATISSERIE
                              BRASSERIE COGNAC EAST
                                  LE PAIN QUOTIDIEN
                                     CHAGALL BISTRO
                                     PARIS BAGUETTE
                                             BATARD
                                         CAFE HENRI

---MORE---
 name
----------------------------------------------------------
                                          GABY RESTAURANT
                                                LE RIVAGE
                                                BARRIO 47
                                             FRENCH DINER
                             LA MAISON DU CROQUE MONSIEUR
                                                TARTINERY
                                                 BARAWINE
                                                SEL RROSE
                                                  STATION
                                                 RED CORK
                                                 CREPERIE
 INTERCONTINENTAL NEW YORK TIMES SQUARE/TODD ENGLISH CAVA
                                                   LA VIE
                                             PETIT POULET
                                      PATES el TRADITIONS
                                                 LE MONDE
                                        LE PAIN QUOTIDIEN
                                         GENTLEMAN FARMER
                                             DIRTY FRENCH
                                        LE PAIN QUOTIDIEN
                                                 WINEGASM
                                                CLAUDETTE
                                                  PARADOU
                                                   ALMOND
                                                 MATCH 65
                                        AIR FRANCE LOUNGE
                                            THE TEN BELLS
                                       BRASSERIE MAGRITTE
                                    PAPILLON BISTRO & BAR
                                                LE GARAGE
                       CREDIT AGRICOLE-CBI EXECUTIVE ROOM
                                                   RAOULS
                                    LA CREPE C'EST SI BON
                                            VIVE LA CREPE
                           THE PARK BENCH CAFE & CREPERIE
                                        LE PAIN QUOTIDIEN
                                                 OCABANON
                                          CAFE CHAMPIGNON
                                             PERRY STREET
                                       THE BROOKLYN LABEL
                                             LE BILBOQUET
                                         BRASSERIE COGNAC
                                                TALON BAR
                                     FINANCIER PATISSERIE
                                           BOUCHON BAKERY
                                                 LE GIGOT
                                        THE PANDERING PIG
                                                TARTINERY
                                              SANTOS ANNE
                                                CAFE DADA
                                     BAR SUZETTE CREPERIE

(351 rows)
cqlsh:resto_ny> SELECT name FROM Restaurant
            ... WHERE borough = 'BROOKLYN' ALLOW FILTERING;

 name
--------------------------------------------
                          TJ'S TASTY CORNER
                             KING'S KITCHEN
                         LEO'S DELI & GRILL
                           JIN SUSHI & THAI
                        CROWN FRIED CHICKEN
                            BROOKLYN CAFE 1
                       CRESCENT COFFEE SHOP
                LA ROYALE BEER BURGER HOUSE
                         CONNECTICUT MUFFIN
                        GREENSTREETS SALADS
                                  THE TOPAZ
                             LA GUARIDA BAR
                         MAMA ROZ SOUL FOOD
                           HONG KONG BAKERY
                 BROOKLYN BRIDGE GARDEN BAR
                                THE CANTINE
                              THE GUMBO BRO
                          DAVEY'S ICE CREAM
                        CROWN FRIED CHICKEN
                                THAI TONY'S
                               CHINA DRAGON
                           KNAPP BAGEL CAFE
                     SCHNITZI SCHNITZEL BAR
                            INDIGO MURPHY'S
                    EDDIE JR'S SPORT LOUNGE
                       EL GRAN MAR DE PLATA
                               MALAY BAKERY
                EL NUEVO BARZOLA RESTAURANT
                         PURITAN RESTAURANT
                          EL CHARRO POBLANO
                        HOLIDAY INN EXPRESS
                                     SUBWAY
                          BREUCKELEN COLONY
                                SILENT BARN
                                     BATATA
                               WHITE CASTLE
                          BUBBLE TEA- B.B.Q
                         RED SUN RESTAURANT
                                    OUTPOST
                           ROCCO'S PIZZERIA
                   SAPPORO JAPANESE CUISINE
                              CAMILA'S CAFE
                                 ZOMBIE HUT
                                     SUBWAY
                              EAST MET WEST
                                   BOOMWICH
                                 MCDONALD'S
                                        KFC
                NEW HONG KONG RESTAURANT II
                                SHAKE SHACK
                              NABLUS SWEETS
                                WOLF & LAMB
                            BARCEY'S COFFEE
                          KALINA RESTAURANT
                            ARMANDO'S PIZZA
                        SING WAH RESTAURANT
              EL TEQUILERO BAR & RESTAURANT
                                  KONDITORI
                           SWEETLEAF COFFEE
                         NEW ZHANG'S GARDEN
                                   VAQUEROS
                         LIU'S SHANGHAI INC
               LA CEMITA MEXICAN GRILL CORP
                                COURT ORDER
                      EL PASO MEXICAN GRILL
                                   SCOPELLO
 VETERANS OF FOREIGN WARS POST #107 CANTEEN
                                      RASOI
                                   MIRAKUYA
                               AGRA HEIGHTS
                                HAAGEN-DAZS
                                 TYGERSHARK
             COURT STREET GROCERS HERO SHOP
                                 MUCHMORE'S
                             DUNKIN' DONUTS
                             FAMILY KITCHEN
                       ANARKALI INDIAN FOOD
                                        GFC
        TONY'S PIZZA, JERK CHICKEN AND FISH
                       PETITE FLEURY BAKERY
                                    PIQUANT
                    CHEZ MACOULE RESTAURANT
                    FOOTPRINTS CAFE EXPRESS
                                      PANDA
                             DUNKIN' DONUTS
                   KINARA INDIAN RESTAURANT
                         TEPANGO RESTAURANT
                                   FRANNY'S
                               FRANKIES 457
                                   re.union
                                   JAM ROCK
                   983 BUSHWICK LIVING ROOM
                              PROPELLERHEAD
                              HOPE & ANCHOR
                                IKHOFI CAFE
                                   THE VALE
                         YOSSIS GLATT SUSHI
                                 BLANK CAFE
                                   KI SUSHI
                                     SUBWAY

---MORE---
 name
--------------------------------------
                       SEAPORT BUFFET
                       METROSTAR CAFE
                             THE WELL
                     FATTY DADDY TACO
                GUESTHOUSE RETSAURANT
                             ST MAZIE
                         B & F BAKERY
                        LITTLE PURITY
                    BEAST AND BOTTLES
                           TOWNE CAFE
                          GOLDEN STAR
                     HUNGARIAN KOSHER
                       GORILLA COFFEE
                        THE FIVE SPOT
                      ARMOND'S LOUNGE
                JOSEPH'S DREAM BURGER
                       DUNKIN' DONUTS
                        URBAN VINTAGE
                    TEA FLOWER BAKERY
                     BUSY CORNER DELI
                       UPRIGHT COFFEE
                     NEW BAMBOO HOUSE
                  ORCHIDEA RESTAURANT
                             CADAQUES
                          CLOVER CLUB
                   GUSTOSO RESTAURANT
             NO. 1 CHINESE RESTAURANT
                   DIVINE BAR & GRILL
                            EMELINE'S
                  STEEPLECHASE COFFEE
                     SORT OF WINE BAR
                                ERV'S
                            99 ROGERS
                  PARADISE RESTAURANT
                               MYMOON
                   MASHA AND THE BEAR
 JOHN HUGHES KNIGHTS OF COLUMBUS CLUB
                           EAT N' RUN
                               SUBWAY
                     PRINCE TEA HOUSE
                                MAITE
                       CITY TECH CAFE
                        UNIQUE BAKERY
                         TIN CUP CAFE
                              BAOBURG
                               LUCALI
                          CORNER CAFE
                           VIP COFFEE
                     REGULAR VISITORS
                   PERRY'S RESTAURANT
                            TREEHOUSE
                       JOHNNY'S PIZZA
                        POLLO CAMPERO
                     ROCCO'S PIZZERIA
                                TALDE
                             CALEXICO
                           EL ALMACEN
                         THE MONTROSE
       PEPPAS JERK CHICKEN RESTAURANT
                      ROTI ON THE RUN
                          PACOS TACOS
                           NU CAFE 47
                NEW DRAGON RESTAURANT
                   KIWIANA RESTAURANT
                           FAITH PENN
                SALLY'S FISH & THINGS
                       WONG'S KITCHEN
                                 HAWA
          MR MCKAY'S MORE THAN SALADS
               DON BURRITO RESTAURANT
      MASHALLAH SWEETS AND RESTAURANT
                  THEE SEVEN SISTER'S
                  CANDELAS RESTAURANT
                        SMITH CANTEEN
                   KENNY'S RESTAURANT
           Popeye's Louisiana Kitchen
                            ANI SUSHI
                            MATCHABAR
           GREAT WALL CHINESE CUISINE
                    FISH FISH MO FISH
                          ESPRESSO ME
                           MCDONALD'S
   CHARLIE'S CORNER RESTAURANT & DELI
                           I & R DELI
                    KYOTO SUSHI GRILL
                           L & U CAFE
                       KELLY'S TAVERN
                    KAVE ESPRESSO BAR
                       TORTILLAS KING
                                 BECO
                        TASTY CHICKEN
                            BABA COOL
                   NYC Famous CHICKEN
                             IL POSTO
                  CROWN FRIED CHICKEN
              FERDINANDO'S RESTAURANT
                           LION'S DEN
                            GRINDHAUS
         ROCKY SULLIVAN'S OF RED HOOK
                 SOUTH 4TH BAR & CAFE

---MORE---
 name
------------------------------------------------
                                 PEKING EXPRESS
                                TAQUERIA MILEAR
                                  HUNAN COTTAGE
                                 DUNKIN' DONUTS
                          MAMA BELLA RESTAURANT
                                     BERRY PARK
                                   VEGGIES CAFE
                            XSTASY BAR & LOUNGE
                                       TULCINGO
                            WINDSOR ROAST HOUSE
                                  OVI'S EXPRESS
                                       CLOVER'S
                        KOOL JUICE & COFFEE BAR
                                    OSAKA SUSHI
                                   1,001 NIGHTS
                                   JOJO'S PIZZA
                        KAL BAKERY & RESTAURANT
                                 DUNKIN' DONUTS
                                 BAR SAN MIGUEL
                             PETE'S CANDY STORE
                     BEST WESTERN GREGORY HOTEL
                                     KING PIZZA
                                        JUPIOCA
                                 BATTERY HARRIS
                                  LUIGI'S PIZZA
                             PINK LOTUS GOURMET
                                EXCLUSIVE PIZZA
                           PEACHES MARKET TABLE
                                  NEW FOOD KING
                                 KINGSTON PIZZA
                                     MAISON MAY
                             VINEGAR HILL HOUSE
                             DANNY'S TASTY TIPS
                                         SALTIE
                       SABOR TORIBIO RESTAURANT
                                   CHINA DRAGON
                                     KILO BRAVO
                             DISH FOOD & EVENTS
                                        JUNIPER
                                      VIP GRILL
                                 DUNKIN' DONUTS
                                PIZZA SUPERSTAR
                                 BAD BOYS PIZZA
                              BAKERY RZESZOWSKA
                                    GYRO CORNER
                                     BURLY CAFE
                             CATSKILL BAGEL CO.
                                      LA GRINGA
                                 BRANDED SALOON
                                THE BAGEL STORE
                               CARVEL ICE CREAM
                                          FLORA
                           JAHBREW COFFEE & TEA
                               LA BRASA PERUANA
           DELICIAS TAJADAS BAKERY & RESTAURANT
                                 DUNKIN' DONUTS
 EAST BROADWAY PIZZA & FRIED CHICKEN RESTAURANT
                                     MCDONALD'S
                                         SUBWAY
                    TAK KING CHINESE RESTAURANT
                              MEX CARROLL DINER
                                  MAGGIE BAKERY
                           YAYO'S LATIN CUISINE
                                        BLIMPIE
                                 ALICE'S MARKET
                               LA BAGUETTE SHOP
                       MI CANDILEJAS RESTAURANT
                                        NAMASTE
                       THE FEDERAL BAR BROOKLYN
                                 BUN-CHA-GRAPES
                       Daisy's Deli & Groceries
                                OCEAN VIEW CAFE
                           SHAARE ZION CATERERS
                                     THE MARKET
                       PARK AVENUE LUNCHEONETTE
                                       USAGI NY
                           PAIR WINE AND CHEESE
                 NEW HEIGHTS BAR AND RESTAURANT
                 PALM GROVE TAKE OUT RESTAURANT
                             AVENUE P APPETIZER
                              WASABI RESTAURANT
                       US FRIED CHICKEN & PIZZA
                                           BOZU
                                LARRY  LAWRENCE
                                     MR. WONTON
                                       JJM CAFE
                                HEALTHY NIBBLES
                                         SUBWAY
                             SAVOY CAFE & GRILL
                                 STEAK & SIZZLE
                                      PIZZA HUT
                             NYCS FRIED CHICKEN
                                ARMANDO'S PIZZA
                              FATTY DADDY TACOS
                           LITTLE CAESARS PIZZA
                        ROSAMUNDE SAUSAGE GRILL
                         PUNTA CANA COFFEE SHOP
                             BUFFALO WILD WINGS
                 THE ORIGINAL PIZZA OF AVENUE L
                                       DOMINO'S

---MORE---
 name
----------------------------------------------
                              CUP OF BROOKLYN
                                   THE CAMLIN
                         S & N JAPANESE CREPE
                GREAT WALL CHINESE RESTAURANT
                             PLAKA RESTAURANT
                            COLSON PATISSERIE
                               DUNKIN' DONUTS
                         CHUNGKING RESTAURANT
                    LAS MARGARITAS RESTAURANT
                                   THE GRAHAM
                                        Vegan
                                HAMACHI SUSHI
                           SUNNY SWEET BAKERY
                              PANINO ITALIANO
                               MCG GRAND CAFE
                           RED RYDER BROOKLYN
                        HAMPTON INN  BROOKLYN
                            NEW BEST WOK NO 1
                                  ANNA'S CAFE
                             LELLA ALIMENTARI
                                    BOON THAI
                                   BAGEL ROAD
                      SOL DE QUITO RESTAURANT
                                     SURF BAR
                             Asian Kitchen 55
                       SEAFOOD HOT POT BUFFET
                        PRATT INSTITUTE NORTH
                              OAXACA TAQUERIA
                             BRICK OVEN BREAD
                               RUNNER & STONE
                             LA BAGEL DELIGHT
                           MI PUEBLITA BAKERY
                               LIVE FAST FOOD
                           MITCHELL'S KITCHEN
                        NEW PEKING RESTAURANT
                                  FIX-U-PLATE
                                      HOT WOK
                                 PROVINI CAFE
                                 LUKE LOBSTER
                        KENNEDY FRIED CHICKEN
                                      MR TONG
                                BAHH MI PLACE
                            LILY BLOOM BAKERY
                               DUNKIN' DONUTS
                  JASLOWICZANKA POLISH BAKERY
                        KENNEDY FRIED CHICKEN
                   HUNTER'S STEAK & ALE HOUSE
                            THE BAGEL FACTORY
                                           QI
                             FROST RESTAURANT
                            CAFE & RESTAURANT
                               DUNKIN' DONUTS
   METROPOLITAN FOOD CAFE OF BROOKLYN COLLEGE
                                    HAIL MARY
                                      BUN-KER
                                   LIN GARDEN
                               MID-BREAK CAFE
                     CARIDAD CHINA RESTAURANT
                                        CHIKA
                                    STARBUCKS
                                 SPEEDY ROMEO
                                 620 ON CATON
                                  VIVA MEXICO
                            THE BURGER BISTRO
                               DUNKIN' DONUTS
                     624 KAM HAI CHINESE FOOD
                      LOS PRIMOS DELICATESSEN
                                 COLADOR CAFE
                                   Vivid Cafe
        GOLDEN KRUST CARIBBEAN BAKERY & GRILL
                                     CHECKERS
                                          RYE
                                  SURF TWELVE
                   YANKARI SQUARE SOUL 2 SOUL
                             18 STARS KITCHEN
                            THE AVE LUNCH BOX
                                  BENTOU CAFE
                             SOPHIES'S BISTRO
        SUPER SKYWAY RESTAURANT & KEBAB HOUSE
                        WONG WONG NOODLE SHOP
                               FORTUNE BAKERY
 ROBIN SAYV COOL RUNNING CARIBBEAN RESTAURANT
                           ALKOURA RESTAURANT
                              HUNTER BAR  888
                                AVILA KITCHEN
                              NICE CHINA TOWN
                                   DOT & LINE
                                   SWEET CAFE
                        MEMORIES BAR SHEVROJA
                            FATHER KNOWS BEST
                           SHAXIAN DELICACIES
                                   BON CHOVIE
             BO BO KITCHEN CHINESE RESTAURANT
                                  BURGER KING
                     RED VELVET HOOKAH LOUNGE
                                   CAFE CHILI
                        QUETZALITO RESTAURANT
                        BROOKLYN BURGER SHACK
                         SAIGON BAR AND GRILL
                                TASTEE PATTEE

---MORE---
 name
-----------------------------------
                             TORST
              LUCK THAI RESTAURANT
                   NEW CHUANG HING
                 MOTORINO BROADWAY
               CROWN FRIED CHICKEN
                    KWIE'S KITCHEN
                BALBOA RESTAURANT.
                          CHIKURIN
                            GATHER
     LA STRADA PIZZERIA RESTAURANT
                        FORK SLOPE
                          VEKSLERS
                         BUKANITAS
                 AUDREY'S CONCERTO
             PUNTA CANA RESTAURANT
                             TBAAR
                 NOSTRO RISTORANTE
                         EL TIPICO
                  PIO PIO BROOKLYN
        BOAT HOUSE & CAJUN CUISINE
                          REYNARDS
     ASEA FUSION & YAKITORI LOUNGE
              COBBLESTONE CATERING
             FIFTH AVE CAFE /DINER
                            SUBWAY
            SOFIA PIZZA RESTAURANT
 HONG KONG CAFE CHINESE RESTAURANT
                      PEKING HOUSE
                   D'AMICOS COFFEE
             XING XIANG RESTAURANT
                 BEANER COFFEE BAR
                  DI FARA PIZZERIA
           PRATT-HIGGINS HALL CAFE
                    YI MIN KITCHEN
                    BROADWAY PIZZA
          SISTERS GOURMET PARADISE
                           ALCHEMY
        TACOS MATAMOROS RESTAURANT
                               KFC
                    ANGELO'S PIZZA
                             FIL'S
               DENO'S SWEET SHOPPE
                  CARVEL ICE CREAM
         FAMOUS ROTISSERIE & GRILL
                      YEBISU RAMEN
                          SAKETUMI
                      NAPOLI PIZZA
                            ENID'S
                   CORONA PIZZERIA
           STARBUCKS COFFEE #29850
                    JOYCE BAKESHOP
              RIMINI PASTRY SHOPPE
            THE FOX AND THE CREPES
                        O FORT INC
                      STEVES PIZZA
                   ORIENTAL PALACE
                      COMMONS CAFE
          A & P ROTI & PASTRY SHOP
                            ONOMEA
                           MEZCALS
                     MOE'S DOUGH'S
           LA PARADA II RESTAURANT
                          VSTRECHA
            TATIANA GRILL AND CAFE
           THE BROOKLYN TABERNACLE
                I.M. PASTRY STUDIO
                       SHAKTIBARRE
     CINDY RESTAURANT LUNCHEONETTE
                        CAFE HADAR
                  AMANDA'S KITCHEN
  PANDA HOUSE @1638 BEDFORD AVENUE
                    MORRITO'S CAFE
               GOLDEN KRUST BAKERY
   SAKURA JAPANESE RESTAURANT 3118
                     SOCCER TAVERN
                      GOLDEN CHINA
                     YOUR WAY CAFE
                   HOOKED  ON 12TH
                   ANTEPLI BAKLAVA
                       STOOP JUICE
           T-ROC HOMESTYLE COOKING
         POPEYES LOUISIANA KITCHEN
     THE ORIGINAL PIZZA OF 4TH AVE
                  C.M. COFFEE SHOP
     CHUBBY BURGER CHICKEN & PIZZA
     MANHATTAN 3 DECKER RESTAURANT
                      BROOKLYN MAC
                      FORMOSA CAFE
                     DELROY'S CAFE
           ROYAL CUISINE YARD FOOD
          ROBERTA'S PIZZA & BAKERY
                 VINNIE'S PIZZERIA
                            KOGANE
                   TACOS EL CATRIN
                 AMBER STEAK HOUSE
        VILLABATE-ALBA PASTICCERIA
                            DYNACO
       CHOLULITA DELI & RESTAURANT
                    SOUVLAKI HOUSE
                     THE STARLINER

---MORE---
 name
-------------------------------------------
                     MILL BASIN BAGEL CAFE
                           FOOTPRINTS CAFE
                            DUNKIN' DONUTS
                             SONNY'S HEROS
                 FRANKIE'S COCKTAIL LOUNGE
                            CATERINA PIZZA
                    MILL BASIN KOSHER DELI
                                    SUBWAY
                 POPEYES LOUISIANA KITCHEN
                                  4O KNOTS
                   GREAT WALL CHINESE FOOD
                       SUN HING RESTAURANT
                          PULI BROTHERS II
                             HONG BAO CAFE
                   CHARTER COFFEE AND CUTS
         CJ'S JAMAICAN RESTAURANT & BAKERY
                 RESTAURANT ON 58 ST. INC.
                                  DALY PIE
           ANTHONY'S RESTAURANT & PIZZERIA
                             NICKY'S PIZZA
                             PANKO EXPRESS
                                 SUPERFINE
                          SHINJU III SUSHI
                                  LUNATICO
         CHABBA BBQ/FAMILY GRILL & CUISINE
                       GOLDEN Z RESTAURANT
                        COCOA BAR BROOKLYN
                                DE ISLANDS
                                  HUNTER'S
                              DECORA PIZZA
                       CROWN FRIED CHICKEN
                               JUMBO HOUSE
                        MANDELA RESTAURANT
                         THE COUNTING ROOM
                                    Lot 45
                               OMONIA CAFE
                                 CHICKEN V
                               FREEKS MILL
                           ANTHONY'S PLACE
                        ONE STOP BEER SHOP
                       ANTOJITOS DELI FOOD
         BROOKLYN BURGER & BEER RESTAURANT
                                EAST RIVER
                                BAGELSMITH
             TASTE OF THE CITY FRESH GRILL
                TAQUITOS MEXICO RESTAURANT
                                      LARK
                                   AP CAFE
                                    SUBWAY
                                MCDONALD'S
                   TWO TOM'S RESTAURANT II
                             BERGEN BAGELS
                                   DJERDAN
                          DENIZ RESTAURANT
                    THIS & THAT RESTAURANT
                           SOLE OF THE SEA
              XING LUNG CHINESE RESTAURANT
                      BLUE NILE RESTAURANT
                  MITOUSHI JAPANESE FUSION
                            THE ARCH DINER
                          THE SHANTI SHACK
                         CHUCK E. CHEESE'S
                           THE BURGER GURU
                                OAK & IRON
                           ZEFF'S PIZZERIA
 GREEN PAVILION RESTAURANT & SPORTS LOUNGE
            JUNIOR'S PIZZA & FRIED CHICKEN
                                   U IZIKA
                       CHANG YU RESTAURANT
                              PIZZA STUDIO
                            CAFFE LA NOTTE
                                  George's
                    THE CIVIL SERVICE CAFE
                              CHINA GARDEN
                               SILVER RICE
                                     DOS31
                              SAKURA SUSHI
                         YEMEN ALSAED CAFE
                     BULL'S EYE SPORTS PUB
                              MIA'S BAKERY
                  MI BELLA DAMA RESTAURANT
                               SIMPLE CAFE
                     GOTTLIEB'S RESTAURANT
                           PACIFICANA REST
                      PRIMAVERA RESTAURANT
                               PAPA JOHN'S
                 POPEYES LOUISIANA KITCHEN
                       EVILOLIVE PIZZA BAR
                      CHINA ONE RESTAURANT
                                  BORNHOLM
                           ARMANDO'S PIZZA
                                 Midnights
                                 BAR CHORD
                        DAVID'S RESTAURANT
                               PAPA JOHN'S
                          BREAD AND SPREAD
                                IONA'S BAR
     GOLDEN KRUST CARIBBEAN BAKERY & GRILL
  KATHY'S GOURMET ITALIAN ICES & ICE CREAM
                               DIM SUM BAR

---MORE---
 name
-------------------------------------------------------------
                                                    TAI THAI
                                                  TRAVEL BAR
                                        AFFY'S PREMIUM GRILL
                                       BREWKLYN GRIND COFFEE
                                             CHOCOLATE WORKS
                                              GRAND ST PIZZA
                               DUNKIN' DONUTS/BASKIN ROBBINS
                                                  PATTIE HUT
                                              DUNKIN' DONUTS
                                                  CHINA DOLL
                                                     YI CAFE
                               LISA'S PIZZERIA AND DUMPLINGS
                                                WHITE CASTLE
                                                     SUNNY'S
                                             GREENWOOD BEACH
 CARIBBEAN & AMERICAN ENTERTAINMENT BAR  LOUNGE & RESTAURANT
                                      NORA'S PARK BENCH CAFE
                                                  RICO CHIMI
                                            MARIO'S PIZZERIA
                                            BLENDZVILLE CAFE
                                      EL CASTILLO RESTAURANT
                                                    WAH YUNG
                                                  PIPINS PUB
                       GOLDEN KRUST CARIBBEAN BAKERY & GRILL
                                               SUSHI MESHUGA
                                 PETES PIZZERIA & RESTAURANT
                                             WA SUSHI & THAI
                                            PUMPS EXOTIC BAR
                                                KIMCHI GRILL
                                           CONNIE'S PIZZERIA
                                                  MOLTO BENE
                                                       TAZZA
                                                 WATTY & MEG
                                          PABLO'S RESTAURANT
                              GOOD FRIEND CHINESE RESTAURANT
                                                  PHO 18 AVE
                                              BLACK BEAR BAR
                                             KAFE LOUVERTURE
                                  RADEGAST HALL & BIERGARTEN
                                         L'INDUSRIE PIZZERIA
                                                BEEHIVE OVEN
                                                     TEA BAR
                                          NEW TONG & TACO 88
                                         BED STUY PROVISIONS
                                               CLOW & CLOVER
                                                PANERA BREAD
                            BEDFORD COFFEE COMPANY/STARBUCKS
                                           TRADITIONS EATERY
                     CHIPOTLE MEXICAN GRILL OF COLORADO, LLC
                                                BOMBAY SPICE
                                                FULTON GRAND
                                                     NIGHTÂ°
                                                ELUDZ LOUNGE
                                              DUNKIN' DONUTS
                                          WILLIAMSBURG PIZZA
                                              DUNKIN' DONUTS
                                         GOLDEN CROWN BAKERY
                                             IRON CHEF HOUSE
                                                 BURGER KING
                                               Flavorlicious
                                                 KITTEN CAFE
                                        COCO ROCO RESTAURANT
                                                     JACKBAR
                                                   PIZZA DEN
                                                  CARRO CAFE
                                              EVODIO'S PLACE
                                            MARGARITA ISLAND
                                        MERMELSTEIN CATERERS
                                             DELI EL BIGOTES
                                       DADDY'S PIZZA & PASTA
                                                  MP TAVERNA
                                                   RICH LANE
                                  LIANG'S SEAFOOD RESTAURANT
                                                  CAFE METRO
                                                 PAPA JOHN'S
                                              TASTE OF CHINA
                                     GIOVANNIS BROOKLYN EATS
                                                      LE NAR
                                                    DOMINO'S
                                                Git-It-N-Git
                                               cafe paulette
                             SUPERSTAR FAMILY FUN CENTER INC
                                                        CROP
                                             HOP LEE KITCHEN
                                            PRIVILEGE LOUNGE
                                        LIN'S GARDEN KITCHEN
                                         NEW BOK CHOY & ROLL
                                                 ROSE CASTLE
                                                    GRAN BAR
                                               WILLBURG CAFE
                                             KNAPP PIZZA III
                                                  FUEL FEVER
                                                MIKE'S DINER
                      GOLDEN KRUST CARRIBBEAN BAKERY & GRILL
                                               L' CHAIM CAFE
                                                CARVEL #2248
                                       NEW MING HING KITCHEN
                                                      JOLOFF
                                              DUNKIN' DONUTS
                                     NIMBOODA INDIAN CUISINE

---MORE---
 name
-------------------------------------------------------------------
                                                          NATIONAL
                                                         HOPS HILL
                                                  POP'S RESTAURANT
                                                  LA BOHEME LOUNGE
                                          KING ROYAL FRIED CHICKEN
                                                            SUBWAY
                                                         Ria Bella
                                                        BAGEL CAFE
                  GOOD SHEPHERD SERVICES-SHIRLEY CHISOLM RESIDENCE
                                                          URO CAFE
                                                          GOLDIE'S
                                                       NEW HOT WOK
                                                               BKW
                                                    DANIELA'S CAFE
                                                  JIA XIANG BAKERY
                                                    DUNKIN' DONUTS
                                                      PRONTO PIZZA
                                                  VIP KINGS BAKERY
                                                  PIZZA ON THE RUN
                                                        MCDONALD'S
                                                     NORTH PENGUIN
                                    CAPTAIN DAN'S GOOD TIME TAVERN
                                               L'ALBERO DEI GELATI
                                                    TOUS LES JOURS
                                                 ROCCA/CAFE-LOUNGE
                                                           TEAFFEE
                                                      SUNSET DINER
                                                         BEST DELI
                                                       TIKKA GRILL
                                                    DUNKIN' DONUTS
                                                     FATTY CUE BBQ
                                        Liu Liu Seafood Restaurant
                                         BROOKLYN HEIGHTS WINE BAR
                                                   BROOKLYN STOOPS
                                                            CIPURA
                                                     LUCKY KITCHEN
                                                    3 IN 1 KITCHEN
                                                           PALOMAS
                                                     BOSTON MARKET
                                         LANGQI SEAFOOD RESTAURANT
                                                U.S. FRIED CHICKEN
                                                   BUENA NUTRICION
                                                            DINGHY
                                                BAHARY FISH MARKET
                                                     6321 YUAN BAO
                                                         CHIP SHOP
                                                         STARBUCKS
                                                 TANOREEN CATERERS
                                                              OLEA
                                                        MCDONALD'S
                                                   MARK'S PIZZERIA
                                        SOSAKU JAPANESE RESTAURANT
                                                         MUSE CAFE
                                                  FISHERMAN'S COVE
                                                          DOMINO'S
                                    DUNKIN' DONUTS, BASKIN ROBBINS
                                         POPEYES LOUISIANA KITCHEN
                                                          THE HARP
                                               CASTILLO RESTAURNAT
                                                          CHECKERS
                                                      BAGEL MARKET
                                             SANCA DELI RESTAURANT
                                                 WISE ESPRESSO BAR
                                                   ONE & TWO FOODS
                                                 THE MEATBALL SHOP
                                              USULUTECO RESTAURANT
                                                       ALL NATIONS
                                                           SKYLARK
                                               DAMAS FALAFEL HOUSE
                                                        CLUBS GYRO
                                         POPEYES LOUISIANA KITCHEN
                                            ICE CREAM -196 CELSIUS
                                    EL MAGUEY MEXICANA SALVADORENA
                                                              JOYA
                                                  BERG'N BEER HALL
                                               NEW MARIOS PIZZERIA
                                                           BOUTROS
                                                         67 Burger
                                               CROWN FRIED CHICKEN
                                        A.W.O.L. All Walks of Life
                                                         POLKA DOT
                                                         REBECCA'S
                                                THE FLYING LOBSTER
                                            WOLF AND DEER BROOKLYN
                                                   SAPPORO ICHIBAN
                                              ELEGANTE PASTRY SHOP
                                          YOLIE'S BAR & RESTAURANT
                                                   Duff's Brooklyn
                                                           BARON'S
                                                             HANOI
                                                    DUNKIN' DONUTS
                                                             DEITY
                                                     KING & QUEENS
                                    DAGAN PIZZA & DAIRY RESTAURANT
 UNION SQUARE SPORTS & ENTERTAINMENT AT THEATRE FOR A NEW AUDIENCE
                                                     GOURMET GRILL
                                       ANNIES FIRST WOK RESTAURANT
                                                   A & A BAKE SHOP
                                                    DUNKIN' DONUTS
                                       BROOKLYN ROASTING WORKS LLC

---MORE---
 name
----------------------------------------------
                           BRUNSWICK BED STUY
                              NEW JOHN GARDEN
                               PROPELLER CAFE
                                  SWEET BASIL
                                    LLAMA INN
                                 GINO'S PIZZA
                            Twin Lin's Garden
               New Win Way Chinese Restaurant
                           BROOKLYN STEAK CO.
                              TAKSIM SQUARE 2
                                      DAR 525
                                MATCHPOINTNYC
                              JEMZ RESTAURANT
                                  WHITE MAIZE
              OCEAN 8 AT BROWNSTONE BILLIARDS
                         LITTLE CEASARS PIZZA
                                    LOCK YARD
                              THE CONTINENTAL
           SAMIA'S FINE MEDITERRANEAN CUISINE
                                        MAHJI
                                BENSION KOHEN
                         BENNY'S FAMOUS PIZZA
                                PRETZEL MAKER
                                    ZONA ROSA
           THE ORIGINAL CULPEPPERS RESTAURANT
                                       GALICI
                         FAY WONG CAFE BAKERY
                         JOE & SAL'S PIZZERIA
                                   SAVOR CAFE
                     RMR CAFE (BOWLING ALLEY)
                               PRECIOUS METAL
                             GOURMET GARDEN 8
                   GOOD VIEW DELICIOUS BAKERY
                                  THE GROCERY
                                  AZTECA MAYA
                                      SACHIKO
                 EL SABOR CARIBENO RESTAURANT
                             HALAL GYRO MANIA
                                   MCDONALD'S
                            RESTAURACJA RELAX
                            LEO CASA CALAMARI
                                  CROWN GRILL
     MICHAEL & PING'S MODERN CHINESE TAKE-OUT
                                      FORNINO
                           TASTE OF CHINA USA
                LA ESTRELLA DEL CASTILLO CORP
                             EL NOEL WELLNESS
                                WESTWAY BAGEL
                IMMACULEE BAKERY & RESTAURANT
                  GRACE DELICIOUS KITCHEN INC
                            DYKER PARK BAGELS
                                   HENG CHANG
                           ELISA'S LOVE BITES
                              JUICERY+KITCHEN
                                     DOMINO'S
                                    DONG DONG
                                   APPLEBEE'S
                  PANADERIA PUEBLA RESTAURANT
 SILVER' CRUST WEST INDIAN RESTAURANT & GRILL
                                         FAUN
                              ROOFTOP  LOUNGE
                                   MCDONALD'S
                                         MINT
                             BATH BEACH DINER
                                   MAHAL KITA
                                   SWEETGREEN
                                   BARBONCINO
                                    U BO SING
                         PAPA'S FRIED CHICKEN
                             PASTELITOS ELVYS
                         JERUSALEM STEAKHOUSE
                               DIZZY'S ON 5TH
                               AGRA TAJ MAHAL
                                  MESA AZTECA
                LUANNE'S WILDGINGER ALL-ASIAN
             FRANCESCO'S PIZZERIA & TRATTORIA
                                 SAINT ANSELM
                    LUNATICS ICE CREAM PARLOR
                         NEW DYKER RESTAURANT
                         CHINA WOK RESTAURANT
                                       BERLYN
     PONTENTIAL VEGETAL (PV HERBS & VITAMINS)
                                    STARBUCKS
                                      BIRDY'S
                  BOSTON JERK-CITY RESTAURANT
                                 HUNGRY GHOST
                                   MR. FULTON
                      NEW FUN SING RESTAURANT
                          NIGHTS AND WEEKENDS
                              TASTE OF HEAVEN
                               DUNKIN' DONUTS
                          PAT'S FLAVORS KRUSS
                    TROPICAL HOUSE BAKING CO.
                             LIVINGSTON DINER
                           NO. 1 PEKING OISHI
                            AVENUE J PIZZERIA
                       MEME'S HEALTHY NIBBLES
                                 INES' BAKERY
                            HAPPY COFFEE SHOP
                         LA CUARTA RESTAURANT

---MORE---
 name
------------------------------------------------------------------------------------------------------
                                                                                          TASTY HOUSE
                                                                                          GOLDEN RING
                                                                                    KOSHER BAGEL HOLE
                                                                                        KOMBIT KREYOL
                                                                             TORRES ITALIAN RESTURANT
                                                                                         BOMBAY CURRY
                                                                       MARIA COFFEE SHOP & RESTAURANT
                                                                                  PAT'S PALM TREE INN
                                                                                               MI-TEA
                                                                                            LA CUESTA
                                                                             CHINA EXPRESS RESTAURANT
                                                                                  SHUNDECK RESTAURANT
                                                                                   NORTHERN TERRITORY
                                                                            LOPEZ BAR RESTAURANT CORP
                                                                                   CONNECTICUT MUFFIN
                                                                                       SUN HOUSE CAFE
                                                                                     SHUN FAT KITCHEN
                                                                      TRIPOLI RESTAURANT/SWALLOW CAFE
                                                                                              PITANGA
                                                                                           WEATHER UP
                                                                                            CITY CAFE
                                                                                  HAN WONG RESTAURANT
                                                                         ATHENA MEDITERRANEAN CUISINE
                                                                                         FREDDY'S BAR
                                                                 ALIMENTOS SALUDABLES - MEXICAN GRILL
                                                                                      NATHAN'S FAMOUS
                                                                                            GOURMET K
                                                                                       DUNKIN' DONUTS
                                                                          THE NEW SANTIAGO RESTAURANT
                                                                                             RITZ BAR
                                                                                       DUNKIN' DONUTS
                                                                                        NOORMAN'S KIL
                                                                                             CHECKERS
                                                                                  CROWN FRIED CHICKEN
                                                                                        WU LA BU HUAN
                                                                                 BROADWAY COFFEE SHOP
                                                                                          ENERGY FUEL
                                                                                 LITTLE CAESARS PIZZA
                                                                              ISLAND GROVE RESTAURANT
                                                                                   FRIENDS AND LOVERS
                                                                                       DUNKIN' DONUTS
                                                                                          HI TEA CAFE
                                                                                   The Great Room Bar
                                                                                       DUNKIN' DONUTS
                                                                          TING HUA CHINESE RESTAURANT
                                                                             AJI ASIAN FUSION CUISINE
                                                                                           RUSS PIZZA
                                                                                  POLONICA RESTAURANT
                                                                                         OLYMPIC PITA
                                                                                 CRAB SPOT RESTAURANT
                                                                                 NEW TOP TACO & CHINA
                                                                                ISLAND POT RESTAURANT
                                                                                               SUZUME
 CHILOS                                                                                        nnnnnn
                                                                                     IC BROOKLYN CAFE
                                                                                          DINING ROOM
                                                                                             SAN LOCO
                                                                                  SHOBU SUSHI & GRILL
                                                                                GRAN VILLA RESTAURANT
                                                                                   CHOCK FULL O' NUTS
                                                                                        ROZAFA LOUNGE
                                                                                F&M CAFE & RESTAURANT
                                                                                         SAKURA SUSHI
                                                                                           NEW GARDEN
                                                                                            HING WONG
                                                                                      ROYAL RIB HOUSE
                                                                                       PUDGE KNUCKLES
                                                               (LEWIS DRUG STORE) LOCANDA VINI E OLII
                                                                                           CAFFE BENE
                                                                                     LILY RESTAURANT.
                                                                                           DALLAS BBQ
                                                                             NO. 1 CHINESE RESTAURANT
                                                                                BENSON EATING STATION
                                                                                NEW HOP SHING KITCHEN
                                                                                       L' ANTAGONISTE
                                                                              EAT FRESH INTERNATIONAL
                                                                                               SUBWAY
                                                                                        TACOS TIJUANA
                                                                                  SUNDAES BY THE PARK
                                                                             LA BRUSCHETTA RESTAURANT
                                                                                         THE BREW INN
                                                                                 CHINA DRAGON EXPRESS
                                                                                UNCLE'S SHACK & GRILL
                                                                                 NEW SUNNY RESTAURANT
                                                                                GREENPOINT BEER & ALE
                                                                                                TBAAR
                                                                                          PETER PIZZA
                                                                   FIVE GUYS FAMOUS BURGERS AND FRIES
                                                                                     FU EN RESTAURANT
                                                                           SUNSET PARK DINER & DONUTS
                                                                                         WALTER FOODS
                                                                             GOLDEN DRAGON RESTAURANT
                                                                                          HAAGEN-DAZS
                                                                                    SUBWAY SANDWICHES
                                                                                   WILLIAMSBURG PIZZA
                                                                                  CROWN FRIED CHICKEN
                                                                                           SOTTO CASA
                                                                                 OFF SHORE RESTAURANT
                                                                                       DA VINCI PIZZA
                                                                        CARROLL GARDENS CLASSIC DINER

---MORE---
 name
---------------------------------------
             ARTICHOKE BASILLE'S PIZZA
                             CRAWFORDS
                         TASTY CHICKEN
                          ICHI SUSHI I
                 BLACKSTAR BAKERY CAFE
                           THE NARROWS
                            LA NORTENA
                             STARBUCKS
                            THE BOUNTY
                               HANCO'S
                             NAKED DOG
                     JIA XIANG KITCHEN
                TIP OF THE TONGUE CAFE
                   CHAP A NOSH/YUN KEE
                    BROOKLYN BARGE BAR
                        DUNKIN' DONUTS
            EL GRAN MALECON RESTAURANT
                           HOT POT 828
        JOYCE'S WEST INDIES RESTAURANT
                                SUBWAY
   DRAGON CHINA RESTAURANT ON BAYRIDGE
                             WING-N-IT
                      MEE THAI CUISINE
               GREAT FLAVOR RESTAURANT
      BROOKLYN ACADEMY OF MUSIC-HARVEY
              DELLAROCCO'S OF BROOKLYN
                NOSTRAND ISLAND EATERY
                              MAYFIELD
             BROOKLYN ROASTING COMPANY
                               ROUTINE
                             CRIF DOGS
                  LA PARADA RESTAURANT
                      CARVEL ICE CREAM
                       RIVIERA CATERER
                          ARASHI SUSHI
           GRILL'S DELIGHT & JUICE BAR
                      KING WOK TAKEOUT
                OASIS DINER/RESTAURANT
                              PHO VIET
                           WAHLBURGERS
         OZU JAPANESE CUISINE & LOUNGE
 CROWN HEIGHTS BUNCH-O-BAGELS AND MORE
                      PANINI TOST CAFE
         CHIPOTLE MEXICAN GRILL # 2766
                          BARI'S PIZZA
                              TO SPITI
            TENGU SUSHI & NOODLE HOUSE
                      SOUTHSIDE COFFEE
                       ROWS RESTAURANT
            BROOKLYN ICE CREAM FACTORY
                            GRIMALDI'S
                         KINGS THEATRE
                           LUCHA LUCHA
                          FEENEY'S PUB
                       EMERALD FORTUNE
                           HAPPY LEMON
                      CARVEL ICE CREAM
              THE VILLAGE LUNCHEONETTE
                      EL AGUILA BAKERY
       CHINA GARDEN CHINESE RESTAURANT
             LANDY PIZZERIA RESTAURANT
                WING HING 1 RESTAURANT
                               ALAMEDA
                               MOLDOVA
                             PINKBERRY
                          LITTLE ZELDA
    GOLDEN IMPERIAL SEAFOOD RESTAURANT
          TONY'S PIZZERIA & RESTAURANT
            NINA'S RESTAURANT PIZZERIA
                     THE BURGER BISTRO
                 KENNEDY FRIED CHICKEN
                   BROOKLYN SAFE HOUSE
               PEARL INDIAN RESTAURANT
                         UPSTATE STOCK
                    TKO CHICKEN & RIBS
               NEW SOLDIERS RESTAURANT
                             LULA BEAN
                                 SIENA
                               GLADY'S
                               JUNIORS
                              Aperture
                          H & Y BAKERY
                 GEORGIAN DREAM BAKERY
             GRACE & SUNG 7 STARS DELI
                           MARINER INN
                          R.J.'S PLACE
                     SUBWAY SANDWICHES
                                BENNYS
                     OFF TO START CAFE
                              WILSON'S
                   CROWN FRIED CHICKEN
                 BUTTER MILK BAKE SHOP
                        DUNKIN' DONUTS
                             MAC SHACK
         KINGS COUNTY CAFETERIA BLDG T
                               SKYTOWN
                             CANAL BAR
                            LIGHTHOUSE
        PIER 53 COFFEE & SANDWICH SHOP
   PECTOPAH TYPMAH (GURMAN RESTAURANT)

---MORE---
cqlsh:resto_ny> SELECT grade, score FROM Inspection
            ... WHERE idRestaurant = 41569764 AND score >= 10 ALLOW FILTERING;

 grade | score
-------+-------
  null |    19
     A |    10

(2 rows)
cqlsh:resto_ny> SELECT grade FROM Inspection
            ... WHERE score > 30 ALLOW FILTERING;

 grade
----------------
           null
           null
           null
              C
           null
           null
           null
           null
           null
           null
              C
           null
           null
           null
           null
           null
           null
           null
           null
           null
           null
           null
           null
           null
           null
           null
           null
           null
           null
           null
           null
           null
           null
           null
           null
           null
           null
              C
           null
           null
           null
           null
           null
           null
           null
           null
           null
           null
           null
           null
           null
 Not Yet Graded
           null
           null
           null
           null
           null
           null
           null
           null
           null
           null
           null
           null
           null
           null
           null
           null
           null
           null
           null
           null
           null
           null
           null
           null
           null
           null
           null
              C
           null
           null
           null
              C
           null
           null
           null
           null
              C
           null
           null
           null
           null
           null
           null
           null
           null
           null
           null
           null

---MORE---
 grade
----------------
           null
           null
           null
           null
           null
           null
           null
           null
           null
           null
           null
           null
              C
           null
              C
           null
              C
              C
           null
           null
           null
              C
           null
           null
           null
           null
           null
           null
           null
           null
           null
           null
              C
           null
           null
           null
           null
           null
              C
           null
           null
              C
           null
           null
           null
           null
           null
           null
           null
           null
           null
           null
           null
           null
           null
           null
           null
           null
           null
              C
           null
           null
           null
           null
           null
           null
           null
           null
           null
           null
           null
              C
           null
           null
 Not Yet Graded
           null
              C
           null
           null
           null
           null
           null
           null
           null
           null
           null
           null
              C
           null
           null
           null
              C
           null
           null
           null
           null
              C
           null
           null
           null

---MORE---
 grade
----------------
           null
           null
           null
           null
              C
           null
              C
              C
           null
              C
           null
           null
           null
           null
           null
           null
           null
           null
           null
           null
           null
           null
           null
           null
           null
              Z
           null
           null
           null
              C
 Not Yet Graded
              C
           null
           null
              C
           null
           null
           null
           null
           null
           null
           null
           null
              C
           null
           null
           null
           null
           null
              C
              C
           null
           null
           null
           null
           null
           null
           null
           null
           null
              Z
           null
           null
           null
           null
           null
           null
           null
           null
           null
           null
           null
              C
           null
           null
           null
           null
              C
           null
           null
           null
           null
           null
           null
           null
           null
           null
           null
           null
           null
           null
           null
           null
           null
           null
           null
           null
           null
           null
           null

---MORE---
 grade
----------------
           null
           null
           null
           null
           null
           null
           null
           null
           null
           null
           null
           null
           null
           null
           null
              C
           null
           null
              Z
 Not Yet Graded
              C
           null
           null
           null
           null
           null
           null
           null
           null
           null
           null
              C
           null
           null
           null
           null
           null
           null
           null
           null
           null
           null
           null
           null
           null
           null
           null
           null
           null
           null
           null
           null
           null
           null
           null
           null
           null
           null
           null
              C
           null
           null
           null
           null
           null
           null
              C
           null
              C
           null
           null
           null
           null
           null
           null
           null
           null
              C
           null
              C
           null
           null
           null
           null
              C
           null
           null
           null
           null
           null
           null
           null
              C
           null
           null
              C
           null
           null
           null
              C

---MORE---
 grade
----------------
           null
           null
              C
           null
           null
           null
           null
           null
              C
           null
           null
           null
           null
           null
           null
           null
           null
           null
           null
           null
           null
           null
           null
           null
           null
           null
              C
           null
           null
              C
           null
           null
              C
           null
              C
           null
           null
           null
           null
           null
           null
           null
           null
           null
           null
           null
           null
           null
           null
           null
 Not Yet Graded
           null
           null
           null
           null
           null
           null
           null
           null
           null
           null
           null
           null
           null
              C
           null
           null
           null
           null
           null
           null
              C
           null
           null
           null
           null
           null
           null
              C
           null
           null
           null
              C
           null
           null
              C
           null
           null
           null
           null
           null
           null
           null
           null
           null
              C
           null
           null
           null
           null

---MORE---
 grade
----------------
           null
           null
           null
           null
           null
           null
           null
           null
           null
           null
           null
           null
           null
           null
           null
           null
           null
           null
           null
           null
           null
           null
           null
           null
           null
           null
           null
           null
           null
           null
           null
              C
           null
           null
           null
              C
           null
           null
           null
              C
           null
              C
              C
           null
           null
           null
           null
              C
           null
           null
              C
           null
           null
           null
           null
           null
           null
           null
           null
           null
           null
           null
           null
           null
           null
           null
           null
           null
           null
           null
              C
           null
           null
           null
              C
           null
           null
              C
              C
           null
           null
 Not Yet Graded
           null
           null
           null
           null
           null
           null
           null
           null
           null
           null
           null
           null
           null
           null
           null
           null
              C
           null

---MORE---
cqlsh:resto_ny> SELECT count(*) FROM Inspection
            ... WHERE score > 30 ALLOW FILTERING;

 count
-------
  8698

(1 rows)

Warnings :
Aggregation query used without partition key

Read 1651 live rows and 1130 tombstone cells for query SELECT score FROM resto_ny.inspection WHERE score > 30 LIMIT 100 ALLOW FILTERING; token -9013105958081990342 (see tombstone_warn_threshold)

Read 1828 live rows and 1354 tombstone cells for query SELECT score FROM resto_ny.inspection WHERE token(idrestaurant) >= token(41492598) AND score > 30 LIMIT 100 ALLOW FILTERING; token -8779302347467588585 (see tombstone_warn_threshold)

Read 1522 live rows and 1086 tombstone cells for query SELECT score FROM resto_ny.inspection WHERE token(idrestaurant) >= token(41618586) AND score > 30 LIMIT 100 ALLOW FILTERING; token -8579136122643564250 (see tombstone_warn_threshold)

Read 1636 live rows and 1157 tombstone cells for query SELECT score FROM resto_ny.inspection WHERE token(idrestaurant) >= token(41366039) AND score > 30 LIMIT 100 ALLOW FILTERING; token -8379605781327546252 (see tombstone_warn_threshold)

Read 1878 live rows and 1267 tombstone cells for query SELECT score FROM resto_ny.inspection WHERE token(idrestaurant) >= token(40906490) AND score > 30 LIMIT 100 ALLOW FILTERING; token -8150864666108308860 (see tombstone_warn_threshold)

Read 1804 live rows and 1218 tombstone cells for query SELECT score FROM resto_ny.inspection WHERE token(idrestaurant) >= token(50051698) AND score > 30 LIMIT 100 ALLOW FILTERING; token -7926832779045826763 (see tombstone_warn_threshold)

Read 1744 live rows and 1288 tombstone cells for query SELECT score FROM resto_ny.inspection WHERE token(idrestaurant) >= token(41302781) AND score > 30 LIMIT 100 ALLOW FILTERING; token -7737927962167294459 (see tombstone_warn_threshold)

Read 1567 live rows and 1057 tombstone cells for query SELECT score FROM resto_ny.inspection WHERE token(idrestaurant) >= token(41509061) AND score > 30 LIMIT 100 ALLOW FILTERING; token -7553517068519239805 (see tombstone_warn_threshold)

Read 1655 live rows and 1124 tombstone cells for query SELECT score FROM resto_ny.inspection WHERE token(idrestaurant) >= token(41163809) AND score > 30 LIMIT 100 ALLOW FILTERING; token -7342918856001188655 (see tombstone_warn_threshold)

Read 1537 live rows and 1098 tombstone cells for query SELECT score FROM resto_ny.inspection WHERE token(idrestaurant) >= token(41465557) AND score > 30 LIMIT 100 ALLOW FILTERING; token -7145263726567122542 (see tombstone_warn_threshold)

Read 1998 live rows and 1420 tombstone cells for query SELECT score FROM resto_ny.inspection WHERE token(idrestaurant) >= token(41255152) AND score > 30 LIMIT 100 ALLOW FILTERING; token -6890051609577913029 (see tombstone_warn_threshold)

Read 1636 live rows and 1191 tombstone cells for query SELECT score FROM resto_ny.inspection WHERE token(idrestaurant) >= token(41643870) AND score > 30 LIMIT 100 ALLOW FILTERING; token -6660189309869880155 (see tombstone_warn_threshold)

Read 1691 live rows and 1228 tombstone cells for query SELECT score FROM resto_ny.inspection WHERE token(idrestaurant) >= token(41452652) AND score > 30 LIMIT 100 ALLOW FILTERING; token -6471626504674095634 (see tombstone_warn_threshold)

Read 1715 live rows and 1153 tombstone cells for query SELECT score FROM resto_ny.inspection WHERE token(idrestaurant) >= token(41233053) AND score > 30 LIMIT 100 ALLOW FILTERING; token -6145273940833363137 (see tombstone_warn_threshold)

Read 1768 live rows and 1240 tombstone cells for query SELECT score FROM resto_ny.inspection WHERE token(idrestaurant) >= token(41721444) AND score > 30 LIMIT 100 ALLOW FILTERING; token -5909753255744505682 (see tombstone_warn_threshold)

Read 1624 live rows and 1147 tombstone cells for query SELECT score FROM resto_ny.inspection WHERE token(idrestaurant) >= token(40837605) AND score > 30 LIMIT 100 ALLOW FILTERING; token -5714322549263396857 (see tombstone_warn_threshold)

Read 1713 live rows and 1174 tombstone cells for query SELECT score FROM resto_ny.inspection WHERE token(idrestaurant) >= token(40392721) AND score > 30 LIMIT 100 ALLOW FILTERING; token -5524024193057878676 (see tombstone_warn_threshold)

Read 1770 live rows and 1226 tombstone cells for query SELECT score FROM resto_ny.inspection WHERE token(idrestaurant) >= token(40393118) AND score > 30 LIMIT 100 ALLOW FILTERING; token -5302282856172528105 (see tombstone_warn_threshold)

Read 1556 live rows and 1175 tombstone cells for query SELECT score FROM resto_ny.inspection WHERE token(idrestaurant) >= token(40374415) AND score > 30 LIMIT 100 ALLOW FILTERING; token -5110984544666748283 (see tombstone_warn_threshold)

Read 1851 live rows and 1238 tombstone cells for query SELECT score FROM resto_ny.inspection WHERE token(idrestaurant) >= token(41163361) AND score > 30 LIMIT 100 ALLOW FILTERING; token -4887919724939209625 (see tombstone_warn_threshold)

Read 1702 live rows and 1194 tombstone cells for query SELECT score FROM resto_ny.inspection WHERE token(idrestaurant) >= token(50039510) AND score > 30 LIMIT 100 ALLOW FILTERING; token -4648852378126080587 (see tombstone_warn_threshold)

Read 1960 live rows and 1276 tombstone cells for query SELECT score FROM resto_ny.inspection WHERE token(idrestaurant) >= token(50035646) AND score > 30 LIMIT 100 ALLOW FILTERING; token -4395312937507507635 (see tombstone_warn_threshold)

Read 1814 live rows and 1225 tombstone cells for query SELECT score FROM resto_ny.inspection WHERE token(idrestaurant) >= token(41276545) AND score > 30 LIMIT 100 ALLOW FILTERING; token -4169543331923492638 (see tombstone_warn_threshold)

Read 1748 live rows and 1210 tombstone cells for query SELECT score FROM resto_ny.inspection WHERE token(idrestaurant) >= token(41704391) AND score > 30 LIMIT 100 ALLOW FILTERING; token -3756641592414738413 (see tombstone_warn_threshold)

Read 1714 live rows and 1122 tombstone cells for query SELECT score FROM resto_ny.inspection WHERE token(idrestaurant) >= token(40604769) AND score > 30 LIMIT 100 ALLOW FILTERING; token -3523928397587056195 (see tombstone_warn_threshold)

Read 1770 live rows and 1271 tombstone cells for query SELECT score FROM resto_ny.inspection WHERE token(idrestaurant) >= token(41592029) AND score > 30 LIMIT 100 ALLOW FILTERING; token -3320077971853953864 (see tombstone_warn_threshold)

Read 1521 live rows and 1122 tombstone cells for query SELECT score FROM resto_ny.inspection WHERE token(idrestaurant) >= token(50052660) AND score > 30 LIMIT 100 ALLOW FILTERING; token -2970866984464885705 (see tombstone_warn_threshold)

Read 2033 live rows and 1396 tombstone cells for query SELECT score FROM resto_ny.inspection WHERE token(idrestaurant) >= token(50000198) AND score > 30 LIMIT 100 ALLOW FILTERING; token -2717965985992624140 (see tombstone_warn_threshold)

Read 1433 live rows and 1082 tombstone cells for query SELECT score FROM resto_ny.inspection WHERE token(idrestaurant) >= token(50001480) AND score > 30 LIMIT 100 ALLOW FILTERING; token -2548059391886746247 (see tombstone_warn_threshold)

Read 1652 live rows and 1098 tombstone cells for query SELECT score FROM resto_ny.inspection WHERE token(idrestaurant) >= token(41542069) AND score > 30 LIMIT 100 ALLOW FILTERING; token -2360052078449045358 (see tombstone_warn_threshold)

Read 1521 live rows and 1030 tombstone cells for query SELECT score FROM resto_ny.inspection WHERE token(idrestaurant) >= token(50034994) AND score > 30 LIMIT 100 ALLOW FILTERING; token -2177186863961630774 (see tombstone_warn_threshold)

Read 1566 live rows and 1133 tombstone cells for query SELECT score FROM resto_ny.inspection WHERE token(idrestaurant) >= token(41253988) AND score > 30 LIMIT 100 ALLOW FILTERING; token -1980086056540075932 (see tombstone_warn_threshold)

Read 1784 live rows and 1203 tombstone cells for query SELECT score FROM resto_ny.inspection WHERE token(idrestaurant) >= token(50015953) AND score > 30 LIMIT 100 ALLOW FILTERING; token -1776571828733033484 (see tombstone_warn_threshold)

Read 1603 live rows and 1155 tombstone cells for query SELECT score FROM resto_ny.inspection WHERE token(idrestaurant) >= token(40383281) AND score > 30 LIMIT 100 ALLOW FILTERING; token -1563142434179860382 (see tombstone_warn_threshold)

Read 1529 live rows and 1063 tombstone cells for query SELECT score FROM resto_ny.inspection WHERE token(idrestaurant) >= token(40362715) AND score > 30 LIMIT 100 ALLOW FILTERING; token -1193966357606812008 (see tombstone_warn_threshold)

Read 2011 live rows and 1323 tombstone cells for query SELECT score FROM resto_ny.inspection WHERE token(idrestaurant) >= token(41389061) AND score > 30 LIMIT 100 ALLOW FILTERING; token -929043659315881810 (see tombstone_warn_threshold)

Read 1809 live rows and 1221 tombstone cells for query SELECT score FROM resto_ny.inspection WHERE token(idrestaurant) >= token(50004565) AND score > 30 LIMIT 100 ALLOW FILTERING; token -700640535230773872 (see tombstone_warn_threshold)

Read 1541 live rows and 1078 tombstone cells for query SELECT score FROM resto_ny.inspection WHERE token(idrestaurant) >= token(50016328) AND score > 30 LIMIT 100 ALLOW FILTERING; token -513707074341577459 (see tombstone_warn_threshold)

Read 1823 live rows and 1273 tombstone cells for query SELECT score FROM resto_ny.inspection WHERE token(idrestaurant) >= token(41579195) AND score > 30 LIMIT 100 ALLOW FILTERING; token -303582210317713632 (see tombstone_warn_threshold)

Read 1650 live rows and 1124 tombstone cells for query SELECT score FROM resto_ny.inspection WHERE token(idrestaurant) >= token(40363834) AND score > 30 LIMIT 100 ALLOW FILTERING; token -127026397007894576 (see tombstone_warn_threshold)

Read 1816 live rows and 1257 tombstone cells for query SELECT score FROM resto_ny.inspection WHERE token(idrestaurant) >= token(50003400) AND score > 30 LIMIT 100 ALLOW FILTERING; token 94544298865432992 (see tombstone_warn_threshold)

Read 1776 live rows and 1201 tombstone cells for query SELECT score FROM resto_ny.inspection WHERE token(idrestaurant) >= token(50018027) AND score > 30 LIMIT 100 ALLOW FILTERING; token 335295097490532048 (see tombstone_warn_threshold)

Read 2156 live rows and 1536 tombstone cells for query SELECT score FROM resto_ny.inspection WHERE token(idrestaurant) >= token(50005724) AND score > 30 LIMIT 100 ALLOW FILTERING; token 586906212180391074 (see tombstone_warn_threshold)

Read 1724 live rows and 1225 tombstone cells for query SELECT score FROM resto_ny.inspection WHERE token(idrestaurant) >= token(41630060) AND score > 30 LIMIT 100 ALLOW FILTERING; token 817671140765277548 (see tombstone_warn_threshold)

Read 2078 live rows and 1409 tombstone cells for query SELECT score FROM resto_ny.inspection WHERE token(idrestaurant) >= token(41224938) AND score > 30 LIMIT 100 ALLOW FILTERING; token 1266166379637567653 (see tombstone_warn_threshold)

Read 1991 live rows and 1407 tombstone cells for query SELECT score FROM resto_ny.inspection WHERE token(idrestaurant) >= token(41209002) AND score > 30 LIMIT 100 ALLOW FILTERING; token 1521086755988229966 (see tombstone_warn_threshold)

Read 1818 live rows and 1253 tombstone cells for query SELECT score FROM resto_ny.inspection WHERE token(idrestaurant) >= token(41429788) AND score > 30 LIMIT 100 ALLOW FILTERING; token 1747128266608527856 (see tombstone_warn_threshold)

Read 1940 live rows and 1434 tombstone cells for query SELECT score FROM resto_ny.inspection WHERE token(idrestaurant) >= token(40544044) AND score > 30 LIMIT 100 ALLOW FILTERING; token 1981286529867282422 (see tombstone_warn_threshold)

Read 1507 live rows and 1017 tombstone cells for query SELECT score FROM resto_ny.inspection WHERE token(idrestaurant) >= token(50011370) AND score > 30 LIMIT 100 ALLOW FILTERING; token 2164882739137228652 (see tombstone_warn_threshold)

Read 1742 live rows and 1250 tombstone cells for query SELECT score FROM resto_ny.inspection WHERE token(idrestaurant) >= token(41486944) AND score > 30 LIMIT 100 ALLOW FILTERING; token 2363293772103126592 (see tombstone_warn_threshold)

Read 2020 live rows and 1286 tombstone cells for query SELECT score FROM resto_ny.inspection WHERE token(idrestaurant) >= token(50001978) AND score > 30 LIMIT 100 ALLOW FILTERING; token 2592747456824638275 (see tombstone_warn_threshold)

Read 1707 live rows and 1173 tombstone cells for query SELECT score FROM resto_ny.inspection WHERE token(idrestaurant) >= token(41624716) AND score > 30 LIMIT 100 ALLOW FILTERING; token 2802569825627040159 (see tombstone_warn_threshold)

Read 1904 live rows and 1307 tombstone cells for query SELECT score FROM resto_ny.inspection WHERE token(idrestaurant) >= token(50045738) AND score > 30 LIMIT 100 ALLOW FILTERING; token 3049901107033644926 (see tombstone_warn_threshold)

Read 2006 live rows and 1355 tombstone cells for query SELECT score FROM resto_ny.inspection WHERE token(idrestaurant) >= token(41038585) AND score > 30 LIMIT 100 ALLOW FILTERING; token 3485648201936142562 (see tombstone_warn_threshold)

Read 1630 live rows and 1102 tombstone cells for query SELECT score FROM resto_ny.inspection WHERE token(idrestaurant) >= token(40900938) AND score > 30 LIMIT 100 ALLOW FILTERING; token 3677306117119391380 (see tombstone_warn_threshold)

Read 2076 live rows and 1412 tombstone cells for query SELECT score FROM resto_ny.inspection WHERE token(idrestaurant) >= token(41386827) AND score > 30 LIMIT 100 ALLOW FILTERING; token 3917191443378653424 (see tombstone_warn_threshold)

Read 1813 live rows and 1198 tombstone cells for query SELECT score FROM resto_ny.inspection WHERE token(idrestaurant) >= token(50014251) AND score > 30 LIMIT 100 ALLOW FILTERING; token 4141544321314479402 (see tombstone_warn_threshold)

Read 1960 live rows and 1400 tombstone cells for query SELECT score FROM resto_ny.inspection WHERE token(idrestaurant) >= token(50009899) AND score > 30 LIMIT 100 ALLOW FILTERING; token 4345688240560556414 (see tombstone_warn_threshold)

Read 1838 live rows and 1279 tombstone cells for query SELECT score FROM resto_ny.inspection WHERE token(idrestaurant) >= token(41371241) AND score > 30 LIMIT 100 ALLOW FILTERING; token 4558878922534312472 (see tombstone_warn_threshold)

Read 1813 live rows and 1245 tombstone cells for query SELECT score FROM resto_ny.inspection WHERE token(idrestaurant) >= token(41701903) AND score > 30 LIMIT 100 ALLOW FILTERING; token 4811718692626500359 (see tombstone_warn_threshold)

Read 1899 live rows and 1242 tombstone cells for query SELECT score FROM resto_ny.inspection WHERE token(idrestaurant) >= token(50001058) AND score > 30 LIMIT 100 ALLOW FILTERING; token 5041355346199775690 (see tombstone_warn_threshold)

Read 1692 live rows and 1211 tombstone cells for query SELECT score FROM resto_ny.inspection WHERE token(idrestaurant) >= token(40561040) AND score > 30 LIMIT 100 ALLOW FILTERING; token 5248579243291366969 (see tombstone_warn_threshold)

Read 1502 live rows and 1065 tombstone cells for query SELECT score FROM resto_ny.inspection WHERE token(idrestaurant) >= token(41366292) AND score > 30 LIMIT 100 ALLOW FILTERING; token 5444522485537356640 (see tombstone_warn_threshold)

Read 1897 live rows and 1224 tombstone cells for query SELECT score FROM resto_ny.inspection WHERE token(idrestaurant) >= token(41689018) AND score > 30 LIMIT 100 ALLOW FILTERING; token 5683869961545940043 (see tombstone_warn_threshold)

Read 2092 live rows and 1444 tombstone cells for query SELECT score FROM resto_ny.inspection WHERE token(idrestaurant) >= token(41163019) AND score > 30 LIMIT 100 ALLOW FILTERING; token 5956996101499370521 (see tombstone_warn_threshold)

Read 1536 live rows and 1016 tombstone cells for query SELECT score FROM resto_ny.inspection WHERE token(idrestaurant) >= token(41677816) AND score > 30 LIMIT 100 ALLOW FILTERING; token 6157276057837811681 (see tombstone_warn_threshold)

Read 2050 live rows and 1441 tombstone cells for query SELECT score FROM resto_ny.inspection WHERE token(idrestaurant) >= token(41714097) AND score > 30 LIMIT 100 ALLOW FILTERING; token 6412530244020976663 (see tombstone_warn_threshold)

Read 1590 live rows and 1109 tombstone cells for query SELECT score FROM resto_ny.inspection WHERE token(idrestaurant) >= token(41376871) AND score > 30 LIMIT 100 ALLOW FILTERING; token 6631702097019363508 (see tombstone_warn_threshold)

Read 1774 live rows and 1229 tombstone cells for query SELECT score FROM resto_ny.inspection WHERE token(idrestaurant) >= token(41710136) AND score > 30 LIMIT 100 ALLOW FILTERING; token 6853624071370207103 (see tombstone_warn_threshold)

Read 1916 live rows and 1374 tombstone cells for query SELECT score FROM resto_ny.inspection WHERE token(idrestaurant) >= token(50010805) AND score > 30 LIMIT 100 ALLOW FILTERING; token 7085636840272529616 (see tombstone_warn_threshold)

Read 1784 live rows and 1176 tombstone cells for query SELECT score FROM resto_ny.inspection WHERE token(idrestaurant) >= token(41130819) AND score > 30 LIMIT 100 ALLOW FILTERING; token 7301808020340537601 (see tombstone_warn_threshold)

Read 1779 live rows and 1213 tombstone cells for query SELECT score FROM resto_ny.inspection WHERE token(idrestaurant) >= token(50005852) AND score > 30 LIMIT 100 ALLOW FILTERING; token 7516590775299439648 (see tombstone_warn_threshold)

Read 1536 live rows and 1025 tombstone cells for query SELECT score FROM resto_ny.inspection WHERE token(idrestaurant) >= token(50001923) AND score > 30 LIMIT 100 ALLOW FILTERING; token 7688008565564184699 (see tombstone_warn_threshold)

Read 1533 live rows and 1044 tombstone cells for query SELECT score FROM resto_ny.inspection WHERE token(idrestaurant) >= token(41447792) AND score > 30 LIMIT 100 ALLOW FILTERING; token 7868157568907691658 (see tombstone_warn_threshold)

Read 1694 live rows and 1157 tombstone cells for query SELECT score FROM resto_ny.inspection WHERE token(idrestaurant) >= token(41230776) AND score > 30 LIMIT 100 ALLOW FILTERING; token 8095404755706562485 (see tombstone_warn_threshold)

Read 1629 live rows and 1159 tombstone cells for query SELECT score FROM resto_ny.inspection WHERE token(idrestaurant) >= token(41203533) AND score > 30 LIMIT 100 ALLOW FILTERING; token 8267899125743984545 (see tombstone_warn_threshold)

Read 1518 live rows and 1111 tombstone cells for query SELECT score FROM resto_ny.inspection WHERE token(idrestaurant) >= token(50002616) AND score > 30 LIMIT 100 ALLOW FILTERING; token 8451671287089402443 (see tombstone_warn_threshold)

Read 1593 live rows and 1118 tombstone cells for query SELECT score FROM resto_ny.inspection WHERE token(idrestaurant) >= token(41713624) AND score > 30 LIMIT 100 ALLOW FILTERING; token 8645678468591709993 (see tombstone_warn_threshold)

Read 1679 live rows and 1184 tombstone cells for query SELECT score FROM resto_ny.inspection WHERE token(idrestaurant) >= token(41706074) AND score > 30 LIMIT 100 ALLOW FILTERING; token 8852810324103723950 (see tombstone_warn_threshold)

Read 1697 live rows and 1180 tombstone cells for query SELECT score FROM resto_ny.inspection WHERE token(idrestaurant) >= token(41154580) AND score > 30 LIMIT 100 ALLOW FILTERING; token 9054280880587737577 (see tombstone_warn_threshold)

Read 1490 live rows and 1015 tombstone cells for query SELECT score FROM resto_ny.inspection WHERE token(idrestaurant) >= token(50012051) AND score > 30 LIMIT 100 ALLOW FILTERING; token 9222309874911565378 (see tombstone_warn_threshold)

cqlsh:resto_ny> SELECT score FROM Inspection
            ... WHERE score > 30 ALLOW FILTERING LIMIT 100;
SyntaxException: line 2:33 mismatched input 'LIMIT' expecting EOF (...score > 30 ALLOW FILTERING [LIMIT]...)
cqlsh:resto_ny> SELECT score FROM Inspection
            ... WHERE score > 30 ALLOW FILTERING LIMIT 100;
SyntaxException: line 2:33 mismatched input 'LIMIT' expecting EOF (...score > 30 ALLOW FILTERING [LIMIT]...)
cqlsh:resto_ny> SELECT score FROM Inspection
            ... WHERE score > 30
            ... LIMIT 100 ALLOW FILTERING;

 score
-------
    31
    54
    31
    43
    56
    51
    50
    40
    45
    36
    47
    44
    31
    37
    49
    50
    32
    54
    56
    32
    53
    50
    33
    74
    32
    42
    40
    48
    41
    33
    37
    31
    42
    32
    32
    40
    37
    38
    31
    48
    38
    33
    38
    34
    35
    42
    39
    49
    35
    35
    34
    35
    45
    45
    35
    32
    32
    38
    53
    59
    37
    34
    35
    31
    63
    35
    37
    36
    34
    31
    42
    40
    37
    43
    41
   103
    33
    43
    41
    31
    34
    53
    49
    34
    33
    37
    32
    82
    47
    61
    38
    56
    63
    88
    40
    33
    35
    33
    36
    35

(100 rows)

Warnings :
Read 1651 live rows and 1130 tombstone cells for query SELECT score FROM resto_ny.inspection WHERE score > 30 LIMIT 100 ALLOW FILTERING; token -9013105958081990342 (see tombstone_warn_threshold)

cqlsh:resto_ny> SELECT idRestaurant, count(*) AS inspection_count
            ... FROM Inspection
            ... GROUP BY idRestaurant
            ... ALLOW FILTERING
            ... LIMIT 10;
SyntaxException: line 5:0 mismatched input 'LIMIT' expecting EOF (...GROUP BY idRestaurantALLOW FILTERING[LIMIT]...)
cqlsh:resto_ny> SELECT count(*) FROM Inspection
            ... WHERE idRestaurant = 41569764;

 count
-------
     8

(1 rows)
cqlsh:resto_ny> COPY Restaurant TO '/tmp/restaurant_export.csv' WITH HEADER = true;
Using 3 child processes

Starting copy of resto_ny.restaurant with columns [id, borough, buildingnum, cuisinetype, name, phone, street, zipcode].
Processed: 25624 rows; Rate:   31469 rows/s; Avg. rate:   20309 rows/s
25624 rows exported to 1 files in 0 day, 0 hour, 0 minute, and 1.299 seconds.
cqlsh:resto_ny> COPY Inspection TO '/tmp/inspection_export.csv' WITH HEADER = true;
Using 3 child processes

Starting copy of resto_ny.inspection with columns [idrestaurant, inspectiondate, criticalflag, grade, score, violationcode, violationdescription].
Processed: 149818 rows; Rate:   33552 rows/s; Avg. rate:   26962 rows/s
149818 rows exported to 1 files in 0 day, 0 hour, 0 minute, and 5.571 seconds.
cqlsh:resto_ny> docker cp mon-cassandra:/tmp/restaurant_export.csv C:\Users\INFOLAB\Desktop\
Invalid syntax at char 54
  docker cp mon-cassandra:/tmp/restaurant_export.csv C:\Users\INFOLAB\Desktop\
                                                       ^
cqlsh:resto_ny> docker cp mon-cassandra:/tmp/inspection_export.csv C:\Users\INFOLAB\Desktop\

































