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


-- Customer Table procedure

create or replace procedure manage_customer(p_operation in varchar2, p_customer customers%rowtype) is
begin
    if lower(p_operation)  = 'insert' then
        insert into customers
        values p_customer;
    elsif lower(p_operation) = 'update' then
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
    elsif lower(p_operation) = 'delete' then
        delete
        from customers
        where customer_id = p_customer.customer_id;
    else
        DBMS_OUTPUT.PUT_LINE('Invalid operation provided. Valid operations are insert, update, and delete.');
    end if;
end;


-- Finance_Category table procedure

create or replace procedure manage_finance_category(p_operation in varchar2, p_category finance_category%rowtype) is
begin
    if lower(p_operation) = 'insert' then
        insert into finance_category
        values p_category;
    elsif lower(p_operation) = 'update' then
        update finance_category
        set category_name = p_category.category_name
        where category_id = p_category.category_id;
    elsif lower(p_operation) = 'delete' then
        delete
        from finance_category
        where category_id = p_category.category_id;
    else
        DBMS_OUTPUT.PUT_LINE('Invalid operation provided. Valid operations are insert, update, and delete.');
    end if;
end;


-- Equity_Share table procedure

create or replace procedure manage_equity_share(p_operation in varchar2, p_equity equity_shares%rowtype) is
begin
    if lower(p_operation) = 'insert' then
        insert into equity_shares
        values p_equity;
    elsif lower(p_operation) = 'update' then
        update equity_shares
        set equity_name        = p_equity.equity_name,
            equity_category_id = p_equity.equity_category_id,
            quantity           = p_equity.quantity,
            purchase_date      = p_equity.purchase_date,
            purchase_price     = p_equity.purchase_price
        where equity_id = p_equity.equity_id;
    elsif lower(p_operation) = 'delete' then
        delete
        from equity_shares
        where equity_id = p_equity.equity_id;
    else
        DBMS_OUTPUT.PUT_LINE('Invalid operation provided. Valid operations are insert, update, and delete.');
    end if;
end;


-- Equity_Rate table procedure

create or replace procedure manage_equity_rate(p_operation in varchar2, p_rate in equity_rate%rowtype) is
begin
    if lower(p_operation) = 'insert' then
        insert into equity_rate
        values p_rate;
    elsif lower(p_operation) = 'update' then
        update equity_rate
        set equity_id     = p_rate.equity_id,
            rate_date     = p_rate.rate_date,
            closing_price = p_rate.closing_price
        where rate_id = p_rate.rate_id;
    elsif lower(p_operation) = 'delete' then
        delete
        from equity_rate
        where rate_id = p_rate.rate_id;
    else
        DBMS_OUTPUT.PUT_LINE('Invalid operation provided. Valid operations are insert, update, and delete.');
    end if;
end;


-- MF_Master table procedure

create or replace procedure manage_mf_master(p_operation in varchar2, p_mf_master in mf_master%rowtype) is
begin
    if lower(p_operation) = 'insert' then
        insert into mf_master
        values p_mf_master;
    elsif lower(p_operation) = 'update' then
        update mf_master
        set mf_name         = p_mf_master.mf_name,
            mf_category_id  = p_mf_master.mf_category_id,
            fund_house      = p_mf_master.fund_house,
            inception_price = p_mf_master.inception_price
        where mf_id = p_mf_master.mf_id;
    elsif lower(p_operation) = 'delete' then
        delete from mf_master
        where mf_id = p_mf_master.mf_id;
    else
        DBMS_OUTPUT.PUT_LINE('Invalid operation provided. Valid operations are insert, update, and delete.');
    end if;
end;


-- MF_Rates table procedure

create or replace procedure manage_mf_rates(p_operation in varchar2, p_mf_rates in mf_rates%rowtype) is
begin
    if lower(p_operation) = 'insert' then
        insert into mf_rates
        values p_mf_rates;
    elsif lower(p_operation) = 'update' then
        update mf_rates
        set mf_id     = p_mf_rates.mf_id,
            rate_date = p_mf_rates.rate_date,
            nav       = p_mf_rates.nav
        where rate_id = p_mf_rates.rate_id;
    elsif lower(p_operation) = 'delete' then
        delete from mf_rates
        where rate_id = p_mf_rates.rate_id;
    else
        DBMS_OUTPUT.PUT_LINE('Invalid operation provided. Valid operations are insert, update, and delete.');
    end if;
end;


-- Insurance_master table procedure

create or replace procedure manage_insurance_master(p_operation in varchar2, p_insurance_master in insurance_master%rowtype) is
begin
    if lower(p_operation) = 'insert' then
        insert into insurance_master
        values p_insurance_master;
    elsif lower(p_operation) = 'update' then
        update insurance_master
        set policy_number  = p_insurance_master.policy_number,
            insurance_type = p_insurance_master.insurance_type,
            premium_amount = p_insurance_master.premium_amount,
            start_date     = p_insurance_master.start_date,
            end_date       = p_insurance_master.end_date
        where insurance_id = p_insurance_master.insurance_id;
    elsif lower(p_operation) = 'delete' then
        delete from insurance_master
        where insurance_id = p_insurance_master.insurance_id;
    else
        DBMS_OUTPUT.PUT_LINE('Invalid operation provided. Valid operations are insert, update, and delete.');
    end if;
end;


-- Transaction table procedure

create or replace procedure manage_transaction(p_operation in varchar2, p_transaction in transactions%rowtype) is
begin
    if lower(p_operation) = 'insert' then
        insert into transactions
        values p_transaction;
    elsif lower(p_operation) = 'update' then
        update transactions
        set transactions_date = p_transaction.transactions_date,
            transactions_type = p_transaction.transactions_type,
            amount            = p_transaction.amount,
            customer_id       = p_transaction.customer_id,
            equity_id         = p_transaction.equity_id,
            mf_id             = p_transaction.mf_id,
            insurance_id      = p_transaction.insurance_id
        where transaction_id = p_transaction.transaction_id;
    elsif lower(p_operation) = 'delete' then
        delete from transactions
        where transaction_id = p_transaction.transaction_id;
    else
        DBMS_OUTPUT.PUT_LINE('Invalid operation provided. Valid operations are insert, update, and delete.');
    end if;
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