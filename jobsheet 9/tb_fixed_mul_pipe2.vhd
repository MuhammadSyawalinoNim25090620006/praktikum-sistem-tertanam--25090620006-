
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_fixed_mul_pipe2 is
end tb_fixed_mul_pipe2;

architecture sim of tb_fixed_mul_pipe2 is
    signal clk : STD_LOGIC := '0';

    signal a : STD_LOGIC_VECTOR(15 downto 0)
             := (others => '0');

    signal b : STD_LOGIC_VECTOR(15 downto 0)
             := (others => '0');

    signal result : STD_LOGIC_VECTOR(15 downto 0);
begin

    -- Clock periode 10 ns
    clk <= not clk after 5 ns;

    uut: entity work.fixed_mul_pipe2
        port map (
            clk    => clk,
            a      => a,
            b      => b,
            result => result
        );

    stimulus: process
    begin
        -- Tes 1: 2,0 x 3,0 = 6,0
        wait until falling_edge(clk);
        a <= x"0200";
        b <= x"0300";

        wait until rising_edge(clk);
        wait until rising_edge(clk);
        wait for 1 ns;

        assert result = x"0600"
            report "ERROR: Tes 1 gagal"
            severity error;

        -- Tes 2: 1,5 x 2,0 = 3,0
        wait until falling_edge(clk);
        a <= x"0180";
        b <= x"0200";

        wait until rising_edge(clk);
        wait until rising_edge(clk);
        wait for 1 ns;

        assert result = x"0300"
            report "ERROR: Tes 2 gagal"
            severity error;

        -- Tes 3: 0,5 x 0,5 = 0,25
        wait until falling_edge(clk);
        a <= x"0080";
        b <= x"0080";

        wait until rising_edge(clk);
        wait until rising_edge(clk);
        wait for 1 ns;

        assert result = x"0040"
            report "ERROR: Tes 3 gagal"
            severity error;

        report "Semua pengujian pipeline berhasil"
            severity note;

        wait;
    end process;

end sim;
