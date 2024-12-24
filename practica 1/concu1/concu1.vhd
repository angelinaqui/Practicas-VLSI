library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity concu1 is
    port(
        clk: in std_logic;
        ssg0: out std_logic_vector(6 downto 0);
        ssg1: out std_logic_vector(6 downto 0);
        ssg2: out std_logic_vector(6 downto 0);
        ssg3: out std_logic_vector(6 downto 0)
    );
end entity;

architecture a of concu1 is
    signal clkl: std_logic := '0'; -- Divisor de frecuencia
    signal contador: integer range 0 to 250000 := 0;
    signal minutos1, minutos2, horas1, horas2: integer := 0;
    signal carry_minutos, carry_horas: std_logic := '0';
begin
    -- Divisor de frecuencia
    process(clk)
    begin
        if rising_edge(clk) then
            if contador = 250000 then
                contador <= 0;
                clkl <= not clkl;
            else
                contador <= contador + 1;
            end if;
        end if;
    end process;

    -- Contadores de minutos y horas
    process(clkl)
    begin
        if rising_edge(clkl) then
            -- Contador de minutos unidades (ssg0)
            if minutos1 = 9 then
                minutos1 <= 0;
                carry_minutos <= '1';
            else
                minutos1 <= minutos1 + 1;
                carry_minutos <= '0';
            end if;

            -- Contador de minutos decenas (ssg1)
            if carry_minutos = '1' then
                if minutos2 = 5 then
                    minutos2 <= 0;
                    carry_horas <= '1';
                else
                    minutos2 <= minutos2 + 1;
                    carry_horas <= '0';
                end if;
            end if;

            -- Contador de horas unidades (ssg2)
            if carry_horas = '1' then
                if horas1 = 9 then
                    horas1 <= 0;
                    if horas2 = 2 then
                        horas2 <= 0;
                    else
                        horas2 <= horas2 + 1;
                    end if;
                else
                    horas1 <= horas1 + 1;
                end if;
                carry_horas <= '0';
            end if;
        end if;
    end process;

    -- Display de 7 segmentos para ssg0 (minutos, unidades)
    with minutos1 select
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

    -- Display de 7 segmentos para ssg1 (minutos, decenas)
    with minutos2 select
    ssg1 <= "1000000" when 0,
            "1111001" when 1,
            "0100100" when 2,
            "0110000" when 3,
            "0011001" when 4,
            "0010010" when 5,
            "1111111" when others;

    -- Display de 7 segmentos para ssg2 (horas, unidades)
    with horas1 select
    ssg2 <= "1000000" when 0,
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

    -- Display de 7 segmentos para ssg3 (horas, decenas)
    with horas2 select
    ssg3 <= "1000000" when 0,
            "1111001" when 1,
            "0100100" when 2,
            "1111111" when others;

end architecture;
