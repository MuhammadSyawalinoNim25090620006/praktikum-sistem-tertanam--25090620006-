library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_alu4 is
end tb_alu4;

architecture Behavioral of tb_alu4 is

    signal a      : STD_LOGIC_VECTOR (3 downto 0);
    signal b      : STD_LOGIC_VECTOR (3 downto 0);
    signal opcode : STD_LOGIC;
    signal result : STD_LOGIC_VECTOR (3 downto 0);
    signal carry  : STD_LOGIC;

begin

    uut: entity work.alu4
        port map (
            a      => a,
            b      => b,
            opcode => opcode,
            result => result,
            carry  => carry
        );

    stimulus: process
    begin

        -- Test 1: 7 + 1 = 8
        a <= "0111";
        b <= "0001";
        opcode <= '0';
        wait for 10 ns;

        assert result = "1000"
            report "Test 1 gagal: 7 + 1"
            severity error;

        assert carry = '0'
            report "Test 1 carry gagal"
            severity error;


        -- Test 2: 15 + 1 = 16
        a <= "1111";
        b <= "0001";
        opcode <= '0';
        wait for 10 ns;

        assert result = "0000"
            report "Test 2 gagal: 15 + 1"
            severity error;

        assert carry = '1'
            report "Test 2 carry gagal"
            severity error;


        -- Test 3: 9 + 6 = 15
        a <= "1001";
        b <= "0110";
        opcode <= '0';
        wait for 10 ns;

        assert result = "1111"
            report "Test 3 gagal: 9 + 6"
            severity error;

        assert carry = '0'
            report "Test 3 carry gagal"
            severity error;


        -- Test 4: 7 - 1 = 6
        a <= "0111";
        b <= "0001";
        opcode <= '1';
        wait for 10 ns;

        assert result = "0110"
            report "Test 4 gagal: 7 - 1"
            severity error;

        assert carry = '0'
            report "Test 4 carry gagal"
            severity error;


        -- Test 5: 5 - 3 = 2
        a <= "0101";
        b <= "0011";
        opcode <= '1';
        wait for 10 ns;

        assert result = "0010"
            report "Test 5 gagal: 5 - 3"
            severity error;

        assert carry = '0'
            report "Test 5 carry gagal"
            severity error;


        -- Test 6: 3 - 5 = -2
        a <= "0011";
        b <= "0101";
        opcode <= '1';
        wait for 10 ns;

        assert result = "1110"
            report "Test 6 gagal: 3 - 5"
            severity error;

        assert carry = '1'
            report "Test 6 carry gagal"
            severity error;


        report "Semua pengujian ALU selesai."
            severity note;

        wait;

    end process;

end Behavioral;