-- TransactionList Procedure

create or replace procedure transactionlist(
    p_customer_id in number default null,
    p_transaction_type in varchar2 default null
) as
begin
    if p_customer_id is not null and p_transaction_type is not null then
        -- Retrieve transactions for a specific customer and transaction type
        for trans in (
            select t.*, c.first_name, c.last_name, c.email
            from transactions t
                     join customers c on t.customer_id = c.customer_id
            where t.customer_id = p_customer_id
              and t.transactions_type = p_transaction_type
            )
            loop
                dbms_output.put_line('Transaction ID: ' || trans.transaction_id);
                dbms_output.put_line('Transaction Date: ' || trans.transactions_date);
                dbms_output.put_line('Transaction Type: ' || trans.transactions_type);
                dbms_output.put_line('Amount: ' || trans.amount);
                dbms_output.put_line('Customer ID: ' || trans.customer_id);
                dbms_output.put_line('Equity ID: ' || trans.equity_id);
                dbms_output.put_line('First Name: ' || trans.first_name);
                dbms_output.put_line('Last Name: ' || trans.last_name);
                dbms_output.put_line('Email: ' || trans.email);
                dbms_output.put_line('-----------------------------');
            end loop;
    elsif p_customer_id is not null then
        -- Retrieve transactions for a specific customer
        for trans in (
            select t.*, c.first_name, c.last_name, c.email
            from transactions t
                     join customers c on t.customer_id = c.customer_id
            where t.customer_id = p_customer_id
            )
            loop
                dbms_output.put_line('Transaction ID: ' || trans.transaction_id);
                dbms_output.put_line('Transaction Date: ' || trans.transactions_date);
                dbms_output.put_line('Transaction Type: ' || trans.transactions_type);
                dbms_output.put_line('Amount: ' || trans.amount);
                dbms_output.put_line('Customer ID: ' || trans.customer_id);
                dbms_output.put_line('Equity ID: ' || trans.equity_id);
                dbms_output.put_line('First Name: ' || trans.first_name);
                dbms_output.put_line('Last Name: ' || trans.last_name);
                dbms_output.put_line('Email: ' || trans.email);
                dbms_output.put_line('-----------------------------');
            end loop;
    elsif p_transaction_type is not null then
        -- Retrieve transactions for a specific transaction type
        for trans in (
            select t.*, c.first_name, c.last_name, c.email
            from transactions t
                     join customers c on t.customer_id = c.customer_id
            where t.transactions_type = p_transaction_type
            )
            loop
                dbms_output.put_line('Transaction ID: ' || trans.transaction_id);
                dbms_output.put_line('Transaction Date: ' || trans.transactions_date);
                dbms_output.put_line('Transaction Type: ' || trans.transactions_type);
                dbms_output.put_line('Amount: ' || trans.amount);
                dbms_output.put_line('Customer ID: ' || trans.customer_id);
                dbms_output.put_line('Equity ID: ' || trans.equity_id);
                dbms_output.put_line('First Name: ' || trans.first_name);
                dbms_output.put_line('Last Name: ' || trans.last_name);
                dbms_output.put_line('Email: ' || trans.email);
                dbms_output.put_line('-----------------------------');
            end loop;
    else
        -- Retrieve all transactions for all customers
        for trans in (
            select t.*, c.first_name, c.last_name, c.email
            from transactions t
                     join customers c on t.customer_id = c.customer_id
            )
            loop
                dbms_output.put_line('Transaction ID: ' || trans.transaction_id);
                dbms_output.put_line('Transaction Date: ' || trans.transactions_date);
                dbms_output.put_line('Transaction Type: ' || trans.transactions_type);
                dbms_output.put_line('Amount: ' || trans.amount);
                dbms_output.put_line('Customer ID: ' || trans.customer_id);
                dbms_output.put_line('Equity ID: ' || trans.equity_id);
                dbms_output.put_line('First Name: ' || trans.first_name);
                dbms_output.put_line('Last Name: ' || trans.last_name);
                dbms_output.put_line('Email: ' || trans.email);
                dbms_output.put_line('-----------------------------');
            end loop;
    end if;
end;

begin
    transactionList(p_customer_id =>5, p_transaction_type => 'Buy');
end;

begin
    transactionList(p_customer_id =>5);
end;

begin
    transactionList(p_transaction_type => 'Buy');
end;

begin
    transactionList();
end;