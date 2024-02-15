Plan hash value: 1275645332
 
------------------------------------------------------------------------------------------------------------------------------------------
| Id  | Operation                                   | Name                       | Rows  | Bytes | Cost (%CPU)| Time     | Pstart| Pstop |
------------------------------------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT                            |                            |    77 | 71918 | 74976   (1)| 00:15:00 |       |       |
|   1 |  TABLE ACCESS BY INDEX ROWID                | CSTB_ADDL_TEXT             |     1 |    57 |     2   (0)| 00:00:01 |       |       |
|*  2 |   INDEX UNIQUE SCAN                         | PK01_CSTB_ADDL_TEXT        |     1 |       |     2   (0)| 00:00:01 |       |       |
|   3 |   PARTITION HASH SINGLE                     |                            |     1 |    38 |     2   (0)| 00:00:01 |   KEY |   KEY |
|   4 |    TABLE ACCESS BY LOCAL INDEX ROWID        | DETB_RTL_TELLER            |     1 |    38 |     2   (0)| 00:00:01 |   KEY |   KEY |
|*  5 |     INDEX UNIQUE SCAN                       | UI01_DETB_RTL_TELLER       |     1 |       |     1   (0)| 00:00:01 |   KEY |   KEY |
|   6 |     TABLE ACCESS BY INDEX ROWID             | DETB_JRNL_TXN_DETAIL       |     1 |    59 |     2   (0)| 00:00:01 |       |       |
|*  7 |      INDEX UNIQUE SCAN                      | PK_DETB_JRNL_TXN_DETAIL    |     1 |       |     2   (0)| 00:00:01 |       |       |
|   8 |      TABLE ACCESS BY INDEX ROWID            | SITB_CONTRACT_MASTER       |     1 |    55 |     2   (0)| 00:00:01 |       |       |
|*  9 |       INDEX RANGE SCAN                      | XXI_SITB_CONTRACT_MASTER   |     1 |       |     2   (0)| 00:00:01 |       |       |
|  10 |        SORT AGGREGATE                       |                            |     1 |    21 |            |          |       |       |
|  11 |         FIRST ROW                           |                            |     1 |    21 |     2   (0)| 00:00:01 |       |       |
|* 12 |          INDEX RANGE SCAN (MIN/MAX)         | XXI_SITB_CONTRACT_MASTER   |     1 |    21 |     2   (0)| 00:00:01 |       |       |
|  13 |       HASH GROUP BY                         |                            |     1 |   355 |    14  (22)| 00:00:01 |       |       |
|* 14 |        FILTER                               |                            |       |       |            |          |       |       |
|* 15 |         HASH JOIN OUTER                     |                            |     1 |   355 |    13  (16)| 00:00:01 |       |       |
|  16 |          NESTED LOOPS OUTER                 |                            |     1 |   214 |     7  (15)| 00:00:01 |       |       |
|  17 |           TABLE ACCESS BY INDEX ROWID       | CSTB_CONTRACT              |     1 |    31 |     2   (0)| 00:00:01 |       |       |
|* 18 |            INDEX UNIQUE SCAN                | PK01_CSTB_CONTRACT         |     1 |       |     1   (0)| 00:00:01 |       |       |
|* 19 |           VIEW                              |                            |     1 |   183 |     6  (17)| 00:00:01 |       |       |
|* 20 |            FILTER                           |                            |       |       |            |          |       |       |
|  21 |             SORT GROUP BY                   |                            |     1 |   194 |     6  (17)| 00:00:01 |       |       |
|  22 |              NESTED LOOPS                   |                            |     1 |   194 |     5   (0)| 00:00:01 |       |       |
|  23 |               NESTED LOOPS                  |                            |     1 |   194 |     5   (0)| 00:00:01 |       |       |
|  24 |                NESTED LOOPS                 |                            |     1 |   174 |     4   (0)| 00:00:01 |       |       |
|  25 |                 NESTED LOOPS                |                            |     1 |   109 |     3   (0)| 00:00:01 |       |       |
|  26 |                  TABLE ACCESS BY INDEX ROWID| LCTB_PARTIES               |     1 |    65 |     2   (0)| 00:00:01 |       |       |
|* 27 |                   INDEX RANGE SCAN          | IND_PART_LANG              |     1 |       |     1   (0)| 00:00:01 |       |       |
|  28 |                  TABLE ACCESS BY INDEX ROWID| LCTB_CONTRACT_MASTER       |     1 |    44 |     1   (0)| 00:00:01 |       |       |
|* 29 |                   INDEX UNIQUE SCAN         | PK01_LCTB_CONTRACT_MASTER  |     1 |       |     1   (0)| 00:00:01 |       |       |
|  30 |                 TABLE ACCESS BY INDEX ROWID | LCTB_PARTIES               |     1 |    65 |     1   (0)| 00:00:01 |       |       |
|* 31 |                  INDEX RANGE SCAN           | IND_PART_LANG              |     1 |       |     1   (0)| 00:00:01 |       |       |
|* 32 |                INDEX RANGE SCAN             | PK01_LCTB_CONTRACT_MASTER  |     1 |       |     1   (0)| 00:00:01 |       |       |
|  33 |               TABLE ACCESS BY INDEX ROWID   | LCTB_CONTRACT_MASTER       |     1 |    20 |     1   (0)| 00:00:01 |       |       |
|  34 |          VIEW                               |                            |     1 |   141 |     6  (17)| 00:00:01 |       |       |
|* 35 |           FILTER                            |                            |       |       |            |          |       |       |
|  36 |            SORT GROUP BY                    |                            |     1 |   201 |     6  (17)| 00:00:01 |       |       |
|  37 |             NESTED LOOPS                    |                            |     1 |   201 |     5   (0)| 00:00:01 |       |       |
|  38 |              NESTED LOOPS                   |                            |     1 |   201 |     5   (0)| 00:00:01 |       |       |
|  39 |               NESTED LOOPS                  |                            |     1 |   181 |     4   (0)| 00:00:01 |       |       |
|  40 |                NESTED LOOPS                 |                            |     1 |   112 |     3   (0)| 00:00:01 |       |       |
|  41 |                 TABLE ACCESS BY INDEX ROWID | BCTB_CONTRACT_PARTIES      |     1 |    69 |     2   (0)| 00:00:01 |       |       |
|* 42 |                  INDEX RANGE SCAN           | PK01_BCTB_CONTRACT_PARTIES |     1 |       |     1   (0)| 00:00:01 |       |       |
|  43 |                 TABLE ACCESS BY INDEX ROWID | BCTB_CONTRACT_MASTER       |     1 |    43 |     1   (0)| 00:00:01 |       |       |
|* 44 |                  INDEX UNIQUE SCAN          | PK01_BCTB_CONTRACT_MASTER  |     1 |       |     1   (0)| 00:00:01 |       |       |
|  45 |                TABLE ACCESS BY INDEX ROWID  | BCTB_CONTRACT_PARTIES      |     1 |    69 |     1   (0)| 00:00:01 |       |       |
|* 46 |                 INDEX UNIQUE SCAN           | PK01_BCTB_CONTRACT_PARTIES |     1 |       |     1   (0)| 00:00:01 |       |       |
|* 47 |               INDEX RANGE SCAN              | PK01_BCTB_CONTRACT_MASTER  |     1 |       |     1   (0)| 00:00:01 |       |       |
|  48 |              TABLE ACCESS BY INDEX ROWID    | BCTB_CONTRACT_MASTER       |     1 |    20 |     1   (0)| 00:00:01 |       |       |
|* 49 |  VIEW                                       |                            |    77 | 71918 | 74976   (1)| 00:15:00 |       |       |
|  50 |   WINDOW SORT                               |                            |    77 | 16555 | 74976   (1)| 00:15:00 |       |       |
|  51 |    NESTED LOOPS                             |                            |    77 | 16555 | 74975   (1)| 00:15:00 |       |       |
|  52 |     NESTED LOOPS                            |                            |    77 | 16555 | 74975   (1)| 00:15:00 |       |       |
|  53 |      NESTED LOOPS OUTER                     |                            |    77 | 14399 | 74936   (1)| 00:15:00 |       |       |
|  54 |       NESTED LOOPS OUTER                    |                            |    77 | 12474 | 74898   (1)| 00:14:59 |       |       |
|* 55 |        HASH JOIN ANTI NA                    |                            |    77 | 10087 | 74878   (1)| 00:14:59 |       |       |
|* 56 |         HASH JOIN                           |                            |    91 |  9555 | 41712   (1)| 00:08:21 |       |       |
|  57 |          INLIST ITERATOR                    |                            |       |       |            |          |       |       |
|  58 |           TABLE ACCESS BY INDEX ROWID       | STTM_TRN_CODE              |     2 |    54 |     2   (0)| 00:00:01 |       |       |
|* 59 |            INDEX UNIQUE SCAN                | PK01_STTM_TRN_CODE         |     2 |       |     1   (0)| 00:00:01 |       |       |
|  60 |          PARTITION LIST ALL                 |                            |  9653 |   735K| 41710   (1)| 00:08:21 |     1 |   564 |
|* 61 |           TABLE ACCESS BY LOCAL INDEX ROWID | ACTB_DAILY_LOG             |  9653 |   735K| 41710   (1)| 00:08:21 |     1 |   564 |
|* 62 |            INDEX SKIP SCAN                  | IX08_ACTB_DAILY_LOG        |  1028K|       |  6274   (1)| 00:01:16 |     1 |   564 |
|  63 |         PARTITION LIST ALL                  |                            |  1485 | 38610 | 33166   (1)| 00:06:38 |     1 |   564 |
|* 64 |          TABLE ACCESS BY LOCAL INDEX ROWID  | ACTB_DAILY_LOG             |  1485 | 38610 | 33166   (1)| 00:06:38 |     1 |   564 |
|* 65 |           INDEX SKIP SCAN                   | X005_ACTB_DAILY_LOG        |   158K|       | 15827   (1)| 00:03:10 |     1 |   564 |
|  66 |        PARTITION LIST ITERATOR              |                            |     1 |    31 |     1   (0)| 00:00:01 |   KEY |   KEY |
|* 67 |         INDEX RANGE SCAN                    | XX_APP_MASTER              |     1 |    31 |     1   (0)| 00:00:01 |   KEY |   KEY |
|  68 |       TABLE ACCESS BY GLOBAL INDEX ROWID    | STTM_CUSTOMER              |     1 |    25 |     1   (0)| 00:00:01 | ROWID | ROWID |
|* 69 |        INDEX UNIQUE SCAN                    | PK01_STTM_CUSTOMER         |     1 |       |     1   (0)| 00:00:01 |       |       |
|* 70 |      INDEX UNIQUE SCAN                      | UI06_STTM_CUST_ACCOUNT     |     1 |       |     1   (0)| 00:00:01 |       |       |
|  71 |     TABLE ACCESS BY GLOBAL INDEX ROWID      | STTM_CUST_ACCOUNT          |     1 |    28 |     1   (0)| 00:00:01 | ROWID | ROWID |
------------------------------------------------------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - access("EVNT_SEQ_NO"=:B1 AND "REFERENCE_NO"=:B2)
   5 - access("TRN_REF_NO"=:B1)
   7 - access("REFERENCE_NO"=:B1 AND "SERIAL_NO"=:B2)
   9 - access("CONTRACT_REF_NO"=:B1 AND "VERSION_NO"= (SELECT MAX("VERSION_NO") FROM "FCC114"."SITB_CONTRACT_MASTER" 
              "SITB_CONTRACT_MASTER" WHERE "CONTRACT_REF_NO"=:B2))
  12 - access("CONTRACT_REF_NO"=:B1)
  14 - filter(:B1='N')
  15 - access("S"."CONTRACT_REF_NO"="U"."BCREFNO"(+))
  18 - access("S"."CONTRACT_REF_NO"=:B1)
  19 - filter("S"."CONTRACT_REF_NO"="T"."CONTRACT_REF_NO"(+))
  20 - filter("A"."VERSION_NO"=MAX("VERSION_NO"))
  27 - access("PARTY_TYPE"='APP' AND "CONTRACT_REF_NO"=:B1)
  29 - access("A"."CONTRACT_REF_NO"=:B1 AND "A"."EVENT_SEQ_NO"="EVENT_SEQ_NO")
       filter("A"."CONTRACT_REF_NO"="CONTRACT_REF_NO")
  31 - access("PARTY_TYPE"='BEN' AND "CONTRACT_REF_NO"=:B1 AND "A"."EVENT_SEQ_NO"="EVENT_SEQ_NO")
       filter("A"."CONTRACT_REF_NO"="CONTRACT_REF_NO")
  32 - access("CONTRACT_REF_NO"=:B1)
       filter("CONTRACT_REF_NO"="A"."CONTRACT_REF_NO")
  35 - filter("D"."VERSION_NO"=MAX("VERSION_NO"))
  42 - access("BCREFNO"=:B1 AND "PARTY_TYPE"='DRAWEE')
       filter("PARTY_TYPE"='DRAWEE')
  44 - access("D"."BCREFNO"=:B1 AND "D"."EVENT_SEQ_NO"="EVENT_SEQ_NO")
       filter("D"."BCREFNO"="BCREFNO")
  46 - access("BCREFNO"=:B1 AND "D"."EVENT_SEQ_NO"="EVENT_SEQ_NO" AND "PARTY_TYPE"='DRAWER')
       filter("D"."BCREFNO"="BCREFNO")
  47 - access("BCREFNO"=:B1)
       filter("BCREFNO"="D"."BCREFNO")
  49 - filter(TO_CHAR(INTERNAL_FUNCTION("PRG"."TXN_DT_TIME"),'YYYYMMDD')=TO_CHAR(CURRENT_DATE-1,'YYYYMMDD') AND 
              TO_CHAR(INTERNAL_FUNCTION("PRG"."TXN_DT_TIME"),'HH24')>='21')
  55 - access("A"."TRN_REF_NO"="TRN_REF_NO")
  56 - access("A"."TRN_CODE"="S"."TRN_CODE")
  59 - access("S"."TRN_CODE"='445' OR "S"."TRN_CODE"='446')
  61 - filter("A"."TRN_CODE"='445' OR "A"."TRN_CODE"='446')
  62 - access("A"."CUST_GL"='A')
       filter("A"."CUST_GL"='A')
  64 - filter("TRN_CODE"='445' OR "TRN_CODE"='446')
  65 - access("EVENT"='REVR')
       filter("EVENT"='REVR')
  67 - access("A"."AC_BRANCH"="X"."BRANCH_CODE"(+) AND "A"."RELATED_ACCOUNT"="X"."ACCOUNT_NUMBER"(+))
  69 - access("X"."CUSTOMER_ID"="Y"."CUSTOMER_NO"(+))
  70 - access("A"."AC_NO"="B"."CUST_AC_NO")
