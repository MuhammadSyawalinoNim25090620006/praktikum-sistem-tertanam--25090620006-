----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08.09.2026 20:43:53
-- Design Name: 
-- Module Name: tb_mux8to1 - sim
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

entity tb_mux8to1 is
end tb_mux8to1;

architecture sim of tb_mux8to1 is

    signal sel_tb : STD_LOGIC_VECTOR (2 downto 0);
    signal in0_tb : STD_LOGIC_VECTOR (3 downto 0);
    signal in1_tb : STD_LOGIC_VECTOR (3 downto 0);
    signal in2_tb : STD_LOGIC_VECTOR (3 downto 0);
    signal in3_tb : STD_LOGIC_VECTOR (3 downto 0);
    signal in4_tb : STD_LOGIC_VECTOR (3 downto 0);
    signal in5_tb : STD_LOGIC_VECTOR (3 downto 0);
    signal in6_tb : STD_LOGIC_VECTOR (3 downto 0);
    signal in7_tb : STD_LOGIC_VECTOR (3 downto 0);
    signal y_tb   : STD_LOGIC_VECTOR (3 downto 0);

begin

    DUT: entity work.mux8to1
        port map (
            sel => sel_tb,
            in0 => in0_tb,
            in1 => in1_tb,
            in2 => in2_tb,
            in3 => in3_tb,
            in4 => in4_tb,
            in5 => in5_tb,
            in6 => in6_tb,
            in7 => in7_tb,
            y   => y_tb
        );

    stim_proc: process
    begin

        sel_tb <= "000";
        in0_tb <= "0001";
        in1_tb <= "0010";
        in2_tb <= "0011";
        in3_tb <= "0100";
        in4_tb <= "0101";
        in5_tb <= "0110";
        in6_tb <= "0111";
        in7_tb <= "1000";
        wait for 20 ns;

        sel_tb <= "001";
        wait for 20 ns;

        sel_tb <= "010";
        wait for 20 ns;

        sel_tb <= "011";
        wait for 20 ns;

        sel_tb <= "100";
        wait for 20 ns;

        sel_tb <= "101";
        wait for 20 ns;

        sel_tb <= "110";
        wait for 20 ns;

        sel_tb <= "111";
        wait for 20 ns;

        wait;
    end process;

end sim;
