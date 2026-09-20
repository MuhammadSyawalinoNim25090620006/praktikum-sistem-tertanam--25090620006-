library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_alu4_signed is
end tb_alu4_signed;

architecture Behavioral of tb_alu4_signed is

    signal a        : STD_LOGIC_VECTOR (3 downto 0);
    signal b        : STD_LOGIC_VECTOR (3 downto 0);
    signal opcode   : STD_LOGIC;
    signal result   : STD_LOGIC_VECTOR (3 downto 0);
    signal overflow : STD_LOGIC;

begin

    uut: entity work.alu4_signed
        port map (
            a        => a,
            b        => b,
            opcode   => opcode,
            result   => result,
            overflow => overflow
        );

    process
    begin

        -- Test 1: +7 + +1 = overflow
        a <= "0111";
        b <= "0001";
        opcode <= '0';
        wait for 10 ns;

        assert result = "1000"
            report "Test 1: hasil tidak sesuai"
            severity error;

        assert overflow = '1'
            report "Test 1: overflow tidak terdeteksi"
            severity error;


        -- Test 2: +3 + +2 = +5, tidak overflow
        a <= "0011";
        b <= "0010";
        opcode <= '0';
        wait for 10 ns;

        assert result = "0101"
            report "Test 2: hasil tidak sesuai"
            severity error;

        assert overflow = '0'
            report "Test 2: overflow salah"
            severity error;


        -- Test 3: -4 + -5 = +7, overflow
        a <= "1100";
        b <= "1011";
        opcode <= '0';
        wait for 10 ns;

        assert result = "0111"
            report "Test 3: hasil tidak sesuai"
            severity error;

        assert overflow = '1'
            report "Test 3: overflow tidak terdeteksi"
            severity error;


        report "Pengujian overflow signed selesai."
            severity note;

        wait;

    end process;

end Behavioral;