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



/* 3. Версия 2. Изменяем цикл.  
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


