
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use std.env.all;

entity tb_bram_256x8 is
end entity tb_bram_256x8;

architecture sim of tb_bram_256x8 is

    signal clk : std_logic := '0';
    signal we  : std_logic := '0';

    -- Nilai yang ditampilkan dalam desimal
    signal addr_dec : integer range 0 to 255 := 0;
    signal din_dec  : integer range 0 to 255 := 0;
    signal dout_dec : integer range 0 to 255 := 0;

    -- Koneksi ke modul BRAM
    signal addr_vec : std_logic_vector(7 downto 0);
    signal din_vec  : std_logic_vector(7 downto 0);
    signal dout_vec : std_logic_vector(7 downto 0);

begin

    clk <= not clk after 5 ns;

    -- Konversi nilai desimal ke format 8-bit
    addr_vec <= std_logic_vector(to_unsigned(addr_dec, 8));
    din_vec  <= std_logic_vector(to_unsigned(din_dec, 8));

    -- Konversi keluaran BRAM ke desimal
    dout_dec <= to_integer(unsigned(dout_vec));

    uut: entity work.bram_256x8
        port map (
            clk  => clk,
            we   => we,
            addr => addr_vec,
            din  => din_vec,
            dout => dout_vec
        );

    stimulus: process
    begin

        -- Menulis data 165 pada alamat 5
        wait until falling_edge(clk);
        we <= '1';
        addr_dec <= 5;
        din_dec  <= 165;
        wait until rising_edge(clk);

        -- Menulis data 60 pada alamat 18
        wait until falling_edge(clk);
        addr_dec <= 18;
        din_dec  <= 60;
        wait until rising_edge(clk);

        -- Menulis data 126 pada alamat 240
        wait until falling_edge(clk);
        addr_dec <= 240;
        din_dec  <= 126;
        wait until rising_edge(clk);

        -- Membaca alamat 5
        wait until falling_edge(clk);
        we <= '0';
        addr_dec <= 5;
        wait until rising_edge(clk);
        wait for 1 ns;

        assert dout_dec = 165
            report "GAGAL: alamat 5"
            severity failure;

        -- Membaca alamat 18
        wait until falling_edge(clk);
        addr_dec <= 18;
        wait until rising_edge(clk);
        wait for 1 ns;

        assert dout_dec = 60
            report "GAGAL: alamat 18"
            severity failure;

        -- Membaca alamat 240
        wait until falling_edge(clk);
        addr_dec <= 240;
        wait until rising_edge(clk);
        wait for 1 ns;

        assert dout_dec = 126
            report "GAGAL: alamat 240"
            severity failure;

        report "PASS: semua data BRAM berhasil diuji"
            severity note;

        stop;
        wait;

    end process;

end architecture sim;
