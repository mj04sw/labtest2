library IEEE;
use IEEE.std_logic_1164.all;
--use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity BB_Top is
port (
	sw	: in  std_logic_vector(15 downto 0);
	btn	: in  std_logic_vector(3 downto 0);
	led	: out std_logic_vector(15 downto 0);
	RGB0: out std_logic_vector(2 downto 0);
    RGB1: out std_logic_vector(2 downto 0);
	
	sysclk_100mhz: in std_logic; -- 100 MHz
	
	D0_AN: out std_logic_vector(3 downto 0);
	D0_SEG: out std_logic_vector(7 downto 0);
	D1_AN: out std_logic_vector(3 downto 0);
    D1_SEG: out std_logic_vector(7 downto 0);

    UART_rxd: in std_logic;
    UART_txd: out std_logic
);
end BB_Top;

architecture BB_Top_arch of BB_Top is
    signal btn_buf: std_logic_vector(3 downto 0);
--    -- btn_x: are buffered buttons that give pulses of exactly 1 clock period when pressed
    signal btn_x: std_logic_vector(3 downto 0); 
--    signal CLK: std_logic;

    -- 7 segment displays: 4x BCDs
	--signal ss7, ss6, ss5, ss4: std_logic_vector(3 downto 0);
	signal ss3, ss2, ss1, ss0: std_logic_vector(3 downto 0);
    signal btn_top, btn_btm: std_logic_vector(1 downto 0);

    -- Add your core as a component here
    component BB_Core is
        port (
            sw:  in  std_logic_vector(15 downto 0);
            btn: in  std_logic_vector(3 downto 0);
            CLK: in  std_logic;
            led: out std_logic_vector(15 downto 0);
            ss3: out std_logic_vector(3 downto 0);
            ss2: out std_logic_vector(3 downto 0);
            ss1: out std_logic_vector(3 downto 0);
            ss0: out std_logic_vector(3 downto 0)
        );
    end component;

    component SS_Decoder is
        generic (clkdiv_width: integer := 21);
        port (
            d3 	: in  std_logic_vector(3 downto 0); -- BCD digit 3 (Left)
            d2 	: in  std_logic_vector(3 downto 0); -- BCD digit 2 
            d1 	: in  std_logic_vector(3 downto 0); -- BCD digit 1 
            d0 	: in  std_logic_vector(3 downto 0); -- BCD digit 0 (Right)
            a  	: out std_logic_vector(3 downto 0); -- Anode
            c	: out std_logic_vector(7 downto 0); -- Cathode
            clk	: in  std_logic
        );
    end component;
    signal CLK: std_logic; -- for the BB_core
    signal BB_reset, BB_reset_n: std_logic; -- active-high
    signal state: std_logic_vector(1 downto 0);
    signal swr: std_logic_vector(15 downto 0); -- sw remote as shift register via uart
    signal clk_divisor: std_logic_vector(27 downto 0);
begin  
 
    -- Create an instance of your component and port map devices
	core_inst: BB_Core
	port map (
	   sw => sw,
       btn => btn_x,
       CLK => CLK,
	   led => led,
	   ss3 => ss3,
	   ss2 => ss2,
	   ss1 => ss1,
	   ss0 => ss0
	);

    --
    -- STAY OFF: DO NOT MODIFY THE CODE BELOW --
    --
    D0_AN <= "1111"; -- OFF
    --SS_D0: SS_Decoder port map (d3 => ss7, d2 => ss6, d1 => ss5, d0 => ss4, 
    --                            a => D0_AN, c => D0_SEG, clk => clk);
    SS_D1: SS_Decoder port map (d3 => ss3, d2 => ss2, d1 => ss1, d0 => ss0, 
                                a => D1_AN, c => D1_SEG, clk => sysclk_100mhz);
    -- Clock divisor
    --CLK <= sysclk_100mhz; -- IF YOU USE THE STANDARD SYSTEM CLOCK 100 MHz
    CLK <= clk_divisor(25); -- IF YOU USE A SLOWER CLOCK
	process(sysclk_100mhz)
	begin
		if (sysclk_100mhz'event and sysclk_100mhz = '1') then
			clk_divisor <= clk_divisor + 1;
        end if;
    end process;

    -- main reset signal
    BB_reset <= btn(0);
    BB_reset_n <= not BB_reset;
 
    -- handle buttons
    btn_x <= btn and not btn_buf;
    -- Buffer the button to generate a pulse of exactly 1 clock period
    process (sysclk_100mhz)
    begin
        if sysclk_100mhz'event and sysclk_100mhz = '1' then
            btn_buf <= btn;
        end if;
    end process;
    
    -- RGB LED demos
    btn_top <= btn(0) & btn(1);
    btn_btm <= btn(2) & btn(3);
    
    with btn_top select
        RGB0 <= "000" when "00",
                "100" when "10",
                "010" when "01",
                "001" when others;
    with btn_btm select
        RGB1 <= "000" when "00",
                "110" when "10",
                "011" when "01",
                "101" when others;
end BB_Top_arch;
