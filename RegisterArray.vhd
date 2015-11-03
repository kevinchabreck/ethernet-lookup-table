library ieee;
use IEEE.std_logic_1164.all;
use Work.tableState.all;

ENTITY RegisterArray IS
	PORT ( 
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

BEGIN

--COMPONENT INSTANTIATIONS--

	tableRegisterArray:
	FOR i IN 0 TO NUM_REGISTERS GENERATE
		tableRegisterX : tableRegister PORT MAP (
			aclr		=> '0',
			clock		=> '0',
			data		=> in_data,
			enable		=> '0',
			load		=> '0',
			q			=> out_q(i)
			);
		end GENERATE tableRegisterArray;


END RegisterArray_Architecture;
