library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_debounce is
end tb_debounce;

architecture Behavioral of tb_debounce is

    signal clk     : STD_LOGIC := '0';
    signal btn_in  : STD_LOGIC := '0';
    signal btn_out : STD_LOGIC;

begin

    -- Clock 100 MHz
    clk <= not clk after 5 ns;

    -- Unit Under Test
    uut : entity work.debounce
        generic map (
            CLK_FREQ_HZ => 100_000_000,
            STABLE_MS   => 10
        )
        port map (
            clk     => clk,
            btn_in  => btn_in,
            btn_out => btn_out
        );

    -- Stimulus
    process
    begin

        -- Kondisi awal
        btn_in <= '0';
        wait for 20 ms;

        -- Simulasi bouncing tombol
        btn_in <= '1';
        wait for 1 ms;

        btn_in <= '0';
        wait for 1 ms;

        btn_in <= '1';
        wait for 1 ms;

        btn_in <= '0';
        wait for 1 ms;

        btn_in <= '1';

        -- Biarkan stabil
        wait for 15 ms;

        -- Lepas tombol
        btn_in <= '0';

        -- Biarkan stabil
        wait for 15 ms;

        wait;
    end process;

end Behavioral;