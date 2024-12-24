library ieee; --library 
use ieee.std_logic_1164.all;

entity cafe is
    port (
        clk, reset : in  std_logic; --entrada reloj reinicio
        SalMoore   : out std_logic_vector(2 downto 0) --salida del estado
    );
end entity;

architecture a of cafe is --arquitectura cafe
    subtype state is std_logic_vector(2 downto 0); --subtipo para estados
    signal present_state, next_state : state; --señales estado actual siguiente
    
    constant e0 : state := "000"; --Estado 0
    constant e1 : state := "001"; --Estado 1
    constant e2 : state := "010"; --Estado 2
    constant e3 : state := "011"; --Estado 3
    constant e4 : state := "100"; --Estado 4
    constant e5 : state := "101"; --Estado 5

begin
	-- Disparar cambio de estado
    process(clk)
    begin
        if rising_edge(clk) then
            if (reset = '0') then
                present_state <= e0; -- Si reset está en '0', se reinicia al estado e0
            else
                present_state <= next_state; -- De lo contrario, se actualiza al siguiente estado
            end if;
        end if;
    end process;
	-- Transiciones de estado
    process(present_state)
    begin
        case present_state is
            when e0 => next_state <= e1; -- Transición del estado e0 al e1
            when e1 => next_state <= e2; -- Transición del estado e1 al e2
            when e2 => next_state <= e3; -- Transición del estado e2 al e3
            when e3 => next_state <= e4; -- Transición del estado e3 al e4
            when e4 => next_state <= e5; -- Transición del estado e4 al e5
			when e5 => next_state <= e0;
            when others => next_state <= e0; 
        end case;
        SalMoore <= present_state;
    end process;
end architecture;
