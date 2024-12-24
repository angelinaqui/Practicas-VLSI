library ieee; --libreria 
use ieee.std_logic_arith.all;
use ieee.std_logic_1164.all;

entity relojlento is
    port(
        clkl : in std_logic; --entrada de reloj
        led  : buffer std_logic := '0' --salida del estado de led
    );
end relojlento;

architecture a of relojlento is
    signal conteo : integer range 0 to 25000000; --señal interna de conteo
begin
    process(clkl)
    begin
        if (clkl'event and clkl = '1') then
            if (conteo = 25000000) then
                conteo <= 0;
                led <= not led;
            else
                conteo <= conteo + 1; --incrementa contreo
            end if;
        end if;
    end process;
end architecture;
