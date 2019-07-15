/* Создание спецификации пакета */
create or replace package pkg_goods is

  procedure get_info_tree_cat_goods (refcur out sys_refcursor);


  procedure get_info_goods_from_id_cat (p_category_goods_id  in   integer, 
										refcur               out  sys_refcursor);
                      
                      
  procedure get_info_goods_from_id_cat_v2 (p_category_goods_id  in   integer, 
										   refcur               out  sys_refcursor); 
                   
  
  procedure get_info_goods (p_goods_id  in   integer, 
							refcur      out  sys_refcursor);
                
                
  procedure add_goods_to_basket (p_users_id       in integer, 
								 p_goods_price_id in integer,
								 p_amount         in integer);
                   
end pkg_goods;




/* Создание тела пакета */
create or replace package body pkg_goods is

	/* 1. Процедура, а в ней курсор, который отдает иерархический список категорий, начиная с тех, в которых есть товары с заведенной стоимостью. 
	Иерархический список категорий следующий: 
	ИД категории
	ИД родительской категории
	Название
	Флаг, который показывает является ли узел листом */

	procedure get_info_tree_cat_goods (refcur out sys_refcursor) 
	is

	begin

	  open refcur for
		/* Если в категори хотя бы один товар имееет цену, а все остальные не имеют, то вывести эту категорию */
		select
		  level, /* Уровень иерархии */
		  category_goods_id,
		  parent_category_goods_id,
		  category_goods_name,
		  connect_by_isleaf "Лист дерева?" /* 0 - если не лист иерархии, 1 - если лист иерархии  */
		from
		  category_goods
		where
		  category_goods_id in (
								select distinct
								  category_goods.category_goods_id
								from
								  goods_price,
								  goods,
								  goods_inherit_category,
								  category_goods
								where
								  goods_price.goods_id = goods.goods_id and
								  goods.goods_id = goods_inherit_category.goods_id and 
								  goods_inherit_category.category_goods_id = category_goods.category_goods_id and
								  goods_price.price is not null)
		start with 
		  parent_category_goods_id is null
		connect by 
		  prior category_goods_id = parent_category_goods_id;
	  
	end get_info_tree_cat_goods;

  /* 2. Процедура, а вней курсор, который показывает товар, если ввести ИД категории непосредственно, 
  то есть, если вводится ИД категории самого первого уровня, то данный курсор не проходит по всем дочерним элементам.
  Курсор, оторый по ИД категории отдает список:  
  ИД товара, 
  Название товара,
  Текущая цена */
  procedure get_info_goods_from_id_cat (p_category_goods_id  in   integer, 
                                        refcur               out  sys_refcursor) 
  is

  begin

    open refcur for
    select
      goods.goods_id,
      goods.goods_name,
      goods_price.price
    from
      category_goods,
      goods_inherit_category, 
      goods, 
      goods_price
    where
      category_goods.category_goods_id = p_category_goods_id and
      category_goods.category_goods_id = goods_inherit_category.category_goods_id and
      goods_inherit_category.goods_id = goods.goods_id and
      goods.goods_id = goods_price.goods_id and
      (sysdate between goods_price.active_from and goods_price.active_to); /* Цена товара должна попадать в промежуток времени */
    
  end get_info_goods_from_id_cat;
  
  
  
  /* 2. Версия 2 (Если вводится ИД категории самого первого уровня, то пройти по всем дочерним элементам).
  Процедура, а вней курсор, который по ИД категории отдает список:  
  ИД товара, 
  Название товара,
  Текущая цена */
  procedure get_info_goods_from_id_cat_v2 (p_category_goods_id  in   integer, 
                                           refcur               out  sys_refcursor) 
  is

  begin

    open refcur for
    select
      goods.goods_id,
      goods.goods_name,
      goods_price.price
    from
      category_goods,
      goods_inherit_category, 
      goods, 
      goods_price
    where
      category_goods.category_goods_id in (select
												category_goods_id
											from
												category_goods
											start with 
												parent_category_goods_id = p_category_goods_id
											connect by 
												prior category_goods_id = parent_category_goods_id) and
      category_goods.category_goods_id = goods_inherit_category.category_goods_id and
      goods_inherit_category.goods_id = goods.goods_id and
      goods.goods_id = goods_price.goods_id and
      (sysdate between goods_price.active_from and goods_price.active_to); /* Цена товара должна попадать в промежуток времени */
    
  end get_info_goods_from_id_cat_v2;
  
  
  
  /* 3.Процедура, а вней курсор, который по ИД товара одает данные: 
  название товара, 
  текущая цена товара,
  длинна товара,
  ширина ширина,
  высота товара. */
  procedure get_info_goods (p_goods_id  in   integer, 
                            refcur      out  sys_refcursor) 
  is

  begin

    open refcur for
    select
      goods.goods_name,
      goods_price.price,
      goods.length,
      goods.width,
      goods.height
    from 
      goods, 
      goods_price
    where
      goods.goods_id = p_goods_id and
      goods.goods_id = goods_price.goods_id and
      (sysdate between goods_price.active_from and goods_price.active_to); /* Цена товара должна попадать в промежуток времени */
    
  end get_info_goods;
  
  
  /* 4. Процедура, которая добавляет товар в корзину */
  procedure add_goods_to_basket (p_users_id       in integer, 
                                 p_goods_price_id in integer,
                                 p_amount         in integer) 
  is

  begin

    insert into basket (basket_id, users_id, goods_price_id, amount)
    values (basket_seq.nextval, p_users_id, p_goods_price_id, p_amount);
    
  end add_goods_to_basket;


end pkg_goods;






/* Вызов процедур из пакета -----------------------------------------------------------------------------------------*/

/* Вызов процедуры "get_info_tree_cat_goods" из пакета между begin и end */
declare
  tmp$cur sys_refcursor;
  level integer;
  category_goods_id integer;
  parent_category_goods_id integer;
  category_goods_name varchar2(200);
  connect_by_isleaf integer;
begin

  /* Вызов происходит здесь! */
  pkg_goods.get_info_tree_cat_goods (tmp$cur);

  loop
    fetch 
      tmp$cur
    into  
      level, category_goods_id, parent_category_goods_id, category_goods_name, connect_by_isleaf;
    
    exit when tmp$cur%notfound;
    
    dbms_output.put_line('Уровень: ' || level ||
						 '       ИД категории товара: ' || category_goods_id ||
						 ',        Родительский ИД  у категории товара: ' || parent_category_goods_id ||
						 ',        Название категории товара: ' || category_goods_name ||
						 ',        Является ли листом?: ' || connect_by_isleaf);
  end loop;
end;



/* Вызов процедуры "get_info_goods_from_id_cat" из пакета между begin и end */
declare
  tmp$cur sys_refcursor;
  goods_id integer;
  goods_name varchar2(200);
  price number;
begin

  /* Вызов происходит здесь! */
  pkg_goods.get_info_goods_from_id_cat (7,tmp$cur);

  loop
    fetch 
      tmp$cur
    into  
      goods_id, goods_name, price;
    
    exit when tmp$cur%notfound;
    
    dbms_output.put_line('ИД товара: ' || goods_id ||
						 ',        Название товара: ' || goods_name ||
						 ',        текущая цена товара: ' || price);
  end loop;
end;



/* Вызов процедуры "get_info_goods_from_id_cat_v2" из пакета между begin и end */
declare
  tmp$cur sys_refcursor;
  goods_id integer;
  goods_name varchar2(200);
  price number;
begin

  /* Вызов происходит здесь! */
  pkg_goods.get_info_goods_from_id_cat_v2 (2, tmp$cur); /* Если ввести в первый параметр аргумент 2, то выведутся вся обувь. А если ввести в первый параметр аргумент 3, то выведется все штаны. */

  loop
    fetch 
      tmp$cur
    into  
      goods_id, goods_name, price;
    
    exit when tmp$cur%notfound;
    
    dbms_output.put_line('ИД товара: ' || goods_id ||
						 ',        Название товара: ' || goods_name ||
						 ',        текущая цена товара: ' || price);
  end loop;
end;



/* Вызов процедуры "get_info_goods" из пакета между begin и end */
declare
  tmp$cur sys_refcursor;
  goods_name varchar2(200);
  price varchar2(200);
  length varchar2(200);
  width varchar2(200);
  height varchar2(200);
begin

  /* Вызов происходит здесь! */
  pkg_goods.get_info_goods (2, tmp$cur);

  loop
    fetch 
      tmp$cur
    into  
      goods_name, price, length, width, height;
    
    exit when tmp$cur%notfound;
    
    dbms_output.put_line('Название товара: ' || goods_name ||
						 ',        текущая цена товара: ' || price || 
						 ',        длина товара: ' || length || 
						 ',        ширина товара: ' || width || 
						 ',        высота товара: ' || height);
  end loop;
end;



/* Вызов процедуры "add_goods_to_basket" из пакета */
exec pkg_goods.add_goods_to_basket(1, 1, 2);