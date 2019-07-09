alter table basket
   drop constraint fk_basket_goods_price_id;

alter table basket
   drop constraint fk_basket_user_id;

alter table category_goods
   drop constraint fk_cat_gds_cat_gds_id;

alter table goods_inherit_category
   drop constraint fk_gds_inhrt_cat_goods_id;

alter table goods_inherit_category
   drop constraint fk_gds_inhrt_cat_cat_gds_id;

alter table goods_price
   drop constraint fk_goods_price_goods_id;

alter table history_status_order
   drop constraint fk_histr_sts_ord_sts_ord_id;

alter table history_status_order
   drop constraint fk_history_status_order_id;

alter table order_detail
   drop constraint fk_ord_detail_gds_price_id;

alter table order_detail
   drop constraint fk_order_detail_order_id;

alter table orders
   drop constraint fk_order_user_id;

alter table orders
   drop constraint fk_order_status_order_id;

alter table rule_trans_status_order
   drop constraint fk_trans_s_ord_prev_s_ord_id;

alter table rule_trans_status_order
   drop constraint fk_trans_s_ord_foll_s_ord_id;

drop index i_basket_goods_price_id;

drop index i_basket_user_id;

drop table basket cascade constraints;

drop index i_cat_gds_parent_cat_gds_id;

drop table category_goods cascade constraints;

drop table client cascade constraints;

drop index i_goods_category_goods_id;

drop table goods cascade constraints;

drop index i_gds_inhrt_cat_cat_gds_id;

drop index i_gds_inhrt_cat_gds_id;

drop table goods_inherit_category cascade constraints;

drop index i_goods_price_goods_id;

drop table goods_price cascade constraints;

drop index i_histry_sts_ord_sts_ord_id;

drop index i_histry_sts_order_order_id;

drop table history_status_order cascade constraints;

drop index i_order_detail_gds_price_id;

drop index i_order_detail_order_id;

drop table order_detail cascade constraints;

drop index i_order_status_order_id;

drop index i_order_user_id;

drop table orders cascade constraints;

drop index i_r_trans_s_o_foll_s_o_id;

drop index i_r_trans_s_o_prev_s_o_id;

drop table rule_trans_status_order cascade constraints;

drop table status_order cascade constraints;

/*==============================================================*/
/* Table: basket                                                */
/*==============================================================*/
create table basket 
(
   basket_id            INTEGER              not null,
   client_id            INTEGER              not null,
   goods_price_id       INTEGER              not null,
   amount               INTEGER              not null,
   constraint PK_BASKET primary key (basket_id)
);

comment on table basket is
'Таблица корзина товаров.';

/*==============================================================*/
/* Index: i_basket_user_id                                      */
/*==============================================================*/
create index i_basket_user_id on basket (
   client_id ASC
);

/*==============================================================*/
/* Index: i_basket_goods_price_id                               */
/*==============================================================*/
create index i_basket_goods_price_id on basket (
   goods_price_id ASC
);

/*==============================================================*/
/* Table: category_goods                                        */
/*==============================================================*/
create table category_goods 
(
   category_goods_id    INTEGER              not null,
   parent_category_goods_id INTEGER,
   category_goods_name  VARCHAR2(200)        not null,
   order_by             INTEGER              not null,
   constraint PK_CATEGORY_GOODS primary key (category_goods_id)
);

comment on table category_goods is
'Таблица - справочник по категориям товара.';

comment on column category_goods.order_by is
'Поля для искусственного упорядочивания (сортировки).';

/*==============================================================*/
/* Index: i_cat_gds_parent_cat_gds_id                           */
/*==============================================================*/
create index i_cat_gds_parent_cat_gds_id on category_goods (
   parent_category_goods_id ASC
);

/*==============================================================*/
/* Table: client                                                */
/*==============================================================*/
create table client 
(
   client_id            INTEGER              not null,
   login                VARCHAR2(200)        not null,
   password             VARCHAR2(200)        not null,
   constraint PK_CLIENT primary key (client_id)
);

comment on table client is
'Таблица пользователей.';

/*==============================================================*/
/* Table: goods                                                 */
/*==============================================================*/
create table goods 
(
   goods_id             INTEGER              not null,
   goods_name           VARCHAR2(200)        not null,
   length               NUMBER,
   width                NUMBER,
   height               NUMBER,
   constraint PK_GOODS primary key (goods_id)
);

comment on table goods is
'Таблица товаров';

/*==============================================================*/
/* Index: i_goods_category_goods_id                             */
/*==============================================================*/
create index i_goods_category_goods_id on goods (
   
);

/*==============================================================*/
/* Table: goods_inherit_category                                */
/*==============================================================*/
create table goods_inherit_category 
(
   goods_inherit_category_id INTEGER              not null,
   goods_id             INTEGER              not null,
   category_goods_id    INTEGER              not null,
   constraint PK_GOODS_INHERIT_CATEGORY primary key (goods_inherit_category_id)
);

comment on table goods_inherit_category is
'Таблица, показывающая отношения товара к категориям.

Товар также может относиться к нескольким категориям.';

/*==============================================================*/
/* Index: i_gds_inhrt_cat_gds_id                                */
/*==============================================================*/
create index i_gds_inhrt_cat_gds_id on goods_inherit_category (
   goods_id ASC
);

/*==============================================================*/
/* Index: i_gds_inhrt_cat_cat_gds_id                            */
/*==============================================================*/
create index i_gds_inhrt_cat_cat_gds_id on goods_inherit_category (
   category_goods_id ASC
);

/*==============================================================*/
/* Table: goods_price                                           */
/*==============================================================*/
create table goods_price 
(
   goods_price_id       INTEGER              not null,
   goods_id             INTEGER              not null,
   price                NUMBER               not null,
   active_from          DATE                 not null,
   active_to            DATE                 default '01.01.4000' not null,
   constraint PK_GOODS_PRICE primary key (goods_price_id)
);

/*==============================================================*/
/* Index: i_goods_price_goods_id                                */
/*==============================================================*/
create index i_goods_price_goods_id on goods_price (
   goods_id ASC
);

/*==============================================================*/
/* Table: history_status_order                                  */
/*==============================================================*/
create table history_status_order 
(
   history_status_order_id INTEGER              not null,
   orders_id            INTEGER              not null,
   status_order_id      INTEGER              not null,
   active_from          DATE                 not null,
   active_to            DATE                 not null,
   constraint PK_HISTORY_STATUS_ORDER primary key (history_status_order_id)
);

comment on table history_status_order is
'Таблица, в которой хранится история статусов у заказа.';

/*==============================================================*/
/* Index: i_histry_sts_order_order_id                           */
/*==============================================================*/
create index i_histry_sts_order_order_id on history_status_order (
   orders_id ASC
);

/*==============================================================*/
/* Index: i_histry_sts_ord_sts_ord_id                           */
/*==============================================================*/
create index i_histry_sts_ord_sts_ord_id on history_status_order (
   status_order_id ASC
);

/*==============================================================*/
/* Table: order_detail                                          */
/*==============================================================*/
create table order_detail 
(
   order_detail_id      INTEGER              not null,
   orders_id            INTEGER              not null,
   goods_price_id       INTEGER              not null,
   amount               INTEGER              not null,
   constraint PK_ORDER_DETAIL primary key (order_detail_id)
);

comment on table order_detail is
'Таблица заказ подробно.';

/*==============================================================*/
/* Index: i_order_detail_order_id                               */
/*==============================================================*/
create index i_order_detail_order_id on order_detail (
   orders_id ASC
);

/*==============================================================*/
/* Index: i_order_detail_gds_price_id                           */
/*==============================================================*/
create index i_order_detail_gds_price_id on order_detail (
   goods_price_id ASC
);

/*==============================================================*/
/* Table: orders                                                */
/*==============================================================*/
create table orders 
(
   orders_id            INTEGER              not null,
   client_id            INTEGER              not null,
   status_order_id      INTEGER              not null,
   total_amount         NUMBER               not null,
   constraint PK_ORDERS primary key (orders_id)
);

comment on table orders is
'Таблица заказов.';

/*==============================================================*/
/* Index: i_order_user_id                                       */
/*==============================================================*/
create index i_order_user_id on orders (
   client_id ASC
);

/*==============================================================*/
/* Index: i_order_status_order_id                               */
/*==============================================================*/
create index i_order_status_order_id on orders (
   status_order_id ASC
);

/*==============================================================*/
/* Table: rule_trans_status_order                               */
/*==============================================================*/
create table rule_trans_status_order 
(
   rule_trans_status_order_id INTEGER              not null,
   prev_status_order_id INTEGER              not null,
   follow_status_order_id INTEGER              not null,
   constraint PK_RULE_TRANS_STATUS_ORDER primary key (rule_trans_status_order_id)
);

comment on table rule_trans_status_order is
'Таблица, которая показывает правила перехода у статуса заказа';

/*==============================================================*/
/* Index: i_r_trans_s_o_prev_s_o_id                             */
/*==============================================================*/
create index i_r_trans_s_o_prev_s_o_id on rule_trans_status_order (
   prev_status_order_id ASC
);

/*==============================================================*/
/* Index: i_r_trans_s_o_foll_s_o_id                             */
/*==============================================================*/
create index i_r_trans_s_o_foll_s_o_id on rule_trans_status_order (
   follow_status_order_id ASC
);

/*==============================================================*/
/* Table: status_order                                          */
/*==============================================================*/
create table status_order 
(
   status_order_id      INTEGER              not null,
   status_order_name    VARCHAR2(200)        not null,
   constraint PK_STATUS_ORDER primary key (status_order_id)
);

comment on table status_order is
'Таблица - справочник о статусе заказа.


Поле (name) может содержать в себе значения (выполнен, отменен, в пути):
1). done; 
2). canceled;
3). on_the_way.
';

alter table basket
   add constraint fk_basket_goods_price_id foreign key (goods_price_id)
      references goods_price (goods_price_id);

alter table basket
   add constraint fk_basket_user_id foreign key (client_id)
      references client (client_id);

alter table category_goods
   add constraint fk_cat_gds_cat_gds_id foreign key (parent_category_goods_id)
      references category_goods (category_goods_id);

alter table goods_inherit_category
   add constraint fk_gds_inhrt_cat_goods_id foreign key (goods_id)
      references goods (goods_id);

alter table goods_inherit_category
   add constraint fk_gds_inhrt_cat_cat_gds_id foreign key (category_goods_id)
      references category_goods (category_goods_id);

alter table goods_price
   add constraint fk_goods_price_goods_id foreign key (goods_id)
      references goods (goods_id);

alter table history_status_order
   add constraint fk_histr_sts_ord_sts_ord_id foreign key (status_order_id)
      references status_order (status_order_id);

alter table history_status_order
   add constraint fk_history_status_order_id foreign key (orders_id)
      references orders (orders_id);

alter table order_detail
   add constraint fk_ord_detail_gds_price_id foreign key (goods_price_id)
      references goods_price (goods_price_id);

alter table order_detail
   add constraint fk_order_detail_order_id foreign key (orders_id)
      references orders (orders_id);

alter table orders
   add constraint fk_order_user_id foreign key (client_id)
      references client (client_id);

alter table orders
   add constraint fk_order_status_order_id foreign key (status_order_id)
      references status_order (status_order_id);

alter table rule_trans_status_order
   add constraint fk_trans_s_ord_prev_s_ord_id foreign key (prev_status_order_id)
      references status_order (status_order_id);

alter table rule_trans_status_order
   add constraint fk_trans_s_ord_foll_s_ord_id foreign key (follow_status_order_id)
      references status_order (status_order_id);

	  
/* --------------------------- Код ниже создан мной --------------------------- */	  

/* Наполнение таблицы категории товаров (category_goods) */
create sequence category_goods_seq;
create sequence category_goods_orderby_seq;

insert into category_goods (category_goods_id, parent_category_goods_id, category_goods_name, order_by)
values (category_goods_seq.nextval, null, 'Одежда', category_goods_orderby_seq.nextval);

insert into category_goods (category_goods_id, parent_category_goods_id, category_goods_name, order_by)
values (category_goods_seq.nextval, 1, 'Обувь', category_goods_orderby_seq.nextval);

insert into category_goods (category_goods_id, parent_category_goods_id, category_goods_name, order_by)
values (category_goods_seq.nextval, 1, 'Брюки', category_goods_orderby_seq.nextval);

insert into category_goods (category_goods_id, parent_category_goods_id, category_goods_name, order_by)
values (category_goods_seq.nextval, 2, 'Зимняя обувь', category_goods_orderby_seq.nextval);

insert into category_goods (category_goods_id, parent_category_goods_id, category_goods_name, order_by)
values (category_goods_seq.nextval, 2, 'Летняя обувь', category_goods_orderby_seq.nextval);

insert into category_goods (category_goods_id, parent_category_goods_id, category_goods_name, order_by)
values (category_goods_seq.nextval, 4, 'Валенки', category_goods_orderby_seq.nextval);

insert into category_goods (category_goods_id, parent_category_goods_id, category_goods_name, order_by)
values (category_goods_seq.nextval, 4, 'Зимние ботинки', category_goods_orderby_seq.nextval);

insert into category_goods (category_goods_id, parent_category_goods_id, category_goods_name, order_by)
values (category_goods_seq.nextval, 5, 'Кроссовки', category_goods_orderby_seq.nextval);

insert into category_goods (category_goods_id, parent_category_goods_id, category_goods_name, order_by)
values (category_goods_seq.nextval, 5, 'Сандали', category_goods_orderby_seq.nextval);

insert into category_goods (category_goods_id, parent_category_goods_id, category_goods_name, order_by)
values (category_goods_seq.nextval, 5, 'Лапти', category_goods_orderby_seq.nextval);

insert into category_goods (category_goods_id, parent_category_goods_id, category_goods_name, order_by)
values (category_goods_seq.nextval, 3, 'Джинсы', category_goods_orderby_seq.nextval);

insert into category_goods (category_goods_id, parent_category_goods_id, category_goods_name, order_by)
values (category_goods_seq.nextval, 3, 'Подштанники', category_goods_orderby_seq.nextval);

insert into category_goods (category_goods_id, parent_category_goods_id, category_goods_name, order_by)
values (category_goods_seq.nextval, 11, 'Зауженные джинсы', category_goods_orderby_seq.nextval);

insert into category_goods (category_goods_id, parent_category_goods_id, category_goods_name, order_by)
values (category_goods_seq.nextval, 11, 'Джинсы с низкой посадкой', category_goods_orderby_seq.nextval);



/* Наполнение таблицы товаров (goods) */
CREATE SEQUENCE goods_seq;

INSERT INTO goods (goods_id, category_goods_id, goods_name, length, width, height)
VALUES (goods_seq.nextval, 4,);




