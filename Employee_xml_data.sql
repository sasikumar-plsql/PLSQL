create or replace PROCEDURE Employee_xml_data (pemp_id IN NUMBER)
AS
  xml_emp XMLTYPE;
BEGIN
    SELECT Sys_xmlgen (Employee_map (employee_id, first_name, last_name))
    INTO   xml_emp
    FROM   employees
    WHERE  employee_id = pemp_id;

    INSERT INTO emp_xml_data
    VALUES     (pemp_id,
                xml_emp);

    COMMIT;

    dbms_output.Put_line(xml_emp.Getclobval());
END;