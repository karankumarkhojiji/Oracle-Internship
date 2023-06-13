-- Transactionlist procedure

create or replace type transaction_record as object
(
    transaction_id    number,
    transactions_date date,
    transactions_type varchar2(50),
    amount            number,
    first_name        varchar2(50),
    last_name         varchar2(50),
    email             varchar2(100),
    phone_number      varchar2(20)
);

create or replace procedure transactionlist(
    p_customer_id in customers.customer_id%type default null,
    p_transaction_type in transactions.transactions_type%type default null,
    p_result out sys_refcursor
) is
begin
    open p_result for
        select transaction_record(
                       t.transaction_id,
                       t.transactions_date,
                       t.transactions_type,
                       t.amount,
                       c.first_name,
                       c.last_name,
                       c.email,
                       c.phone_number
                   )
        from transactions t
                 join customers c on t.customer_id = c.customer_id
        where (p_customer_id is null or c.customer_id = p_customer_id)
          and (p_transaction_type is null or t.transactions_type = p_transaction_type);
end;

var rc refcursor;
execute transactionlist(p_result=>:rc)
print rc;


-- Alter customers table

alter table customers
    add customerid varchar2(50) unique;

-- Alter transaction table

alter table transactions
    add customerid varchar2(50) unique;

-- Generate portfolio report procedure

create or replace procedure generate_portfolio_report(p_cursor out sys_refcursor) as
begin
    open p_cursor for
        select c.customer_id,
               c.first_name,
               c.last_name,
               nvl(sum(case when t.transactions_type = 'Buy' and t.equity_id is not null then t.amount else 0 end),0)as total_investment_amount_equity,
               nvl(sum(eq.quantity * er.closing_price), 0) as total_equity_value,
               nvl(sum(case when t.transactions_type = 'Buy' and t.mf_id is not null then t.amount else 0 end),0) as total_investment_amount_mf,
               nvl(sum(case when t.transactions_type = 'Buy' and t.insurance_id is not null then t.amount else 0 end),0) as total_investment_amount_insurance,
               NVL(SUM(case when t.transactions_type = 'Buy' then t.amount else 0 end), 0) as total_investment_amount
        from customers c
                 left join transactions t on c.customer_id = t.customer_id
                 left join equity_shares eq on t.equity_id = eq.equity_id
                 left join equity_rate er on eq.equity_id = er.equity_id
                 left join mf_master mf on t.mf_id = mf.mf_id
        group by c.customer_id,
                 c.first_name,
                 c.last_name;
end;

var rc refcursor;
exec generate_portfolio_report(p_cursor => :rc);
print rc;
