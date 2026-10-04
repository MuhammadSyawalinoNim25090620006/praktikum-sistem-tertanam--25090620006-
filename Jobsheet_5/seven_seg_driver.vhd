library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity seven_seg_driver is
    generic (
        CLK_FREQ_HZ : integer := 100_000_000;
        DIGITS      : integer := 4
    );
    port (
        clk   : in  STD_LOGIC;
        value : in  STD_LOGIC_VECTOR(15 downto 0);
        seg   : out STD_LOGIC_VECTOR(6 downto 0);
        dp    : out STD_LOGIC;
        an    : out STD_LOGIC_VECTOR(3 downto 0)
    );
end seven_seg_driver;

architecture Behavioral of seven_seg_driver is

    -- Pembagi clock untuk refresh sekitar 1 kHz
    constant REFRESH_COUNT : integer := CLK_FREQ_HZ / 1000;

    signal refresh_cnt : integer range 0 to REFRESH_COUNT - 1 := 0;
    signal digit_sel   : unsigned(1 downto 0) := "00";

    -- Konversi 1 digit BCD (0-9)
    -- menjadi pola seven-segment aktif-rendah
    -- seg(6 downto 0) = g f e d c b a
    function bcd_to_seg(
        digit : unsigned(3 downto 0)
    ) return STD_LOGIC_VECTOR is
    begin
        case digit is
            when "0000" => return "1000000"; -- 0
            when "0001" => return "1111001"; -- 1
            when "0010" => return "0100100"; -- 2
            when "0011" => return "0110000"; -- 3
            when "0100" => return "0011001"; -- 4
            when "0101" => return "0010010"; -- 5
            when "0110" => return "0000010"; -- 6
            when "0111" => return "1111000"; -- 7
            when "1000" => return "0000000"; -- 8
            when "1001" => return "0010000"; -- 9
            when others => return "0111111"; -- -
        end case;
    end function;

begin

    -- Clock divider dan pemilih digit
    process(clk)
    begin
        if rising_edge(clk) then
            if refresh_cnt = REFRESH_COUNT - 1 then
                refresh_cnt <= 0;
                digit_sel <= digit_sel + 1;
            else
                refresh_cnt <= refresh_cnt + 1;
            end if;
        end if;
    end process;

    -- Multiplexing seven-segment
    process(digit_sel, value)
        variable digit : unsigned(3 downto 0);
    begin

        -- Semua digit dimatikan terlebih dahulu
        an <= "1111";

        case digit_sel is

            when "00" =>
                digit := unsigned(value(3 downto 0));
                an <= "1110";

            when "01" =>
                digit := unsigned(value(7 downto 4));
                an <= "1101";

            when "10" =>
                digit := unsigned(value(11 downto 8));
                an <= "1011";

            when "11" =>
                digit := unsigned(value(15 downto 12));
                an <= "0111";

            when others =>
                digit := "0000";
                an <= "1111";

        end case;

        seg <= bcd_to_seg(digit);

        -- Decimal point dimatikan
        dp <= '1';

    end process;

end Behavioral;