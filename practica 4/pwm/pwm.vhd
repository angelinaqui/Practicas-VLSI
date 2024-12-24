library ieee;
use ieee.std_logic_1164.all;

ENTITY pwm IS
port( clk: in std_logic;
		led0,led1,led2,led3,led4,led5,led6,led7,led8: out std_logic);
end pwm;

architecture b of pwm is
signal clkl0: std_logic;
begin
	u1: entity work.divf(a) generic map(250) port map(clk,clkl0);
	

	u10: entity work.senal(c) port map(clkl0,220,led0); -- 10%
	u11: entity work.senal(c) port map(clkl0,246,led1); -- 20%
	u12: entity work.senal(c) port map(clkl0,261,led2); -- 30%
	u13: entity work.senal(c) port map(clkl0,294,led3); -- 40%
	u14: entity work.senal(c) port map(clkl0,312,led4); -- 50%
	u15: entity work.senal(c) port map(clkl0,330,led5); -- 60%
	u16: entity work.senal(c) port map(clkl0,350,led6); -- 70%
	u17: entity work.senal(c) port map(clkl0,392,led7); -- 80%
	u18: entity work.senal(c) port map(clkl0,416,led8); -- 90%
end architecture;