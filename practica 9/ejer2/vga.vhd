Library IEEE;
Use IEEE.Std_logic_1164.all;
Use IEEE.Std_logic_arith.all;
Use IEEE.Std_logic_unsigned.ALL;
Use IEEE.numeric_std.all;

Entity ejer2 is
	generic( constant h_pulse: integer := 96;
				constant h_bp: integer := 48;
				constant h_pixels:integer := 640;
				constant h_fp: integer := 16;
				constant v_pulse: integer := 2;
				constant v_bp: integer := 33;
				constant v_pixels:integer := 480;
				constant v_fp: integer := 10);
	port( clk50Mhz: in std_logic;
			red: out std_logic_vector(3 downto 0);
			green: out std_logic_vector(3 downto 0);
			blue : out std_logic_vector(3 downto 0);
			h_sync: out std_logic;
			v_sync : out std_logic;
			swt : in std_logic_vector(3 downto 0));
end entity;

Architecture bhv of ejer2 is
constant h_period : integer := h_pulse+h_bp+h_pixels+h_fp;
constant v_period : integer := v_pulse+v_bp+v_pixels+v_fp;
signal h_count : integer range 0 to h_period-1 := 0;
signal v_count : integer range 0 to v_period-1 := 0;

signal reloj_pixel : std_logic;
signal column : integer := 0;
signal row : integer :=0;
signal display_ena : std_logic ;

Begin
	relojpixel : Process(clk50MHz) is
	Begin
		If rising_edge(clk50MHz) then
			reloj_pixel <= not reloj_pixel;
		End If;
	End Process relojpixel;
	
	contadores : Process(reloj_pixel) -- H_periodo=800, V_periodo=525 
	Begin
		If rising_edge(reloj_pixel) then
			If (h_count < h_period-1) then
				h_count <= h_count + 1;
			else
				h_count <= 0;
				If (v_count < v_period-1) then
					v_count <= v_count + 1;
				else
					v_count <= 0;
				End If;
			End If;
		End If;
	End Process contadores;
	
	senial_vsync: Process(reloj_pixel) --v_pixel + v_fp + v_pulse = 525
	Begin
		If rising_edge(reloj_pixel) then
			If (v_count >= v_pixels + v_fp) and
				(v_count >= v_pixels + v_fp + v_pulse - 1) then
					v_sync <= '0';
			else
				v_sync <= '1';
			End If;
		End If;
	End Process senial_vsync;
	
	senial_hsync: Process(reloj_pixel) --h_pixels + h_fp + h_pulse = 784
	Begin
		If rising_edge(reloj_pixel) then
			If (h_count >= h_pixels + h_fp) and	(h_count >= h_pixels + h_fp + h_pulse - 1) then
				h_sync <= '0';
			else
				h_sync <= '1';
			End If;
		End If;
	End Process senial_hsync;
	
	coords_pixel: Process(reloj_pixel) --h_pixels + h_fp + h_pulse = 784
	Begin
		If rising_edge(reloj_pixel) then
			If (h_count < h_pixels) then
				column <= h_count;
			End If;
			If (v_count < v_pixels) then
				row <= v_count;
			End If;
		End If;
	End Process coords_pixel;
	
	display_enable: Process(reloj_pixel) --h_pixels = 640 y v_pixels = 480
	Begin
		If rising_edge(reloj_pixel) then
			If (h_count < h_pixels and v_count < v_pixels) then
				display_ena <= '1';
			Else
				display_ena <= '0';
			End If;
		End If;
	End Process display_enable;
	
	imagen: Process(display_ena, row, column,swt)
	
	variable num: std_logic_vector (6 downto 0);
	constant cero: std_logic_vector (6 downto 0):= "1000000";
	constant uno: std_logic_vector (6 downto 0):= "0111111";   --gfedcba
	constant dos: std_logic_vector (6 downto 0):= "0000110";
	constant tres: std_logic_vector (6 downto 0):= "1100111";
	constant cuatro: std_logic_vector (6 downto 0):= "1100110";
	constant cinco: std_logic_vector (6 downto 0):= "1101101";
	constant seis: std_logic_vector (6 downto 0):= "1111101";
	constant siete: std_logic_vector (6 downto 0):= "0000111";
	constant ocho: std_logic_vector (6 downto 0):= "1111111";
	constant nueve: std_logic_vector (6 downto 0):= "1110011";
	constant r1: std_logic_vector(3 downto 0) :=(OTHERS => '1');
	constant r0: std_logic_vector(3 downto 0) :=(OTHERS => '0');
	constant g1: std_logic_vector(3 downto 0) :=(OTHERS => '1');
	constant g0: std_logic_vector(3 downto 0) :=(OTHERS => '0');
	constant b1: std_logic_vector(3 downto 0) :=(OTHERS => '1');
	constant b0: std_logic_vector(3 downto 0) :=(OTHERS => '0');

	BEGIN
	case swt is
            when "0000" =>  -- 0
                num := cero;
            when "0001" =>  -- 1
                num := uno;
            when "0010" =>  -- 2
                num := dos;
            when "0011" =>  -- 3
                num := tres;
            when "0100" =>  -- 4
                num := cuatro;
            when "0101" =>  -- 5
                num := cinco;
            when "0110" =>  -- 6
                num := seis;
            when "0111" =>  -- 7
                num := siete;
            when "1000" =>  -- 8
                num := ocho;
            when "1001" =>  -- 9
                num := nueve;
            when others =>  -- Apagado o error
                num := "1111111";
        end case;

	IF(display_ena = '1') THEN         --display time
		 case num is
		 when cero =>
            if ((row > 200 and row < 210) and (column > 110 and column < 140)) THEN --a azul
                red <= (OTHERS => '0');
                green <= (OTHERS => '0');
                blue <= (OTHERS => '1');
            elsif ((row > 210 and row < 240) and (column > 140 and column < 150)) THEN --b verde
                red <= (OTHERS => '0');
                green <= (OTHERS => '1');
                blue <= (OTHERS => '0');
            elsif ((row > 250 and row < 280) and (column > 140 and column < 150)) THEN --c rojo
                red <= (OTHERS => '1');
                green <= (OTHERS => '0');
                blue <= (OTHERS => '0');
            elsif ((row > 280 and row < 290) and (column > 110 and column < 140)) THEN --d blanco
                red <= (OTHERS => '1');
                green <= (OTHERS => '1');
                blue <= (OTHERS => '1');
				elsif ((row > 210 and row < 240) and (column > 100 and column < 110)) THEN --f amarillo
				  red <= (OTHERS => '1');
				  green <= (OTHERS => '1');
				  blue <= (OTHERS => '0');
				elsif ((row > 250 and row < 280) and (column > 100 and column < 110)) THEN --e cian
				  red <= (OTHERS => '0');
				  green <= (OTHERS => '1');
				  blue <= (OTHERS => '1');
            else
                red <= (OTHERS => '0');
                green <= (OTHERS => '0');
                blue <= (OTHERS => '0');
            end if;
		 when uno =>
			  if ((row > 210 and row < 240) and (column > 140 and column < 150)) THEN  --b verde
					red <= (OTHERS => '0');
					green <= (OTHERS => '1');
					blue <= (OTHERS => '0');
			  elsif ((row > 250 and row < 280) and (column > 140 and column < 150)) THEN --c rojo
					red <= (OTHERS => '1');
					green <= (OTHERS => '0');
					blue <= (OTHERS => '0');
			  else
					red <= (OTHERS => '0');    --es el fondo
					green <= (OTHERS => '0');
					blue <= (OTHERS => '0');
			  end if;
			  
			  when dos =>
			 if ((row > 200 and row < 210) and (column > 110 and column < 140)) THEN --a azul
				  red <= (OTHERS => '0');
				  green <= (OTHERS => '0');
				  blue <= (OTHERS => '1');
			 elsif ((row > 210 and row < 240) and (column > 140 and column < 150)) THEN --b verde
				  red <= (OTHERS => '0');
				  green <= (OTHERS => '1');
				  blue <= (OTHERS => '0');
			 elsif ((row > 280 and row < 290) and (column > 110 and column < 140)) THEN --d blanco
				  red <= (OTHERS => '1');
				  green <= (OTHERS => '1');
				  blue <= (OTHERS => '1');
			 elsif ((row > 250 and row < 280) and (column > 100 and column < 110)) THEN --e cian
				  red <= (OTHERS => '0');
				  green <= (OTHERS => '1');
				  blue <= (OTHERS => '1');
			 elsif ((row > 240 and row < 250) and (column > 110 and column < 140)) THEN --g violeta
				  red <= (OTHERS => '1');
				  green <= (OTHERS => '0');
				  blue <= (OTHERS => '1');
			 else
				  red <= (OTHERS => '0'); --es el fondo
				  green <= (OTHERS => '0');
				  blue <= (OTHERS => '0');
			 end if;
			 
			 
			 when tres =>
            if ((row > 200 and row < 210) and (column > 110 and column < 140)) THEN --a azul
                red <= (OTHERS => '0');
                green <= (OTHERS => '0');
                blue <= (OTHERS => '1');
				elsif ((row > 210 and row < 240) and (column > 140 and column < 150)) THEN --b verde
					  red <= (OTHERS => '0');
					  green <= (OTHERS => '1');
					  blue <= (OTHERS => '0');
            elsif ((row > 250 and row < 280) and (column > 140 and column < 150)) THEN --c rojo
                red <= (OTHERS => '1');
                green <= (OTHERS => '0');
                blue <= (OTHERS => '0');
            elsif ((row > 280 and row < 290) and (column > 110 and column < 140)) THEN --d blanco
                red <= (OTHERS => '1');
                green <= (OTHERS => '1');
                blue <= (OTHERS => '1');
            elsif ((row > 240 and row < 250) and (column > 110 and column < 140)) THEN --g violeta
                red <= (OTHERS => '1');
                green <= (OTHERS => '0');
                blue <= (OTHERS => '1');
            else
                red <= (OTHERS => '0');
                green <= (OTHERS => '0');
                blue <= (OTHERS => '0');
            end if;

        when cuatro =>
            if ((row > 210 and row < 240) and (column > 140 and column < 150)) THEN --b verde
                red <= (OTHERS => '0');
                green <= (OTHERS => '1');
                blue <= (OTHERS => '0');
            elsif ((row > 240 and row < 250) and (column > 110 and column < 140)) THEN --g violeta
                red <= (OTHERS => '1');
                green <= (OTHERS => '0');
                blue <= (OTHERS => '1');
            elsif ((row > 250 and row < 280) and (column > 140 and column < 150)) THEN --c rojo
                red <= (OTHERS => '1');
                green <= (OTHERS => '0');
                blue <= (OTHERS => '0');
				elsif ((row > 210 and row < 240) and (column > 100 and column < 110)) THEN --f amarillo
				  red <= (OTHERS => '1');
				  green <= (OTHERS => '1');
				  blue <= (OTHERS => '0');
            else
                red <= (OTHERS => '0');
                green <= (OTHERS => '0');
                blue <= (OTHERS => '0');
            end if;

        when cinco =>
            if ((row > 200 and row < 210) and (column > 110 and column < 140)) THEN 
                red <= (OTHERS => '0');
                green <= (OTHERS => '1');
                blue <= (OTHERS => '0');
            elsif ((row > 210 and row < 240) and (column > 100 and column < 110)) THEN 
                red <= (OTHERS => '0');
                green <= (OTHERS => '0');
                blue <= (OTHERS => '1');
            elsif ((row > 280 and row < 290) and (column > 110 and column < 140)) THEN 
                red <= (OTHERS => '1');
                green <= (OTHERS => '0');
                blue <= (OTHERS => '1');
            elsif ((row > 250 and row < 280) and (column > 140 and column < 150)) THEN 
                red <= (OTHERS => '0');
                green <= (OTHERS => '1');
                blue <= (OTHERS => '1');
				elsif ((row > 240 and row < 250) and (column > 110 and column < 140)) THEN 
                red <= (OTHERS => '1');
                green <= (OTHERS => '1');
                blue <= (OTHERS => '1');
            else
                red <= (OTHERS => '0');
                green <= (OTHERS => '0');
                blue <= (OTHERS => '0');
            end if;

        when seis =>
            if ((row > 200 and row < 210) and (column > 110 and column < 140)) THEN --a azul
                red <= (OTHERS => '0');
                green <= (OTHERS => '0');
                blue <= (OTHERS => '1');
            elsif ((row > 250 and row < 280) and (column > 140 and column < 150)) THEN --c rojo
                red <= (OTHERS => '1');
                green <= (OTHERS => '0');
                blue <= (OTHERS => '0');
            elsif ((row > 280 and row < 290) and (column > 110 and column < 140)) THEN --d blanco
                red <= (OTHERS => '1');
                green <= (OTHERS => '1');
                blue <= (OTHERS => '1');
				elsif ((row > 210 and row < 240) and (column > 100 and column < 110)) THEN --f amarillo
				  red <= (OTHERS => '1');
				  green <= (OTHERS => '1');
				  blue <= (OTHERS => '0');
				elsif ((row > 250 and row < 280) and (column > 100 and column < 110)) THEN --e cian
				  red <= (OTHERS => '0');
				  green <= (OTHERS => '1');
				  blue <= (OTHERS => '1');  	 
            elsif ((row > 240 and row < 250) and (column > 110 and column < 140)) THEN --g violeta
                red <= (OTHERS => '1');
                green <= (OTHERS => '0');
                blue <= (OTHERS => '1');
            else
                red <= (OTHERS => '0');
                green <= (OTHERS => '0');
                blue <= (OTHERS => '0');
            end if;

        when siete =>
            if ((row > 200 and row < 210) and (column > 110 and column < 140)) THEN --a azul
                red <= (OTHERS => '0');
                green <= (OTHERS => '0');
                blue <= (OTHERS => '1');
            elsif ((row > 210 and row < 240) and (column > 140 and column < 150)) THEN --b verde
                red <= (OTHERS => '0');
                green <= (OTHERS => '1');
                blue <= (OTHERS => '0');
				elsif ((row > 250 and row < 280) and (column > 140 and column < 150)) THEN --c rojo
                red <= (OTHERS => '1');
                green <= (OTHERS => '0');
                blue <= (OTHERS => '0');
            else
                red <= (OTHERS => '0');
                green <= (OTHERS => '0');
                blue <= (OTHERS => '0');
            end if;

        when ocho =>
            if ((row > 200 and row < 210) and (column > 110 and column < 140)) THEN --a azul
                red <= (OTHERS => '0');
                green <= (OTHERS => '0');
                blue <= (OTHERS => '1');
            elsif ((row > 210 and row < 240) and (column > 140 and column < 150)) THEN --b verde
                red <= (OTHERS => '0');
                green <= (OTHERS => '1');
                blue <= (OTHERS => '0');
            elsif ((row > 250 and row < 280) and (column > 140 and column < 150)) THEN --c rojo
                red <= (OTHERS => '1');
                green <= (OTHERS => '0');
                blue <= (OTHERS => '0');
            elsif ((row > 280 and row < 290) and (column > 110 and column < 140)) THEN --d blanco
                red <= (OTHERS => '1');
                green <= (OTHERS => '1');
                blue <= (OTHERS => '1');
				elsif ((row > 210 and row < 240) and (column > 100 and column < 110)) THEN --f amarillo
				  red <= (OTHERS => '1');
				  green <= (OTHERS => '1');
				  blue <= (OTHERS => '0');
				elsif ((row > 250 and row < 280) and (column > 100 and column < 110)) THEN --e cian
				  red <= (OTHERS => '0');
				  green <= (OTHERS => '1');
				  blue <= (OTHERS => '1');
            elsif ((row > 240 and row < 250) and (column > 110 and column < 140)) THEN --g violeta
                red <= (OTHERS => '1');
                green <= (OTHERS => '0');
                blue <= (OTHERS => '1');
            else
                red <= (OTHERS => '0');
                green <= (OTHERS => '0');
                blue <= (OTHERS => '0');
            end if;
			 
			 when nueve =>
			 if ((row > 200 and row < 210) and (column > 110 and column < 140)) THEN --a azul
				  red <= (OTHERS => '0');
				  green <= (OTHERS => '0');
				  blue <= (OTHERS => '1');
			 elsif ((row > 210 and row < 240) and (column > 140 and column < 150)) THEN --b verde
				  red <= (OTHERS => '0');
				  green <= (OTHERS => '1');
				  blue <= (OTHERS => '0');
			 elsif ((row > 250 and row < 280) and (column > 140 and column < 150)) THEN --c rojo
				  red <= (OTHERS => '1');
				  green <= (OTHERS => '0');
				  blue <= (OTHERS => '0');
			 elsif ((row > 210 and row < 240) and (column > 100 and column < 110)) THEN --f amarillo
				  red <= (OTHERS => '1');
				  green <= (OTHERS => '1');
				  blue <= (OTHERS => '0');
			 elsif ((row > 240 and row < 250) and (column > 110 and column < 140)) THEN --g violeta
				  red <= (OTHERS => '1');
				  green <= (OTHERS => '0');
				  blue <= (OTHERS => '1');
			 else
				  red <= (OTHERS => '0'); --es el fondo
				  green <= (OTHERS => '0');
				  blue <= (OTHERS => '0');
			 end if;

		when others => red <= r0; green <= g0; blue <= b0;


		 end case;
	end if;

	End Process imagen;
	
End architecture bhv;