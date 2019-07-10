	  
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



/* Наполнение таблицы "товаров" (goods) */
create sequence goods_seq;

insert into goods (goods_id, goods_name, length, width, height)
values (goods_seq.nextval, 'Зимние ботинки Adidas', 22.10, 15.00, 23.50);

insert into goods (goods_id, goods_name, length, width, height)
values (goods_seq.nextval, 'Зимние ботинки Nike', 25.00, 15.00, 24.00);

insert into goods (goods_id, goods_name, length, width, height)
values (goods_seq.nextval, 'Кроссовки китайские Adidac', 25.00, 15.00, 10.00);

insert into goods (goods_id, goods_name, length, width, height)
values (goods_seq.nextval, 'Подштанники c петельками', null, 35.00, 60.50);

insert into goods (goods_id, goods_name, length, width, height)
values (goods_seq.nextval, 'Джинсы намеренно мятые', null, 35.00, 60.50);



/* Наполнение таблицы "цена товаров" (goods_price) */
create sequence goods_price_seq;

insert into goods_price (goods_price_id, goods_id, price, active_from)
values (goods_price_seq.nextval, 1, 6000, sysdate);

insert into goods_price (goods_price_id, goods_id, price, active_from)
values (goods_price_seq.nextval, 2, 6200, sysdate);

insert into goods_price (goods_price_id, goods_id, price, active_from)
values (goods_price_seq.nextval, 3, 1500, sysdate);

insert into goods_price (goods_price_id, goods_id, price, active_from)
values (goods_price_seq.nextval, 4, 150, sysdate);

insert into goods_price (goods_price_id, goods_id, price, active_from)
values (goods_price_seq.nextval, 5, 2590, sysdate);




/* Наполнение таблицы, показывающей отношение товара к категориям (goods_inherit_category) */
create sequence goods_inherit_category_seq;

insert into goods_inherit_category (goods_inherit_category_id, goods_id, category_goods_id)
values (goods_inherit_category_seq.nextval, 1, 7);

insert into goods_inherit_category (goods_inherit_category_id, goods_id, category_goods_id)
values (goods_inherit_category_seq.nextval, 2, 7);

insert into goods_inherit_category (goods_inherit_category_id, goods_id, category_goods_id)
values (goods_inherit_category_seq.nextval, 3, 8);

insert into goods_inherit_category (goods_inherit_category_id, goods_id, category_goods_id)
values (goods_inherit_category_seq.nextval, 4, 12);

insert into goods_inherit_category (goods_inherit_category_id, goods_id, category_goods_id)
values (goods_inherit_category_seq.nextval, 5, 14);




/* Создание последовательности для таблицы "пользователи" (users) */
create sequence users_seq;

insert into users (users_id, login, password)
values (users_seq.nextval, 'matthewk', 'matthewk');

insert into users (users_id, login, password)
values (users_seq.nextval, 'miroslav', 'miroslav');




/* Создание последовательности для таблицы "корзины" (basket) */
create sequence basket_seq;

insert into basket (basket_id, users_id, goods_price_id, amount)
values (basket_seq.nextval, 1, 1, 1);

insert into basket (basket_id, users_id, goods_price_id, amount)
values (basket_seq.nextval, 1, 4, 2);

insert into basket (basket_id, users_id, goods_price_id, amount)
values (basket_seq.nextval, 2, 5, 1);

insert into basket (basket_id, users_id, goods_price_id, amount)
values (basket_seq.nextval, 2, 3, 2);








