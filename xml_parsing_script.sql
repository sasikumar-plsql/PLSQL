set serveroutput on;
declare

--xml data declared using clob...
test clob := '<Data>
<Employees>
	<employee_id>101</employee_id>
	<employee_name>Test1</employee_name>
</Employees>
<fields>
	<field name="hire_date">
	<value>8/10/2020</value>
	</field>
	<field name="dept_no">
	<value>10</value>
	</field>
	<field name="address">
		<value>
		<rowset>
			<address>
				<street1>test st1</street1>
				<street2>test st2</street2>
				<city>Chennai</city>
			</address>
		</rowset>
		</value>
    </field>
</fields>
</Data>';

l_rows number;
begin

insert into xml_emp_data
select
    employee_id, 
    employee_name,
    hire_date, 
    dept_no,
    street1,
    street2,
    city
    --into emp_r    
from 
    --Transforming a CLOB into an XMLType is referred to as an inline query...
    (select xmltype(test) as xml_data from dual) t,
    xmltable(
    '/Data/Employees'
    passing t.xml_data
    columns 
        employee_id     varchar2(40) path 'employee_id',
        employee_name   varchar2(40) path 'employee_name'
    ) e,
    xmltable(
    '/Data/fields'
    passing t.xml_data
    columns 
        hire_date   varchar2(40) path 'field[@name="hire_date"]',        
        dept_no     varchar2(5) path 'field[@name="dept_no"]',
        address     xmltype path 'field[@name="address"]'
    ) a,
    xmltable(
    'field[@name="address"]/value/rowset/address'
    passing a.address
    columns 
        street1 varchar2(40) path 'street1',
        street2 varchar2(40) path 'street2',
        city    varchar2(30) path 'city'
    ) c;

--check recent records inserted successfully...
l_rows:=sql%rowcount;

dbms_output.put_line('records inserted... '||l_rows);

end;

