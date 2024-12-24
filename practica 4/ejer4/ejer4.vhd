library ieee;
use ieee.std_logic_1164.all;

ENTITY ejer4 IS
port( 
    clk: in std_logic;
    led0, led1, led2, led3, led4, led5, led6, led7, led8: out std_logic
);
end ejer4;

architecture b of ejer4 is
    -- Definir un tipo de arreglo para los ciclos de trabajo
    type duty_array_type is array(0 to 8) of integer range 0 to 1000;
    signal duty_cycle_array: duty_array_type := (100, 200, 300, 400, 500, 600, 700, 800, 900);
    signal clkl0, clkl1, clkl2, clkl3, clkl4, clkl5, clkl6, clkl7, clkl8: std_logic;
    signal counter: integer range 0 to 25000000 := 0; -- Para controlar la rotación de LEDs
begin
    -- Divisores de frecuencia
    u1: entity work.divf(a) generic map(25000) port map(clk, clkl0);
    u2: entity work.divf(a) generic map(25000) port map(clk, clkl1);
    u3: entity work.divf(a) generic map(25000) port map(clk, clkl2);
    u4: entity work.divf(a) generic map(25000) port map(clk, clkl3);
    u5: entity work.divf(a) generic map(25000) port map(clk, clkl4);
    u6: entity work.divf(a) generic map(25000) port map(clk, clkl5);
    u7: entity work.divf(a) generic map(25000) port map(clk, clkl6);
    u8: entity work.divf(a) generic map(25000) port map(clk, clkl7);
    u9: entity work.divf(a) generic map(25000) port map(clk, clkl8);

    -- Señal PWM con ciclos de trabajo dinámicos para cada LED
    u10: entity work.senal(c) port map(clkl0, duty_cycle_array(0), led0);
    u11: entity work.senal(c) port map(clkl1, duty_cycle_array(1), led1);
    u12: entity work.senal(c) port map(clkl2, duty_cycle_array(2), led2);
    u13: entity work.senal(c) port map(clkl3, duty_cycle_array(3), led3);
    u14: entity work.senal(c) port map(clkl4, duty_cycle_array(4), led4);
    u15: entity work.senal(c) port map(clkl5, duty_cycle_array(5), led5);
    u16: entity work.senal(c) port map(clkl6, duty_cycle_array(6), led6);
    u17: entity work.senal(c) port map(clkl7, duty_cycle_array(7), led7);
    u18: entity work.senal(c) port map(clkl8, duty_cycle_array(8), led8);

    -- Proceso para rotar los ciclos de trabajo entre los LEDs
    process(clk)
        variable temp_duty: integer; -- Declarar temp_duty como una variable local
    begin
        if rising_edge(clk) then
            if counter = 25000000 then -- Cada cierto tiempo (ajustar según el periodo deseado)
                counter <= 0;
                -- Rotación de los ciclos de trabajo
                temp_duty := duty_cycle_array(0);
                duty_cycle_array(0) <= duty_cycle_array(1);
                duty_cycle_array(1) <= duty_cycle_array(2);
                duty_cycle_array(2) <= duty_cycle_array(3);
                duty_cycle_array(3) <= duty_cycle_array(4);
                duty_cycle_array(4) <= duty_cycle_array(5);
                duty_cycle_array(5) <= duty_cycle_array(6);
                duty_cycle_array(6) <= duty_cycle_array(7);
                duty_cycle_array(7) <= duty_cycle_array(8);
                duty_cycle_array(8) <= temp_duty; -- Rotar el primer ciclo de trabajo al último LED
            else
                counter <= counter + 1;
            end if;
        end if;
    end process;
end architecture;
