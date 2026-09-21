library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity piso8_top is
    Port (
        clk  : in STD_LOGIC;
        btnU : in STD_LOGIC;
        btnC : in STD_LOGIC;
        sw   : in STD_LOGIC_VECTOR (7 downto 0);
        led  : out STD_LOGIC_VECTOR (7 downto 0)
    );
end piso8_top;

architecture Behavioral of piso8_top is

    component piso8
        Port (
            clk  : in STD_LOGIC;
            rst  : in STD_LOGIC;
            load : in STD_LOGIC;
            d    : in STD_LOGIC_VECTOR (7 downto 0);
            sout : out STD_LOGIC
        );
    end component;

    signal sout_signal : STD_LOGIC;

begin

    U1: piso8
        port map (
            clk  => clk,
            rst  => btnU,
            load => btnC,
            d    => sw,
            sout => sout_signal
        );

    led(0) <= sout_signal;
    led(7 downto 1) <= (others => '0');

end Behavioral;