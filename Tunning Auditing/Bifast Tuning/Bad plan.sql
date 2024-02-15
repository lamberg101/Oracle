Plan hash value: 22757531
--------------------------------------------------------------------------------------------------------------------------------------------------
| Id  | Operation                                   | Name                       | Rows  | Bytes |TempSpc| Cost (%CPU)| Time     | Pstart| Pstop |
--------------------------------------------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT                            |                            |  6602 |  6021K|       |    58M  (2)|193:57:09 |       |       |
|   1 |  TABLE ACCESS BY INDEX ROWID                | CSTB_ADDL_TEXT             |     1 |    57 |       |     2   (0)| 00:00:01 |       |       |
|*  2 |   INDEX UNIQUE SCAN                         | PK01_CSTB_ADDL_TEXT        |     1 |       |       |     2   (0)| 00:00:01 |       |       |
|   3 |   PARTITION HASH SINGLE                     |                            |     1 |    38 |       |     2   (0)| 00:00:01 |   KEY |   KEY |
|   4 |    TABLE ACCESS BY LOCAL INDEX ROWID        | DETB_RTL_TELLER            |     1 |    38 |       |     2   (0)| 00:00:01 |   KEY |   KEY |
|*  5 |     INDEX UNIQUE SCAN                       | UI01_DETB_RTL_TELLER       |     1 |       |       |     1   (0)| 00:00:01 |   KEY |   KEY |
|   6 |     TABLE ACCESS BY INDEX ROWID             | DETB_JRNL_TXN_DETAIL       |     1 |    59 |       |     2   (0)| 00:00:01 |       |       |
|*  7 |      INDEX UNIQUE SCAN                      | PK_DETB_JRNL_TXN_DETAIL    |     1 |       |       |     2   (0)| 00:00:01 |       |       |
|   8 |      TABLE ACCESS BY INDEX ROWID            | SITB_CONTRACT_MASTER       |     1 |    55 |       |     2   (0)| 00:00:01 |       |       |
|*  9 |       INDEX RANGE SCAN                      | XXI_SITB_CONTRACT_MASTER   |     1 |       |       |     2   (0)| 00:00:01 |       |       |
|  10 |        SORT AGGREGATE                       |                            |     1 |    21 |       |            |          |       |       |
|  11 |         FIRST ROW                           |                            |     1 |    21 |       |     2   (0)| 00:00:01 |       |       |
|* 12 |          INDEX RANGE SCAN (MIN/MAX)         | XXI_SITB_CONTRACT_MASTER   |     1 |    21 |       |     2   (0)| 00:00:01 |       |       |
|  13 |       HASH GROUP BY                         |                            |     1 |   355 |       |    14  (22)| 00:00:01 |       |       |
|* 14 |        FILTER                               |                            |       |       |       |            |          |       |       |
|* 15 |         HASH JOIN OUTER                     |                            |     1 |   355 |       |    13  (16)| 00:00:01 |       |       |
|  16 |          NESTED LOOPS OUTER                 |                            |     1 |   214 |       |     7  (15)| 00:00:01 |       |       |
|  17 |           TABLE ACCESS BY INDEX ROWID       | CSTB_CONTRACT              |     1 |    31 |       |     2   (0)| 00:00:01 |       |       |
|* 18 |            INDEX UNIQUE SCAN                | PK01_CSTB_CONTRACT         |     1 |       |       |     1   (0)| 00:00:01 |       |       |
|* 19 |           VIEW                              |                            |     1 |   183 |       |     6  (17)| 00:00:01 |       |       |
|* 20 |            FILTER                           |                            |       |       |       |            |          |       |       |
|  21 |             SORT GROUP BY                   |                            |     1 |   194 |       |     6  (17)| 00:00:01 |       |       |
|  22 |              NESTED LOOPS                   |                            |     1 |   194 |       |     5   (0)| 00:00:01 |       |       |
|  23 |               NESTED LOOPS                  |                            |     1 |   194 |       |     5   (0)| 00:00:01 |       |       |
|  24 |                NESTED LOOPS                 |                            |     1 |   174 |       |     4   (0)| 00:00:01 |       |       |
|  25 |                 NESTED LOOPS                |                            |     1 |   109 |       |     3   (0)| 00:00:01 |       |       |
|  26 |                  TABLE ACCESS BY INDEX ROWID| LCTB_PARTIES               |     1 |    65 |       |     2   (0)| 00:00:01 |       |       |
|* 27 |                   INDEX RANGE SCAN          | IND_PART_LANG              |     1 |       |       |     1   (0)| 00:00:01 |       |       |
|  28 |                  TABLE ACCESS BY INDEX ROWID| LCTB_CONTRACT_MASTER       |     1 |    44 |       |     1   (0)| 00:00:01 |       |       |
|* 29 |                   INDEX UNIQUE SCAN         | PK01_LCTB_CONTRACT_MASTER  |     1 |       |       |     1   (0)| 00:00:01 |       |       |
|  30 |                 TABLE ACCESS BY INDEX ROWID | LCTB_PARTIES               |     1 |    65 |       |     1   (0)| 00:00:01 |       |       |
|* 31 |                  INDEX RANGE SCAN           | IND_PART_LANG              |     1 |       |       |     1   (0)| 00:00:01 |       |       |
|* 32 |                INDEX RANGE SCAN             | PK01_LCTB_CONTRACT_MASTER  |     1 |       |       |     1   (0)| 00:00:01 |       |       |
|  33 |               TABLE ACCESS BY INDEX ROWID   | LCTB_CONTRACT_MASTER       |     1 |    20 |       |     1   (0)| 00:00:01 |       |       |
|  34 |          VIEW                               |                            |     1 |   141 |       |     6  (17)| 00:00:01 |       |       |
|* 35 |           FILTER                            |                            |       |       |       |            |          |       |       |
|  36 |            SORT GROUP BY                    |                            |     1 |   201 |       |     6  (17)| 00:00:01 |       |       |
|  37 |             NESTED LOOPS                    |                            |     1 |   201 |       |     5   (0)| 00:00:01 |       |       |
|  38 |              NESTED LOOPS                   |                            |     1 |   201 |       |     5   (0)| 00:00:01 |       |       |
|  39 |               NESTED LOOPS                  |                            |     1 |   181 |       |     4   (0)| 00:00:01 |       |       |
|  40 |                NESTED LOOPS                 |                            |     1 |   112 |       |     3   (0)| 00:00:01 |       |       |
|  41 |                 TABLE ACCESS BY INDEX ROWID | BCTB_CONTRACT_PARTIES      |     1 |    69 |       |     2   (0)| 00:00:01 |       |       |
|* 42 |                  INDEX RANGE SCAN           | PK01_BCTB_CONTRACT_PARTIES |     1 |       |       |     1   (0)| 00:00:01 |       |       |
|  43 |                 TABLE ACCESS BY INDEX ROWID | BCTB_CONTRACT_MASTER       |     1 |    43 |       |     1   (0)| 00:00:01 |       |       |
|* 44 |                  INDEX UNIQUE SCAN          | PK01_BCTB_CONTRACT_MASTER  |     1 |       |       |     1   (0)| 00:00:01 |       |       |
|  45 |                TABLE ACCESS BY INDEX ROWID  | BCTB_CONTRACT_PARTIES      |     1 |    69 |       |     1   (0)| 00:00:01 |       |       |
|* 46 |                 INDEX UNIQUE SCAN           | PK01_BCTB_CONTRACT_PARTIES |     1 |       |       |     1   (0)| 00:00:01 |       |       |
|* 47 |               INDEX RANGE SCAN              | PK01_BCTB_CONTRACT_MASTER  |     1 |       |       |     1   (0)| 00:00:01 |       |       |
|  48 |              TABLE ACCESS BY INDEX ROWID    | BCTB_CONTRACT_MASTER       |     1 |    20 |       |     1   (0)| 00:00:01 |       |       |
|* 49 |  VIEW                                       |                            |  6602 |  6021K|       |    58M  (2)|193:57:09 |       |       |
|  50 |   WINDOW SORT                               |                            |  6602 |  1392K|  1480K|    58M  (2)|193:57:09 |       |       |
|  51 |    NESTED LOOPS                             |                            |  6602 |  1392K|       |    58M  (2)|193:57:06 |       |       |
|  52 |     NESTED LOOPS                            |                            |  6602 |  1392K|       |    58M  (2)|193:57:06 |       |       |
|  53 |      NESTED LOOPS OUTER                     |                            |  6602 |  1212K|       |    58M  (2)|193:56:26 |       |       |
|* 54 |       HASH JOIN OUTER                       |                            |  6602 |  1050K|       |    58M  (2)|193:55:46 |       |       |
|* 55 |        HASH JOIN ANTI NA                    |                            |  6602 |   851K|       |    58M  (2)|193:55:34 |       |       |
|* 56 |         HASH JOIN                           |                            |  6818 |   705K|       |    29M  (2)| 97:14:36 |       |       |
|  57 |          INLIST ITERATOR                    |                            |       |       |       |            |          |       |       |
|  58 |           TABLE ACCESS BY INDEX ROWID       | STTM_TRN_CODE              |     2 |    54 |       |     2   (0)| 00:00:01 |       |       |
|* 59 |            INDEX UNIQUE SCAN                | PK01_STTM_TRN_CODE         |     2 |       |       |     1   (0)| 00:00:01 |       |       |
|  60 |          PARTITION LIST ALL                 |                            |  3439K|   259M|       |    29M  (2)| 97:14:36 |     1 |   564 |
|* 61 |           TABLE ACCESS FULL                 | ACTB_HISTORY               |  3439K|   259M|       |    29M  (2)| 97:14:36 |     1 |   564 |
|  62 |         PARTITION LIST ALL                  |                            |   109K|  2772K|       |    29M  (1)| 96:40:58 |     1 |   564 |
|* 63 |          TABLE ACCESS FULL                  | ACTB_HISTORY               |   109K|  2772K|       |    29M  (1)| 96:40:58 |     1 |   564 |
|  64 |        PARTITION LIST ALL                   |                            |   291K|  8834K|       |  1008   (1)| 00:00:13 |     1 |   564 |
|  65 |         INDEX FAST FULL SCAN                | XX_APP_MASTER              |   291K|  8834K|       |  1008   (1)| 00:00:13 |     1 |   564 |
|  66 |       TABLE ACCESS BY GLOBAL INDEX ROWID    | STTM_CUSTOMER              |     1 |    25 |       |     1   (0)| 00:00:01 | ROWID | ROWID |
|* 67 |        INDEX UNIQUE SCAN                    | PK01_STTM_CUSTOMER         |     1 |       |       |     1   (0)| 00:00:01 |       |       |
|* 68 |      INDEX UNIQUE SCAN                      | UI06_STTM_CUST_ACCOUNT     |     1 |       |       |     1   (0)| 00:00:01 |       |       |
|  69 |     TABLE ACCESS BY GLOBAL INDEX ROWID      | STTM_CUST_ACCOUNT          |     1 |    28 |       |     1   (0)| 00:00:01 | ROWID | ROWID |
--------------------------------------------------------------------------------------------------------------------------------------------------
 
Query Block Name / Object Alias (identified by operation id):
-------------------------------------------------------------
 
   1 - SEL$3        / CSTBS_ADDL_TEXT@SEL$3
   2 - SEL$3        / CSTBS_ADDL_TEXT@SEL$3
   3 - SEL$4       
   4 - SEL$4        / DETB_RTL_TELLER@SEL$4
   5 - SEL$4        / DETB_RTL_TELLER@SEL$4
   6 - SEL$5        / DETB_JRNL_TXN_DETAIL@SEL$5
   7 - SEL$5        / DETB_JRNL_TXN_DETAIL@SEL$5
   8 - SEL$6        / SITB_CONTRACT_MASTER@SEL$6
   9 - SEL$6        / SITB_CONTRACT_MASTER@SEL$6
  10 - SEL$7       
  12 - SEL$7        / SITB_CONTRACT_MASTER@SEL$7
  13 - SEL$8       
  17 - SEL$8        / S@SEL$8
  18 - SEL$8        / S@SEL$8
  19 - SEL$187F3A83 / T@SEL$8
  20 - SEL$187F3A83
  26 - SEL$187F3A83 / LCTB_PARTIES@SEL$10
  27 - SEL$187F3A83 / LCTB_PARTIES@SEL$10
  28 - SEL$187F3A83 / A@SEL$9
  29 - SEL$187F3A83 / A@SEL$9
  30 - SEL$187F3A83 / LCTB_PARTIES@SEL$11
  31 - SEL$187F3A83 / LCTB_PARTIES@SEL$11
  32 - SEL$187F3A83 / LCTBS_CONTRACT_MASTER@SEL$12
  33 - SEL$187F3A83 / LCTBS_CONTRACT_MASTER@SEL$12
  34 - SEL$290D7DBA / U@SEL$8
  35 - SEL$290D7DBA
  41 - SEL$290D7DBA / BCTB_CONTRACT_PARTIES@SEL$14
  42 - SEL$290D7DBA / BCTB_CONTRACT_PARTIES@SEL$14
  43 - SEL$290D7DBA / D@SEL$13
  44 - SEL$290D7DBA / D@SEL$13
  45 - SEL$290D7DBA / BCTB_CONTRACT_PARTIES@SEL$15
  46 - SEL$290D7DBA / BCTB_CONTRACT_PARTIES@SEL$15
  47 - SEL$290D7DBA / BCTB_CONTRACT_MASTER@SEL$16
  48 - SEL$290D7DBA / BCTB_CONTRACT_MASTER@SEL$16
  49 - SEL$9AFAFE26 / PRG@SEL$1
  50 - SEL$9AFAFE26
  58 - SEL$9AFAFE26 / S@SEL$2
  59 - SEL$9AFAFE26 / S@SEL$2
  61 - SEL$9AFAFE26 / A@SEL$2
  63 - SEL$9AFAFE26 / ACTB_HISTORY@SEL$17
  65 - SEL$9AFAFE26 / X@SEL$2
  66 - SEL$9AFAFE26 / Y@SEL$2
  67 - SEL$9AFAFE26 / Y@SEL$2
  68 - SEL$9AFAFE26 / B@SEL$2
  69 - SEL$9AFAFE26 / B@SEL$2
 
Outline Data
-------------
 
  /*+
      BEGIN_OUTLINE_DATA
      NLJ_BATCHING(@"SEL$290D7DBA" "BCTB_CONTRACT_MASTER"@"SEL$16")
      USE_NL(@"SEL$290D7DBA" "BCTB_CONTRACT_MASTER"@"SEL$16")
      USE_NL(@"SEL$290D7DBA" "BCTB_CONTRACT_PARTIES"@"SEL$15")
      USE_NL(@"SEL$290D7DBA" "D"@"SEL$13")
      LEADING(@"SEL$290D7DBA" "BCTB_CONTRACT_PARTIES"@"SEL$14" "D"@"SEL$13" "BCTB_CONTRACT_PARTIES"@"SEL$15" "BCTB_CONTRACT_MASTER"@"SEL$16")
      INDEX(@"SEL$290D7DBA" "BCTB_CONTRACT_MASTER"@"SEL$16" ("BCTB_CONTRACT_MASTER"."BCREFNO" "BCTB_CONTRACT_MASTER"."EVENT_SEQ_NO"))
      INDEX_RS_ASC(@"SEL$290D7DBA" "BCTB_CONTRACT_PARTIES"@"SEL$15" ("BCTB_CONTRACT_PARTIES"."BCREFNO" "BCTB_CONTRACT_PARTIES"."EVENT_SEQ_NO" 
              "BCTB_CONTRACT_PARTIES"."PARTY_TYPE"))
      INDEX_RS_ASC(@"SEL$290D7DBA" "D"@"SEL$13" ("BCTB_CONTRACT_MASTER"."BCREFNO" "BCTB_CONTRACT_MASTER"."EVENT_SEQ_NO"))
      INDEX_RS_ASC(@"SEL$290D7DBA" "BCTB_CONTRACT_PARTIES"@"SEL$14" ("BCTB_CONTRACT_PARTIES"."BCREFNO" "BCTB_CONTRACT_PARTIES"."EVENT_SEQ_NO" 
              "BCTB_CONTRACT_PARTIES"."PARTY_TYPE"))
      NLJ_BATCHING(@"SEL$187F3A83" "LCTBS_CONTRACT_MASTER"@"SEL$12")
      USE_NL(@"SEL$187F3A83" "LCTBS_CONTRACT_MASTER"@"SEL$12")
      USE_NL(@"SEL$187F3A83" "LCTB_PARTIES"@"SEL$11")
      USE_NL(@"SEL$187F3A83" "A"@"SEL$9")
      LEADING(@"SEL$187F3A83" "LCTB_PARTIES"@"SEL$10" "A"@"SEL$9" "LCTB_PARTIES"@"SEL$11" "LCTBS_CONTRACT_MASTER"@"SEL$12")
      INDEX(@"SEL$187F3A83" "LCTBS_CONTRACT_MASTER"@"SEL$12" ("LCTBS_CONTRACT_MASTER"."CONTRACT_REF_NO" "LCTBS_CONTRACT_MASTER"."EVENT_SEQ_NO"))
      INDEX_RS_ASC(@"SEL$187F3A83" "LCTB_PARTIES"@"SEL$11" ("LCTB_PARTIES"."PARTY_TYPE" "LCTB_PARTIES"."CONTRACT_REF_NO" 
              "LCTB_PARTIES"."EVENT_SEQ_NO"))
      INDEX_RS_ASC(@"SEL$187F3A83" "A"@"SEL$9" ("LCTBS_CONTRACT_MASTER"."CONTRACT_REF_NO" "LCTBS_CONTRACT_MASTER"."EVENT_SEQ_NO"))
      INDEX_RS_ASC(@"SEL$187F3A83" "LCTB_PARTIES"@"SEL$10" ("LCTB_PARTIES"."PARTY_TYPE" "LCTB_PARTIES"."CONTRACT_REF_NO" 
              "LCTB_PARTIES"."EVENT_SEQ_NO"))
      INDEX(@"SEL$7" "SITB_CONTRACT_MASTER"@"SEL$7" ("SITB_CONTRACT_MASTER"."CONTRACT_REF_NO" "SITB_CONTRACT_MASTER"."VERSION_NO"))
      INDEX_RS_ASC(@"SEL$3" "CSTBS_ADDL_TEXT"@"SEL$3" ("CSTBS_ADDL_TEXT"."EVNT_SEQ_NO" "CSTBS_ADDL_TEXT"."REFERENCE_NO"))
      INDEX_RS_ASC(@"SEL$4" "DETB_RTL_TELLER"@"SEL$4" ("DETB_RTL_TELLER"."TRN_REF_NO"))
      INDEX_RS_ASC(@"SEL$5" "DETB_JRNL_TXN_DETAIL"@"SEL$5" ("DETB_JRNL_TXN_DETAIL"."REFERENCE_NO" "DETB_JRNL_TXN_DETAIL"."SERIAL_NO"))
      PUSH_SUBQ(@"SEL$7")
      INDEX_RS_ASC(@"SEL$6" "SITB_CONTRACT_MASTER"@"SEL$6" ("SITB_CONTRACT_MASTER"."CONTRACT_REF_NO" "SITB_CONTRACT_MASTER"."VERSION_NO"))
      USE_HASH_AGGREGATION(@"SEL$8")
      USE_HASH(@"SEL$8" "U"@"SEL$8")
      USE_NL(@"SEL$8" "T"@"SEL$8")
      LEADING(@"SEL$8" "S"@"SEL$8" "T"@"SEL$8" "U"@"SEL$8")
      NO_ACCESS(@"SEL$8" "U"@"SEL$8")
      NO_ACCESS(@"SEL$8" "T"@"SEL$8")
      INDEX_RS_ASC(@"SEL$8" "S"@"SEL$8" ("CSTB_CONTRACT"."CONTRACT_REF_NO"))
      NLJ_BATCHING(@"SEL$9AFAFE26" "B"@"SEL$2")
      USE_NL(@"SEL$9AFAFE26" "B"@"SEL$2")
      USE_NL(@"SEL$9AFAFE26" "Y"@"SEL$2")
      USE_HASH(@"SEL$9AFAFE26" "X"@"SEL$2")
      USE_HASH(@"SEL$9AFAFE26" "ACTB_HISTORY"@"SEL$17")
      USE_HASH(@"SEL$9AFAFE26" "A"@"SEL$2")
      LEADING(@"SEL$9AFAFE26" "S"@"SEL$2" "A"@"SEL$2" "ACTB_HISTORY"@"SEL$17" "X"@"SEL$2" "Y"@"SEL$2" "B"@"SEL$2")
      INDEX(@"SEL$9AFAFE26" "B"@"SEL$2" ("STTM_CUST_ACCOUNT"."CUST_AC_NO"))
      INDEX_RS_ASC(@"SEL$9AFAFE26" "Y"@"SEL$2" ("STTM_CUSTOMER"."CUSTOMER_NO"))
      INDEX_FFS(@"SEL$9AFAFE26" "X"@"SEL$2" ("CLTB_ACCOUNT_APPS_MASTER"."BRANCH_CODE" "CLTB_ACCOUNT_APPS_MASTER"."ACCOUNT_NUMBER" 
              "CLTB_ACCOUNT_APPS_MASTER"."LOAN_TYPE" "CLTB_ACCOUNT_APPS_MASTER"."CUSTOMER_ID" "CLTB_ACCOUNT_APPS_MASTER"."ACCOUNT_STATUS" 
              "CLTB_ACCOUNT_APPS_MASTER"."AUTH_STAT"))
      FULL(@"SEL$9AFAFE26" "ACTB_HISTORY"@"SEL$17")
      FULL(@"SEL$9AFAFE26" "A"@"SEL$2")
      INDEX_RS_ASC(@"SEL$9AFAFE26" "S"@"SEL$2" ("STTMS_TRN_CODE"."TRN_CODE"))
      NO_ACCESS(@"SEL$1" "PRG"@"SEL$1")
      OUTLINE(@"SEL$15")
      OUTLINE(@"SEL$14")
      OUTLINE(@"SEL$13")
      OUTLINE(@"SEL$11")
      OUTLINE(@"SEL$10")
      OUTLINE(@"SEL$9")
      MERGE(@"SEL$15")
      MERGE(@"SEL$14")
      OUTLINE(@"SEL$19979EC1")
      MERGE(@"SEL$11")
      MERGE(@"SEL$10")
      OUTLINE(@"SEL$A5E413B3")
      OUTLINE(@"SEL$16")
      OUTLINE(@"SEL$C47FE401")
      OUTLINE(@"SEL$12")
      OUTLINE(@"SEL$AF463B2F")
      OUTLINE(@"SEL$17")
      OUTLINE(@"SEL$2")
      OUTLINE(@"SEL$F42BAC74")
      UNNEST(@"SEL$16")
      OUTLINE(@"SEL$1CCD6A15")
      OUTLINE(@"SEL$32487103")
      UNNEST(@"SEL$12")
      OUTLINE(@"SEL$B1825B25")
      OUTLINE_LEAF(@"SEL$1")
      UNNEST(@"SEL$17")
      OUTLINE_LEAF(@"SEL$9AFAFE26")
      OUTLINE_LEAF(@"SEL$8")
      MERGE(@"SEL$F42BAC74")
      OUTLINE_LEAF(@"SEL$290D7DBA")
      MERGE(@"SEL$32487103")
      OUTLINE_LEAF(@"SEL$187F3A83")
      OUTLINE_LEAF(@"SEL$6")
      OUTLINE_LEAF(@"SEL$7")
      OUTLINE_LEAF(@"SEL$5")
      OUTLINE_LEAF(@"SEL$4")
      OUTLINE_LEAF(@"SEL$3")
      ALL_ROWS
      OPT_PARAM('optimizer_index_caching' 90)
      OPT_PARAM('optimizer_index_cost_adj' 50)
      OPT_PARAM('_optimizer_adaptive_cursor_sharing' 'false')
      OPT_PARAM('_optimizer_extended_cursor_sharing_rel' 'none')
      OPT_PARAM('_optimizer_connect_by_cost_based' 'false')
      OPT_PARAM('_optimizer_extended_cursor_sharing' 'none')
      OPT_PARAM('_optimizer_cost_based_transformation' 'off')
      OPT_PARAM('query_rewrite_enabled' 'false')
      DB_VERSION('11.2.0.4')
      OPTIMIZER_FEATURES_ENABLE('11.2.0.2')
      IGNORE_OPTIM_EMBEDDED_HINTS
      END_OUTLINE_DATA
  */
 
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
              TO_CHAR(INTERNAL_FUNCTION("PRG"."TXN_DT_TIME"),'HH24')>='21' AND TO_CHAR(INTERNAL_FUNCTION("PRG"."TXN_DT_TIME"),'HH24')<='24')
  54 - access("A"."RELATED_ACCOUNT"="X"."ACCOUNT_NUMBER"(+) AND "A"."AC_BRANCH"="X"."BRANCH_CODE"(+))
  55 - access("A"."TRN_REF_NO"="TRN_REF_NO")
  56 - access("A"."TRN_CODE"="S"."TRN_CODE")
  59 - access("S"."TRN_CODE"='445' OR "S"."TRN_CODE"='446')
  61 - filter(("A"."TRN_CODE"='445' OR "A"."TRN_CODE"='446') AND "A"."CUST_GL"='A')
  63 - filter("EVENT"='REVR' AND ("TRN_CODE"='445' OR "TRN_CODE"='446'))
  67 - access("X"."CUSTOMER_ID"="Y"."CUSTOMER_NO"(+))
  68 - access("A"."AC_NO"="B"."CUST_AC_NO")
 
Column Projection Information (identified by operation id):
-----------------------------------------------------------
 
   1 - "CSTBS_ADDL_TEXT".ROWID[ROWID,10], "ADDL_TEXT"[VARCHAR2,255]
   2 - "CSTBS_ADDL_TEXT".ROWID[ROWID,10]
   3 - "NARRATIVE"[VARCHAR2,255]
   4 - "NARRATIVE"[VARCHAR2,255]
   5 - "DETB_RTL_TELLER".ROWID[ROWID,10]
   6 - "DETB_JRNL_TXN_DETAIL".ROWID[ROWID,10], "ADDL_TEXT"[VARCHAR2,350]
   7 - "DETB_JRNL_TXN_DETAIL".ROWID[ROWID,10]
   8 - "SITB_CONTRACT_MASTER".ROWID[ROWID,10], "INTERNAL_REMARKS"[VARCHAR2,255]
   9 - "SITB_CONTRACT_MASTER".ROWID[ROWID,10]
  10 - (#keys=0) MAX("VERSION_NO")[22]
  11 - "VERSION_NO"[NUMBER,22]
  12 - "VERSION_NO"[NUMBER,22]
  13 - (#keys=6) "S"."USER_REF_NO"[VARCHAR2,35], "S"."MODULE_CODE"[VARCHAR2,2], "T"."EXPIRY_DATE"[DATE,7], "U"."MATURITY_DATE"[DATE,7], 
       "T"."KET1"[VARCHAR2,313], "U"."KET2"[VARCHAR2,229]
  14 - "T"."KET1"[VARCHAR2,313], "S"."USER_REF_NO"[VARCHAR2,35], "S"."MODULE_CODE"[VARCHAR2,2], "T"."EXPIRY_DATE"[DATE,7], 
       "U"."KET2"[VARCHAR2,229], "U"."MATURITY_DATE"[DATE,7]
  15 - (#keys=1) "T"."KET1"[VARCHAR2,313], "S"."USER_REF_NO"[VARCHAR2,35], "S"."MODULE_CODE"[VARCHAR2,2], "T"."EXPIRY_DATE"[DATE,7], 
       "U"."KET2"[VARCHAR2,229], "U"."MATURITY_DATE"[DATE,7]
  16 - (#keys=0) "S"."CONTRACT_REF_NO"[VARCHAR2,16], "S"."USER_REF_NO"[VARCHAR2,35], "S"."MODULE_CODE"[VARCHAR2,2], 
       "T"."EXPIRY_DATE"[DATE,7], "T"."KET1"[VARCHAR2,313]
  17 - "S"."CONTRACT_REF_NO"[VARCHAR2,16], "S"."USER_REF_NO"[VARCHAR2,35], "S"."MODULE_CODE"[VARCHAR2,2]
  18 - "S".ROWID[ROWID,10], "S"."CONTRACT_REF_NO"[VARCHAR2,16]
  19 - "T"."CONTRACT_REF_NO"[VARCHAR2,16], "T"."EXPIRY_DATE"[DATE,7], "T"."KET1"[VARCHAR2,313]
  20 - "CUST_NAME"[VARCHAR2,150], "CUST_NAME"[VARCHAR2,150], "A"."EXPIRY_DATE"[DATE,7], "A"."CONTRACT_REF_NO"[VARCHAR2,16]
  21 - (#keys=9) "CONTRACT_REF_NO"[VARCHAR2,16], ROWID[ROWID,10], ROWID[ROWID,10], ROWID[ROWID,10], "A"."VERSION_NO"[NUMBER,22], 
       "CUST_NAME"[VARCHAR2,150], "CUST_NAME"[VARCHAR2,150], "A"."EXPIRY_DATE"[DATE,7], "A"."CONTRACT_REF_NO"[VARCHAR2,16], MAX("VERSION_NO")[22]
  22 - (#keys=0) ROWID[ROWID,10], "CUST_NAME"[VARCHAR2,150], ROWID[ROWID,10], "A"."CONTRACT_REF_NO"[VARCHAR2,16], 
       "A"."VERSION_NO"[NUMBER,22], "A"."EXPIRY_DATE"[DATE,7], ROWID[ROWID,10], "CUST_NAME"[VARCHAR2,150], "CONTRACT_REF_NO"[VARCHAR2,16], 
       "VERSION_NO"[NUMBER,22]
  23 - (#keys=0) ROWID[ROWID,10], "CUST_NAME"[VARCHAR2,150], ROWID[ROWID,10], "A"."CONTRACT_REF_NO"[VARCHAR2,16], 
       "A"."VERSION_NO"[NUMBER,22], "A"."EXPIRY_DATE"[DATE,7], ROWID[ROWID,10], "CUST_NAME"[VARCHAR2,150], 
       "LCTBS_CONTRACT_MASTER".ROWID[ROWID,10], "CONTRACT_REF_NO"[VARCHAR2,16]
  24 - (#keys=0) ROWID[ROWID,10], "CUST_NAME"[VARCHAR2,150], ROWID[ROWID,10], "A"."CONTRACT_REF_NO"[VARCHAR2,16], 
       "A"."VERSION_NO"[NUMBER,22], "A"."EXPIRY_DATE"[DATE,7], ROWID[ROWID,10], "CUST_NAME"[VARCHAR2,150]
  25 - (#keys=0) ROWID[ROWID,10], "CUST_NAME"[VARCHAR2,150], ROWID[ROWID,10], "A"."CONTRACT_REF_NO"[VARCHAR2,16], 
       "A"."VERSION_NO"[NUMBER,22], "A"."EVENT_SEQ_NO"[NUMBER,22], "A"."EXPIRY_DATE"[DATE,7]
  26 - ROWID[ROWID,10], "CONTRACT_REF_NO"[VARCHAR2,16], "EVENT_SEQ_NO"[NUMBER,22], "CUST_NAME"[VARCHAR2,150]
  27 - ROWID[ROWID,10], "CONTRACT_REF_NO"[VARCHAR2,16], "EVENT_SEQ_NO"[NUMBER,22]
  28 - ROWID[ROWID,10], "A"."CONTRACT_REF_NO"[VARCHAR2,16], "A"."VERSION_NO"[NUMBER,22], "A"."EVENT_SEQ_NO"[NUMBER,22], 
       "A"."EXPIRY_DATE"[DATE,7]
  29 - ROWID[ROWID,10], "A"."CONTRACT_REF_NO"[VARCHAR2,16], "A"."EVENT_SEQ_NO"[NUMBER,22]
  30 - ROWID[ROWID,10], "CUST_NAME"[VARCHAR2,150]
  31 - ROWID[ROWID,10]
  32 - "LCTBS_CONTRACT_MASTER".ROWID[ROWID,10], "CONTRACT_REF_NO"[VARCHAR2,16]
  33 - "VERSION_NO"[NUMBER,22]
  34 - "U"."BCREFNO"[VARCHAR2,16], "U"."MATURITY_DATE"[DATE,7], "U"."KET2"[VARCHAR2,229]
  35 - "PARTY_NAME"[VARCHAR2,105], "PARTY_NAME"[VARCHAR2,105], "D"."MATURITY_DATE"[DATE,7], "D"."BCREFNO"[VARCHAR2,16]
  36 - (#keys=9) "BCREFNO"[VARCHAR2,16], ROWID[ROWID,10], ROWID[ROWID,10], ROWID[ROWID,10], "D"."VERSION_NO"[NUMBER,22], 
       "PARTY_NAME"[VARCHAR2,105], "PARTY_NAME"[VARCHAR2,105], "D"."MATURITY_DATE"[DATE,7], "D"."BCREFNO"[VARCHAR2,16], MAX("VERSION_NO")[22]
  37 - (#keys=0) ROWID[ROWID,10], "PARTY_NAME"[VARCHAR2,105], ROWID[ROWID,10], "D"."BCREFNO"[VARCHAR2,16], "D"."VERSION_NO"[NUMBER,22], 
       "D"."MATURITY_DATE"[DATE,7], ROWID[ROWID,10], "PARTY_NAME"[VARCHAR2,105], "BCREFNO"[VARCHAR2,16], "VERSION_NO"[NUMBER,22]
  38 - (#keys=0) ROWID[ROWID,10], "PARTY_NAME"[VARCHAR2,105], ROWID[ROWID,10], "D"."BCREFNO"[VARCHAR2,16], "D"."VERSION_NO"[NUMBER,22], 
       "D"."MATURITY_DATE"[DATE,7], ROWID[ROWID,10], "PARTY_NAME"[VARCHAR2,105], "BCTB_CONTRACT_MASTER".ROWID[ROWID,10], "BCREFNO"[VARCHAR2,16]
  39 - (#keys=0) ROWID[ROWID,10], "PARTY_NAME"[VARCHAR2,105], ROWID[ROWID,10], "D"."BCREFNO"[VARCHAR2,16], "D"."VERSION_NO"[NUMBER,22], 
       "D"."MATURITY_DATE"[DATE,7], ROWID[ROWID,10], "PARTY_NAME"[VARCHAR2,105]
  40 - (#keys=0) ROWID[ROWID,10], "PARTY_NAME"[VARCHAR2,105], ROWID[ROWID,10], "D"."BCREFNO"[VARCHAR2,16], "D"."EVENT_SEQ_NO"[NUMBER,22], 
       "D"."VERSION_NO"[NUMBER,22], "D"."MATURITY_DATE"[DATE,7]
  41 - ROWID[ROWID,10], "BCREFNO"[VARCHAR2,16], "EVENT_SEQ_NO"[NUMBER,22], "PARTY_NAME"[VARCHAR2,105]
  42 - ROWID[ROWID,10], "BCREFNO"[VARCHAR2,16], "EVENT_SEQ_NO"[NUMBER,22]
  43 - ROWID[ROWID,10], "D"."BCREFNO"[VARCHAR2,16], "D"."EVENT_SEQ_NO"[NUMBER,22], "D"."VERSION_NO"[NUMBER,22], 
       "D"."MATURITY_DATE"[DATE,7]
  44 - ROWID[ROWID,10], "D"."BCREFNO"[VARCHAR2,16], "D"."EVENT_SEQ_NO"[NUMBER,22]
  45 - ROWID[ROWID,10], "PARTY_NAME"[VARCHAR2,105]
  46 - ROWID[ROWID,10]
  47 - "BCTB_CONTRACT_MASTER".ROWID[ROWID,10], "BCREFNO"[VARCHAR2,16]
  48 - "VERSION_NO"[NUMBER,22]
  49 - "PRG"."NO"[NUMBER,22], "PRG"."AC_NO"[VARCHAR2,20], "PRG"."NAMA_NASABAH"[VARCHAR2,105], "PRG"."TRN_REF_NO"[VARCHAR2,16], 
       "PRG"."TXN_DT_TIME"[TIMESTAMP,11], "PRG"."TIME"[VARCHAR2,19], "PRG"."TRN_CODE"[VARCHAR2,3], "PRG"."EVENT"[VARCHAR2,4], 
       "PRG"."KETERANGAN"[VARCHAR2,1593], "PRG"."DRCR_IND"[CHARACTER,1], "PRG"."AMOUNT"[NUMBER,22]
  50 - (#keys=1) "A"."TXN_DT_TIME"[TIMESTAMP,11], "A"."RELATED_ACCOUNT"[VARCHAR2,20], "X"."ACCOUNT_NUMBER"[VARCHAR2,35], 
       "A"."AC_BRANCH"[VARCHAR2,3], "X"."BRANCH_CODE"[VARCHAR2,35], "A"."TRN_REF_NO"[VARCHAR2,16], "TRN_REF_NO"[VARCHAR2,16], 
       "S"."TRN_CODE"[VARCHAR2,3], "A"."TRN_CODE"[VARCHAR2,3], "S".ROWID[ROWID,10], "S"."TRN_DESC"[VARCHAR2,105], 
       "A"."DONT_SHOWIN_STMT"[CHARACTER,1], "A"."EVENT_SR_NO"[NUMBER,22], "A"."EVENT"[VARCHAR2,4], "TRN_CODE"[VARCHAR2,3], 
       "A"."AC_NO"[VARCHAR2,20], "A"."DRCR_IND"[CHARACTER,1], "B"."AC_DESC"[VARCHAR2,105], "A"."LCY_AMOUNT"[NUMBER,22], "EVENT"[VARCHAR2,4], 
       "A"."CUST_GL"[CHARACTER,1], "A"."MODULE"[VARCHAR2,2], "A"."CURR_NO"[NUMBER,22], "X"."CUSTOMER_ID"[VARCHAR2,35], "Y".ROWID[ROWID,10], 
       "Y"."CUSTOMER_NO"[VARCHAR2,9], "Y"."CUSTOMER_NAME1"[VARCHAR2,105], "B".ROWID[ROWID,10], "B"."CUST_AC_NO"[VARCHAR2,20], ROW_NUMBER() OVER 
       ( ORDER BY "TXN_DT_TIME")[22]
  51 - (#keys=0) "A"."RELATED_ACCOUNT"[VARCHAR2,20], "X"."ACCOUNT_NUMBER"[VARCHAR2,35], "A"."AC_BRANCH"[VARCHAR2,3], 
       "X"."BRANCH_CODE"[VARCHAR2,35], "A"."TRN_REF_NO"[VARCHAR2,16], "TRN_REF_NO"[VARCHAR2,16], "S"."TRN_CODE"[VARCHAR2,3], 
       "A"."TRN_CODE"[VARCHAR2,3], "S".ROWID[ROWID,10], "S"."TRN_DESC"[VARCHAR2,105], "A"."DONT_SHOWIN_STMT"[CHARACTER,1], 
       "A"."EVENT_SR_NO"[NUMBER,22], "A"."EVENT"[VARCHAR2,4], "TRN_CODE"[VARCHAR2,3], "A"."AC_NO"[VARCHAR2,20], "A"."DRCR_IND"[CHARACTER,1], 
       "A"."TXN_DT_TIME"[TIMESTAMP,11], "A"."LCY_AMOUNT"[NUMBER,22], "EVENT"[VARCHAR2,4], "A"."CUST_GL"[CHARACTER,1], "A"."MODULE"[VARCHAR2,2], 
       "A"."CURR_NO"[NUMBER,22], "X"."CUSTOMER_ID"[VARCHAR2,35], "Y".ROWID[ROWID,10], "Y"."CUSTOMER_NO"[VARCHAR2,9], 
       "Y"."CUSTOMER_NAME1"[VARCHAR2,105], "B".ROWID[ROWID,10], "B"."CUST_AC_NO"[VARCHAR2,20], "B"."AC_DESC"[VARCHAR2,105]
  52 - (#keys=0) "A"."RELATED_ACCOUNT"[VARCHAR2,20], "X"."ACCOUNT_NUMBER"[VARCHAR2,35], "A"."AC_BRANCH"[VARCHAR2,3], 
       "X"."BRANCH_CODE"[VARCHAR2,35], "A"."TRN_REF_NO"[VARCHAR2,16], "TRN_REF_NO"[VARCHAR2,16], "S"."TRN_CODE"[VARCHAR2,3], 
       "A"."TRN_CODE"[VARCHAR2,3], "S".ROWID[ROWID,10], "S"."TRN_DESC"[VARCHAR2,105], "A"."DONT_SHOWIN_STMT"[CHARACTER,1], 
       "A"."EVENT_SR_NO"[NUMBER,22], "A"."EVENT"[VARCHAR2,4], "TRN_CODE"[VARCHAR2,3], "A"."AC_NO"[VARCHAR2,20], "A"."DRCR_IND"[CHARACTER,1], 
       "A"."TXN_DT_TIME"[TIMESTAMP,11], "A"."LCY_AMOUNT"[NUMBER,22], "EVENT"[VARCHAR2,4], "A"."CUST_GL"[CHARACTER,1], "A"."MODULE"[VARCHAR2,2], 
       "A"."CURR_NO"[NUMBER,22], "X"."CUSTOMER_ID"[VARCHAR2,35], "Y".ROWID[ROWID,10], "Y"."CUSTOMER_NO"[VARCHAR2,9], 
       "Y"."CUSTOMER_NAME1"[VARCHAR2,105], "B".ROWID[ROWID,10], "B"."CUST_AC_NO"[VARCHAR2,20]
  53 - (#keys=0) "A"."RELATED_ACCOUNT"[VARCHAR2,20], "X"."ACCOUNT_NUMBER"[VARCHAR2,35], "A"."AC_BRANCH"[VARCHAR2,3], 
       "X"."BRANCH_CODE"[VARCHAR2,35], "A"."TRN_REF_NO"[VARCHAR2,16], "TRN_REF_NO"[VARCHAR2,16], "S"."TRN_CODE"[VARCHAR2,3], 
       "A"."TRN_CODE"[VARCHAR2,3], "S".ROWID[ROWID,10], "S"."TRN_DESC"[VARCHAR2,105], "A"."DONT_SHOWIN_STMT"[CHARACTER,1], 
       "A"."EVENT_SR_NO"[NUMBER,22], "A"."EVENT"[VARCHAR2,4], "TRN_CODE"[VARCHAR2,3], "A"."AC_NO"[VARCHAR2,20], "A"."DRCR_IND"[CHARACTER,1], 
       "A"."TXN_DT_TIME"[TIMESTAMP,11], "A"."LCY_AMOUNT"[NUMBER,22], "EVENT"[VARCHAR2,4], "A"."CUST_GL"[CHARACTER,1], "A"."MODULE"[VARCHAR2,2], 
       "A"."CURR_NO"[NUMBER,22], "X"."CUSTOMER_ID"[VARCHAR2,35], "Y".ROWID[ROWID,10], "Y"."CUSTOMER_NO"[VARCHAR2,9], 
       "Y"."CUSTOMER_NAME1"[VARCHAR2,105]
  54 - (#keys=2) "A"."RELATED_ACCOUNT"[VARCHAR2,20], "X"."ACCOUNT_NUMBER"[VARCHAR2,35], "A"."AC_BRANCH"[VARCHAR2,3], 
       "X"."BRANCH_CODE"[VARCHAR2,35], "A"."TRN_REF_NO"[VARCHAR2,16], "TRN_REF_NO"[VARCHAR2,16], "S"."TRN_CODE"[VARCHAR2,3], 
       "A"."TRN_CODE"[VARCHAR2,3], "S".ROWID[ROWID,10], "S"."TRN_DESC"[VARCHAR2,105], "A"."DONT_SHOWIN_STMT"[CHARACTER,1], 
       "A"."EVENT_SR_NO"[NUMBER,22], "A"."EVENT"[VARCHAR2,4], "TRN_CODE"[VARCHAR2,3], "A"."AC_NO"[VARCHAR2,20], "A"."DRCR_IND"[CHARACTER,1], 
       "A"."TXN_DT_TIME"[TIMESTAMP,11], "A"."LCY_AMOUNT"[NUMBER,22], "EVENT"[VARCHAR2,4], "A"."CUST_GL"[CHARACTER,1], "A"."MODULE"[VARCHAR2,2], 
       "A"."CURR_NO"[NUMBER,22], "X"."CUSTOMER_ID"[VARCHAR2,35]
  55 - (#keys=1) "A"."TRN_REF_NO"[VARCHAR2,16], "TRN_REF_NO"[VARCHAR2,16], "S"."TRN_CODE"[VARCHAR2,3], "A"."TRN_CODE"[VARCHAR2,3], 
       "S".ROWID[ROWID,10], "S"."TRN_DESC"[VARCHAR2,105], "A"."DONT_SHOWIN_STMT"[CHARACTER,1], "A"."EVENT_SR_NO"[NUMBER,22], 
       "A"."EVENT"[VARCHAR2,4], "A"."AC_BRANCH"[VARCHAR2,3], "A"."AC_NO"[VARCHAR2,20], "A"."DRCR_IND"[CHARACTER,1], 
       "A"."TXN_DT_TIME"[TIMESTAMP,11], "A"."LCY_AMOUNT"[NUMBER,22], "A"."RELATED_ACCOUNT"[VARCHAR2,20], "A"."CUST_GL"[CHARACTER,1], 
       "A"."MODULE"[VARCHAR2,2], "A"."CURR_NO"[NUMBER,22], "TRN_CODE"[VARCHAR2,3], "EVENT"[VARCHAR2,4]
  56 - (#keys=1) "S"."TRN_CODE"[VARCHAR2,3], "A"."TRN_CODE"[VARCHAR2,3], "S".ROWID[ROWID,10], "S"."TRN_DESC"[VARCHAR2,105], 
       "A"."TRN_REF_NO"[VARCHAR2,16], "A"."EVENT_SR_NO"[NUMBER,22], "A"."EVENT"[VARCHAR2,4], "A"."AC_BRANCH"[VARCHAR2,3], 
       "A"."AC_NO"[VARCHAR2,20], "A"."DRCR_IND"[CHARACTER,1], "A"."TXN_DT_TIME"[TIMESTAMP,11], "A"."LCY_AMOUNT"[NUMBER,22], 
       "A"."RELATED_ACCOUNT"[VARCHAR2,20], "A"."CUST_GL"[CHARACTER,1], "A"."MODULE"[VARCHAR2,2], "A"."CURR_NO"[NUMBER,22], 
       "A"."DONT_SHOWIN_STMT"[CHARACTER,1]
  57 - "S".ROWID[ROWID,10], "S"."TRN_CODE"[VARCHAR2,3], "S"."TRN_DESC"[VARCHAR2,105]
  58 - "S".ROWID[ROWID,10], "S"."TRN_CODE"[VARCHAR2,3], "S"."TRN_DESC"[VARCHAR2,105]
  59 - "S".ROWID[ROWID,10], "S"."TRN_CODE"[VARCHAR2,3]
  60 - "A"."TRN_REF_NO"[VARCHAR2,16], "A"."EVENT_SR_NO"[NUMBER,22], "A"."EVENT"[VARCHAR2,4], "A"."AC_BRANCH"[VARCHAR2,3], 
       "A"."AC_NO"[VARCHAR2,20], "A"."DRCR_IND"[CHARACTER,1], "A"."TRN_CODE"[VARCHAR2,3], "A"."LCY_AMOUNT"[NUMBER,22], 
       "A"."RELATED_ACCOUNT"[VARCHAR2,20], "A"."CUST_GL"[CHARACTER,1], "A"."MODULE"[VARCHAR2,2], "A"."CURR_NO"[NUMBER,22], 
       "A"."DONT_SHOWIN_STMT"[CHARACTER,1], "A"."TXN_DT_TIME"[TIMESTAMP,11]
  61 - "A"."TRN_REF_NO"[VARCHAR2,16], "A"."EVENT_SR_NO"[NUMBER,22], "A"."EVENT"[VARCHAR2,4], "A"."AC_BRANCH"[VARCHAR2,3], 
       "A"."AC_NO"[VARCHAR2,20], "A"."DRCR_IND"[CHARACTER,1], "A"."TRN_CODE"[VARCHAR2,3], "A"."LCY_AMOUNT"[NUMBER,22], 
       "A"."RELATED_ACCOUNT"[VARCHAR2,20], "A"."CUST_GL"[CHARACTER,1], "A"."MODULE"[VARCHAR2,2], "A"."CURR_NO"[NUMBER,22], 
       "A"."DONT_SHOWIN_STMT"[CHARACTER,1], "A"."TXN_DT_TIME"[TIMESTAMP,11]
  62 - "TRN_REF_NO"[VARCHAR2,16], "EVENT"[VARCHAR2,4], "TRN_CODE"[VARCHAR2,3]
  63 - "TRN_REF_NO"[VARCHAR2,16], "EVENT"[VARCHAR2,4], "TRN_CODE"[VARCHAR2,3]
  64 - "X"."ACCOUNT_NUMBER"[VARCHAR2,35], "X"."BRANCH_CODE"[VARCHAR2,35], "X"."CUSTOMER_ID"[VARCHAR2,35]
  65 - "X"."ACCOUNT_NUMBER"[VARCHAR2,35], "X"."BRANCH_CODE"[VARCHAR2,35], "X"."CUSTOMER_ID"[VARCHAR2,35]
  66 - "Y".ROWID[ROWID,10], "Y"."CUSTOMER_NO"[VARCHAR2,9], "Y"."CUSTOMER_NAME1"[VARCHAR2,105]
  67 - "Y".ROWID[ROWID,10], "Y"."CUSTOMER_NO"[VARCHAR2,9]
  68 - "B".ROWID[ROWID,10], "B"."CUST_AC_NO"[VARCHAR2,20]
  69 - "B".ROWID[ROWID,10], "B"."AC_DESC"[VARCHAR2,105]