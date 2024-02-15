explain plan for 
SELECT /*+ PARALLEL (10) */ * FROM (
SELECT row_number() over ( order by txn_dt_time ) as no, 
a.ac_no,b.AC_DESC nama_nasabah,  a.trn_ref_no, 
a.TXN_DT_TIME, to_char(a.TXN_DT_TIME,'DD/MM/YYYY HH24:MI:SS') time, a.trn_code, a.event,
((SELECT trim(ADDL_TEXT)
FROM CSTBS_ADDL_TEXT
WHERE REFERENCE_NO = a.trn_ref_no
AND EVNT_SEQ_NO = a.event_sr_no
) || ' ' || (SELECT narrative FROM DETB_RTL_TELLER
WHERE TRN_REF_NO = a.trn_ref_no
) || ' ' || (
SELECT DISTINCT ADDL_TEXT
FROM DETB_JRNL_TXN_DETAIL
WHERE reference_no = a.trn_ref_no
AND serial_no = a.curr_no
) || ' ' || s.trn_desc || ' ' || (
CASE
WHEN s.trn_desc LIKE 'SI %'
THEN (
SELECT internal_remarks
FROM SITB_CONTRACT_MASTER
WHERE contract_ref_no = a.trn_ref_no
AND version_no = (
SELECT max(version_no)
FROM sitb_contract_master
WHERE contract_ref_no = a.TRN_REF_NO
)
)
ELSE decode(a.related_account, '', '', ' For the Account No.' || a.related_account) || decode(a.module, 'CI', ' a.n ' || y.customer_name1, '')
END
) || ' ' || (
SELECT s.user_ref_no || ' ' || decode(s.module_code, 'IB', 'Mtr_dt: ' || to_char(u.maturity_date, 'YYYY-MM-DD') || ' ' || u.ket2, 'Exp_dt: ' || to_char(t.expiry_date, 'YYYY-MM-DD') || ' ' || t.ket1)
FROM cstb_contract s
,(
SELECT a.contract_ref_no
,a.expiry_date
,('APP: ' || b.cust_name || ' & ' || 'BEN: ' || c.cust_name) ket1
FROM LCTBS_CONTRACT_MASTER a
,(
SELECT contract_ref_no
,event_seq_no
,cust_name
FROM LCTB_PARTIES
WHERE party_type = 'APP'
) b
,(
SELECT contract_ref_no
,event_seq_no
,cust_name
FROM LCTB_PARTIES
WHERE party_type = 'BEN'
) c
WHERE a.contract_ref_no = b.contract_ref_no
AND a.contract_ref_no = c.contract_ref_no
AND a.event_seq_no = b.event_seq_no
AND a.event_seq_no = c.event_seq_no
AND a.version_no = (
SELECT max(version_no)
FROM LCTBS_CONTRACT_MASTER
WHERE contract_ref_no = a.contract_ref_no
)
) t
,(
SELECT d.bcrefno
,d.maturity_date
,('DRAWEE: ' || e.party_name || ' & ' || 'DRAWER: ' || f.party_name) ket2
FROM BCTB_CONTRACT_MASTER d
,(
SELECT bcrefno
,event_seq_no
,party_name
FROM BCTB_CONTRACT_PARTIES
WHERE party_type = 'DRAWEE'
) e
,(
SELECT bcrefno
,event_seq_no
,party_name
FROM BCTB_CONTRACT_PARTIES
WHERE party_type = 'DRAWER'
) f
WHERE d.bcrefno = e.bcrefno
AND d.bcrefno = f.bcrefno
AND d.event_seq_no = e.event_seq_no
AND d.event_seq_no = f.event_seq_no
AND d.version_no = (
SELECT max(version_no)
FROM BCTB_CONTRACT_MASTER
WHERE bcrefno = d.bcrefno
)
) u
WHERE s.contract_ref_no = t.contract_ref_no(+)
AND s.contract_ref_no = u.bcrefno(+)
AND s.contract_ref_no = a.trn_ref_no
AND A.DONT_SHOWIN_STMT = 'N'
GROUP BY s.user_ref_no, s.module_code, t.expiry_date, u.maturity_date,t.ket1,u.ket2)) keterangan
,a.drcr_ind
,a.lcy_amount AS amount
FROM actb_history a, STTM_CUST_ACCOUNT b
,sttms_trn_code s
,cltb_account_apps_master x
,sttm_customer y
WHERE a.trn_code in ('445','446')
AND a.TRN_REF_NO NOT IN (SELECT TRN_REF_NO FROM actb_history WHERE trn_code in ('445','446') and event='REVR')
AND a.cust_gl='A'
AND a.trn_code = s.trn_code
AND a.ac_no = b.CUST_AC_NO 
AND a.related_account = x.account_number(+)
AND a.ac_branch = x.branch_code(+)
AND x.customer_id = y.customer_no(+)) PRG
WHERE TO_CHAR(PRG.txn_dt_time, 'YYYYMMDD') = TO_CHAR(CURRENT_DATE-1, 'YYYYMMDD') 
AND TO_CHAR(PRG.txn_dt_time, 'HH24') >= '21' 
AND TO_CHAR(PRG.txn_dt_time, 'HH24') <= '24' ;