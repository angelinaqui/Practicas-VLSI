library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity movimiento is 
    port(
        clk, pi, pf, inc, dec, rst: in std_logic;
        ancho: out integer
    );
end entity;

architecture arqmov of movimiento is
    signal valor: integer range 0 to 200 := 75;
    signal counter: integer range 0 to 50000 := 0;  -- Contador para generar el retardo
    signal enable: std_logic := '0';  -- Señal de habilitación para controlar el incremento/decremento
begin
    process (clk, rst)
    begin
        if rst = '1' then
            valor <= 75;
            counter <= 0;
            enable <= '0';
        elsif rising_edge(clk) then
            if counter = 5000 then  -- Asumiendo un reloj de 50 MHz para obtener 1 ms
                enable <= '1';
                counter <= 0;
            else
                counter <= counter + 1;
                enable <= '0';
            end if;

            if enable = '1' then
                if pi = '1' then
                    valor <= 55;  -- 5.5% -~1 ms
                elsif pf = '1' then 
                    valor <= 95;  -- 9.5% -~2ms
                elsif inc = '1' and valor < 95 then
                    valor <= valor + 1;
                elsif dec = '1' and valor > 55 then
                    valor <= valor - 1;
                end if;
            end if;
        end if;
    end process;

    ancho <= valor; -- Asignación continua de `ancho` al valor calculado
end architecture;
