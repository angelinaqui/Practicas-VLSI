library ieee; --libreria
use ieee.std_logic_1164.all; 

entity ejer3 is--Entidad principal de diseño 
    port( 
	 --señales de entrada
        clk, reset : in std_logic; --Reloj y reinicio
        clk_led    : out std_logic; --Reloj de led
        hex0, hex1, hex2, hex3, hex4 : buffer std_logic_vector(6 downto 0) --Cambio de valores para display en hex
    );
end entity;

--Arquitectura del diseño
architecture a of ejer3 is
    signal clkl : std_logic; --señal reloj interno 
    signal bcd  : std_logic_vector(2 downto 0);--Valores de BCD de 3 Bits
begin
    clk_led <= clkl;-- se asigna señal de reloj interno a reloj de led
    u1: entity work.relojlento(a) port map (clk, clkl);---- Instanciación del componente 'relojlento' que genera la señal de reloj local
    u2: entity work.cafe(a) port map (clkl, reset, bcd); -- Instanciación del componente 'cafe' que maneja la señal de reinicio y genera el valor BCD
    u3: entity work.decCafe(a) port map ('0' & bcd, hex0);-- Instanciación del componente 'decCafe' que convierte el valor BCD a un formato adecuado para el display
    u4: entity work.display(a) port map (clkl, hex0, hex1); -- hex0 datos display1, hex1 datos display2
    u5: entity work.display(a) port map (clkl, hex1, hex2); -- hex1 datos display2, hex2 datos displya3
    u6: entity work.display(a) port map (clkl, hex2, hex3); --hex2 datos display3, hex3 datos display4
    u7: entity work.display(a) port map (clkl, hex3, hex4); --hex3 datos display4, hex4 datos display 5
end architecture;