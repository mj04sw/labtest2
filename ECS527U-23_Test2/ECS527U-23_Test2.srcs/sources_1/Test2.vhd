-- Student ID: 230414158
library IEEE;
use IEEE.std_logic_1164.all;

entity Test2 is
port (
    CLK:  in std_logic;
    LD:   in std_logic;
    D_IN: in  std_logic_vector(7 downto 0);
    Q:    out std_logic_vector(7 downto 0));
end Test2;

architecture arch of Test2 is
    signal reg: std_logic_vector(7 downto 0);
    signal s_in: std_logic;
begin
    -- Process for the shift register
    process(CLK)
    begin
        if rising_edge(CLK) then
            if LD = '1' then
                reg <= D_IN;  -- Synchronous load
            else
                -- Shift right and insert feedback bit
                reg <= s_in & reg(7 downto 1);
            end if;
        end if;
    end process;

    -- Feedback logic: XOR of bits 7, 6, and 5
    s_in <= reg(7) xor (reg(6) xor reg(5));

    -- Output assignment
    Q <= reg;
end arch;
