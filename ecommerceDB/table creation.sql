use ecommerce;
create table IF NOT EXISTS supplier(
SUPP_ID int primary key auto_increment,
SUPP_NAME varchar(50) NOT NULL,
SUPP_CITY varchar(50),
SUPP_PHONE VARCHAR(10) NOT NULL
);
create table IF NOT EXISTS customer(
CUS_ID int primary key auto_increment,
CUS_NAME varchar(20) NOT NULL,
CUS_PHONE varchar(10) NOT NULL,
CUS_CITY VARCHAR(30) NOT NULL,
CUS_GENDER char
);
create table if not exists category(
CAT_ID int primary key auto_increment,
CAT_NAME VARCHAR(20) NOT NULL
);
create table if not exists product(
PRO_ID int primary key auto_increment,
PRO_NAME VARCHAR(20) NOT NULL default "dummy",
PRO_DESC VARCHAR(60),
CAT_ID int,
foreign key (CAT_ID) references category(CAT_ID)
);
create table if not exists supplier_pricing(
PRICING_ID int primary key auto_increment,
PRO_ID int,
SUPP_ID int,
SUPP_PRICE int default 0,
foreign key (PRO_ID) references product(PRO_ID),
foreign key(SUPP_ID) references supplier(SUPP_ID)
);
create table if not exists order_table(
ORD_ID int primary key auto_increment,
ORD_AMOUNT int NOT NULL,
ORD_DATE date NOT NULL,
CUS_ID int,
PRICING_ID int,
foreign key(CUS_ID) references customer(CUS_ID),
foreign key(PRICING_ID) references supplier_pricing(PRICING_ID)
);
create table if not exists rating(
RAT_ID int primary key auto_increment,
ORD_ID int,
RAT_RATSTARS int NOT NULL,
foreign key(ORD_ID) references order_table(ORD_ID)
);
