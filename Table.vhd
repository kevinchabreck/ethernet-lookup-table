library ieee;
use IEEE.std_logic_1164.all;

PACKAGE tableState IS
    TYPE VECTOR_MAC_PORT IS ARRAY (NATURAL RANGE <>) OF STD_LOGIC_VECTOR(49 DOWNTO 0);
    CONSTANT NUM_REGISTERS : INTEGER := 31;
    CONSTANT PORT1         : INTEGER := 49;
    CONSTANT PORT0         : INTEGER := 48;
END PACKAGE tableState;

library ieee;
use IEEE.std_logic_1164.all;
use Work.tableState.all;

    ENTITY Table IS
    PORT (
        clock         : IN STD_LOGIC; -- clock
        input_valid   : IN  STD_LOGIC; -- indicates valid data in input_reg
        input_reg     : IN  STD_LOGIC_VECTOR(97 DOWNTO 0); -- dst | src | port
        test_en       : IN STD_LOGIC_VECTOR(4 downto 0);
        write_enable  : OUT STD_LOGIC; -- indicates we have read input_reg
        output_valid  : OUT STD_LOGIC; -- indicates valid data in output_reg
        address_found : OUT STD_LOGIC; -- indicates table contains entry for dst address
        output_reg    : OUT STD_LOGIC_VECTOR(1 DOWNTO 0); -- return same port if src not in table


		-- Test outputs
		testMuxOutput : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
		testOutputValid : OUT STD_LOGIC;
		testOutputSrcLookup : OUT STD_LOGIC_VECTOR(4 DOWNTO 0)
    );
    END Table;


ARCHITECTURE Table_Architecture OF Table IS

    --LOOKUP--
    component RegisterArray IS
    PORT (
		out_q : OUT VECTOR_MAC_PORT(NUM_REGISTERS DOWNTO 0);
        --out_q0 : OUT STD_LOGIC_VECTOR(49 downto 0);
        --out_q1 : OUT STD_LOGIC_VECTOR(49 downto 0);
        --out_q2 : OUT STD_LOGIC_VECTOR(49 downto 0);
        --out_q3 : OUT STD_LOGIC_VECTOR(49 downto 0);
        --out_q4 : OUT STD_LOGIC_VECTOR(49 downto 0);
        in_wenable  : IN STD_LOGIC ;
        in_aclr     : IN STD_LOGIC ;
        in_clock    : IN STD_LOGIC ;
        in_data     : IN STD_LOGIC_VECTOR(49 DOWNTO 0);
        in_enable   : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
        in_load     : IN STD_LOGIC 
        --out_q     : OUT VECTOR_MAC_PORT(4 downto 0)
    );
    END component;


    component Lookup IS
    PORT (
		input_registerArray : IN VECTOR_MAC_PORT(NUM_REGISTERS DOWNTO 0);
        --input_registerArray0    : std_LOGIC_VECTOR(49 DOWNTO 0);
        --input_registerArray1    : std_LOGIC_VECTOR(49 DOWNTO 0);
        --input_registerArray2    : std_LOGIC_VECTOR(49 DOWNTO 0);
        --input_registerArray3    : std_LOGIC_VECTOR(49 DOWNTO 0);
        --input_registerArray4    : std_LOGIC_VECTOR(49 DOWNTO 0);
        input_register          : IN  STD_LOGIC_VECTOR(47 DOWNTO 0);
        output_port             : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
        output_valid            : OUT STD_LOGIC;
        output_registerNumber   : OUT STD_LOGIC_VECTOR(4 DOWNTO 0)
    );
    END component;

    component random is
    generic ( width : integer :=  5 );
    port (
      clk : in std_logic;
      random_num : out std_logic_vector (width-1 downto 0)   --output vector
    );
    end comPONENT;

    component twoMux IS
    PORT (
        data0x  : IN STD_LOGIC_VECTOR (4 DOWNTO 0);
        data1x  : IN STD_LOGIC_VECTOR (4 DOWNTO 0);
        sel     : IN STD_LOGIC ;
        result  : OUT STD_LOGIC_VECTOR (4 DOWNTO 0)
    );
    END component;

	--component D_FF_5bit IS
	--port (
	--	clk : in std_logic;
	--	rst : in std_logic;
	--	pre : in std_logic;
	--	ce  : in std_logic;
	--	d : in std_logic_vector(4 downto 0);
	--	q : out std_logic_vector(4 downto 0)
	--);
	--end component;


	--component D_FF_2bit IS
	--port (
	--	clk : in std_logic;
	--	rst : in std_logic;
	--	pre : in std_logic;
	--	ce  : in std_logic;
	--	d : in std_logic_vector(1 downto 0);
	--	q : out std_logic_vector(1 downto 0)
	--);
	--end component;



	--component D_FF IS
	--port (
	--	clk : in std_logic;
	--	rst : in std_logic;
	--	pre : in std_logic;
	--	ce  : in std_logic;
	--	d : in std_logic;
	--	q : out std_logic
	--);
	--end component;

	component D_FF_VHDL IS
	port (
		clk : in std_logic;
		rst : in std_logic;
		pre : in std_logic;
		ce  : in std_logic;
		d : in std_logic_vector(49 downto 0);
		q : out std_logic_vector(49 downto 0)
	);
	end component;

	component FSM IS
	port (
			clock : IN STD_LOGIC;
			input_valid : IN STD_LOGIC;
			tableRegisterOutput : IN VECTOR_MAC_PORT(NUM_REGISTERS DOWNTO 0);
			destLookupFSM: OUT VECTOR_MAC_PORT(NUM_REGISTERS DOWNTO 0);
			srcLookupFSM: OUT VECTOR_MAC_PORT(NUM_REGISTERS DOWNTO 0)
		);
	END component;

	--FSM--
	TYPE state_type IS (A, B, C);
	SIGNAL current_state, next_state: state_type;


    --SIGNALS--
	--RegisterArray
	SIGNAL tableRegisterOutput : VECTOR_MAC_PORT(NUM_REGISTERS DOWNTO 0);

	--destLookup
	SIGNAL destLookupInput : VECTOR_MAC_PORT(NUM_REGISTERS DOWNTO 0);

	--srcLookup
	SIGNAL srcLookupInput : VECTOR_MAC_PORT(NUM_REGISTERS DOWNTO 0);

    SIGNAL myLookup_registerNumber : STD_LOGIC_VECTOR(4 DOWNTO 0);
    SIGNAL blank_regNum : STD_LOGIC_VECTOR(4 downto 0);
    SIGNAL rand : STD_LOGIC_VECTOR(4 downto 0);
    SIGNAL blank_output_reg: STD_LOGIC_VECTOR(1 downto 0);
    signal is_src_there: STD_LOGIC;
    SIGNAL writeEnable: STD_LOGIC_VECTOR(4 DOWNTO 0);
	 

BEGIN
    --COMPONENT INSTANTIATIONS--
    myRegisterArray : RegisterArray
    PORT MAP (
		out_q => tableRegisterOutput(NUM_REGISTERS DOWNTO 0),
        in_wenable  => '0',
        in_aclr     => '0',
        in_clock    => clock,
        in_data     => input_reg(49 DOWNTO 0),
        in_enable   => writeEnable,
        in_load     => '0'
     );

	myFSM : FSM
	PORT MAP (
		clock,
		input_valid,
		tableRegisterOutput,
		destLookupFSM => destLookupInput,
		srcLookupFSM => srcLookupInput
		);

    destLookup : Lookup
    PORT MAP (
		destLookupInput,
        input_register          => input_reg(97 DOWNTO 50),
        output_port             => output_reg,
        output_valid            => output_valid,
        output_registerNumber   => blank_regNum
     );

    srcLookup : Lookup
    PORT MAP (
        srcLookupInput,
        input_register          => input_reg(49 DOWNTO 2),
        output_port             => blank_output_reg,
        output_valid            => is_src_there,
        output_registerNumber   => myLookup_registerNumber(4 DOWNTO 0)
    );

    --myRandom : random
    --port map(
    --    clk => clock,
    --    random_num => rand(4 downto 0)   --output vector
    --);

    --myMux: twoMux
    --PORT map (
    --    data0x => rand(4 downto 0),
    --    data1x => myLookup_registerNumber(4 DOWNTO 0),
    --    sel     => is_src_there,
    --    result => writeEnable(4 downto 0)
    --);


	testMuxOutput <= writeEnable(4 downto 0);
	testOutputValid <= is_src_there;
	testOutputSrcLookup <= myLookup_registerNumber(4 DOWNTO 0);

END Table_Architecture;
