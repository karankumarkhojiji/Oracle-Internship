-- TransactionList Procedure

create or replace procedure transactionlist(
    p_customer_id in number default null,
    p_transaction_type in varchar2 default null,
    p_results out varchar2
) as
    v_result varchar2(4000); -- variable to store the result
begin
    if p_customer_id is not null and p_transaction_type is not null then
        -- retrieve transactions for a specific customer and transaction type
        select 'transaction id: ' || t.transaction_id || chr(10) ||
               'transaction date: ' || t.transactions_date || chr(10) ||
               'transaction type: ' || t.transactions_type || chr(10) ||
               'amount: ' || t.amount || chr(10) ||
               'customer id: ' || t.customer_id || chr(10) ||
               'equity id: ' || t.equity_id || chr(10) ||
               'first name: ' || c.first_name || chr(10) ||
               'last name: ' || c.last_name || chr(10) ||
               'email: ' || c.email
        into v_result
        from transactions t
                 join customers c on t.customer_id = c.customer_id
        where t.customer_id = p_customer_id
          and t.transactions_type = p_transaction_type;

    elsif p_customer_id is not null then
        -- retrieve transactions for a specific customer
        select 'transaction id: ' || t.transaction_id || chr(10) ||
               'transaction date: ' || t.transactions_date || chr(10) ||
               'transaction type: ' || t.transactions_type || chr(10) ||
               'amount: ' || t.amount || chr(10) ||
               'customer id: ' || t.customer_id || chr(10) ||
               'equity id: ' || t.equity_id || chr(10) ||
               'first name: ' || c.first_name || chr(10) ||
               'last name: ' || c.last_name || chr(10) ||
               'email: ' || c.email
        into v_result
        from transactions t
                 join customers c on t.customer_id = c.customer_id
        where t.customer_id = p_customer_id;

    elsif p_transaction_type is not null then
        -- retrieve transactions for a specific transaction type
        select 'transaction id: ' || t.transaction_id || chr(10) ||
               'transaction date: ' || t.transactions_date || chr(10) ||
               'transaction type: ' || t.transactions_type || chr(10) ||
               'amount: ' || t.amount || chr(10) ||
               'customer id: ' || t.customer_id || chr(10) ||
               'equity id: ' || t.equity_id || chr(10) ||
               'first name: ' || c.first_name || chr(10) ||
               'last name: ' || c.last_name || chr(10) ||
               'email: ' || c.email
        into v_result
        from transactions t
                 join customers c on t.customer_id = c.customer_id
        where t.transactions_type = p_transaction_type;

    else
        -- retrieve all transactions for all customers
        select 'transaction id: ' || t.transaction_id || chr(10) ||
               'transaction date: ' || t.transactions_date || chr(10) ||
               'transaction type: ' || t.transactions_type || chr(10) ||
               'amount: ' || t.amount || chr(10) ||
               'customer id: ' || t.customer_id || chr(10) ||
               'equity id: ' || t.equity_id || chr(10) ||
               'first name: ' || c.first_name || chr(10) ||
               'last name: ' || c.last_name || chr(10) ||
               'email: ' || c.email
        into v_result
        from transactions t
                 join customers c on t.customer_id = c.customer_id;
    end if;

    -- assign the result to the output parameter
    p_results := v_result;
end;


declare
    v_results varchar2(4000);
begin
    transactionlist(p_customer_id => 5, p_transaction_type => 'Buy', p_results => v_results);
end;
