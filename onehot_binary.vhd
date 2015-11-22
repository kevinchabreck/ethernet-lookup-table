LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE Work.tableState.ALL;

ENTITY onehot_binary IS
PORT( 
    onehot_in   : IN  STD_LOGIC_VECTOR(NUM_REGISTERS downto 0);
    binary_out  : OUT STD_LOGIC_VECTOR(4 downto 0);
    outVal      : OUT STD_LOGIC
    );
END onehot_binary;

ARCHITECTURE rtl OF onehot_binary IS
    BEGIN PROCESS(onehot_in)
        BEGIN
        outVal      <='1';
        binary_out  <="00000";
        CASE onehot_in IS
            WHEN "00000000000000000000000000000001" => binary_out <= "00000";
            WHEN "00000000000000000000000000000010" => binary_out <= "00001";
            WHEN "00000000000000000000000000000100" => binary_out <= "00010";
            WHEN "00000000000000000000000000001000" => binary_out <= "00011";
            WHEN "00000000000000000000000000010000" => binary_out <= "00100";
            WHEN "00000000000000000000000000100000" => binary_out <= "00101";
            WHEN "00000000000000000000000001000000" => binary_out <= "00110";
            WHEN "00000000000000000000000010000000" => binary_out <= "00111";
            WHEN "00000000000000000000000100000000" => binary_out <= "01000";
            WHEN "00000000000000000000001000000000" => binary_out <= "01001";
            WHEN "00000000000000000000010000000000" => binary_out <= "01010";
            WHEN "00000000000000000000100000000000" => binary_out <= "01011";
            WHEN "00000000000000000001000000000000" => binary_out <= "01100";
            WHEN "00000000000000000010000000000000" => binary_out <= "01101";
            WHEN "00000000000000000100000000000000" => binary_out <= "01110";
            WHEN "00000000000000001000000000000000" => binary_out <= "01111";
            WHEN "00000000000000010000000000000000" => binary_out <= "10000";
            WHEN "00000000000000100000000000000000" => binary_out <= "10001";
            WHEN "00000000000001000000000000000000" => binary_out <= "10010";
            WHEN "00000000000010000000000000000000" => binary_out <= "10011";
            WHEN "00000000000100000000000000000000" => binary_out <= "10100";
            WHEN "00000000001000000000000000000000" => binary_out <= "10101";
            WHEN "00000000010000000000000000000000" => binary_out <= "10110";
            WHEN "00000000100000000000000000000000" => binary_out <= "10111";
            WHEN "00000001000000000000000000000000" => binary_out <= "11000";
            WHEN "00000010000000000000000000000000" => binary_out <= "11001";
            WHEN "00000100000000000000000000000000" => binary_out <= "11010";
            WHEN "00001000000000000000000000000000" => binary_out <= "11011";
            WHEN "00010000000000000000000000000000" => binary_out <= "11100";
            WHEN "00100000000000000000000000000000" => binary_out <= "11101";
            WHEN "01000000000000000000000000000000" => binary_out <= "11110";
            WHEN "10000000000000000000000000000000" => binary_out <= "11111";
            WHEN OTHERS => outVal <= '0';
        END CASE;
    END PROCESS;
END rtl;
