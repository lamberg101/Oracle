select sum (bytes/1024/1024/1024) "Datafiles (GB)" from cdb_data_files;
select sum (bytes/1024/1024/1024) "Segments (GB)" from cdb_segments;