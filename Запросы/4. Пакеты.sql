/* Создание спецификации пакета */
create or replace package pkg_goods is

  procedure get_info_tree_cat_goods;


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

  /* 1. Процедура, которая отдает иерархический список категорий, начиная с тех, в которых есть товары с заведенной стоимостью. 
  Иерархический список категорий следующий: 
  ИД категории
  ИД родительской категории
  Название
  Флаг, который показывает является ли узел листом */
  procedure get_info_tree_cat_goods
  is
    type t_id_cat is table of integer index by pls_integer;

    ar_id_cat t_id_cat;
    ar_id_cat_without_price t_id_cat;
    
    /* Счетчики */
    i pls_integer := 0;
    j pls_integer := 0;
      
    /* переменная флаг */
    l_exists boolean := false;  
      
    /* Переменные для записи в них сведений из запроса select */
    l_level integer;
    l_category_goods_id category_goods.category_goods_id%type;
    l_parent_category_goods_id category_goods.parent_category_goods_id%type;
    l_category_goods_name category_goods.category_goods_name%type;
    l_connect_by_isleaf integer; 


    cursor get_id_cat_include_price is
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
                    
                    
    cursor get_id_cat_all is
      select
        category_goods_id
      from
        category_goods;
        
  begin

    /* Записать в массив ИД категорий, у которых хотя бы 1 товар содержит цену */
    open get_id_cat_include_price; 
      
    i := 0;
      
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
    dbms_output.put_line('--------------------------- Категории, в которых есть товары с ценой в кол-ве от 1-го товара и выше:');                          
      
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



    /* Записать в массив ИД категорий, у которых все товары не содержат цену */
    open get_id_cat_all; 
       
      i := 0;
        
      loop 
        
        fetch 
          get_id_cat_all 
        into 
          l_category_goods_id;

        exit when get_id_cat_all%NOTFOUND;
      

        j := ar_id_cat.first;
        l_exists := false;
          
        while (j is not null) loop
          
          if (ar_id_cat(j) = l_category_goods_id) then
            l_exists := true;
          end if;  
          
          j := ar_id_cat.next(j); 
        end loop;
          
          
          
        if (not l_exists) then
          ar_id_cat_without_price(i) := l_category_goods_id;
            
          i := i + 1;
        end if;
          
      end loop; 
       
    close get_id_cat_all;
       
       
       
    /* А потом вывести древовидный список категорий без цен */
    dbms_output.put_line('--------------------------- Категории без цены:');                          
      
    i := ar_id_cat_without_price.first;

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
        category_goods_id = ar_id_cat_without_price(i)
      start with 
        parent_category_goods_id is null
      connect by 
        prior category_goods_id = parent_category_goods_id;

        
      dbms_output.put_line('Уровень: ' ||l_level ||
                               '         ИД категории товара: ' || l_category_goods_id ||
                               ',        Родительский ИД  у категории товара: ' || l_parent_category_goods_id ||
                               ',        Название категории товара: ' || l_category_goods_name ||
                               ',        Является ли листом?: ' || l_connect_by_isleaf ||
                               ',        В данной категории ни один товар НЕ содержит цену');
                
      i := ar_id_cat_without_price.next(i);
         
    end loop;
      
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
exec pkg_goods.get_info_tree_cat_goods;



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