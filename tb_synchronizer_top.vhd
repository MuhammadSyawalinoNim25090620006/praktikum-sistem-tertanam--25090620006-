library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_synchronizer_top is
end tb_synchronizer_top;

architecture Behavioral of tb_synchronizer_top is

    component synchronizer_top
        Port (
            clk  : in STD_LOGIC;
            btnC : in STD_LOGIC;
            led  : out STD_LOGIC_VECTOR (7 downto 0)
        );
    end component;

    signal clk  : STD_LOGIC := '0';
    signal btnC : STD_LOGIC := '0';
    signal led  : STD_LOGIC_VECTOR (7 downto 0);

begin

    uut: synchronizer_top
        port map (
            clk  => clk,
            btnC => btnC,
            led  => led
        );

    -- Clock periode 20 ns
    clk_process : process
    begin
        while true loop
            clk <= '0';
            wait for 10 ns;
            clk <= '1';
            wait for 10 ns;
        end loop;
    end process;

    -- Pengujian tombol
    stim_proc : process
    begin

        -- Kondisi awal
        btnC <= '0';
        wait for 40 ns;

        -- Tekan tombol pertama
        btnC <= '1';
        wait for 40 ns;

        -- Lepaskan tombol
        btnC <= '0';
        wait for 40 ns;

        -- Tekan tombol kedua
        btnC <= '1';
        wait for 40 ns;

        -- Lepaskan tombol
        btnC <= '0';
        wait for 40 ns;

        -- Tekan tombol ketiga
        btnC <= '1';
        wait for 40 ns;

        -- Lepaskan tombol
        btnC <= '0';
        wait for 40 ns;

        wait;
    end process;

end Behavioral;