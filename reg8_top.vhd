
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity reg8_top is
    Port (
        clk : in STD_LOGIC;
        btnU : in STD_LOGIC;
        btnC : in STD_LOGIC;
        sw : in STD_LOGIC_VECTOR (7 downto 0);
        led : out STD_LOGIC_VECTOR (7 downto 0)
    );
end reg8_top;

architecture Behavioral of reg8_top is

    component reg8_en
        Port (
            clk : in STD_LOGIC;
            rst : in STD_LOGIC;
            en  : in STD_LOGIC;
            d   : in STD_LOGIC_VECTOR (7 downto 0);
            q   : out STD_LOGIC_VECTOR (7 downto 0)
        );
    end component;

begin

    U1: reg8_en
        port map (
            clk => clk,
            rst => btnU,
            en  => btnC,
            d   => sw,
            q   => led
        );

end Behavioral;