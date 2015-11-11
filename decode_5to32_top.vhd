library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity decode_5to32_top is
    Port ( A  : in  STD_LOGIC_VECTOR (4 downto 0);  
           X  : out STD_LOGIC_VECTOR (31 downto 0);  
           EN : in  STD_LOGIC);                    
end decode_5to32_top;

architecture Behavioral of decode_5to32_top is
begin
process (A, EN)
begin
    X <= "00000000000000000000000000000000";        -- default output value
    if (EN = '1') then  -- active high enable pin
        case A is
            when "00000" => X(0) <= '1';
            when "00001" => X(1) <= '1';
            when "00010" => X(2) <= '1';
            when "00011" => X(3) <= '1';
            when "00100" => X(4) <= '1';
            when "00101" => X(5) <= '1';
            when "00110" => X(6) <= '1';
            when "00111" => X(7) <= '1';
            when "01000" => X(8) <= '1';
            when "01001" => X(9) <= '1';
            when "01010" => X(10) <= '1';
            when "01011" => X(11) <= '1';
            when "01100" => X(12) <= '1';
            when "01101" => X(13) <= '1';
            when "01110" => X(14) <= '1';
            when "01111" => X(15) <= '1';
            when "10000" => X(16) <= '1';
            when "10001" => X(17) <= '1';
            when "10010" => X(18) <= '1';
            when "10011" => X(19) <= '1';
            when "10100" => X(20) <= '1';
            when "10101" => X(21) <= '1';
            when "10110" => X(22) <= '1';
            when "10111" => X(23) <= '1';
            when "11000" => X(24) <= '1';
            when "11001" => X(25) <= '1';
            when "11010" => X(26) <= '1';
            when "11011" => X(27) <= '1';
            when "11100" => X(28) <= '1';
            when "11101" => X(29) <= '1';
            when "11110" => X(30) <= '1';
            when "11111" => X(31) <= '1';
            when others => X <= "00000000000000000000000000000000";
        end case;
    end if;
end process;
end Behavioral;
