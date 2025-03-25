--
--step 1
--convert table record to xmltype datatype
create table employee_xml
as
select 
    employee_id,
    xmltype('<Data>    
        <Employees>
            <employee_id>'||employee_id||'</employee_id>
            <employee_name>'||employee_name||'</employee_name>
        </Employees>
        <fields>
            <field name="hire_date">
                <value>'||hire_date||'</value>
            </field>
            <field name="dept_no">
                <value>'||dept_no||'</value>
            </field>
            <field name="address">
                <value>
                    <rowset>
                        <address>
                            <street1>'||street1||'</street1>
                            <street2>'||street2||'</street2>
                            <city>'||city||'</city>                            
                        </address>
                    </rowset>
                </value>
            </field>
        </fields>
    </Data>') as xml_data
from xml_emp_data;

select * from employee_xml;

--step 2
--Extracting information from XML files, then parsing and flattening it to load into the emp_data target table...
set serveroutput on;
declare
l_rows number;
begin

insert into emp_data
select
    emp.employee_id,
    emp.employee_name,
    emp.hire_date,
    emp.dept_no,
    addr.street1,
    addr.street2,
    addr.city
from 
    --Transforming a CLOB into an XMLType is referred to as an inline query...
    employee_xml t,
    --Employee info...
    xmltable(
    '/Data'
    passing t.xml_data
    columns 
        employee_id     varchar2(40) path 'Employees/employee_id',
        employee_name   varchar2(40) path 'Employees/employee_name',
        hire_date   varchar2(40) path 'fields/field[@name="hire_date"]',
        dept_no   varchar2(40) path 'fields/field[@name="dept_no"]',
        address   xmltype path 'fields/field[@name="address"]'
    ) emp,
    --Address info...
    xmltable(
    'field/value/rowset/address'
    passing emp.address
    columns 
        street1 varchar2(40) path 'street1',
        street2 varchar2(40) path 'street2',
        city    varchar2(30) path 'city'
    ) addr;
    
--check recent records inserted successfully...
l_rows:=sql%rowcount;

dbms_output.put_line('records inserted... '||l_rows);

end;


--step 3
--Confirm that the entries placed into the `emp_data` table are accurate.
--select * from emp_data;