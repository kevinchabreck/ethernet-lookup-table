LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY random IS GENERIC(width : integer :=  5); 
    PORT(
        clk         : IN STD_LOGIC;
        random_num  : OUT STD_LOGIC_VECTOR (width-1 DOWNTO 0)   --output vector            
    );
END random;

ARCHITECTURE Behavioral OF random IS
    BEGIN PROCESS(clk)
        VARIABLE rand_temp  : STD_LOGIC_VECTOR(width-1 downto 0) := (width-1 => '1',others => '0');
        VARIABLE temp       : STD_LOGIC := '0';
        BEGIN
        IF(rising_edge(clk)) THEN
            temp := rand_temp(width-1) xor rand_temp(width-2);
            rand_temp(width-1 downto 1) := rand_temp(width-2 downto 0);
            rand_temp(0) := temp;
        END IF;
        random_num <= rand_temp;
    END PROCESS;
END ARCHITECTURE;
