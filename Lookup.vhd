library ieee;
use IEEE.std_logic_1164.all;
-- 23 1 5 enter
use Work.tableState.all;

ENTITY Lookup IS
PORT (
	input_registerArray		: VECTOR_PORT_MAC(NUM_REGISTERS DOWNTO 0);
	--input_registerArray0 	: std_LOGIC_VECTOR(REGISTER_SIZE DOWNTO 0);
	--input_registerArray1 	: std_LOGIC_VECTOR(REGISTER_SIZE DOWNTO 0);
	--input_registerArray2 	: std_LOGIC_VECTOR(REGISTER_SIZE DOWNTO 0);
	--input_registerArray3 	: std_LOGIC_VECTOR(REGISTER_SIZE DOWNTO 0);
	--input_registerArray4 	: std_LOGIC_VECTOR(REGISTER_SIZE DOWNTO 0);
	input_register			: IN STD_LOGIC_VECTOR(MAC_SIZE DOWNTO 0);
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
		onehot_in  : IN  STD_LOGIC_VECTOR(NUM_REGISTERS DOWNTO 0);
       	binary_out : OUT STD_LOGIC_VECTOR (4 DOWNTO 0);
		outVal : OUT STD_LOGIC
	);
	END COMPONENT;

	SIGNAL tableRegisterOutput : VECTOR_PORT_MAC(NUM_REGISTERS DOWNTO 0);
	SIGNAL tableComparatorOutput : STD_LOGIC_VECTOR(NUM_REGISTERS DOWNTO 0);
	SIGNAL onehot_binaryOutput : STD_LOGIC_VECTOR(4 DOWNTO 0);

BEGIN

	tableComparatorArray:
	FOR i in 0 to NUM_REGISTERS GENERATE
		tableComparatorX : tableComparator PORT MAP (
		dataa		=>	input_registerArray(i)(REGISTER_SIZE DOWNTO 2),
		datab		=>	input_register(47 DOWNTO 0),
		aeb			=>	tableComparatorOutput(i)
	);
	end GENERATE tableComparatorArray;
	--tableComparator0 : tableComparator
	--PORT MAP (
	--	dataa		=>	input_registerArray0(REGISTER_SIZE DOWNTO 2),
	--	datab		=>	input_register(47 DOWNTO 0),
	--	aeb			=>	tableComparatorOutput(0)
	--);

	--tableComparator1 : tableComparator
	--PORT MAP (
	--	dataa		=>	input_registerArray1(REGISTER_SIZE DOWNTO 2),
	--	datab		=>	input_register(47 DOWNTO 0),
	--	aeb			=>	tableComparatorOutput(1)
	--);

	--tableComparator2 : tableComparator
	--PORT MAP (
	--	dataa		=>	input_registerArray2(REGISTER_SIZE DOWNTO 2),
	--	datab		=>	input_register(47 DOWNTO 0),
	--	aeb			=>	tableComparatorOutput(2)
	--);

	--tableComparator3 : tableComparator
	--PORT MAP (
	--	dataa		=>	input_registerArray3(REGISTER_SIZE DOWNTO 2),
	--	datab		=>	input_register(47 DOWNTO 0),
	--	aeb			=>	tableComparatorOutput(3)
	--);

	--tableComparator4 : tableComparator
	--PORT MAP (
	--	dataa		=>	input_registerArray4(REGISTER_SIZE DOWNTO 2),
	--	datab		=>	input_register(47 DOWNTO 0),
	--	aeb			=>	tableComparatorOutput(4)
	--);


	onehot_binary0 : onehot_binary
	PORT MAP (
		onehot_in 	=> tableComparatorOutput(NUM_REGISTERS DOWNTO 0),
		binary_out 	=> onehot_binaryOutput (4 DOWNTO 0),
		outVal => output_valid
	);

	outputPortMux0 	: outputPortMux
	PORT MAP (
		data0x		=> input_registerArray(0)(REGISTER_SIZE downto 48),
		data1x		=> input_registerArray(1)(REGISTER_SIZE downto 48),
		data2x		=> input_registerArray(2)(REGISTER_SIZE downto 48),
		data3x		=> input_registerArray(3)(REGISTER_SIZE downto 48),
		data4x		=> input_registerArray(4)(REGISTER_SIZE downto 48),
		data5x		=> input_registerArray(5)(REGISTER_SIZE downto 48),
		data6x		=> input_registerArray(6)(REGISTER_SIZE downto 48),
		data7x		=> input_registerArray(7)(REGISTER_SIZE downto 48),
		data8x		=> input_registerArray(8)(REGISTER_SIZE downto 48),
		data9x		=> input_registerArray(9)(REGISTER_SIZE downto 48),
		data10x		=> input_registerArray(10)(REGISTER_SIZE downto 48),
		data11x		=> input_registerArray(11)(REGISTER_SIZE downto 48),
		data12x		=> input_registerArray(12)(REGISTER_SIZE downto 48),
		data13x		=> input_registerArray(13)(REGISTER_SIZE downto 48),
		data14x		=> input_registerArray(14)(REGISTER_SIZE downto 48),
		data15x		=> input_registerArray(15)(REGISTER_SIZE downto 48),
		data16x		=> input_registerArray(16)(REGISTER_SIZE downto 48),
		data17x		=> input_registerArray(17)(REGISTER_SIZE downto 48),
		data18x		=> input_registerArray(18)(REGISTER_SIZE downto 48),
		data19x		=> input_registerArray(19)(REGISTER_SIZE downto 48),
		data20x		=> input_registerArray(20)(REGISTER_SIZE downto 48),
		data21x		=> input_registerArray(21)(REGISTER_SIZE downto 48),
		data22x		=> input_registerArray(22)(REGISTER_SIZE downto 48),
		data23x		=> input_registerArray(23)(REGISTER_SIZE downto 48),
		data24x		=> input_registerArray(24)(REGISTER_SIZE downto 48),
		data25x		=> input_registerArray(25)(REGISTER_SIZE downto 48),
		data26x		=> input_registerArray(26)(REGISTER_SIZE downto 48),
		data27x		=> input_registerArray(27)(REGISTER_SIZE downto 48),
		data28x		=> input_registerArray(28)(REGISTER_SIZE downto 48),
		data29x		=> input_registerArray(29)(REGISTER_SIZE downto 48),
		data30x		=> input_registerArray(30)(REGISTER_SIZE downto 48),
		data31x		=> input_registerArray(31)(REGISTER_SIZE downto 48),
		sel			=> onehot_binaryOutput(4 DOWNTO 0),
		result		=> output_port
	);

	output_registerNumber <= onehot_binaryOutput;

END Lookup_Architecture;
