library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity updown_counter is
    port (
        clk     : in  STD_LOGIC;
        rst     : in  STD_LOGIC;
        up_pulse   : in  STD_LOGIC;
        down_pulse : in  STD_LOGIC;
        count   : out STD_LOGIC_VECTOR(15 downto 0)
    );
end updown_counter;

architecture Behavioral of updown_counter is

    signal count_reg : unsigned(15 downto 0) := (others => '0');

begin

    process(clk)
    begin
        if rising_edge(clk) then

            if rst = '1' then
                count_reg <= (others => '0');

            elsif up_pulse = '1' then
                count_reg <= count_reg + 1;

            elsif down_pulse = '1' then
                count_reg <= count_reg - 1;

            end if;

        end if;
    end process;

    count <= std_logic_vector(count_reg);

end Behavioral;