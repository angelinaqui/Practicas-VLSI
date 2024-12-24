library ieee;
use ieee.std_logic_1164.all;

ENTITY pwm IS
port( clk: in std_logic;
		led: out std_logic);
end pwm;

architecture b of pwm is
signal clkl: std_logic;
begin
	u1: entity work.divf(a) generic map(25000) port map(clk,clkl);
	u2: entity work.senal(c) port map(clkl,250,led);
end architecture;