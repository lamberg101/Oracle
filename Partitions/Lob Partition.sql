alter table PRO_APP_TEST.TBAP_PRICE_PLAN move partition PART_ITEMPP_ACTIVE_AUG2038 lob (ITEM_IFRS_PARAM_LIST) store as (tablespace DATAL03);
alter table PRO_APP_TEST.TBAP_PRICE_PLAN move partition SYS_P27260 lob (ITEM_IFRS_PARAM_LIST) store as (tablespace DATAL03);
alter table PRO_APP_TEST.TBAP_PRICE_PLAN move partition PART_ITEMPP_ACTIVE_JAN2038 lob (ITEM_DYN_PROPERTIES) store as (tablespace DATAL03);
