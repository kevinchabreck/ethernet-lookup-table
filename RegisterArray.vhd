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
				out_q		: OUT VECTOR_MAC_PORT
		);
	END RegisterArray;
		
ARCHITECTURE RegisterArray_Architecture OF RegisterArray IS

--TABLE REGISTER--

	COMPONENT tableRegister 
	PORT (
			aclr		: IN STD_LOGIC ;
			clock		: IN STD_LOGIC ;
			data		: IN STD_LOGIC_VECTOR (49 DOWNTO 0);
			enable		: IN STD_LOGIC ;
			load		: IN STD_LOGIC ;
			q			: OUT STD_LOGIC_VECTOR (49 DOWNTO 0)
		 );
	END COMPONENT;		

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

	tableRegisterArray:
	FOR i IN 0 TO NUM_REGISTERS GENERATE
		tableRegisterX : tableRegister PORT MAP (
			aclr		=> in_aclr,
			clock		=> in_clock,
			data		=> in_data,
			enable		=> enableSignal(i),
			load		=> in_load,
			q			=> out_q(i)
			);
		end GENERATE tableRegisterArray;

	myDecoder : decode_5to32_top
    PORT MAP (
		 	A  => in_enable(4 DOWNTO 0),
           	EN => '0',
           	X  => enableSignal(31 DOWNTO 0)
		 );                    


END RegisterArray_Architecture;
