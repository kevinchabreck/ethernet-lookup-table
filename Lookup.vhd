library ieee;
use IEEE.std_logic_1164.all;
-- 23 1 5 enter
use Work.tableState.all;

ENTITY Lookup IS
PORT (
	input_registerArray0 	: std_LOGIC_VECTOR(49 DOWNTO 0);
	input_registerArray1 	: std_LOGIC_VECTOR(49 DOWNTO 0);
	input_registerArray2 	: std_LOGIC_VECTOR(49 DOWNTO 0);
	input_registerArray3 	: std_LOGIC_VECTOR(49 DOWNTO 0);
	input_registerArray4 	: std_LOGIC_VECTOR(49 DOWNTO 0);
	input_register			: IN STD_LOGIC_VECTOR(47 DOWNTO 0);
	output_port				: OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
	output_valid			: OUT STD_LOGIC;
	output_registerNumber	: OUT STD_LOGIC_VECTOR(4 DOWNTO 0)
);
END Lookup;

ARCHITECTURE Lookup_Architecture OF Lookup IS

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
	PORT
	(
		data0x		: IN STD_LOGIC_VECTOR (1 DOWNTO 0);
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
		data1x		: IN STD_LOGIC_VECTOR (1 DOWNTO 0);
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
		data2x		: IN STD_LOGIC_VECTOR (1 DOWNTO 0);
		data30x		: IN STD_LOGIC_VECTOR (1 DOWNTO 0);
		data31x		: IN STD_LOGIC_VECTOR (1 DOWNTO 0);
		data3x		: IN STD_LOGIC_VECTOR (1 DOWNTO 0);
		data4x		: IN STD_LOGIC_VECTOR (1 DOWNTO 0);
		data5x		: IN STD_LOGIC_VECTOR (1 DOWNTO 0);
		data6x		: IN STD_LOGIC_VECTOR (1 DOWNTO 0);
		data7x		: IN STD_LOGIC_VECTOR (1 DOWNTO 0);
		data8x		: IN STD_LOGIC_VECTOR (1 DOWNTO 0);
		data9x		: IN STD_LOGIC_VECTOR (1 DOWNTO 0);
		sel		: IN STD_LOGIC_VECTOR (4 DOWNTO 0);
		result		: OUT STD_LOGIC_VECTOR (1 DOWNTO 0)
	);
	END COMPONENT;

	--ONEHOT BINARY--
	COMPONENT onehot_binary
	PORT (
		onehot_in  : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
       	binary_out : OUT STD_LOGIC_VECTOR (4 DOWNTO 0);
		outVal : OUT STD_LOGIC
	);
	END COMPONENT;

	SIGNAL tableRegisterOutput : VECTOR_MAC_PORT(NUM_REGISTERS DOWNTO 0);
	SIGNAL tableComparatorOutput : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL onehot_binaryOutput : STD_LOGIC_VECTOR(4 DOWNTO 0);

BEGIN

	tableComparator0 : tableComparator
	PORT MAP (
		dataa		=>	input_registerArray0(49 DOWNTO 2),
		datab		=>	input_register(47 DOWNTO 0),
		aeb			=>	tableComparatorOutput(0)
	);

	tableComparator1 : tableComparator
	PORT MAP (
		dataa		=>	input_registerArray1(49 DOWNTO 2),
		datab		=>	input_register(47 DOWNTO 0),
		aeb			=>	tableComparatorOutput(1)
	);

	tableComparator2 : tableComparator
	PORT MAP (
		dataa		=>	input_registerArray2(49 DOWNTO 2),
		datab		=>	input_register(47 DOWNTO 0),
		aeb			=>	tableComparatorOutput(2)
	);

	tableComparator3 : tableComparator
	PORT MAP (
		dataa		=>	input_registerArray3(49 DOWNTO 2),
		datab		=>	input_register(47 DOWNTO 0),
		aeb			=>	tableComparatorOutput(3)
	);

	tableComparator4 : tableComparator
	PORT MAP (
		dataa		=>	input_registerArray4(49 DOWNTO 2),
		datab		=>	input_register(47 DOWNTO 0),
		aeb			=>	tableComparatorOutput(4)
	);


	onehot_binary0 : onehot_binary
	PORT MAP (
		onehot_in 	=> tableComparatorOutput(31 DOWNTO 0),
		binary_out 	=> onehot_binaryOutput (4 DOWNTO 0),
		outVal => output_valid
	);

	outputPortMux0 	: outputPortMux
	PORT MAP (
		data0x		=> input_registerArray0(1 downto 0),
		data1x		=> input_registerArray1(1 downto 0),
		data2x		=> input_registerArray2(1 downto 0),
		data3x		=> input_registerArray3(1 downto 0),
		data4x		=> input_registerArray4(1 downto 0),
		data5x		=> "00",
		data6x		=> "00",
		data7x		=> "00",
		data8x		=> "00",
		data9x		=> "00",
		data10x		=> "00",
		data11x		=> "00",
		data12x		=> "00",
		data13x		=> "00",
		data14x		=> "00",
		data15x		=> "00",
		data16x		=> "00",
		data17x		=> "00",
		data18x		=> "00",
		data19x		=> "00",
		data20x		=> "00",
		data21x		=> "00",
		data22x		=> "00",
		data23x		=> "00",
		data24x		=> "00",
		data25x		=> "00",
		data26x		=> "00",
		data27x		=> "00",
		data28x		=> "00",
		data29x		=> "00",
		data30x		=> "00",
		data31x		=> "00",
		sel			=> onehot_binaryOutput(4 DOWNTO 0),
		result		=> output_port
	);

	output_registerNumber <= onehot_binaryOutput;

END Lookup_Architecture;
