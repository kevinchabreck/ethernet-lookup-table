library ieee;
use IEEE.std_logic_1164.all;

PACKAGE tableState IS
	TYPE VECTOR_MAC_PORT IS ARRAY (NATURAL RANGE <>) OF STD_LOGIC_VECTOR(49 DOWNTO 0);
	CONSTANT NUM_REGISTERS : INTEGER := 31;
	CONSTANT PORT1		   : INTEGER := 49;
	CONSTANT PORT0		   : INTEGER := 48;
END PACKAGE tableState;

library ieee;
use IEEE.std_logic_1164.all;
use Work.tableState.all;

	ENTITY Table IS
	PORT (
			input_valid   : IN  STD_LOGIC; -- indicates valid data in input_reg
			input_reg     : IN  STD_LOGIC_VECTOR(97 DOWNTO 0); -- dst | src | port
			write_enable  : OUT STD_LOGIC; -- indicates we have read input_reg
			output_valid  : OUT STD_LOGIC; -- indicates valid data in output_reg
			address_found : OUT STD_LOGIC; -- indicates table contains entry for dst address
			output_reg    : OUT STD_LOGIC_VECTOR(1 DOWNTO 0) -- return same port if src not in table
		 );
	END Table;


ARCHITECTURE Table_Architecture OF Table IS
	CONSTANT NUM_REGISTERS : INTEGER := 31;
	CONSTANT PORT1		   : INTEGER := 49;
	CONSTANT PORT0		   : INTEGER := 48;

--INPUT REGISTER--

	COMPONENT inputRegister 
	PORT (
			aclr		: IN STD_LOGIC ;
			aset		: IN STD_LOGIC ;
			clock		: IN STD_LOGIC ;
			data		: IN STD_LOGIC_VECTOR (97 DOWNTO 0);
			enable		: IN STD_LOGIC ;
			load		: IN STD_LOGIC ;
			shiftin		: IN STD_LOGIC ;
			q			: OUT STD_LOGIC_VECTOR (97 DOWNTO 0)
		);
	END COMPONENT;

--TABLE REGISTER--

	COMPONENT tableRegister 
	PORT (
			aclr		: IN STD_LOGIC ;
			aset		: IN STD_LOGIC ;
			clock		: IN STD_LOGIC ;
			data		: IN STD_LOGIC_VECTOR (49 DOWNTO 0);
			enable		: IN STD_LOGIC ;
			load		: IN STD_LOGIC ;
			shiftin		: IN STD_LOGIC ;
			q			: OUT STD_LOGIC_VECTOR (49 DOWNTO 0)
		);
	END COMPONENT;		

--LOOKUP--

	COMPONENT Lookup IS
	PORT (
			input_registerArray 	: VECTOR_MAC_PORT(NUM_REGISTERS DOWNTO 0);
			input_register			: IN STD_LOGIC_VECTOR(47 DOWNTO 0);
			output_port				: OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
			output_valid			: OUT STD_LOGIC;
			output_registerNumber	: OUT STD_LOGIC_VECTOR(4 DOWNTO 0)
		 );
	END COMPONENT;

--SIGNALS--

	SIGNAL tableRegisterOutput : VECTOR_MAC_PORT(NUM_REGISTERS DOWNTO 0);
	SIGNAL myLookup_registerNumber : STD_LOGIC_VECTOR(4 DOWNTO 0);

BEGIN

--COMPONENT INSTANTIATIONS--

	tableRegisterArray:
	FOR i IN 0 TO NUM_REGISTERS GENERATE
		tableRegisterX : tableRegister PORT MAP (
			aclr		=> '0',
			aset		=> '0',
			clock		=> '0',
			data		=> input_reg(49 DOWNTO 0), 
			enable		=> '0',
			load		=> '0',
			shiftin		=> '0',
			q			=> tableRegisterOutput(i)
			);
		end GENERATE tableRegisterArray;

	myLookup : Lookup
	PORT MAP (
			input_registerArray 	=> tableRegisterOutput,
			input_register			=> input_reg(47 DOWNTO 0),
			output_port				=> output_reg,
			output_valid			=> output_valid,
			output_registerNumber	=> myLookup_registerNumber(4 DOWNTO 0)
		 );

END Table_Architecture;
