library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity pe8_top is
    Port (
        sw  : in  STD_LOGIC_VECTOR (7 downto 0);
        led : out STD_LOGIC_VECTOR (3 downto 0)
    );
end pe8_top;

architecture Behavioral of pe8_top is

    signal pos_s   : STD_LOGIC_VECTOR (2 downto 0);
    signal valid_s : STD_LOGIC;

begin

    U1: entity work.priority_encoder8
        port map (
            din   => sw,
            pos   => pos_s,
            valid => valid_s
        );

    led(2 downto 0) <= pos_s;
    led(3) <= valid_s;

end Behavioral;