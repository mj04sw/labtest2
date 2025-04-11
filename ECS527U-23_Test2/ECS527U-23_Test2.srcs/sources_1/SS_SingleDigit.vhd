library IEEE;
use IEEE.std_logic_1164.all;

entity SS_SingleDigit is
    port(
		d: in  std_logic_vector(3 downto 0);
		q: out std_logic_vector(7 downto 0));	 
end SS_SingleDigit;

architecture behav of SS_SingleDigit is
	signal qi: std_logic_vector(7 downto 0);	 
begin
	process(d)
	begin
		case d is
            ----------------------pgfedcba
			when "0000" => qi <= "00111111"; --0
			when "0001" => qi <= "00000110"; --1
			when "0010" => qi <= "01011011"; --2
			when "0011" => qi <= "01001111"; --3
			when "0100" => qi <= "01100110"; --4
			when "0101" => qi <= "01101101"; --5
			when "0110" => qi <= "01111101"; --6
			when "0111" => qi <= "00000111"; --7
			when "1000" => qi <= "01111111"; --8
			when "1001" => qi <= "01101111"; --9
			when "1010" => qi <= "01110111"; --A
			when "1011" => qi <= "01111100"; --b
			when "1100" => qi <= "00111001"; --C
			when "1101" => qi <= "01011110"; --d
			when "1110" => qi <= "01111001"; --E
			when "1111" => qi <= "01110001"; --F
			--when "1111" => qi <= "00111110"; -- U
			when others => qi <= "00000000";
		end case;
	end process;	
    q <= not qi; -- cathode, inverted
end behav;
