library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_edge_detect is
end tb_edge_detect;

architecture Behavioral of tb_edge_detect is

    signal clk    : STD_LOGIC := '0';
    signal sig_in : STD_LOGIC := '0';
    signal pulse  : STD_LOGIC;

begin

    -- Clock 100 MHz
    clk <= not clk after 5 ns;

    -- Unit Under Test
    uut : entity work.edge_detect
        port map (
            clk    => clk,
            sig_in => sig_in,
            pulse  => pulse
        );

    -- Stimulus
    process
    begin
        sig_in <= '0';
        wait for 30 ns;

        -- Rising edge pertama
        sig_in <= '1';
        wait for 30 ns;

        -- Tetap HIGH
        wait for 30 ns;

        -- Turun
        sig_in <= '0';
        wait for 30 ns;

        -- Rising edge kedua
        sig_in <= '1';
        wait for 30 ns;

        -- Tetap HIGH
        wait for 30 ns;

        wait;
    end process;

end Behavioral;