
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity seven_seg_driver is
    Port (
        clk      : in  STD_LOGIC;
        hex_data : in  STD_LOGIC_VECTOR(7 downto 0);

        seg      : out STD_LOGIC_VECTOR(6 downto 0);
        an       : out STD_LOGIC_VECTOR(3 downto 0);
        dp       : out STD_LOGIC
    );
end seven_seg_driver;

architecture Behavioral of seven_seg_driver is

    signal refresh_counter :
        UNSIGNED(16 downto 0) := (others => '0');

begin

    -- Clock untuk multiplexing seven-segment
    process(clk)
    begin
        if rising_edge(clk) then
            refresh_counter <= refresh_counter + 1;
        end if;
    end process;

    -- Pemilihan digit dan decoder hexadecimal
    process(refresh_counter, hex_data)

        variable selected_nibble :
            STD_LOGIC_VECTOR(3 downto 0);

    begin

        dp <= '1';

        -- Digit kanan menampilkan 4 bit bawah
        if refresh_counter(16) = '0' then

            an <= "1110";
            selected_nibble := hex_data(3 downto 0);

        -- Digit sebelah kanan menampilkan 4 bit atas
        else

            an <= "1101";
            selected_nibble := hex_data(7 downto 4);

        end if;

        -- Decoder hexadecimal
        case selected_nibble is

            when x"0" => seg <= "1000000";
            when x"1" => seg <= "1111001";
            when x"2" => seg <= "0100100";
            when x"3" => seg <= "0110000";
            when x"4" => seg <= "0011001";
            when x"5" => seg <= "0010010";
            when x"6" => seg <= "0000010";
            when x"7" => seg <= "1111000";
            when x"8" => seg <= "0000000";
            when x"9" => seg <= "0010000";
            when x"A" => seg <= "0001000";
            when x"B" => seg <= "0000011";
            when x"C" => seg <= "1000110";
            when x"D" => seg <= "0100001";
            when x"E" => seg <= "0000110";
            when x"F" => seg <= "0001110";

            when others =>
                seg <= "1111111";

        end case;

    end process;

end Behavioral;
