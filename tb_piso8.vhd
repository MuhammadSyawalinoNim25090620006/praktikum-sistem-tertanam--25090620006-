
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_piso8 is
end tb_piso8;

architecture Behavioral of tb_piso8 is

    component piso8
        Port (
            clk  : in STD_LOGIC;
            rst  : in STD_LOGIC;
            load : in STD_LOGIC;
            d    : in STD_LOGIC_VECTOR (7 downto 0);
            sout : out STD_LOGIC
        );
    end component;

    signal clk  : STD_LOGIC := '0';
    signal rst  : STD_LOGIC := '0';
    signal load : STD_LOGIC := '0';
    signal d    : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
    signal sout : STD_LOGIC;

begin

    uut: piso8
        port map (
            clk  => clk,
            rst  => rst,
            load => load,
            d    => d,
            sout => sout
        );

    clk <= not clk after 5 ns;

    process
    begin
        -- Reset
        rst <= '1';
        wait for 10 ns;

        rst <= '0';

        -- Load data 10110010
        d <= "10110010";
        load <= '1';
        wait for 10 ns;

        load <= '0';

        -- Shift 8 times
        wait for 80 ns;

        wait;
    end process;

end Behavioral;