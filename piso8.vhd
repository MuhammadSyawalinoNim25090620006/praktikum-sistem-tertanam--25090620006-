
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity piso8 is
    Port (
        clk  : in STD_LOGIC;
        rst  : in STD_LOGIC;
        load : in STD_LOGIC;
        d    : in STD_LOGIC_VECTOR (7 downto 0);
        sout : out STD_LOGIC
    );
end piso8;

architecture Behavioral of piso8 is

    signal reg_data : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');

begin

    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                reg_data <= (others => '0');
            elsif load = '1' then
                reg_data <= d;
            else
                reg_data <= reg_data(6 downto 0) & '0';
            end if;
        end if;
    end process;

    sout <= reg_data(7);

end Behavioral;