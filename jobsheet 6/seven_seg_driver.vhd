library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity seven_seg_driver is
    Generic (
        CLK_FREQ_HZ : integer := 100_000_000;
        DIGITS      : integer := 4
    );
    Port (
        clk     : in  STD_LOGIC;
        data_in : in  STD_LOGIC_VECTOR(15 downto 0);
        seg     : out STD_LOGIC_VECTOR(6 downto 0);
        dp      : out STD_LOGIC;
        an      : out STD_LOGIC_VECTOR(3 downto 0)
    );
end seven_seg_driver;

architecture Behavioral of seven_seg_driver is

    constant REFRESH_TICKS : integer := CLK_FREQ_HZ / 1000;

    signal refresh_cnt : integer range 0 to REFRESH_TICKS - 1 := 0;
    signal digit_sel   : integer range 0 to 3 := 0;

    signal digit_value : STD_LOGIC_VECTOR(3 downto 0);

begin

    --------------------------------------------------------------
    -- CLOCK REFRESH
    --------------------------------------------------------------
    process(clk)
    begin
        if rising_edge(clk) then

            if refresh_cnt = REFRESH_TICKS - 1 then

                refresh_cnt <= 0;

                if digit_sel = 3 then
                    digit_sel <= 0;
                else
                    digit_sel <= digit_sel + 1;
                end if;

            else
                refresh_cnt <= refresh_cnt + 1;
            end if;

        end if;
    end process;


    --------------------------------------------------------------
    -- PEMILIH DIGIT
    -- data_in berupa 4 digit BCD
    --------------------------------------------------------------
    process(digit_sel, data_in)
    begin

        case digit_sel is

            when 0 =>
                digit_value <= data_in(3 downto 0);

            when 1 =>
                digit_value <= data_in(7 downto 4);

            when 2 =>
                digit_value <= data_in(11 downto 8);

            when 3 =>
                digit_value <= data_in(15 downto 12);

            when others =>
                digit_value <= "0000";

        end case;

    end process;


    --------------------------------------------------------------
    -- DECIMAL 0-9
    -- seg(6 downto 0) = g f e d c b a
    -- aktif LOW
    --------------------------------------------------------------
    process(digit_value)
    begin

        case digit_value is

            when "0000" =>
                seg <= "1000000"; -- 0

            when "0001" =>
                seg <= "1111001"; -- 1

            when "0010" =>
                seg <= "0100100"; -- 2

            when "0011" =>
                seg <= "0110000"; -- 3

            when "0100" =>
                seg <= "0011001"; -- 4

            when "0101" =>
                seg <= "0010010"; -- 5

            when "0110" =>
                seg <= "0000010"; -- 6

            when "0111" =>
                seg <= "1111000"; -- 7

            when "1000" =>
                seg <= "0000000"; -- 8

            when "1001" =>
                seg <= "0010000"; -- 9

            when others =>
                seg <= "1111111"; -- blank

        end case;

    end process;


    --------------------------------------------------------------
    -- ANODA AKTIF LOW
    --------------------------------------------------------------
    process(digit_sel)
    begin

        case digit_sel is

            when 0 =>
                an <= "1110";

            when 1 =>
                an <= "1101";

            when 2 =>
                an <= "1011";

            when 3 =>
                an <= "0111";

            when others =>
                an <= "1111";

        end case;

    end process;


    --------------------------------------------------------------
    -- DECIMAL POINT OFF
    --------------------------------------------------------------
    dp <= '1';

end Behavioral;