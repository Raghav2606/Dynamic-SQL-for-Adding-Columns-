--Creating the tables list with Row Index for iterating it.
select ROW_NUMBER() over(order by table_name) as row_index,TABLE_NAME into alter_column.tables_list
from INFORMATION_SCHEMA.tables where TABLE_SCHEMA='alter_column' and TABLE_TYPE='Base Table'
and table_name<>'tables_list'


declare @tbl_count int =(select count(*) from alter_column.tables_list)
declare @row_count int=0
declare @tbl_name varchar(100)
declare @column_name varchar(20)='new'
declare @query varchar(400)
declare @error_msg varchar(400)
declare @column_exists int
declare @schema_name varchar(30)='alter_column'

while @row_count<=@tbl_count
begin
set @tbl_name =(select table_name from alter_column.tables_list where row_index=@row_count)
set @column_exists =(select count(*) from INFORMATION_SCHEMA.columns where table_name=@tbl_name and column_name=@column_name)
if @column_exists=0
begin
set @query='alter table '+@schema_name+'.'+@tbl_name+' add '+@column_name+' varchar(10)'
exec(@query)
end
else
begin
set @error_msg='Column '+@column_name+' already exists in the table '+@tbl_name
print(@error_msg)
end
set @row_count =@row_count+1
end
