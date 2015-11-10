library ieee;
use IEEE.std_logic_1164.all;
use Work.tableState.all;

ENTITY RegisterArray IS
	PORT ( 
				in_wenable  : IN STD_LOGIC ;
				in_aclr		: IN STD_LOGIC ;
				in_clock	: IN STD_LOGIC ;
				in_data		: IN STD_LOGIC_VECTOR(49 DOWNTO 0);
				in_enable	: IN STD_LOGIC_VECTOR(4 DOWNTO 0);
				in_load		: IN STD_LOGIC ;
				--out_q		: OUT VECTOR_MAC_PORT(4 downto 0)
				out_q0 : OUT STD_LOGIC_VECTOR(49 downto 0);
				out_q1 : OUT STD_LOGIC_VECTOR(49 downto 0);
				out_q2 : OUT STD_LOGIC_VECTOR(49 downto 0);
				out_q3 : OUT STD_LOGIC_VECTOR(49 downto 0);
				out_q4 : OUT STD_LOGIC_VECTOR(49 downto 0)
				
		);
	END RegisterArray;
	

		
ARCHITECTURE RegisterArray_Architecture OF RegisterArray IS

--TABLE REGISTER--


	
		component D_FF_VHDL is
   port
   (
      clk : in std_logic;

      rst : in std_logic;
      pre : in std_logic;
      ce  : in std_logic;
      
      d : in std_logic_vector(49 downto 0);

      q : out std_logic_vector(49 downto 0)
   );
end component;

	COMPONENT decode_5to32_top is
    PORT (
		 	A  : in  STD_LOGIC_VECTOR (4 downto 0);  
           	EN : in  STD_LOGIC;
           	X  : out STD_LOGIC_VECTOR (31 downto 0)  
		 );                    
	END COMPONENT;

	SIGNAL enableSignal : STD_LOGIC_VECTOR(31 DOWNTO 0);

BEGIN

--COMPONENT INSTANTIATIONS--

--	tableRegisterArray:
--	FOR i IN 0 TO 4 GENERATE
--		tableRegisterX : D_FF_VHDL PORT MAP (
--			rst		=> in_aclr,
--			clk		=> in_clock,
--			d		=> in_data,
--			ce		=> enableSignal(i),
--			pre		=> in_load,
--			q			=> out_q(i)
--			);
--		end GENERATE tableRegisterArray;
		
		reg0 : D_FF_VHDL PORT MAP (
			rst		=> in_aclr,
			clk		=> in_clock,
			d		=> in_data,
			ce		=> enableSignal(0),
			pre		=> in_load,
			q			=> out_q0
			);
			
					reg1 : D_FF_VHDL PORT MAP (
			rst		=> in_aclr,
			clk		=> in_clock,
			d		=> in_data,
			ce		=> enableSignal(1),
			pre		=> in_load,
			q			=> out_q1
			);
			
					reg2 : D_FF_VHDL PORT MAP (
			rst		=> in_aclr,
			clk		=> in_clock,
			d		=> in_data,
			ce		=> enableSignal(2),
			pre		=> in_load,
			q			=> out_q2
			);
			
					reg3 : D_FF_VHDL PORT MAP (
			rst		=> in_aclr,
			clk		=> in_clock,
			d		=> in_data,
			ce		=> enableSignal(3),
			pre		=> in_load,
			q			=> out_q3
			);
			
					reg4 : D_FF_VHDL PORT MAP (
			rst		=> in_aclr,
			clk		=> in_clock,
			d		=> in_data,
			ce		=> enableSignal(4),
			pre		=> in_load,
			q			=> out_q4
			);
	

	myDecoder : decode_5to32_top
    PORT MAP (
		 	A  => in_enable(4 DOWNTO 0),
           	EN => '1',
           	X  => enableSignal(31 DOWNTO 0)
		 );                    


END RegisterArray_Architecture;
