----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01.09.2026 19:28:22
-- Design Name: 
-- Module Name: tb_led_switch_top - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity tb_led_switch_top is
--  Port ( );
end tb_led_switch_top;

architecture Behavioral of tb_led_switch_top is

    signal sw  : STD_LOGIC_VECTOR (15 downto 0);
    signal led : STD_LOGIC_VECTOR (15 downto 0);
begin
 uut: entity work.led_switch_top
        port map (
            sw  => sw,
            led => led
        );
process
    begin

        sw <= "0000000000000000";
        wait for 10 ns;

        sw <= "1111111111111111";
        wait for 10 ns;

        sw <= "0000111110101010";
        wait for 10 ns;

        wait;
    end process;
    
end Behavioral;
