library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity SS_Decoder is
	generic (clkdiv_width: integer := 16);
    port (
        d3 	: in  std_logic_vector(3 downto 0); -- BCD digit 3 (Left)
        d2 	: in  std_logic_vector(3 downto 0); -- BCD digit 2 
        d1 	: in  std_logic_vector(3 downto 0); -- BCD digit 1 
        d0 	: in  std_logic_vector(3 downto 0); -- BCD digit 0 (Right)
        a  	: out std_logic_vector(3 downto 0); -- Anode
        c	: out std_logic_vector(7 downto 0); -- Cathode
        clk	: in  std_logic
    );
end SS_Decoder;

architecture behav of SS_Decoder is
	component SS_SingleDigit
	port (
		d: in  std_logic_vector(3 downto 0);
		q: out std_logic_vector(7 downto 0)); -- includes DP
	end component;
	-- signals
    signal count: std_logic_vector(clkdiv_width-1 downto 0);
    signal scanbits: std_logic_vector(1 downto 0);
    signal a_t: std_logic_vector(3 downto 0);
    signal anode_en: std_logic;
	signal q0, q1, q2, q3: std_logic_vector(7 downto 0); -- decoded 7-segment q signals
begin
	-- port maps
	-- 2 individual 7-seg decoder
	digit3: SS_SingleDigit port map(d => d3, q => q3);
	digit2: SS_SingleDigit port map(d => d2, q => q2);
	digit1: SS_SingleDigit port map(d => d1, q => q1);
	digit0: SS_SingleDigit port map(d => d0, q => q0);

	-- clock divider, divide clock to scanning frequency
    -- clk: 100 MHz
    -- to match the required refresh frequency 60 Hz to 1 kHz,
    clkdiv_proc: process(clk)
	begin
		if (clk'event and clk = '1') then
			count <= count + 1;
		end if;
	end process clkdiv_proc;
    
    anode_en <= '1' when count(clkdiv_width - 1 downto clkdiv_width - 3) = "111" else '0';
    scanbits <= count(clkdiv_width - 4 downto clkdiv_width - 5);

    -- Anodes are turned ON only 1/8 of the time to reduce brightness
    a <= a_t when anode_en = '1' else "1111";
    
    with scanbits select
        a_t <= "0111" when "11",
               "1011" when "10",
               "1101" when "01",
               "1110" when "00",
               "1111" when others;

    with scanbits select
        c <= q3 when "11",
             q2 when "10",
             q1 when "01",
             q0 when others;
end behav;
