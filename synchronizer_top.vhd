library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity synchronizer_top is
    Port (
        clk  : in STD_LOGIC;
        btnC : in STD_LOGIC;
        led  : out STD_LOGIC_VECTOR (7 downto 0)
    );
end synchronizer_top;

architecture Behavioral of synchronizer_top is

    component synchronizer_2ff
        Port (
            clk      : in STD_LOGIC;
            async_in : in STD_LOGIC;
            sync_out : out STD_LOGIC
        );
    end component;

    signal sync_out_signal : STD_LOGIC;
    signal sync_out_prev   : STD_LOGIC := '0';
    signal led_reg         : STD_LOGIC := '0';

begin

    U1: synchronizer_2ff
        port map (
            clk      => clk,
            async_in => btnC,
            sync_out => sync_out_signal
        );

    process(clk)
    begin
        if rising_edge(clk) then
            if sync_out_signal = '1' and sync_out_prev = '0' then
                led_reg <= not led_reg;
            end if;

            sync_out_prev <= sync_out_signal;
        end if;
    end process;

    led(0) <= led_reg;
    led(7 downto 1) <= (others => '0');

end Behavioral;