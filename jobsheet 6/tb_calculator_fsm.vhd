library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_calculator_fsm is
end tb_calculator_fsm;

architecture Behavioral of tb_calculator_fsm is

    -- Clock dan reset
    signal clk : STD_LOGIC := '0';
    signal rst : STD_LOGIC := '0';

    -- Input
    signal sw   : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
    signal btnU : STD_LOGIC := '0';
    signal btnD : STD_LOGIC := '0';
    signal btnL : STD_LOGIC := '0';
    signal btnR : STD_LOGIC := '0';
    signal btnC : STD_LOGIC := '0';

    -- Output
    signal result   : STD_LOGIC_VECTOR(7 downto 0);
    signal op_sel_o : STD_LOGIC;

begin

    ----------------------------------------------------------------
    -- CLOCK 10 ns
    ----------------------------------------------------------------
    clk <= not clk after 5 ns;


    ----------------------------------------------------------------
    -- DUT / Unit Under Test
    ----------------------------------------------------------------
    DUT : entity work.calculator_fsm
        port map (
            clk      => clk,
            rst      => rst,
            sw       => sw,
            btnU     => btnU,
            btnD     => btnD,
            btnL     => btnL,
            btnR     => btnR,
            btnC     => btnC,
            result   => result,
            op_sel_o => op_sel_o
        );


    ----------------------------------------------------------------
    -- TEST SEQUENCE
    ----------------------------------------------------------------
    process
    begin

        ------------------------------------------------------------
        -- RESET
        ------------------------------------------------------------
        rst <= '1';
        wait for 20 ns;

        rst <= '0';
        wait for 20 ns;


        ------------------------------------------------------------
        -- MASUKKAN OPERAND A = 10
        ------------------------------------------------------------
        sw <= "00001010";      -- 10
        btnU <= '1';
        wait for 10 ns;

        btnU <= '0';
        wait for 20 ns;


        ------------------------------------------------------------
        -- MASUKKAN OPERAND B = 5
        ------------------------------------------------------------
        sw <= "00000101";      -- 5
        btnD <= '1';
        wait for 10 ns;

        btnD <= '0';
        wait for 20 ns;


        ------------------------------------------------------------
        -- PILIH OPERASI TAMBAH
        ------------------------------------------------------------
        btnL <= '1';
        wait for 10 ns;

        btnL <= '0';
        wait for 20 ns;


        ------------------------------------------------------------
        -- HITUNG
        ------------------------------------------------------------
        btnC <= '1';
        wait for 10 ns;

        btnC <= '0';


        ------------------------------------------------------------
        -- TUNGGU HASIL
        ------------------------------------------------------------
        wait for 30 ns;


        ------------------------------------------------------------
        -- SELESAI
        ------------------------------------------------------------
        wait;

    end process;

end Behavioral;