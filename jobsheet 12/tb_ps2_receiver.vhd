
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_ps2_receiver is
end tb_ps2_receiver;

architecture sim of tb_ps2_receiver is

    signal clk        : STD_LOGIC := '0';
    signal ps2_clk    : STD_LOGIC := '1';
    signal ps2_data   : STD_LOGIC := '1';

    signal scan_code  : STD_LOGIC_VECTOR(7 downto 0);
    signal data_ready : STD_LOGIC;

    signal ready_seen : STD_LOGIC := '0';

    constant CLK_PERIOD : time := 10 ns;

begin

    -- Unit Under Test
    uut: entity work.ps2_receiver
        port map (
            clk        => clk,
            ps2_clk    => ps2_clk,
            ps2_data   => ps2_data,
            scan_code  => scan_code,
            data_ready => data_ready
        );

    -- Clock sistem 100 MHz
    clk <= not clk after CLK_PERIOD / 2;

    -- Merekam pulsa data_ready
    process(clk)
    begin
        if rising_edge(clk) then
            if data_ready = '1' then
                ready_seen <= '1';
            end if;
        end if;
    end process;

    -- Proses pengiriman frame PS/2
    process

        procedure send_bit(
            constant bit_value : in STD_LOGIC
        ) is
        begin
            ps2_data <= bit_value;
            wait for 30 us;

            ps2_clk <= '0';
            wait for 30 us;

            ps2_clk <= '1';
        end procedure;

    begin

        wait for 100 ns;

        -- Start bit
        send_bit('0');

        -- Data 0x1C (LSB first)
        send_bit('0');
        send_bit('0');
        send_bit('1');
        send_bit('1');
        send_bit('1');
        send_bit('0');
        send_bit('0');
        send_bit('0');

        -- Odd parity
        send_bit('0');

        -- Stop bit
        send_bit('1');

        wait for 1 us;

        assert ready_seen = '1'
            report "ERROR: data_ready tidak aktif"
            severity error;

        assert scan_code = x"1C"
            report "ERROR: Scan code tidak sesuai"
            severity error;

        report "PASS: Scan code A = 1C"
            severity note;

        wait;

    end process;

end sim;
