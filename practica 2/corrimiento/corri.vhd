library ieee;
use ieee.std_logic_1164.all;

entity corri is
    port(
        clk, reset : in std_logic;
        clk_led    : out std_logic;
        hex0, hex1, hex2, hex3, hex4 : out std_logic_vector(6 downto 0)
    );
end entity;

architecture a of corri is
    signal clkl : std_logic;
    signal bcd  : std_logic_vector(2 downto 0);
begin
    clk_led <= clkl;
    u1: entity work.relojlento(a) port map (clk, clkl);
    u2: entity work.conta(a) port map (clkl, reset, bcd);
    u3: entity work.dec7seg(a) port map ('0' & bcd, hex0);
    u4: entity work.dec7seg(a) port map ('0' & bcd, hex1);
    u5: entity work.dec7seg(a) port map ('0' & bcd, hex2);
    u6: entity work.dec7seg(a) port map ('0' & bcd, hex3);
    u7: entity work.dec7seg(a) port map ('0' & bcd, hex4);
end architecture;
