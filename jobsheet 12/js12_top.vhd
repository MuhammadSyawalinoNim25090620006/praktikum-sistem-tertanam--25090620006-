
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity js12_top is
    Port (
        -- Clock sistem 100 MHz
        clk     : in  STD_LOGIC;

        -- Input keyboard PS/2
        PS2Clk  : in  STD_LOGIC;
        PS2Data : in  STD_LOGIC;

        -- Output seven-segment
        seg     : out STD_LOGIC_VECTOR(6 downto 0);
        an      : out STD_LOGIC_VECTOR(3 downto 0);
        dp      : out STD_LOGIC;

        -- Output LED0 Basys 3
        led     : out STD_LOGIC_VECTOR(0 downto 0)
    );
end js12_top;

architecture Behavioral of js12_top is

    -- Sinyal dari PS/2 Receiver
    signal scan_code_wire  : STD_LOGIC_VECTOR(7 downto 0);
    signal data_ready_wire : STD_LOGIC;

    -- Hasil konversi ASCII
    signal ascii_code : STD_LOGIC_VECTOR(7 downto 0)
                       := x"00";

    -- Penanda Break Code
    signal break_pending : STD_LOGIC := '0';

    -- Penyimpanan kondisi LED
    signal led0_reg : STD_LOGIC := '0';

begin

    -- =====================================
    -- 1. PS/2 RECEIVER
    -- =====================================

    U1: entity work.ps2_receiver
        port map (
            clk        => clk,
            ps2_clk    => PS2Clk,
            ps2_data   => PS2Data,
            scan_code  => scan_code_wire,
            data_ready => data_ready_wire
        );


    -- =====================================
    -- 2. MAKE CODE, BREAK CODE DAN ASCII
    -- =====================================

    process(clk)
    begin
        if rising_edge(clk) then

            if data_ready_wire = '1' then

                -- Mendeteksi Break Code F0
                if scan_code_wire = x"F0" then

                    break_pending <= '1';

                -- Membaca scan code setelah F0
                elsif break_pending = '1' then

                    -- Jika tombol A dilepas
                    if scan_code_wire = x"1C" then
                        led0_reg <= '0';
                    end if;

                    -- Reset penanda break code
                    break_pending <= '0';

                else

                    -- Make Code tombol A
                    if scan_code_wire = x"1C" then
                        led0_reg <= '1';
                    end if;

                    -- Lookup Scan Code ke ASCII
                    case scan_code_wire is

                        -- HURUF A-Z
                        when x"1C" =>
                            ascii_code <= x"41"; -- A

                        when x"32" =>
                            ascii_code <= x"42"; -- B

                        when x"21" =>
                            ascii_code <= x"43"; -- C

                        when x"23" =>
                            ascii_code <= x"44"; -- D

                        when x"24" =>
                            ascii_code <= x"45"; -- E

                        when x"2B" =>
                            ascii_code <= x"46"; -- F

                        when x"34" =>
                            ascii_code <= x"47"; -- G

                        when x"33" =>
                            ascii_code <= x"48"; -- H

                        when x"43" =>
                            ascii_code <= x"49"; -- I

                        when x"3B" =>
                            ascii_code <= x"4A"; -- J

                        when x"42" =>
                            ascii_code <= x"4B"; -- K

                        when x"4B" =>
                            ascii_code <= x"4C"; -- L

                        when x"3A" =>
                            ascii_code <= x"4D"; -- M

                        when x"31" =>
                            ascii_code <= x"4E"; -- N

                        when x"44" =>
                            ascii_code <= x"4F"; -- O

                        when x"4D" =>
                            ascii_code <= x"50"; -- P

                        when x"15" =>
                            ascii_code <= x"51"; -- Q

                        when x"2D" =>
                            ascii_code <= x"52"; -- R

                        when x"1B" =>
                            ascii_code <= x"53"; -- S

                        when x"2C" =>
                            ascii_code <= x"54"; -- T

                        when x"3C" =>
                            ascii_code <= x"55"; -- U

                        when x"2A" =>
                            ascii_code <= x"56"; -- V

                        when x"1D" =>
                            ascii_code <= x"57"; -- W

                        when x"22" =>
                            ascii_code <= x"58"; -- X

                        when x"35" =>
                            ascii_code <= x"59"; -- Y

                        when x"1A" =>
                            ascii_code <= x"5A"; -- Z


                        -- ANGKA 0-9
                        when x"45" =>
                            ascii_code <= x"30"; -- 0

                        when x"16" =>
                            ascii_code <= x"31"; -- 1

                        when x"1E" =>
                            ascii_code <= x"32"; -- 2

                        when x"26" =>
                            ascii_code <= x"33"; -- 3

                        when x"25" =>
                            ascii_code <= x"34"; -- 4

                        when x"2E" =>
                            ascii_code <= x"35"; -- 5

                        when x"36" =>
                            ascii_code <= x"36"; -- 6

                        when x"3D" =>
                            ascii_code <= x"37"; -- 7

                        when x"3E" =>
                            ascii_code <= x"38"; -- 8

                        when x"46" =>
                            ascii_code <= x"39"; -- 9


                        -- Kode tidak dikenal
                        when others =>
                            null;

                    end case;

                end if;
            end if;
        end if;
    end process;


    -- =====================================
    -- 3. OUTPUT LED0
    -- =====================================

    led(0) <= led0_reg;


    -- =====================================
    -- 4. SEVEN SEGMENT DRIVER
    -- =====================================

    U2: entity work.seven_seg_driver
        port map (
            clk      => clk,
            hex_data => ascii_code,
            seg      => seg,
            an       => an,
            dp       => dp
        );

end Behavioral;
