/* 4. Хранимая процедура, которая добавляет товар в корзину  */
create or replace procedure add_goods_to_basket (p_users_id       in integer, 
												 p_goods_price_id in integer,
												 p_amount         in integer) 
is

begin

	insert into basket (basket_id, users_id, goods_price_id, amount)
	values (basket_seq.nextval, p_users_id, p_goods_price_id, p_amount);
	
end add_goods_to_basket;


/* Вызов хранимой процедуры */
exec add_goods_to_basket (1, 1, 2);



/* 3. Версия 1. 
Курсор, который по ИД товара одает данные: 
название товара, 
текущая цена товара,
длинна товара,
ширина ширина,
высота товара. */
declare
	v_goods_id     goods.goods_id%type;
	v_goods_name  goods.goods_name%type;
	v_price       goods_price.price%type;
	v_length      goods.length%type;
	v_width       goods.width%type;
	v_height      goods.height%type;
	
	cursor cursor_goods_info(v_id goods.goods_id%type) is
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
			goods.goods_id = goods_price.goods_id and
			goods.goods_id = v_id and
			sysdate between goods_price.active_from and goods_price.active_to; /* Цена товара должна попадать в промежуток времени */
begin

	v_goods_id := 1;
	
	open cursor_goods_info(v_goods_id);

		fetch 
			cursor_goods_info 
		into 
			v_goods_name, v_price, v_length, v_width, v_height;
			
		dbms_output.put_line(v_goods_name || ', ' || v_price || ', ' || v_length || ', ' || v_width || ', ' || v_height);
	
	close cursor_goods_info;
end;



/* 3. Версия 2. Выводит 2-е последние записи.  
Курсор, который по ИД товара одает данные: 
название товара, 
текущая цена товара,
длинна товара,
ширина ширина,
высота товара. */
declare
  
  cursor cursor_goods_info(v_id goods.goods_id%type) is
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
      goods.goods_id = goods_price.goods_id and
      goods.goods_id = v_id and
      sysdate between goods_price.active_from and goods_price.active_to; /* Цена товара должна попадать в промежуток времени */
      
      
  v_сursor_goods_info  cursor_goods_info%ROWTYPE;
  v_goods_id            goods.goods_id%type;
begin
  
  v_goods_id := 1;
  
  open cursor_goods_info(v_goods_id);
  
  loop
  
    exit when (cursor_goods_info%notfound);
	
    fetch 
      cursor_goods_info 
    into 
      v_сursor_goods_info;
      
    dbms_output.put_line('Название товара: ' ||  v_сursor_goods_info.goods_name ||
						 ',        текущая цена товара: ' || v_сursor_goods_info.price || 
						 ',        длина товара: ' || v_сursor_goods_info.length || 
						 ',        ширина товара: ' || v_сursor_goods_info.width || 
						 ',        высота товара: ' || v_сursor_goods_info.height);
						 
  end loop;
                
  close cursor_goods_info;
end;



/* 3. Версия 3. Изменяем цикл, а именно "exit" помещаем после "fetch".  
Курсор, который по ИД товара одает данные: 
название товара, 
текущая цена товара,
длинна товара,
ширина ширина,
высота товара. */
declare
  
  cursor cursor_goods_info(v_id goods.goods_id%type) is
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
      goods.goods_id = v_id and
      goods.goods_id = goods_price.goods_id and
      (sysdate between goods_price.active_from and goods_price.active_to); /* Цена товара должна попадать в промежуток времени */
      

  v_сursor_goods_info  cursor_goods_info%ROWTYPE;
  v_goods_id            goods.goods_id%type;
begin
  
  v_goods_id := 1;
  
  open cursor_goods_info(v_goods_id);
  
  loop
  
    fetch 
      cursor_goods_info 
    into 
      v_сursor_goods_info;
      
    exit when (cursor_goods_info%notfound); 
      
    dbms_output.put_line('Название товара: ' ||  v_сursor_goods_info.goods_name ||
						 ',        текущая цена товара: ' || v_сursor_goods_info.price || 
						 ',        длина товара: ' || v_сursor_goods_info.length || 
						 ',        ширина товара: ' || v_сursor_goods_info.width || 
						 ',        высота товара: ' || v_сursor_goods_info.height);
            
  end loop;
                
  close cursor_goods_info;
end;



/* 3. Версия 4. Помещаем курсор в процедуру ---------------------------------------  
Курсор, который по ИД товара одает данные: 
название товара, 
текущая цена товара,
длинна товара,
ширина ширина,
высота товара. */
create or replace procedure get_info_goods (p_goods_id  in   integer, 
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


/* Вызов процедуры между begin и end */
declare
  tmp$cur sys_refcursor;
  goods_name varchar2(200);
  price varchar2(200);
  length varchar2(200);
  width varchar2(200);
  height varchar2(200);
begin

  /* Вызов происходит здесь! */
  get_info_goods (2, tmp$cur);

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






/* 2. Версия 1. 
Показывает товар, если ввести ИД категории непосредственно, то есть, если вводится ИД категории самого первого уровня, то данный курсор не проходит по всем дочерним элементам.
Курсор, оторый по ИД категории отдает список:  
ИД товара, 
Название товара,
Текущая цена */
declare
  
  cursor cursor_goods_info(v_id goods_inherit_category.goods_inherit_category_id%type) is
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
      category_goods.category_goods_id = v_id and
      category_goods.category_goods_id = goods_inherit_category.category_goods_id and
      goods_inherit_category.goods_id = goods.goods_id and
      goods.goods_id = goods_price.goods_id and
      (sysdate between goods_price.active_from and goods_price.active_to); /* Цена товара должна попадать в промежуток времени */
       
      
      
  v_сursor_goods_info  cursor_goods_info%ROWTYPE;
  v_category_goods_id  goods.goods_id%type;
begin
  
  v_category_goods_id := 3;
  
  open cursor_goods_info(v_category_goods_id);
  
  loop
  
    fetch 
      cursor_goods_info 
    into 
      v_сursor_goods_info;
      
    exit when (cursor_goods_info%notfound); 
      
    dbms_output.put_line('ИД товара: ' ||  v_сursor_goods_info.goods_id ||
             ',        Название товара: ' ||  v_сursor_goods_info.goods_name ||
             ',        текущая цена товара: ' || v_сursor_goods_info.price);
            
  end loop;
                
  close cursor_goods_info;
end;




/* 2. Версия 2. Помещаем курсор в процедуру --------------------------------------- 
Показывает товар, если ввести ИД категории непосредственно, то есть, если вводится ИД категории самого первого уровня, то данный курсор не проходит по всем дочерним элементам.
Курсор, оторый по ИД категории отдает список:  
ИД товара, 
Название товара,
Текущая цена */
create or replace procedure get_info_goods_from_id_cat (p_category_goods_id  in   integer, 
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


/* Вызов процедуры между begin и end */
declare
  tmp$cur sys_refcursor;
  goods_id integer;
  goods_name varchar2(200);
  price number;
begin

  /* Вызов происходит здесь! */
  get_info_goods_from_id_cat (7,tmp$cur);

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



/* 2. Версия 3. 
Если вводится ИД категории самого первого уровня, то пройти по всем дочерним элементам.
Курсор, оторый по ИД категории отдает список:  
ИД товара, 
Название товара,
Текущая цена */
/*select
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
										parent_category_goods_id = 2
									  connect by 
										prior category_goods_id = parent_category_goods_id) and
  category_goods.category_goods_id = goods_inherit_category.category_goods_id and
  goods_inherit_category.goods_id = goods.goods_id and
  goods.goods_id = goods_price.goods_id and
  (sysdate between goods_price.active_from and goods_price.active_to);
*/
create or replace procedure get_info_goods_from_id_cat_v2 (p_category_goods_id  in   integer, 
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


/* Вызов процедуры между begin и end */
declare
  tmp$cur sys_refcursor;
  goods_id integer;
  goods_name varchar2(200);
  price number;
begin

  /* Вызов происходит здесь! */
  get_info_goods_from_id_cat_v2 (2, tmp$cur); /* Если ввести в первый параметр аргумент 2, то выведутся вся обувь. А если ввести в первый параметр аргумент 3, то выведется все штаны. */

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





/* 1. Версия 1. 
Отдает иерархический список категорий, начиная с тех, в которых есть товары с заведенной стоимостью. 
Иерархический список категорий следующий: 
ИД категории
ИД родительской категории
Название
Флаг, который показывает является ли узел листом */
declare
  
  cursor cursor_category_info is
    select
    category_goods_id,
    parent_category_goods_id,
    category_goods_name
  from
    category_goods;
       
      
      
  v_cursor_category_info        cursor_category_info%ROWTYPE;
  v_count_category_goods_id     integer;
begin
  
  
  /* Возможно, можно использовать представленя */
  /* exists или not exists */
  /* агрегатная функция count*/
  
  
  
  open cursor_category_info;
  
  loop
  
    fetch 
      cursor_category_info 
    into 
      v_cursor_category_info;
      
    exit when (cursor_category_info%notfound); 
  
  
    /* Если count(category_goods_id) = 0, то запись в таблице является листом */
    select
      count(category_goods_id)
    into 
      v_count_category_goods_id
    from
      category_goods
    where 
      parent_category_goods_id = v_cursor_category_info.category_goods_id;
      
      
    if (v_count_category_goods_id <> 0) then
      dbms_output.put_line('ИД товара: ' ||  v_cursor_category_info.category_goods_id ||
						   ',        ИД родительской категории: ' ||  v_cursor_category_info.parent_category_goods_id ||
						   ',        Название: ' || v_cursor_category_info.category_goods_name|| 
						   ',        является листом: нет');
    else 
      dbms_output.put_line('ИД товара: ' ||  v_cursor_category_info.category_goods_id ||
							 ',        ИД родительской категории: ' ||  v_cursor_category_info.parent_category_goods_id ||
							 ',        Название: ' || v_cursor_category_info.category_goods_name || 
							 ',        является листом: да');
    end if;
  
  end loop;
                
  close cursor_category_info;
end;



/* 1. Версия 2. Исправлено тело условия, чтобы не было повторяющегося куска кода.
Отдает иерархический список категорий, начиная с тех, в которых есть товары с заведенной стоимостью. 
Иерархический список категорий следующий: 
ИД категории
ИД родительской категории
Название
Флаг, который показывает является ли узел листом */
declare
  
  cursor cursor_category_info is
    select
      category_goods_id,
      parent_category_goods_id,
      category_goods_name
    from
      category_goods;
       
      
      
  v_cursor_category_info        cursor_category_info%ROWTYPE;
  v_count_category_goods_id     integer;
begin
  
  
  /* Возможно, можно использовать представленя */
  /* exists или not exists */
  /* агрегатная функция count*/
  
  open cursor_category_info;
  
  loop
  
    fetch 
      cursor_category_info 
    into 
      v_cursor_category_info;
      
    exit when (cursor_category_info%notfound); 
  
  
    /* Если count(category_goods_id) = 0, то запись в таблице является листом */
    select
      count(category_goods_id)
    into 
      v_count_category_goods_id
    from
      category_goods
    where 
      parent_category_goods_id = v_cursor_category_info.category_goods_id;
      
    dbms_output.put('ИД товара: ' ||  v_cursor_category_info.category_goods_id ||
				   ',        ИД родительской категории: ' ||  v_cursor_category_info.parent_category_goods_id ||
				   ',        Название: ' || v_cursor_category_info.category_goods_name);
      
    if (v_count_category_goods_id <> 0) then
      dbms_output.put(',        является листом: нет');
    else 
      dbms_output.put(',        является листом: да');
    end if;
    
    dbms_output.put_line('');
  
  end loop;
                
  close cursor_category_info;
end;
       



/* 1. Версия 3. Используется иерархический запрос
Процедура, а в ней курсор, который отдает иерархический список категорий, начиная с тех, в которых есть товары с заведенной стоимостью. 
Иерархический список категорий следующий: 
ИД категории
ИД родительской категории
Название
Флаг, который показывает является ли узел листом */


/*
select
  level,
  category_goods_id,
  parent_category_goods_id,
  category_goods_name,
  connect_by_isleaf "Лист дерева?"
from
  category_goods
start with  
  parent_category_goods_id is null
connect by 
  prior category_goods_id = parent_category_goods_id;
*/ 

  
create or replace procedure get_info_tree_cat_goods (refcur out sys_refcursor) 
is

begin

  open refcur for
    select
		level, /* Уровень иерархии */
		category_goods_id,
		parent_category_goods_id,
		category_goods_name,
		connect_by_isleaf "Лист дерева?" /* 0 - если не лист иерархии, 1 - если лист иерархии  */
	from
		category_goods
	start with /* Корневая запись */
		parent_category_goods_id is null
	connect by /* Показываем иерархию */
		prior category_goods_id = parent_category_goods_id;
  
end get_info_tree_cat_goods;




/* Вызов процедуры между begin и end */
declare
  tmp$cur sys_refcursor;
  level integer;
  category_goods_id integer;
  parent_category_goods_id integer;
  category_goods_name varchar2(200);
  connect_by_isleaf integer;
begin

  /* Вызов происходит здесь! */
  get_info_tree_cat_goods (tmp$cur);

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



     

/* 1. Версия 4. Используется иерархический запрос
Если в категори хотя бы один товар имееет цену, а все остальные не имеют, то вывести эту категорию 
Иерархический список категорий следующий: 
ИД категории
ИД родительской категории
Название
Флаг, который показывает является ли узел листом */


/* Возможно для условия: начиная с тех, в которых есть товары с заведенной стоимостью можно придумать 
ORDER SIBLINGS BY */

/*
select 
  * 
from 
  goods_price 
where
  price is not null;

  
select 
  * 
from 
  goods_price 
where
  price is null;
*/


/*
select 
  * 
from 
  goods_price
order by 
  price asc;
*/


/*
select
  category_goods.category_goods_id,
  goods.goods_name,
  goods_price.price
from
  goods_price,
  goods,
  goods_inherit_category,
  category_goods
where
  goods_price.goods_id = goods.goods_id and
  goods.goods_id = goods_inherit_category.goods_id and 
  goods_inherit_category.category_goods_id = category_goods.category_goods_id and
  goods_price.price is not null;
*/

/* Если в категори хотя бы один товар имееет цену, а все остальные не имеют, то вывести эту категорию */
/*select
  level,
  category_goods_id,
  parent_category_goods_id,
  category_goods_name,
  connect_by_isleaf "Лист дерева?"
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
*/


create or replace procedure get_info_tree_cat_goods (refcur out sys_refcursor) 
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




/* Вызов процедуры между begin и end */
declare
  tmp$cur sys_refcursor;
  level integer;
  category_goods_id integer;
  parent_category_goods_id integer;
  category_goods_name varchar2(200);
  connect_by_isleaf integer;
begin

  /* Вызов происходит здесь! */
  get_info_tree_cat_goods (tmp$cur);

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





/* 1. Версия 5.
Процедура, а в ней курсор, который отдает иерархический список категорий, начиная с тех, в которых есть товары с заведенной стоимостью (Но не показывает те категории, где нет товаров и где они не оценены). 
Иерархический список категорий следующий: 
ИД категории
ИД родительской категории
Название
Флаг, который показывает является ли узел листом */
declare
  type t_id_cat is table of integer index by pls_integer;

  ar_id_cat t_id_cat;
  
  i pls_integer := 1;
  
  l_level integer;
  l_category_goods_id category_goods.category_goods_id%type;
  l_parent_category_goods_id category_goods.parent_category_goods_id%type;
  l_category_goods_name category_goods.category_goods_name%type;
  l_connect_by_isleaf integer; 

  cursor get_id_cat_include_price IS
    select
      category_goods_id
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
                              goods_price.price is not null);
                              
                              
  cursor get_id_cat_without_price IS
    select
      category_goods_id
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
                              goods_price.price is null);
                                             
begin

  /* Записать в массивы ИД категорий, у которых хотябы 1 товар содержит цену */
  open get_id_cat_include_price; 
    
    i := 1;
  
    loop 
    
      fetch 
        get_id_cat_include_price 
      into 
        ar_id_cat(i);

      exit when get_id_cat_include_price%NOTFOUND;
      
      i := i + 1;
                
    end loop;

  close get_id_cat_include_price;
  
  
  
  /* Вывести древовидный список категорий, где сначала идут категории, в которых есть товары с ценой, хотя бы 1 */
  DBMS_OUTPUT.PUT_LINE('---------------------------');                          
  
  i := ar_id_cat.first;

  while (i is not null) loop
  
    select
      level, 
      category_goods_id,
      parent_category_goods_id,
      category_goods_name,
      connect_by_isleaf "Лист дерева?"
    into
      l_level,
      l_category_goods_id,
      l_parent_category_goods_id,
      l_category_goods_name,
      l_connect_by_isleaf
    from
      category_goods
    where
      category_goods_id = ar_id_cat(i)
    start with 
      parent_category_goods_id is null
    connect by 
      prior category_goods_id = parent_category_goods_id;

    
    dbms_output.put_line('Уровень: ' ||l_level ||
                             '         ИД категории товара: ' || l_category_goods_id ||
                             ',        Родительский ИД  у категории товара: ' || l_parent_category_goods_id ||
                             ',        Название категории товара: ' || l_category_goods_name ||
                             ',        Является ли листом?: ' || l_connect_by_isleaf ||
                             ',        В данной категории хотя бы один товар содержит цену');
                    
    i := ar_id_cat.next(i);
       
   end loop;
  
  
  
  /* Записать в массивы ИД категорий, у которых все товары не содержат цену */
  ar_id_cat.delete(ar_id_cat.first, ar_id_cat.last);
  
  open get_id_cat_without_price; 
    
    i := 1;

    loop 
    
      fetch 
        get_id_cat_without_price 
      into 
        ar_id_cat(i);

      exit when get_id_cat_without_price%NOTFOUND;

      i := i + 1;
                
    end loop;

  close get_id_cat_without_price;
  
  
  
  /* А потом вывести. Вывести древовидный список категорий без цен */
  DBMS_OUTPUT.PUT_LINE('****************************');
  
  i := ar_id_cat.first;

  while (i is not null) loop
  
    select
      level, 
      category_goods_id,
      parent_category_goods_id,
      category_goods_name,
      connect_by_isleaf "Лист дерева?"
    into
      l_level,
      l_category_goods_id,
      l_parent_category_goods_id,
      l_category_goods_name,
      l_connect_by_isleaf
    from
      category_goods
    where
      category_goods_id = ar_id_cat(i)
    start with 
      parent_category_goods_id is null
    connect by 
      prior category_goods_id = parent_category_goods_id;

    
    dbms_output.put_line('Уровень: ' ||l_level ||
						 '         ИД категории товара: ' || l_category_goods_id ||
						 ',        Родительский ИД  у категории товара: ' || l_parent_category_goods_id ||
						 ',        Название категории товара: ' || l_category_goods_name ||
						 ',        Является ли листом?: ' || l_connect_by_isleaf ||
						 ',        В данной категории ни один товара не содержит цену!!!');
                    
    i := ar_id_cat.next(i);
       
   end loop;
  
end;