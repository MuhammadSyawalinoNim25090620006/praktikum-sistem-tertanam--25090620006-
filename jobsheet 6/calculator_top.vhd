library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity calculator_top is
    Port (
        clk : in STD_LOGIC;

        -- SW7..SW0 = operand
        -- SW9..SW8 = selector operasi
        sw : in STD_LOGIC_VECTOR(9 downto 0);

        btnU : in STD_LOGIC;
        btnD : in STD_LOGIC;
        btnL : in STD_LOGIC;
        btnR : in STD_LOGIC;
        btnC : in STD_LOGIC;

        seg : out STD_LOGIC_VECTOR(6 downto 0);
        dp  : out STD_LOGIC;
        an  : out STD_LOGIC_VECTOR(3 downto 0)
    );
end calculator_top;


architecture Behavioral of calculator_top is

    -- ============================================================
    -- DEBOUNCE
    -- ============================================================
    signal btnU_db : STD_LOGIC;
    signal btnD_db : STD_LOGIC;
    signal btnC_db : STD_LOGIC;


    -- ============================================================
    -- EDGE DETECT
    -- ============================================================
    signal btnU_pulse : STD_LOGIC;
    signal btnD_pulse : STD_LOGIC;
    signal btnC_pulse : STD_LOGIC;


    -- ============================================================
    -- CALCULATOR
    -- ============================================================
    signal result : STD_LOGIC_VECTOR(7 downto 0);

    signal op_sel : STD_LOGIC_VECTOR(1 downto 0);


    -- ============================================================
    -- DISPLAY BCD
    -- ============================================================
    signal display_data : STD_LOGIC_VECTOR(15 downto 0);

begin


    -- ============================================================
    -- DEBOUNCE BTN U
    -- ============================================================
    debounce_U : entity work.debounce
        port map (
            clk     => clk,
            btn_in  => btnU,
            btn_out => btnU_db
        );


    -- ============================================================
    -- DEBOUNCE BTN D
    -- ============================================================
    debounce_D : entity work.debounce
        port map (
            clk     => clk,
            btn_in  => btnD,
            btn_out => btnD_db
        );


    -- ============================================================
    -- DEBOUNCE BTN C
    -- ============================================================
    debounce_C : entity work.debounce
        port map (
            clk     => clk,
            btn_in  => btnC,
            btn_out => btnC_db
        );


    -- ============================================================
    -- EDGE DETECT BTN U
    -- ============================================================
    edge_U : entity work.edge_detect
        port map (
            clk    => clk,
            sig_in => btnU_db,
            pulse  => btnU_pulse
        );


    -- ============================================================
    -- EDGE DETECT BTN D
    -- ============================================================
    edge_D : entity work.edge_detect
        port map (
            clk    => clk,
            sig_in => btnD_db,
            pulse  => btnD_pulse
        );


    -- ============================================================
    -- EDGE DETECT BTN C
    -- ============================================================
    edge_C : entity work.edge_detect
        port map (
            clk    => clk,
            sig_in => btnC_db,
            pulse  => btnC_pulse
        );


    -- ============================================================
    -- CALCULATOR FSM
    -- ============================================================
    calculator : entity work.calculator_fsm
        port map (
            clk => clk,

            rst => '0',

            sw => sw(7 downto 0),

            btnU => btnU_pulse,
            btnD => btnD_pulse,
            btnC => btnC_pulse,

            op_input => sw(9 downto 8),

            result => result,
            op_sel_o => op_sel
        );


    -- ============================================================
    -- KONVERSI BINARY 8-BIT KE 4 DIGIT BCD
    --
    -- Contoh:
    -- 15  -> 0015
    -- 100 -> 0100
    -- 255 -> 0255
    -- ============================================================
    process(result)
        variable value : integer;
        variable ribuan : integer;
        variable ratusan : integer;
        variable puluhan : integer;
        variable satuan  : integer;
    begin

        value := to_integer(unsigned(result));

        ribuan := value / 1000;
        ratusan := (value mod 1000) / 100;
        puluhan := (value mod 100) / 10;
        satuan  := value mod 10;

        display_data(15 downto 12) <=
            std_logic_vector(to_unsigned(ribuan, 4));

        display_data(11 downto 8) <=
            std_logic_vector(to_unsigned(ratusan, 4));

        display_data(7 downto 4) <=
            std_logic_vector(to_unsigned(puluhan, 4));

        display_data(3 downto 0) <=
            std_logic_vector(to_unsigned(satuan, 4));

    end process;


    -- ============================================================
    -- SEVEN SEGMENT DRIVER
    -- ============================================================
    display : entity work.seven_seg_driver
        generic map (
            CLK_FREQ_HZ => 100_000_000,
            DIGITS      => 4
        )
        port map (
            clk     => clk,
            data_in => display_data,
            seg     => seg,
            dp      => dp,
            an      => an
        );

end Behavioral;