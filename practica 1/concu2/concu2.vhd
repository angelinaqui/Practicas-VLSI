library ieee;
use ieee.std_logic_1164.all;

entity concu2 is
    port(
        clk: in std_logic;
        ssg0: out std_logic_vector(6 downto 0);
        ssg1: out std_logic_vector(6 downto 0);
        carry: out std_logic
    );
end entity;

architecture a of concu2 is
    signal clkl: std_logic := '0'; -- Divisor de frecuencia
    signal contador: integer range 0 to 250000 := 0;
    signal conteo1, conteo2: integer := 0;
    signal bandera1: std_logic := '0';
    signal bandera2: std_logic := '0';

begin

    -- Divisor de frecuencia
    process(clk)
    begin
        if rising_edge(clk) then
            if contador = 250000 then
                contador <= 0;
                clkl <= not clkl; -- Salida
            else
                contador <= contador + 1;
            end if;
        end if;
    end process;

    -- Counter1
    process(clkl)
    begin
        if rising_edge(clkl) then 
            if conteo1 = 9 then
                conteo1 <= 0; -- Salida
                bandera1 <= '1'; -- Salida2
            else
                conteo1 <= conteo1 + 1; -- Salida1
                bandera1 <= '0'; -- Flag -- Salida2
            end if;
        end if;
    end process;
    
    carry <= bandera1; -- Asignación de la señal carry

    -- Counter2
    process(clkl) -- Cambiar a clkl en lugar de bandera1
    begin
        if rising_edge(clkl) then 
            if bandera1 = '1' then
                if conteo2 = 9 then
                    conteo2 <= 0; -- Salida1
                    bandera2 <= '1'; -- Salida2
                else
                    conteo2 <= conteo2 + 1; -- Salida1
                    bandera2 <= '0'; -- Flag -- Salida2
                end if;
            end if;
        end if;
    end process;

    -- ssg0
    with conteo1 select
    ssg0 <= "1000000" when 0,
            "1111001" when 1,
            "0100100" when 2,
            "0110000" when 3,
            "0011001" when 4,
            "0010010" when 5,
            "0000010" when 6,
            "1111000" when 7,
            "0000000" when 8,
            "0011000" when 9,
            "1111111" when others;

    -- ssg1
    with conteo2 select
    ssg1 <= "1000000" when 0,
            "1111001" when 1,
            "0100100" when 2,
            "0110000" when 3,
            "0011001" when 4,
            "0010010" when 5,
            "0000010" when 6,
            "1111000" when 7,
            "0000000" when 8,
            "0011000" when 9,
            "1111111" when others;

end architecture;
