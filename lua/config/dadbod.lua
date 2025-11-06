vim.g.db_ui_execute_on_save = false

vim.g.db_ui_table_helpers = {
	sqlserver = {
		-- my_columns =
		-- "select table_schema as 'Schema', left(table_name, 35) as 'Table Name', column_name as 'Field', data_type from information_schema.column order by table_schema, table_name, ordinal_position;"
		all_tables_columns = [[
select
		table_schema as 'Schema',
		left(table_name, 35) as 'Table Name',
		column_name as 'Field',
		data_type
from
		information_schema.columns
order by
table_schema,
table_name,
ordinal_position;
		]]
	}
}
