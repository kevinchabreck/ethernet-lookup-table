library ieee;
use IEEE.std_logic_1164.all;

PACKAGE tableRegisterOutputPackage IS
	TYPE VECTOR32_0 IS ARRAY (31 TO 0) OF STD_LOGIC_VECTOR(49 DOWNTO 0);
END PACKAGE tableRegisterOutputPackage;


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

----COMPARATOR--
--
--	COMPONENT tableComparator
--	PORT (
--			dataa		: IN STD_LOGIC_VECTOR (47 DOWNTO 0);
--			datab		: IN STD_LOGIC_VECTOR (47 DOWNTO 0);
--			aeb			: OUT STD_LOGIC 
--		);
--	END COMPONENT;
--
----OUTPUT PORT MUX--
--	
--	COMPONENT outputPortMux
--	PORT (
--			data0x		: IN STD_LOGIC_VECTOR (1 DOWNTO 0);
--			data1x		: IN STD_LOGIC_VECTOR (1 DOWNTO 0);
--			data2x		: IN STD_LOGIC_VECTOR (1 DOWNTO 0);
--			data3x		: IN STD_LOGIC_VECTOR (1 DOWNTO 0);
--			data4x		: IN STD_LOGIC_VECTOR (1 DOWNTO 0);
--			data5x		: IN STD_LOGIC_VECTOR (1 DOWNTO 0);
--			data6x		: IN STD_LOGIC_VECTOR (1 DOWNTO 0);
--			data7x		: IN STD_LOGIC_VECTOR (1 DOWNTO 0);
--			data8x		: IN STD_LOGIC_VECTOR (1 DOWNTO 0);
--			data9x		: IN STD_LOGIC_VECTOR (1 DOWNTO 0);
--			data10x		: IN STD_LOGIC_VECTOR (1 DOWNTO 0);
--			data11x		: IN STD_LOGIC_VECTOR (1 DOWNTO 0);
--			data12x		: IN STD_LOGIC_VECTOR (1 DOWNTO 0);
--			data13x		: IN STD_LOGIC_VECTOR (1 DOWNTO 0);
--			data14x		: IN STD_LOGIC_VECTOR (1 DOWNTO 0);
--			data15x		: IN STD_LOGIC_VECTOR (1 DOWNTO 0);
--			data16x		: IN STD_LOGIC_VECTOR (1 DOWNTO 0);
--			data17x		: IN STD_LOGIC_VECTOR (1 DOWNTO 0);
--			data18x		: IN STD_LOGIC_VECTOR (1 DOWNTO 0);
--			data19x		: IN STD_LOGIC_VECTOR (1 DOWNTO 0);
--			data20x		: IN STD_LOGIC_VECTOR (1 DOWNTO 0);
--			data21x		: IN STD_LOGIC_VECTOR (1 DOWNTO 0);
--			data22x		: IN STD_LOGIC_VECTOR (1 DOWNTO 0);
--			data23x		: IN STD_LOGIC_VECTOR (1 DOWNTO 0);
--			data24x		: IN STD_LOGIC_VECTOR (1 DOWNTO 0);
--			data25x		: IN STD_LOGIC_VECTOR (1 DOWNTO 0);
--			data26x		: IN STD_LOGIC_VECTOR (1 DOWNTO 0);
--			data27x		: IN STD_LOGIC_VECTOR (1 DOWNTO 0);
--			data28x		: IN STD_LOGIC_VECTOR (1 DOWNTO 0);
--			data29x		: IN STD_LOGIC_VECTOR (1 DOWNTO 0);
--			data30x		: IN STD_LOGIC_VECTOR (1 DOWNTO 0);
--			data31x		: IN STD_LOGIC_VECTOR (1 DOWNTO 0);
--			sel			: IN STD_LOGIC_VECTOR (4 DOWNTO 0);
--			result		: OUT STD_LOGIC_VECTOR (1 DOWNTO 0)
--		 );
--	END COMPONENT;
--
----ONEHOT BINARY--
--
--	COMPONENT onehot_binary
--	PORT ( 
--			onehot_in  : IN  STD_LOGIC_VECTOR(NUM_REGISTERS DOWNTO 0);
--	       	binary_out : OUT STD_LOGIC_VECTOR  
--		 );
--	END COMPONENT;

--SIGNALS--

	TYPE VECTOR32_0 IS ARRAY (NATURAL RANGE <>) OF STD_LOGIC_VECTOR(49 DOWNTO 0);
	SIGNAL tableRegisterOutput : VECTOR32_0(NUM_REGISTERS DOWNTO 0);

	--TYPE VECTOR32_1 IS ARRAY (NATURAL RANGE <>) OF STD_LOGIC;
	--SIGNAL tableComparatorOutput : VECTOR32_1(NUM_REGISTERS DOWNTO 0);
	--SIGNAL tableComparatorOutput : STD_LOGIC_VECTOR(NUM_REGISTERS DOWNTO 0);

	--SIGNAL addressFoundOutput	  : STD_LOGIC ; 
	--SIGNAL onehot_binaryOutput : STD_LOGIC_VECTOR(4 DOWNTO 0);
	--SIGNAL tableComparatorOutput0 : STD_LOGIC ; 
	--SIGNAL tableRegisterOutput   : STD_LOGIC_VECTOR(49 DOWNTO 0); 
	--SIGNAL inputRegisterDestinationAddress : STD_LOGIC_VECTOR(47 DOWNTO 0);

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


--	tableComparatorArray:
--	FOR i IN 0 TO NUM_REGISTERS GENERATE
--		tableComparatorX : tableComparator PORT MAP (
--			dataa		=>	tableRegisterOutput(i)( 47 DOWNTO 0),
--			datab		=>	input_reg(47 DOWNTO 0), 
--			aeb			=>	tableComparatorOutput(i)
--			);
--		end GENERATE tableComparatorArray;
--
--	onehot_binary0 : onehot_binary
--	PORT MAP (
--			onehot_in 	=> tableComparatorOutput(NUM_REGISTERS DOWNTO 0),
--			binary_out 	=> onehot_binaryOutput
--
--		);
--
--	outputPortMux0 	: outputPortMux PORT MAP (
--			data0x		=> tableRegisterOutput(0 )(PORT1 DOWNTO PORT0),
--			data1x		=> tableRegisterOutput(1 )(PORT1 DOWNTO PORT0),
--			data2x		=> tableRegisterOutput(2 )(PORT1 DOWNTO PORT0),
--			data3x		=> tableRegisterOutput(3 )(PORT1 DOWNTO PORT0),
--			data4x		=> tableRegisterOutput(4 )(PORT1 DOWNTO PORT0),
--			data5x		=> tableRegisterOutput(5 )(PORT1 DOWNTO PORT0),
--			data6x		=> tableRegisterOutput(6 )(PORT1 DOWNTO PORT0),
--			data7x		=> tableRegisterOutput(7 )(PORT1 DOWNTO PORT0),
--			data8x		=> tableRegisterOutput(8 )(PORT1 DOWNTO PORT0),
--			data9x		=> tableRegisterOutput(9 )(PORT1 DOWNTO PORT0),
--			data10x		=> tableRegisterOutput(10)(PORT1 DOWNTO PORT0),
--			data11x		=> tableRegisterOutput(11)(PORT1 DOWNTO PORT0),
--			data12x		=> tableRegisterOutput(12)(PORT1 DOWNTO PORT0),
--			data13x		=> tableRegisterOutput(13)(PORT1 DOWNTO PORT0),
--			data14x		=> tableRegisterOutput(14)(PORT1 DOWNTO PORT0),
--			data15x		=> tableRegisterOutput(15)(PORT1 DOWNTO PORT0),
--			data16x		=> tableRegisterOutput(16)(PORT1 DOWNTO PORT0),
--			data17x		=> tableRegisterOutput(17)(PORT1 DOWNTO PORT0),
--			data18x		=> tableRegisterOutput(18)(PORT1 DOWNTO PORT0),
--			data19x		=> tableRegisterOutput(19)(PORT1 DOWNTO PORT0),
--			data20x		=> tableRegisterOutput(20)(PORT1 DOWNTO PORT0),
--			data21x		=> tableRegisterOutput(21)(PORT1 DOWNTO PORT0),
--			data22x		=> tableRegisterOutput(22)(PORT1 DOWNTO PORT0),
--			data23x		=> tableRegisterOutput(23)(PORT1 DOWNTO PORT0),
--			data24x		=> tableRegisterOutput(24)(PORT1 DOWNTO PORT0),
--			data25x		=> tableRegisterOutput(25)(PORT1 DOWNTO PORT0),
--			data26x		=> tableRegisterOutput(26)(PORT1 DOWNTO PORT0),
--			data27x		=> tableRegisterOutput(27)(PORT1 DOWNTO PORT0),
--			data28x		=> tableRegisterOutput(28)(PORT1 DOWNTO PORT0),
--			data29x		=> tableRegisterOutput(29)(PORT1 DOWNTO PORT0),
--			data30x		=> tableRegisterOutput(30)(PORT1 DOWNTO PORT0),
--			data31x		=> tableRegisterOutput(31)(PORT1 DOWNTO PORT0),
--			sel			=> onehot_binaryOutput(4 DOWNTO 0),
--			result		=> output_reg
--			);
--
		--address_found <= addressFoundOutput; 

END Table_Architecture;

--	tableRegister0 : tableRegister PORT MAP (
--			aclr		=> '0',
--			aset		=> '0',
--			clock		=> '0',
--			data		=> input_reg(49 DOWNTO 0), 
--			enable		=> '0',
--			load		=> '0',
--			shiftin		=> '0',
--			q			=> tableRegisterOutput0
--			);
--
--	tableComparator0 : tableComparator PORT MAP (
--			dataa		=>	tableRegisterOutput0(47 DOWNTO 0),
--			datab		=>	input_reg(47 DOWNTO 0), 
--			aeb			=>	addressFoundOutput
--		 );
--
