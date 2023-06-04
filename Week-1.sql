-- Customer Table

create table customers
(
    customer_id  number(10) primary key,
    first_name   varchar2(50) not null,
    last_name    varchar2(50) not null,
    email        varchar2(100) unique,
    phone_number varchar2(20) unique,
    address      varchar2(200),
    city         varchar2(50),
    state        varchar2(50),
    postal_code  varchar2(10),
    country      varchar2(50)
);

-- Finance Category Table

create table finance_category
(
    category_id   number(10) primary key,
    category_name varchar2(50) unique
);

-- Equity Shares Table

create table equity_shares
(
    equity_id          number(10) primary key,
    equity_name        varchar2(100) unique,
    equity_category_id number references finance_category (category_id),
    quantity           number         not null,
    purchase_date      date,
    purchase_price     decimal(10, 2) not null
);

-- Equity Rate

create table equity_rate
(
    rate_id       number(10) primary key,
    equity_id     number references equity_shares (equity_id),
    rate_date     date,
    closing_price decimal(10, 2)
);

-- Mutual Fund Master

create table mf_master
(
    mf_id           number(10) primary key,
    mf_name         varchar2(100) unique,
    mf_category_id  number references finance_category (category_id),
    fund_house      varchar2(100) not null,
    inception_price date          not null
);

-- Mutual Fund Rates

create table mf_rates
(
    rate_id   number(10) primary key,
    mf_id     number references mf_master (mf_id),
    rate_date date           not null,
    nav       decimal(10, 2) not null
);

-- Insurance Master Table

create table insurance_master
(
    insurance_id   number(10) primary key,
    policy_number  varchar2(50)   not null unique,
    insurance_type varchar2(50),
    premium_amount decimal(10, 2) not null,
    start_date     date,
    end_date       date
);

-- Transactions Table

create table transactions
(
    transaction_id    number(10) primary key,
    transactions_date date           not null,
    transactions_type varchar2(20)   not null,
    amount            decimal(10, 2) not null,
    customer_id       number(10) references customers (customer_id),
    equity_id         number(10) references equity_shares (equity_id),
    mf_id             number(10) references mf_master (mf_id),
    insurance_id      number(10) references insurance_master (insurance_id)
);



-- Customer Table Insert procedure

create or replace procedure insert_customer(p_customer customers%rowtype) is
begin
    insert into customers
    values p_customer;
end;

-- Customer Table Update procedure

create or replace procedure update_customer(p_customer customers%rowtype) is
begin
    update customers
    set first_name   = p_customer.first_name,
        last_name    = p_customer.last_name,
        email        = p_customer.email,
        phone_number = p_customer.phone_number,
        address      = p_customer.address,
        city         = p_customer.city,
        state        = p_customer.state,
        postal_code  = p_customer.postal_code,
        country      = p_customer.country
    where customer_id = p_customer.customer_id;
end;

-- Customer Table Delete procedure

create or replace procedure delete_customer(p_customer_id in customers.customer_id%type) is
begin
    delete
    from customers
    where customer_id = p_customer_id;
end;

-- Finance_Category table insert procedure

create or replace procedure insert_finance_category(p_category finance_category%rowtype) is
begin
    insert into finance_category values p_category;
end;

-- Finance_Category table update procedure

create or replace procedure update_finance_category(p_category finance_category%rowtype) is
begin
    update finance_category
    set category_name = p_category.category_name
    where category_id = p_category.category_id;
end;

-- Finance_Category table delete procedure

create or replace procedure delete_finance_category(p_category_id in finance_category.category_id%type) is
begin
    delete
    from finance_category
    where category_id = p_category_id;
end;

-- Equity_Share table insert procedure

create or replace procedure insert_equity_share(p_equity equity_shares%rowtype) is
begin
    insert into equity_shares
    values p_equity;
end;

-- Equity_Share table update procedure

create or replace procedure update_equity_share(p_equity equity_shares%rowtype) is
begin
    update equity_shares
    set equity_name        = p_equity.equity_name,
        equity_category_id = p_equity.equity_category_id,
        quantity           = p_equity.quantity,
        purchase_date      = p_equity.purchase_date,
        purchase_price     = p_equity.purchase_price
    where equity_id = p_equity.equity_id;
end;

-- Equity_Share table delete procedure

create or replace procedure delete_equity_share(p_equity_id in equity_shares.equity_id%type) is
begin
    delete from equity_shares where equity_id = p_equity_id;
end;

-- Equity_Rate table insert procedure

create or replace procedure insert_equity_rate(p_rate in equity_rate%rowtype) is
begin
    insert into equity_rate values p_rate;
end;

-- Equity_Rate table update procedure

create or replace procedure update_equity_rate(p_rate in equity_rate%rowtype) is
begin
    update equity_rate
    set equity_id     = p_rate.equity_id,
        rate_date     = p_rate.rate_date,
        closing_price = p_rate.closing_price
    where rate_id = p_rate.rate_id;
end;

-- Equity_Rate table delete procedure

create or replace procedure delete_equity_rate(p_rate_id in equity_rate.rate_id%type) is
begin
    delete
    from equity_rate
    where rate_id = p_rate_id;
end;

-- MF_Master table insert procedure

create or replace procedure insert_mf_master(p_mf_master in mf_master%rowtype) is
begin
    insert into mf_master values p_mf_master;
end;

-- MF_Master table update procedure

create or replace procedure update_mf_master(p_mf_master in mf_master%rowtype) is
begin
    update mf_master
    set mf_name         = p_mf_master.mf_name,
        mf_category_id  = p_mf_master.mf_category_id,
        fund_house      = p_mf_master.fund_house,
        inception_price = p_mf_master.inception_price
    where mf_id = p_mf_master.mf_id;
end;

-- MF_Master table delete procedure

create or replace procedure delete_mf_master(p_mf_master_id in mf_master.mf_id%type) is
begin
    delete
    from mf_master
    where mf_id = p_mf_master_id;
end;

-- MF_Rates table insert procedure

create or replace procedure insert_mf_rates(p_mf_rates in mf_rates%rowtype) is
begin
    insert into mf_rates values p_mf_rates;
end;

-- MF_Rates table update procedure

create or replace procedure update_mf_rates(p_mf_rates in mf_rates%rowtype) is
begin
    update mf_rates
    set mf_id     = p_mf_rates.mf_id,
        rate_date = p_mf_rates.rate_date,
        nav       = p_mf_rates.nav
    where rate_id = p_mf_rates.rate_id;
end;

-- MF_Rates table delete procedure

create or replace procedure delete_mf_rates(p_mf_rates_id in mf_rates.mf_id%type) is
begin
    delete
    from mf_rates
    where rate_id = p_mf_rates_id;
end;

-- Insurance_master table insert procedure

create or replace procedure insert_insurance_master(p_insurance_master in insurance_master%rowtype) is
begin
    insert into insurance_master values p_insurance_master;
end;

-- Insurance_master table update procedure

create or replace procedure update_insurance_master(p_insurance_master in insurance_master%rowtype) is
begin
    update insurance_master
    set policy_number  = p_insurance_master.policy_number,
        insurance_type = p_insurance_master.insurance_type,
        premium_amount = p_insurance_master.premium_amount,
        start_date     = p_insurance_master.start_date,
        end_date       = p_insurance_master.end_date
    where insurance_id = p_insurance_master.insurance_id;
end;

-- Insurance_master table delete procedure

create or replace procedure delete_insurance_master(p_insurance_master_id in insurance_master.insurance_id%type) is
begin
    delete
    from insurance_master
    where insurance_id = p_insurance_master_id;
end;

-- Transaction table insert procedure

create or replace procedure insert_transaction(p_transaction in transactions%rowtype) is
begin
    insert into transactions values p_transaction;
end;

-- Transaction table update procedure

create or replace procedure update_transaction(p_transaction in transactions%rowtype) is
begin
    update transactions
    set transactions_date = p_transaction.transactions_date,
        transactions_type = p_transaction.transactions_type,
        amount            = p_transaction.amount,
        customer_id       = p_transaction.customer_id,
        equity_id         = p_transaction.equity_id,
        mf_id             = p_transaction.mf_id,
        insurance_id      = p_transaction.insurance_id
    where insurance_id = p_transaction.insurance_id;
end;

-- Transaction table delete procedure

create or replace procedure delete_transaction(p_transaction_id in transactions.transaction_id%type) is
begin
    delete
    from transactions
    where transaction_id = p_transaction_id;
end;

-- Customer Table Sequence

create sequence customer_seq start with 1 increment by 1;

-- Equity_Share Table Sequence

create sequence equity_shares_seq start with 1 increment by 1;

-- Equity_Rate Table Sequence

create sequence equity_rate_seq start with 1 increment by 1;

-- Finance_Category Table Sequence

create sequence finance_category_seq start with 1 increment by 1;

-- MF_Master Table Sequence

create sequence mf_master_seq start with 1 increment by 1;

-- MF_Rates Table Sequence

create sequence mf_rates_seq start with 1 increment by 1;

-- Insurance_master Table Sequence

create sequence insurance_master_seq start with 1 increment by 1;

-- Transactions Table Sequence

create sequence transactions_seq start with 1 increment by 1;