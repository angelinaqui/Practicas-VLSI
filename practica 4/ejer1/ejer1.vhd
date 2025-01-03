library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity ejer1 is
port(clk: in std_logic;
	  duty: in std_logic_vector(3 downto 0):="0011" ; --0011(25%),0111 (50%), 1010(75%), 1111 (100%)
	  snl: out std_logic:='0');
end entity;

architecture a of ejer1 is
signal conteo: std_logic_vector(3 downto 0):="0000";
begin
	process(clk)
		begin
			if(rising_edge(clk))then
				if (conteo= "1111") then
					conteo <= "0000";
				else
					conteo <= conteo+"0001";
				end if;
				if (conteo = duty) then
					snl <= '1';
				else
					snl<= '0';
				end if;
			end if;
		end process;
end architecture;
