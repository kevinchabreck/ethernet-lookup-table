library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity D_FF_5bit is
   port
   (
      clk : in std_logic;

      rst : in std_logic;
      pre : in std_logic;
      ce  : in std_logic;
      
      d : in std_logic_vector(4 downto 0);

      q : out std_logic_vector(4 downto 0)
   );
end entity D_FF_5bit;
 
architecture Behavioral of D_FF_5bit is
begin
   process (clk) is
   begin
      if rising_edge(clk) then  
         if (rst='1') then   
            q <= "00000";
         elsif (pre='1') then
            q <= "11111";
         elsif (ce='1') then
            q <= d;
         end if;
      end if;
   end process;
end architecture Behavioral;
