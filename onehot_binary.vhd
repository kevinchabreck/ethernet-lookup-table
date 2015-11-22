library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use Work.tableState.all;

entity onehot_binary is
  port    ( onehot_in  : in  std_logic_vector(NUM_REGISTERS downto 0);
            binary_out : out std_logic_vector(4 downto 0) ;
	    outVal : out std_logic );


end onehot_binary;

architecture rtl of onehot_binary is
begin
process(onehot_in)
begin
outVal <='1';
case onehot_in is
--when "00001" => binary_out <= "00000";
--when "00010" => binary_out <= "00001";
--when "00100" => binary_out <= "00010";
--when "01000" => binary_out <= "00011";
--when "10000" => binary_out <= "00100";
when "00000000000000000000000000000001" => binary_out <= "00000";
when "00000000000000000000000000000010" => binary_out <= "00001";
when "00000000000000000000000000000100" => binary_out <= "00010";
when "00000000000000000000000000001000" => binary_out <= "00011";
when "00000000000000000000000000010000" => binary_out <= "00100";
when "00000000000000000000000000100000" => binary_out <= "00101";
when "00000000000000000000000001000000" => binary_out <= "00110";
when "00000000000000000000000010000000" => binary_out <= "00111";
when "00000000000000000000000100000000" => binary_out <= "01000";
when "00000000000000000000001000000000" => binary_out <= "01001";
when "00000000000000000000010000000000" => binary_out <= "01010";
when "00000000000000000000100000000000" => binary_out <= "01011";
when "00000000000000000001000000000000" => binary_out <= "01100";
when "00000000000000000010000000000000" => binary_out <= "01101";
when "00000000000000000100000000000000" => binary_out <= "01110";
when "00000000000000001000000000000000" => binary_out <= "01111";
when "00000000000000010000000000000000" => binary_out <= "10000";
when "00000000000000100000000000000000" => binary_out <= "10001";
when "00000000000001000000000000000000" => binary_out <= "10010";
when "00000000000010000000000000000000" => binary_out <= "10011";
when "00000000000100000000000000000000" => binary_out <= "10100";
when "00000000001000000000000000000000" => binary_out <= "10101";
when "00000000010000000000000000000000" => binary_out <= "10110";
when "00000000100000000000000000000000" => binary_out <= "10111";
when "00000001000000000000000000000000" => binary_out <= "11000";
when "00000010000000000000000000000000" => binary_out <= "11001";
when "00000100000000000000000000000000" => binary_out <= "11010";
when "00001000000000000000000000000000" => binary_out <= "11011";
when "00010000000000000000000000000000" => binary_out <= "11100";
when "00100000000000000000000000000000" => binary_out <= "11101";
when "01000000000000000000000000000000" => binary_out <= "11110";
when "10000000000000000000000000000000" => binary_out <= "11111";
when others =>outVal <= '0';
end case;
end process;
end rtl;
