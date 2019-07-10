/* 4. Хранимая процедура, которая добавляет товар в корзину  */
create or replace procedure add_goods_to_basket (p_users_id       in integer, 
												 p_goods_price_id in integer,
												 p_amount         in integer) 
is
	l_count_in_storage integer := 0;
begin

	insert into basket (basket_id, users_id, goods_price_id, amount)
	values (basket_seq.nextval, p_users_id, p_goods_price_id, p_amount);
	
end add_goods_to_basket;


/* Вызов хранимой процедуры */
exec add_goods_to_basket (1, 1, 2);



/* 3. Курсор, который по ИД товара одает данные: 
название товара, 
текущая цена товара,
длинна товара,
ширина ширина,
высота товара. */
declare
	v_user_id     goods.goods_id%type;
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
	
	/* Проверять входит ли в заданный промежуток текущая дата */



	v_user_id := 1;
	
	open cursor_goods_info(v_user_id);

		fetch 
			cursor_goods_info 
		into 
			v_goods_name, v_price, v_length, v_width, v_height;
			
		dbms_output.put_line(v_goods_name || ', ' || v_price || ', ' || v_length || ', ' || v_width || ', ' || v_height);
	
	close cursor_goods_info;
end;
