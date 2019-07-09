/* Хранимая процедура, которая добавляет товар в корзину  */
create or replace procedure add_goods_to_basket (p_basket_id in integer, 
												 p_client_id in integer, 
												 p_goods_price_id in integer,
												 p_amount in integer) 
is
begin
	insert into basket (basket_id, client_id, goods_price_id, amount)
	values (p_basket_id, p_client_id, p_goods_price_id, p_amount);
end add_goods_to_basket;
