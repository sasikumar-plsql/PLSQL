create or replace procedure sp_bulk_load
as
    tot_rows number;
    rem_rows number;

    type t_num_arr is table of number index by pls_integer;
    t_num_ntt t_num_arr;
    l_idx number;
    p_idx number;

begin

    execute immediate 'truncate table tmp_employees';

    select nvl(count(1),0) into tot_rows from employees;

    if tot_rows = 0 then
        return;
    end if;

    for i in 1..tot_rows
    loop
        if mod(i,10) = 0 then
            rem_rows:=i;
            t_num_ntt(i) := i;
        end if;
    end loop;

    t_num_ntt(tot_rows) := tot_rows-rem_rows;

    p_idx:=0;
    
    l_idx := t_num_ntt.first;
    while (l_idx is not null)
    loop    

        dbms_output.put_line(to_char(p_idx,'999')||' - '||to_char(l_idx,'999'));
    
        insert into tmp_employees 
        select * from employees
        offset p_idx row fetch first  (l_idx-p_idx) rows only;
        commit;
            
        p_idx := l_idx;
        l_idx := t_num_ntt.next(l_idx);

    end loop;
end;