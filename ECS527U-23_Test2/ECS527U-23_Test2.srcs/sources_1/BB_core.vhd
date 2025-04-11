----------------------------------------------------------------------------------
-- Company:  Queen Mary University of London
-- Engineer: Matthew Tang
-- 
-- Updated    : 30.03.2023 
-- Design Name: BB_core
-- Module Name: BB_core - Behavioral
-- Project Name: ECS527U Labs
-- Target Devices: Boolean Board
-- Tool Versions: Vivado 2017.03
-- 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity BB_core is
    port (
        sw:  in  std_logic_vector(15 downto 0);
        btn: in  std_logic_vector(3 downto 0); -- push button buffered
        CLK: in  std_logic; -- the clock signal
        led: out std_logic_vector(15 downto 0);
        ss3: out std_logic_vector(3 downto 0);
        ss2: out std_logic_vector(3 downto 0);
        ss1: out std_logic_vector(3 downto 0);
        ss0: out std_logic_vector(3 downto 0)
    );
end BB_core;

architecture structural of BB_core is
    -- signal(s) and component(s) declaration

begin    
    -- port map statement for Test2 block


    -- statement(s) for device mapping (if any)

end structural;
