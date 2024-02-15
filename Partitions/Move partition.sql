--alter trxid partition table:
alter table nbpuser.trxid move partition p_node1 initrans 10 storage (freelists 16 freelist groups 2);
alter table nbpuser.trxid move partition p_node2 initrans 10 storage (freelists 16 freelist groups 2);
alter table nbpuser.trxid move partition p_node3 initrans 10 storage (freelists 16 freelist groups 2);
alter table nbpuser.trxid move partition p_node4 initrans 10 storage (freelists 16 freelist groups 2);
alter table nbpuser.trxid move partition p_node5 initrans 10 storage (freelists 16 freelist groups 2);
alter table nbpuser.trxid move partition p_node6 initrans 10 storage (freelists 16 freelist groups 2);
alter table nbpuser.trxid move partition p_nodex initrans 10 storage (freelists 16 freelist groups 2);

--alter trxid primary index:
alter index nbpuser.trxid_primary_key rebuild initrans 10 storage (freelist groups 2 freelists 16)

--alter trxid secondary index:
alter index nbpuser.trxid_compositeindex rebuild partition p_node1 initrans 10 storage (freelist groups 2 freelists 16)
alter index nbpuser.trxid_compositeindex rebuild partition p_node2 initrans 10 storage (freelist groups 2 freelists 16)
alter index nbpuser.trxid_compositeindex rebuild partition p_node3 initrans 10 storage (freelist groups 2 freelists 16)
alter index nbpuser.trxid_compositeindex rebuild partition p_node4 initrans 10 storage (freelist groups 2 freelists 16)
alter index nbpuser.trxid_compositeindex rebuild partition p_node5 initrans 10 storage (freelist groups 2 freelists 16)
alter index nbpuser.trxid_compositeindex rebuild partition p_node6 initrans 10 storage (freelist groups 2 freelists 16)

