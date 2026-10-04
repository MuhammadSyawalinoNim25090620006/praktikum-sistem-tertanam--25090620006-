library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity js05_top is
    port (
        clk : in STD_LOGIC;

        btnU : in STD_LOGIC;
        btnD : in STD_LOGIC;
        btnC : in STD_LOGIC;

        seg : out STD_LOGIC_VECTOR(6 downto 0);
        dp  : out STD_LOGIC;
        an  : out STD_LOGIC_VECTOR(3 downto 0)
    );
end js05_top;

architecture Behavioral of js05_top is

    -- Sinyal hasil debounce
    signal btnU_clean : STD_LOGIC;
    signal btnD_clean : STD_LOGIC;
    signal btnC_clean : STD_LOGIC;

    -- Pulsa hasil edge detector
    signal btnU_pulse : STD_LOGIC;
    signal btnD_pulse : STD_LOGIC;

    -- Nilai counter
    signal count_value : STD_LOGIC_VECTOR(15 downto 0);

begin

    ----------------------------------------------------------------
    -- DEBOUNCE BUTTON U
    ----------------------------------------------------------------
    debounce_U : entity work.debounce
        port map (
            clk     => clk,
            btn_in  => btnU,
            btn_out => btnU_clean
        );

    ----------------------------------------------------------------
    -- DEBOUNCE BUTTON D
    ----------------------------------------------------------------
    debounce_D : entity work.debounce
        port map (
            clk     => clk,
            btn_in  => btnD,
            btn_out => btnD_clean
        );

    ----------------------------------------------------------------
    -- DEBOUNCE BUTTON C
    ----------------------------------------------------------------
    debounce_C : entity work.debounce
        port map (
            clk     => clk,
            btn_in  => btnC,
            btn_out => btnC_clean
        );

    ----------------------------------------------------------------
    -- EDGE DETECTOR BUTTON U
    ----------------------------------------------------------------
    edge_U : entity work.edge_detect
        port map (
            clk    => clk,
            sig_in => btnU_clean,
            pulse  => btnU_pulse
        );

    ----------------------------------------------------------------
    -- EDGE DETECTOR BUTTON D
    ----------------------------------------------------------------
    edge_D : entity work.edge_detect
        port map (
            clk    => clk,
            sig_in => btnD_clean,
            pulse  => btnD_pulse
        );

    ----------------------------------------------------------------
    -- UP/DOWN COUNTER
    ----------------------------------------------------------------
    counter_inst : entity work.updown_counter
        port map (
            clk        => clk,
            rst        => btnC_clean,
            up_pulse   => btnU_pulse,
            down_pulse => btnD_pulse,
            count      => count_value
        );

    ----------------------------------------------------------------
    -- SEVEN SEGMENT DRIVER
    ----------------------------------------------------------------
    display_inst : entity work.seven_seg_driver
        port map (
            clk   => clk,
            value => count_value,
            seg   => seg,
            dp    => dp,
            an    => an
        );

end Behavioral;