library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity calculator_fsm is
    Port (
        clk      : in  STD_LOGIC;
        rst      : in  STD_LOGIC;

        sw       : in  STD_LOGIC_VECTOR(7 downto 0);

        btnU     : in  STD_LOGIC;  -- Load A
        btnD     : in  STD_LOGIC;  -- Load B
        btnC     : in  STD_LOGIC;  -- Hitung

        op_input : in  STD_LOGIC_VECTOR(1 downto 0);

        result   : out STD_LOGIC_VECTOR(7 downto 0);
        op_sel_o : out STD_LOGIC_VECTOR(1 downto 0)
    );
end calculator_fsm;


architecture Behavioral of calculator_fsm is

    -- ============================================================
    -- STATE
    -- ============================================================
    type calc_state is (
        S_WAIT_A,
        S_WAIT_B,
        S_COMPUTE,
        S_SHOW
    );

    signal state, next_state : calc_state := S_WAIT_A;


    -- ============================================================
    -- REGISTER OPERAND
    -- ============================================================
    signal reg_a : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
    signal reg_b : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');


    -- ============================================================
    -- OPERATION SELECTOR
    -- ============================================================
    signal op_sel : STD_LOGIC_VECTOR(1 downto 0) := "00";


    -- ============================================================
    -- STATUS
    -- ============================================================
    signal b_loaded : STD_LOGIC := '0';


    -- ============================================================
    -- HASIL ALU
    -- ============================================================
    signal alu_result : STD_LOGIC_VECTOR(7 downto 0);

begin


    -- ============================================================
    -- ALU
    -- ============================================================
    ALU_UNIT : entity work.alu8
        port map (
            A      => reg_a,
            B      => reg_b,
            op_sel => op_sel,
            Y      => alu_result
        );


    -- ============================================================
    -- PROCESS 1 : SINKRON
    -- ============================================================
    process(clk)
    begin
        if rising_edge(clk) then

            if rst = '1' then

                state    <= S_WAIT_A;
                reg_a    <= (others => '0');
                reg_b    <= (others => '0');
                op_sel   <= "00";
                b_loaded <= '0';

            else

                -- Update state
                state <= next_state;


                -- =================================================
                -- LOAD OPERAND A
                -- =================================================
                if state = S_WAIT_A then

                    if btnU = '1' then
                        reg_a    <= sw;
                        b_loaded <= '0';
                    end if;

                end if;


                -- =================================================
                -- LOAD OPERAND B
                -- =================================================
                if state = S_WAIT_B then

                    if btnD = '1' then
                        reg_b    <= sw;
                        b_loaded <= '1';
                    end if;

                end if;


                -- =================================================
                -- SIMPAN PILIHAN OPERASI
                -- =================================================
                if state = S_WAIT_B then

                    if btnC = '1' and b_loaded = '1' then
                        op_sel <= op_input;
                    end if;

                end if;


                -- =================================================
                -- RESET STATUS SETELAH SHOW
                -- =================================================
                if state = S_SHOW then
                    b_loaded <= '0';
                end if;

            end if;

        end if;
    end process;


    -- ============================================================
    -- PROCESS 2 : KOMBINASIONAL
    -- ============================================================
    process(state, btnU, btnC, b_loaded)
    begin

        -- Default
        next_state <= state;

        case state is

            -- ====================================================
            -- WAIT A
            -- ====================================================
            when S_WAIT_A =>

                if btnU = '1' then
                    next_state <= S_WAIT_B;
                end if;


            -- ====================================================
            -- WAIT B
            -- ====================================================
            when S_WAIT_B =>

                if btnC = '1' and b_loaded = '1' then
                    next_state <= S_COMPUTE;
                end if;


            -- ====================================================
            -- COMPUTE
            -- ====================================================
            when S_COMPUTE =>

                next_state <= S_SHOW;


            -- ====================================================
            -- SHOW
            -- ====================================================
            when S_SHOW =>

                next_state <= S_WAIT_A;

        end case;

    end process;


    -- ============================================================
    -- OUTPUT
    -- ============================================================
    result   <= alu_result;
    op_sel_o <= op_sel;

end Behavioral;