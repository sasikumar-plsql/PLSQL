CREATE OR replace PROCEDURE Get_xml_data (p_employee_id employees.employee_id%type)
AS
  name  VARCHAR2(30);
  fname VARCHAR2(40);
BEGIN
    name := 'FIRST_NAME';

    SELECT Extractvalue(employee_xml, '/ROW/'
                                      ||name
                                      ||'/text()') AS Vname
    INTO   fname
    FROM   emp_xml_data
    WHERE  employee_id = p_employee_id;

    dbms_output.Put_line('First name : '||fname);
exception
when others then
    dbms_output.put_line('Error : '||substr(sqlerrm,1,200));
END; 