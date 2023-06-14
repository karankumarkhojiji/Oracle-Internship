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
execute transactionlist(p_result=>:rc);
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
               sum(case
                       when t.transactions_type = 'Buy' and t.equity_id is not null then t.amount
                       else 0
                   end) as total_investment_amount_equity,
               sum(case
                       when t.transactions_type = 'Buy' and t.mf_id is not null then t.amount
                       else 0
                   end) as total_investment_amount_mf,
               sum(case
                       when t.transactions_type = 'Buy' and t.insurance_id is not null then t.amount
                       else 0
                   end) as total_investment_amount_insurance,
               sum(case
                       when t.transactions_type = 'Buy' then t.amount
                       else 0
                   end) as total_investment_amount,
               sum(case
                       when t.transactions_type = 'Sell' and (t.equity_id is not null or t.mf_id is not null) then
                           t.amount - (eq.quantity * er.closing_price)
                       else 0
                   end) as total_profit_loss,
               case
                   when sum(case when t.transactions_type = 'Buy' then t.amount else 0 end) <> 0
                       then (sum(case
                                     when t.transactions_type = 'Sell' then t.amount - (eq.quantity * er.closing_price)
                                     else 0 end) /
                             sum(case when t.transactions_type = 'Buy' then t.amount else 0 end)) * 100
                   else 0
                   end  as net_change_percentage
        from customers c
                 left join transactions t on c.customer_id = t.customer_id
                 left join equity_shares eq on t.equity_id = eq.equity_id
                 left join equity_rate er on eq.equity_id = er.equity_id
                 left join mf_master mf on t.mf_id = mf.mf_id
                 left join mf_rates mf_nav on t.mf_id = mf_nav.mf_id and t.transactions_date = mf_nav.rate_date
                 left join insurance_master im on t.insurance_id = im.insurance_id
        where t.equity_id is not null
           or t.mf_id is not null
           or t.insurance_id is not null
        group by c.customer_id,
                 c.first_name,
                 c.last_name
        order by total_investment_amount desc;
end;

var rc refcursor;
exec generate_portfolio_report(p_cursor => :rc);
print rc;