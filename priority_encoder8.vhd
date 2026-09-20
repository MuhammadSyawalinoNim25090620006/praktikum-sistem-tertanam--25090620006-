library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity priority_encoder8 is
    Port (
        din   : in  STD_LOGIC_VECTOR (7 downto 0);
        pos   : out STD_LOGIC_VECTOR (2 downto 0);
        valid : out STD_LOGIC
    );
end priority_encoder8;

architecture Behavioral of priority_encoder8 is
begin

    process(din)
    begin
        pos <= (others => '0');
        valid <= '0';

        for i in 7 downto 0 loop
            if din(i) = '1' then
                pos <= STD_LOGIC_VECTOR(to_unsigned(i, 3));
                valid <= '1';
                exit;
            end if;
        end loop;
    end process;

end Behavioral;