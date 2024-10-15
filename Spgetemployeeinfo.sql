CREATE OR replace PROCEDURE Spgetemployeeinfo (p_deptid
employees.department_id%TYPE,
                                               p_out    OUT SYS_REFCURSOR)
AS
BEGIN
    OPEN p_out FOR
      SELECT *
      FROM   employees
      WHERE  ( ( department_id = p_deptid )
                OR p_deptid IS NULL );
END; 