library ieee;
use ieee.std_logic_1164.all;
entity decCafe is
port(
	bcd: in std_logic_vector(3 downto 0); -- Entrada en formato BCD 
	HEX: out std_logic_vector(6 downto 0) -- Salida para el display de 7 segmentos
	);
end;
architecture a of decCafe is
begin 
	with bcd select
	HEX<= --Mensaje Cafe
		 "1000110" when "0000",--letra C
		 "0001000" when "0001",--letra A
		 "0001110" when "0010",--letra F
		 "0000110" when "0011",--letra E
		 "1111111" when others;
end a;