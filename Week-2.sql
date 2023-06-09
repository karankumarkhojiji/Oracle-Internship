create or replace procedure transactionlist(
    p_customer_id in number default null,
    p_transaction_type in varchar2 default null,
    p_results out sys_refcursor
) as
    v_query varchar2(4000);
begin
    v_query :=
                'select ''transaction id: '' || t.transaction_id || chr(10) ||
                        ''transaction date: '' || t.transactions_date || chr(10) ||
                        ''transaction type: '' || t.transactions_type || chr(10) ||
                        ''amount: '' || t.amount || chr(10) ||
                        ''customer id: '' || t.customer_id || chr(10) ||
                        ''equity id: '' || t.equity_id || chr(10) ||
                        ''first name: '' || c.first_name || chr(10) ||
                        ''last name: '' || c.last_name || chr(10) ||
                        ''email: '' || c.email ' ||
                'from transactions t ' ||
                'join customers c on t.customer_id = c.customer_id';

    if p_customer_id is not null and p_transaction_type is not null then
        v_query := v_query || ' where t.customer_id = ' || p_customer_id || ' and t.transactions_type = ''' ||
                    p_transaction_type || '''';

    elsif p_customer_id is not null then
        v_query := v_query || ' where t.customer_id = ' || p_customer_id;

    elsif p_transaction_type is not null then
        v_query := v_query || ' where t.transactions_type = ''' || p_transaction_type || '''';
    end if;

    open p_results for v_query;
end;

declare
    p_results sys_refcursor;
    v_result_row varchar2(4000);
begin
    transactionlist(p_customer_id => 2,p_transaction_type => 'Buy',p_results => p_results);

    loop
        fetch p_results into v_result_row;
        exit when p_results%notfound;

        DBMS_OUTPUT.PUT_LINE(v_result_row);
    end loop;

    close p_results;
end;

-- Alter customers table

alter table customers
add customerid varchar2(50) unique ;

-- Alter transaction table

alter table transactions
add customerid varchar2(50) unique ;