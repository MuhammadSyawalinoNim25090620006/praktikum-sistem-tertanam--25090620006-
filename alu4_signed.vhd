library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity alu4_signed is
    Port (
        a        : in  STD_LOGIC_VECTOR (3 downto 0);
        b        : in  STD_LOGIC_VECTOR (3 downto 0);
        opcode   : in  STD_LOGIC; -- '0'=tambah, '1'=kurang
        result   : out STD_LOGIC_VECTOR (3 downto 0);
        overflow : out STD_LOGIC
    );
end alu4_signed;

architecture Behavioral of alu4_signed is

    signal a_s : signed(3 downto 0);
    signal b_s : signed(3 downto 0);

begin

    a_s <= signed(a);
    b_s <= signed(b);

    process(a_s, b_s, opcode)
        variable temp : signed(4 downto 0);
        variable r    : signed(3 downto 0);
    begin

        temp := (others => '0');
        r := (others => '0');
        overflow <= '0';

        if opcode = '0' then

            -- Penjumlahan signed
            temp := resize(a_s, 5) + resize(b_s, 5);
            r := temp(3 downto 0);

            -- Overflow jika dua operand bertanda sama
            -- menghasilkan tanda yang berbeda
            if (a_s(3) = b_s(3)) and (r(3) /= a_s(3)) then
                overflow <= '1';
            else
                overflow <= '0';
            end if;

        else

            -- Pengurangan signed
            temp := resize(a_s, 5) - resize(b_s, 5);
            r := temp(3 downto 0);

            -- Overflow jika tanda operand berbeda
            -- dan tanda hasil berbeda dari tanda a
            if (a_s(3) /= b_s(3)) and (r(3) /= a_s(3)) then
                overflow <= '1';
            else
                overflow <= '0';
            end if;

        end if;

        result <= STD_LOGIC_VECTOR(r);

    end process;

end Behavioral;