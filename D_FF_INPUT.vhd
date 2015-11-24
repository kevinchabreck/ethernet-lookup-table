library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.tableState.all;

entity D_FF_INPUT is
   port
   (
      clk : in std_logic;

      rst : in std_logic;
      pre : in std_logic;
      ce  : in std_logic;
      
      d : in std_logic_vector(47 downto 0);

      q : out std_logic_vector(47 downto 0)
   );
end entity D_FF_INPUT;
 
architecture Behavioral of D_FF_INPUT is

begin
   process (clk) is
   begin
      if rising_edge(clk) then  
         if (rst='1') then   
            q <= "000000000000000000000000000000000000000000000000";
         elsif (pre='1') then
            q <= "111111111111111111111111111111111111111111111111";
         elsif (ce='1') then
            q <= d;
         end if;
      end if;
   end process;

   
end architecture Behavioral;
