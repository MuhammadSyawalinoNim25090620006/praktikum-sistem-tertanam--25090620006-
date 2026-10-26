
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use std.env.all;

entity tb_bram_1024x8 is
end entity tb_bram_1024x8;

architecture sim of tb_bram_1024x8 is

    signal clk : std_logic := '0';
    signal we  : std_logic := '0';

    -- Sinyal untuk tampilan desimal
    signal addr_dec : integer range 0 to 1023 := 0;
    signal din_dec  : integer range 0 to 255 := 0;
    signal dout_dec : integer range 0 to 255 := 0;

    -- Bus penghubung ke BRAM
    signal addr_vec : std_logic_vector(9 downto 0);
    signal din_vec  : std_logic_vector(7 downto 0);
    signal dout_vec : std_logic_vector(7 downto 0);

    function slv_to_integer_safe(
        v : std_logic_vector
    ) return integer is
    begin
        if is_x(v) then
            return 0;
        else
            return to_integer(unsigned(v));
        end if;
    end function;

begin

    -- Clock dengan periode 10 ns
    clk <= not clk after 5 ns;

    -- Konversi desimal ke bus BRAM
    addr_vec <= std_logic_vector(to_unsigned(addr_dec, 10));
    din_vec  <= std_logic_vector(to_unsigned(din_dec, 8));

    -- Tampilan keluaran dalam desimal
    dout_dec <= slv_to_integer_safe(dout_vec);

    uut: entity work.bram_1024x8
        port map (
            clk  => clk,
            we   => we,
            addr => addr_vec,
            din  => din_vec,
            dout => dout_vec
        );

    stimulus: process
    begin

        -- Menulis data 165 ke alamat 5
        wait until falling_edge(clk);
        we <= '1';
        addr_dec <= 5;
        din_dec <= 165;
        wait until rising_edge(clk);

        -- Menulis data 60 ke alamat 512
        wait until falling_edge(clk);
        addr_dec <= 512;
        din_dec <= 60;
        wait until rising_edge(clk);

        -- Menulis data 126 ke alamat 1023
        wait until falling_edge(clk);
        addr_dec <= 1023;
        din_dec <= 126;
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

        -- Membaca alamat 512
        wait until falling_edge(clk);
        addr_dec <= 512;
        wait until rising_edge(clk);
        wait for 1 ns;

        assert dout_dec = 60
            report "GAGAL: alamat 512"
            severity failure;

        -- Membaca alamat 1023
        wait until falling_edge(clk);
        addr_dec <= 1023;
        wait until rising_edge(clk);
        wait for 1 ns;

        assert dout_dec = 126
            report "GAGAL: alamat 1023"
            severity failure;

        report "PASS: semua data BRAM 1024x8 berhasil diuji"
            severity note;

        stop;
        wait;

    end process;

end architecture sim;
