library ieee;
use IEEE.std_logic_1164.all;

use Work.tableState.all;

	ENTITY Lookup IS
	PORT (
			input_registerArray 	: VECTOR_MAC_PORT(NUM_REGISTERS DOWNTO 0);
			input_register			: IN STD_LOGIC_VECTOR(47 DOWNTO 0);
			output_port				: OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
			output_valid			: OUT STD_LOGIC;
			output_registerNumber	: OUT STD_LOGIC_VECTOR(4 DOWNTO 0)
		 );

	END Lookup;

ARCHITECTURE Lookup_Architecture OF Lookup IS
	CONSTANT NUM_REGISTERS : INTEGER := 31;
	CONSTANT PORT1		   : INTEGER := 49;
	CONSTANT PORT0		   : INTEGER := 48;
		
--COMPARATOR--

	COMPONENT tableComparator
	PORT (
			dataa		: IN STD_LOGIC_VECTOR (47 DOWNTO 0);
			datab		: IN STD_LOGIC_VECTOR (47 DOWNTO 0);
			aeb			: OUT STD_LOGIC 
		);
	END COMPONENT;

--OUTPUT PORT MUX--
	
	COMPONENT outputPortMux
	PORT (
			data0x		: IN STD_LOGIC_VECTOR (1 DOWNTO 0);
			data1x		: IN STD_LOGIC_VECTOR (1 DOWNTO 0);
			data2x		: IN STD_LOGIC_VECTOR (1 DOWNTO 0);
			data3x		: IN STD_LOGIC_VECTOR (1 DOWNTO 0);
			data4x		: IN STD_LOGIC_VECTOR (1 DOWNTO 0);
			data5x		: IN STD_LOGIC_VECTOR (1 DOWNTO 0);
			data6x		: IN STD_LOGIC_VECTOR (1 DOWNTO 0);
			data7x		: IN STD_LOGIC_VECTOR (1 DOWNTO 0);
			data8x		: IN STD_LOGIC_VECTOR (1 DOWNTO 0);
			data9x		: IN STD_LOGIC_VECTOR (1 DOWNTO 0);
			data10x		: IN STD_LOGIC_VECTOR (1 DOWNTO 0);
			data11x		: IN STD_LOGIC_VECTOR (1 DOWNTO 0);
			data12x		: IN STD_LOGIC_VECTOR (1 DOWNTO 0);
			data13x		: IN STD_LOGIC_VECTOR (1 DOWNTO 0);
			data14x		: IN STD_LOGIC_VECTOR (1 DOWNTO 0);
			data15x		: IN STD_LOGIC_VECTOR (1 DOWNTO 0);
			data16x		: IN STD_LOGIC_VECTOR (1 DOWNTO 0);
			data17x		: IN STD_LOGIC_VECTOR (1 DOWNTO 0);
			data18x		: IN STD_LOGIC_VECTOR (1 DOWNTO 0);
			data19x		: IN STD_LOGIC_VECTOR (1 DOWNTO 0);
			data20x		: IN STD_LOGIC_VECTOR (1 DOWNTO 0);
			data21x		: IN STD_LOGIC_VECTOR (1 DOWNTO 0);
			data22x		: IN STD_LOGIC_VECTOR (1 DOWNTO 0);
			data23x		: IN STD_LOGIC_VECTOR (1 DOWNTO 0);
			data24x		: IN STD_LOGIC_VECTOR (1 DOWNTO 0);
			data25x		: IN STD_LOGIC_VECTOR (1 DOWNTO 0);
			data26x		: IN STD_LOGIC_VECTOR (1 DOWNTO 0);
			data27x		: IN STD_LOGIC_VECTOR (1 DOWNTO 0);
			data28x		: IN STD_LOGIC_VECTOR (1 DOWNTO 0);
			data29x		: IN STD_LOGIC_VECTOR (1 DOWNTO 0);
			data30x		: IN STD_LOGIC_VECTOR (1 DOWNTO 0);
			data31x		: IN STD_LOGIC_VECTOR (1 DOWNTO 0);
			sel			: IN STD_LOGIC_VECTOR (4 DOWNTO 0);
			result		: OUT STD_LOGIC_VECTOR (1 DOWNTO 0)
		 );
	END COMPONENT;

--ONEHOT BINARY--

	COMPONENT onehot_binary
	PORT ( 
			onehot_in  : IN  STD_LOGIC_VECTOR(NUM_REGISTERS DOWNTO 0);
	       	binary_out : OUT STD_LOGIC_VECTOR  
		 );
	END COMPONENT;


	SIGNAL tableRegisterOutput : VECTOR_MAC_PORT(NUM_REGISTERS DOWNTO 0);

	SIGNAL tableComparatorOutput : STD_LOGIC_VECTOR(NUM_REGISTERS DOWNTO 0);
	SIGNAL onehot_binaryOutput : STD_LOGIC_VECTOR(4 DOWNTO 0);

BEGIN

	tableComparatorArray:
	FOR i IN 0 TO NUM_REGISTERS GENERATE
		tableComparatorX : tableComparator PORT MAP (
			dataa		=>	input_registerArray(i)(47 DOWNTO 0),
			datab		=>	input_register(47 DOWNTO 0), 
			aeb			=>	tableComparatorOutput(i)
			);
		end GENERATE tableComparatorArray;

	onehot_binary0 : onehot_binary
	PORT MAP (
			onehot_in 	=> tableComparatorOutput(NUM_REGISTERS DOWNTO 0),
			binary_out 	=> onehot_binaryOutput

		);

	outputPortMux0 	: outputPortMux PORT MAP (
			data0x		=> input_registerArray(0 )(PORT1 DOWNTO PORT0),
			data1x		=> input_registerArray(1 )(PORT1 DOWNTO PORT0),
			data2x		=> input_registerArray(2 )(PORT1 DOWNTO PORT0),
			data3x		=> input_registerArray(3 )(PORT1 DOWNTO PORT0),
			data4x		=> input_registerArray(4 )(PORT1 DOWNTO PORT0),
			data5x		=> input_registerArray(5 )(PORT1 DOWNTO PORT0),
			data6x		=> input_registerArray(6 )(PORT1 DOWNTO PORT0),
			data7x		=> input_registerArray(7 )(PORT1 DOWNTO PORT0),
			data8x		=> input_registerArray(8 )(PORT1 DOWNTO PORT0),
			data9x		=> input_registerArray(9 )(PORT1 DOWNTO PORT0),
			data10x		=> input_registerArray(10)(PORT1 DOWNTO PORT0),
			data11x		=> input_registerArray(11)(PORT1 DOWNTO PORT0),
			data12x		=> input_registerArray(12)(PORT1 DOWNTO PORT0),
			data13x		=> input_registerArray(13)(PORT1 DOWNTO PORT0),
			data14x		=> input_registerArray(14)(PORT1 DOWNTO PORT0),
			data15x		=> input_registerArray(15)(PORT1 DOWNTO PORT0),
			data16x		=> input_registerArray(16)(PORT1 DOWNTO PORT0),
			data17x		=> input_registerArray(17)(PORT1 DOWNTO PORT0),
			data18x		=> input_registerArray(18)(PORT1 DOWNTO PORT0),
			data19x		=> input_registerArray(19)(PORT1 DOWNTO PORT0),
			data20x		=> input_registerArray(20)(PORT1 DOWNTO PORT0),
			data21x		=> input_registerArray(21)(PORT1 DOWNTO PORT0),
			data22x		=> input_registerArray(22)(PORT1 DOWNTO PORT0),
			data23x		=> input_registerArray(23)(PORT1 DOWNTO PORT0),
			data24x		=> input_registerArray(24)(PORT1 DOWNTO PORT0),
			data25x		=> input_registerArray(25)(PORT1 DOWNTO PORT0),
			data26x		=> input_registerArray(26)(PORT1 DOWNTO PORT0),
			data27x		=> input_registerArray(27)(PORT1 DOWNTO PORT0),
			data28x		=> input_registerArray(28)(PORT1 DOWNTO PORT0),
			data29x		=> input_registerArray(29)(PORT1 DOWNTO PORT0),
			data30x		=> input_registerArray(30)(PORT1 DOWNTO PORT0),
			data31x		=> input_registerArray(31)(PORT1 DOWNTO PORT0),
			sel			=> onehot_binaryOutput(4 DOWNTO 0),
			result		=> output_port
			);

		output_registerNumber <= onehot_binaryOutput;

END Lookup_Architecture;
