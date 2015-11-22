LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY decode_5to32_top IS
PORT( 
    A  : IN  STD_LOGIC_VECTOR(4 DOWNTO 0);  
    X  : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);  
    EN : IN  STD_LOGIC
);                    
END decode_5to32_top;

ARCHITECTURE Behavioral OF decode_5to32_top IS
    BEGIN PROCESS(A, EN)
    BEGIN
    X <= "00000000000000000000000000000000";        -- default output value
    IF (EN = '1') THEN  -- active high enable pin
        CASE A IS
            WHEN "00000" => X(0)  <= '1';
            WHEN "00001" => X(1)  <= '1';
            WHEN "00010" => X(2)  <= '1';
            WHEN "00011" => X(3)  <= '1';
            WHEN "00100" => X(4)  <= '1';
            WHEN "00101" => X(5)  <= '1';
            WHEN "00110" => X(6)  <= '1';
            WHEN "00111" => X(7)  <= '1';
            WHEN "01000" => X(8)  <= '1';
            WHEN "01001" => X(9)  <= '1';
            WHEN "01010" => X(10) <= '1';
            WHEN "01011" => X(11) <= '1';
            WHEN "01100" => X(12) <= '1';
            WHEN "01101" => X(13) <= '1';
            WHEN "01110" => X(14) <= '1';
            WHEN "01111" => X(15) <= '1';
            WHEN "10000" => X(16) <= '1';
            WHEN "10001" => X(17) <= '1';
            WHEN "10010" => X(18) <= '1';
            WHEN "10011" => X(19) <= '1';
            WHEN "10100" => X(20) <= '1';
            WHEN "10101" => X(21) <= '1';
            WHEN "10110" => X(22) <= '1';
            WHEN "10111" => X(23) <= '1';
            WHEN "11000" => X(24) <= '1';
            WHEN "11001" => X(25) <= '1';
            WHEN "11010" => X(26) <= '1';
            WHEN "11011" => X(27) <= '1';
            WHEN "11100" => X(28) <= '1';
            WHEN "11101" => X(29) <= '1';
            WHEN "11110" => X(30) <= '1';
            WHEN "11111" => X(31) <= '1';
            WHEN OTHERS => X <= "00000000000000000000000000000000";
        END CASE;
    END IF;
    END PROCESS;
END Behavioral;
