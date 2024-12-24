library ieee;
use ieee.std_logic_1164.all;

entity conta3display is
port(clk: in std_logic;
     ssg0: out std_logic_vector(6 downto 0);
	  ssg1: out std_logic_vector(6 downto 0);
	  ssg2: out std_logic_vector(6 downto 0);
	  banderaSal: out std_logic); --no la utilizo
end entity;

architecture a of conta3display is
signal bandera: std_logic;
signal bandera1: std_logic;
signal conteo: integer range 0 to 9;
begin
   u4: entity work.contador(a) port map(clk,ssg0, bandera);
   u5: entity work.contador1(a) port map(bandera,ssg1, bandera1);
	u6: entity work.cont(a) port map(bandera1,conteo, banderaSal);
   u7: entity work.ss7(ROD) port map(conteo,ssg2);
end architecture;
