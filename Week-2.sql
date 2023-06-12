create or replace procedure transactionlist(
    p_customer_id in customers.customer_id%type default null,
    p_transaction_type in transactions.transactions_type%type default null,
    p_result out sys_refcursor
) is
begin
    open p_result for
        select t.transaction_id, t.transactions_date, t.transactions_type, t.amount,
               c.first_name, c.last_name, c.email, c.phone_number
        from transactions t
        join customers c on t.customer_id = c.customer_id
        where (p_customer_id is null or c.customer_id = p_customer_id)
          and (p_transaction_type is null or t.transactions_type = p_transaction_type);
end;

var rc refcursor;
execute transactionlists(p_result=>:rc);
print rc;


-- Alter customers table

alter table customers
    add customerid varchar2(50) unique;

-- Alter transaction table

alter table transactions
    add customerid varchar2(50) unique;