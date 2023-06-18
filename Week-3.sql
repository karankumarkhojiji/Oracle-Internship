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

-- Generate portfolio report procedure

create or replace procedure generate_portfolio_report(p_cursor out sys_refcursor) as
begin
    open p_cursor for
        select c.customer_id,
               c.first_name,
               c.last_name,
               sum(case
                       when t.transactions_type = 'buy' and t.equity_id is not null then t.amount
                       else 0
                   end) as total_investment_amount_equity,
               sum(case
                       when t.transactions_type = 'buy' and t.mf_id is not null then t.amount
                       else 0
                   end) as total_investment_amount_mf,
               sum(case
                       when t.transactions_type = 'buy' and t.insurance_id is not null then t.amount
                       else 0
                   end) as total_investment_amount_insurance,
               sum(case
                       when t.transactions_type = 'buy' then t.amount
                       else 0
                   end) as total_investment_amount
        from customers c
                 left join transactions t on c.customer_id = t.customer_id
                 left join equity_shares eq on t.equity_id = eq.equity_id
                 left join mf_master mf on t.mf_id = mf.mf_id
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

-- Get_Equity_Details Procedure

create or replace procedure get_equity_details(
    p_customer_id in number,
    p_cursor out sys_refcursor
) is
begin
    open p_cursor for
        select es.equity_name,
               es.quantity                                          as quantity,
               (t.amount / es.quantity)                             as avg_cost,
               er.closing_price                                     as last_trading_price,
               t.amount                                             as invested_amount,
               (er.closing_price - es.purchase_price) * es.quantity as profit_loss,
               ((er.closing_price - es.purchase_price) * es.quantity) / (es.purchase_price * es.quantity) *
               100                                                  as net_change
        from equity_shares es
                 join (select er.equity_id, max(er.rate_date) as max_rate_date
                       from equity_rate er
                       group by er.equity_id) er_max on er_max.equity_id = es.equity_id
                 join equity_rate er on er.equity_id = es.equity_id and er.rate_date = er_max.max_rate_date
                 left join (select equity_id
                            from transactions
                            where customer_id = p_customer_id
                              and transactions_type = 'sell') t_sell on t_sell.equity_id = es.equity_id
                 left join transactions t on t.equity_id = es.equity_id
            and t.customer_id = p_customer_id
            and t.transactions_type = 'buy'
        where t.customer_id = p_customer_id
          and t.equity_id is not null
          and t_sell.equity_id is null;
end;

var rc refcursor;
exec get_equity_details(p_customer_id => 1,p_cursor => :rc);
print rc;

-- Get_Sold_Equity_Details Procedure

create or replace procedure get_sold_equity_details(
    p_customer_id in number,
    p_cursor out sys_refcursor
) is
begin
    open p_cursor for
        select es.equity_name,
               es.quantity                                               as quantity,
               (t_buy.amount / es.quantity)                              as avg_cost,
               er_sell.closing_price                                     as last_trading_price,
               t_buy.amount                                              as invested_amount,
               (er_sell.closing_price - es.purchase_price) * es.quantity as profit_loss,
               ((er_sell.closing_price - es.purchase_price) * es.quantity) / (es.purchase_price * es.quantity) *
               100                                                       as net_change
        from equity_shares es
                 join (select equity_id
                       from transactions
                       where customer_id = p_customer_id
                         and transactions_type = 'buy') sold_equities on sold_equities.equity_id = es.equity_id
                 join (select equity_id, max(rate_date) as max_sell_date
                       from equity_rate
                       where equity_id in (select equity_id
                                           from transactions
                                           where customer_id = p_customer_id
                                             and transactions_type = 'sell')
                       group by equity_id) er_sell_max on er_sell_max.equity_id = es.equity_id
                 join equity_rate er_sell
                      on er_sell.equity_id = es.equity_id and er_sell.rate_date = er_sell_max.max_sell_date
                 join transactions t_buy on t_buy.equity_id = es.equity_id
            and t_buy.customer_id = p_customer_id
            and t_buy.transactions_type = 'buy'
        where exists (select 1
                      from transactions
                      where equity_id = es.equity_id
                        and customer_id = p_customer_id
                        and transactions_type = 'sell');
end;

var rc refcursor;
exec get_sold_equity_details(p_customer_id => 1,p_cursor => :rc);
print rc;