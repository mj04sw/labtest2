library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Test2_tb is
end Test2_tb;

architecture behavioral of Test2_tb is
    -- Component declaration for the Unit Under Test (UUT)
    component Test2
    port (
        CLK:  in std_logic;
        LD:   in std_logic;
        D_IN: in std_logic_vector(7 downto 0);
        Q:    out std_logic_vector(7 downto 0)
    );
    end component;

    -- Inputs
    signal CLK: std_logic := '0';
    signal LD: std_logic := '0';
    signal D_IN: std_logic_vector(7 downto 0) := (others => '0');

    -- Outputs
    signal Q: std_logic_vector(7 downto 0);

    -- Clock period definition
    constant CLK_period: time := 10 ns;

begin
    -- Instantiate the Unit Under Test (UUT)
    uut: Test2 port map (
        CLK => CLK,
        LD => LD,
        D_IN => D_IN,
        Q => Q
    );

    -- Clock process definitions
    CLK_process: process
    begin
        CLK <= '0';
        wait for CLK_period/2;
        CLK <= '1';
        wait for CLK_period/2;
    end process;

    -- Stimulus process
    stim_proc: process
    begin
        -- Initial load of X = 58 (0x3A)
        D_IN <= "00111010";  -- 58 in binary
        LD <= '1';
        wait for CLK_period;
        LD <= '0';
        
        -- Let it run for 6 cycles
        wait for 6 * CLK_period;
        
        -- Load X again
        LD <= '1';
        wait for CLK_period;
        LD <= '0';
        
        -- Let it run for 6 more cycles
        wait for 6 * CLK_period;
        
        wait;
    end process;
end behavioral; 