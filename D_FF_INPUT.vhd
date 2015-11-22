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
      
      d : in std_logic_vector(FRAME_SIZE downto 0);

      q : out std_logic_vector(FRAME_SIZE downto 0)
   );
end entity D_FF_INPUT;
 
architecture Behavioral of D_FF_INPUT is
SIGNAL intermediate : STD_LOGIC_VECTOR(FRAME_SIZE DOWNTO 0);
begin
   process (clk) is
   begin
      if rising_edge(clk) then  
         if (rst='1') then   
            q <= "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000";
         elsif (pre='1') then
            q <= "11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111";
         elsif (ce='1') then
            q <= intermediate(FRAME_SIZE DOWNTO 0);
         end if;
      end if;
   end process;

   intermediate <= d;
end architecture Behavioral;
