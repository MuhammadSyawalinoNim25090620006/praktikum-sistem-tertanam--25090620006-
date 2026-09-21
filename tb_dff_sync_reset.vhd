
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_dff_sync_reset is
end tb_dff_sync_reset;

architecture Behavioral of tb_dff_sync_reset is

    component dff_sync_reset
        Port (
            clk : in STD_LOGIC;
            rst : in STD_LOGIC;
            d   : in STD_LOGIC;
            q   : out STD_LOGIC
        );
    end component;

    signal clk : STD_LOGIC := '0';
    signal rst : STD_LOGIC := '0';
    signal d   : STD_LOGIC := '0';
    signal q   : STD_LOGIC;

begin

    uut: dff_sync_reset
        port map (
            clk => clk,
            rst => rst,
            d   => d,
            q   => q
        );

    -- Clock periode 20 ns
    clk_process: process
    begin
        while true loop
            clk <= '0';
            wait for 10 ns;

            clk <= '1';
            wait for 10 ns;
        end loop;
    end process;

    -- Pengujian input
    stim_proc: process
    begin

        -- Kondisi awal
        rst <= '1';
        d <= '0';
        wait for 20 ns;

        -- Reset dimatikan, D = 1
        rst <= '0';
        d <= '1';
        wait for 20 ns;

        -- D = 0
        d <= '0';
        wait for 20 ns;

        -- Reset aktif kembali
        rst <= '1';
        d <= '1';
        wait for 20 ns;

        -- Reset dimatikan
        rst <= '0';
        d <= '1';
        wait for 20 ns;

        wait;
    end process;

end Behavioral;