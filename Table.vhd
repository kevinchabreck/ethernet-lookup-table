LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

PACKAGE tableState IS
    CONSTANT MAC_SIZE	   : INTEGER := 47;
    CONSTANT REGISTER_SIZE : INTEGER := 49;
    CONSTANT FRAME_SIZE	   : INTEGER := 97;
    CONSTANT NUM_REGISTERS : INTEGER := 31;
    TYPE VECTOR_PORT_MAC IS ARRAY (NATURAL RANGE <>) OF STD_LOGIC_VECTOR(REGISTER_SIZE DOWNTO 0);
END PACKAGE tableState;

--NOTE: Don't delete this, we need to redeclare these after defining tableState package above
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE Work.tableState.ALL;

ENTITY Table IS
    PORT(
        clock           : IN  STD_LOGIC;                                -- clock
        reset           : IN  STD_LOGIC;                                -- reset
        input_valid     : IN  STD_LOGIC;                                -- indicates valid data in input_reg
        input_reg       : IN  STD_LOGIC_VECTOR(FRAME_SIZE DOWNTO 0);    -- port | source | destination
        output_valid    : OUT STD_LOGIC;                                -- indicates valid data in output_reg
        --I think this is redundant and we don't need it anymore, I don't know of a case where address_found and output_valid would be different
        address_found   : OUT STD_LOGIC;                                -- indicates table contains entry for dst address
        output_reg      : OUT STD_LOGIC_VECTOR(1 DOWNTO 0)              -- return same port if src not in table
    );
END Table;

ARCHITECTURE Table_Architecture OF Table IS

    --INPUT REGISTER--
    COMPONENT D_FF_INPUT IS
    PORT(
        clk : IN  STD_LOGIC;
        rst : IN  STD_LOGIC;
        pre : IN  STD_LOGIC;
        ce  : IN  STD_LOGIC;
        d   : IN  STD_LOGIC_VECTOR(FRAME_SIZE DOWNTO 0);
        q   : OUT STD_LOGIC_VECTOR(FRAME_SIZE DOWNTO 0)
    );
    END COMPONENT;

    COMPONENT RegisterArray IS
    PORT(
        in_aclr     : IN  STD_LOGIC;
        in_clock    : IN  STD_LOGIC;
        in_data     : IN  STD_LOGIC_VECTOR(REGISTER_SIZE DOWNTO 0);
        in_enable   : IN  STD_LOGIC_VECTOR(4 DOWNTO 0);
        in_load     : IN  STD_LOGIC;
        out_q       : OUT VECTOR_PORT_MAC(NUM_REGISTERS downto 0)
    );
    END COMPONENT;

    COMPONENT Lookup IS
    PORT(
        input_registerArray     : IN VECTOR_PORT_MAC(NUM_REGISTERS DOWNTO 0);
        input_register          : IN  STD_LOGIC_VECTOR(MAC_SIZE DOWNTO 0);
        output_port             : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
        output_valid            : OUT STD_LOGIC;
        output_registerNumber   : OUT STD_LOGIC_VECTOR(4 DOWNTO 0)
    );
    END COMPONENT;

    COMPONENT random IS GENERIC(width : INTEGER :=  5);
    PORT(
        clk         : IN STD_LOGIC;
        random_num  : OUT STD_LOGIC_VECTOR(width-1 DOWNTO 0)   --output vector
    );
    END COMPONENT;

    COMPONENT twoMux IS
    PORT(
        data0x  : IN STD_LOGIC_VECTOR (4 DOWNTO 0);
        data1x  : IN STD_LOGIC_VECTOR (4 DOWNTO 0);
        sel     : IN STD_LOGIC;
        result  : OUT STD_LOGIC_VECTOR (4 DOWNTO 0)
    );
    END component;

    --SIGNALS--
    SIGNAL tableRegisterOutput 	    : VECTOR_PORT_MAC(NUM_REGISTERS DOWNTO 0);
    SIGNAL myLookup_registerNumber  : STD_LOGIC_VECTOR(4 DOWNTO 0);
    SIGNAL blank_regNum             : STD_LOGIC_VECTOR(4 DOWNTO 0);
    SIGNAL rand                     : STD_LOGIC_VECTOR(4 DOWNTO 0);
    SIGNAL blank_output_reg         : STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL is_src_there             : STD_LOGIC;
    SIGNAL writeEnable              : STD_LOGIC_VECTOR(4 DOWNTO 0);
    SIGNAL input_signal             : STD_LOGIC_VECTOR(FRAME_SIZE DOWNTO 0);
    SIGNAL outputValid_addressFound : STD_LOGIC;

BEGIN
    --COMPONENT INSTANTIATIONS--

    input_register_DFF : D_FF_INPUT
    PORT MAP(
        clk => clock,
        rst => reset,
        pre => '0',
        ce  => input_valid,
        d   => input_reg(FRAME_SIZE DOWNTO 0),
        q   => input_signal(FRAME_SIZE DOWNTO 0)
    );

    myRegisterArray : RegisterArray
    PORT MAP(
        in_aclr     => reset,
        in_clock    => clock,
        in_data     => input_signal(FRAME_SIZE DOWNTO 48),
        in_enable   => writeEnable,
        in_load     => '0',
        out_q       => tableRegisterOutput(NUM_REGISTERS downto 0)
    );

    destLookup : Lookup
    PORT MAP(
        tableRegisterOutput(NUM_REGISTERS DOWNTO 0),
        input_register          => input_signal(REGISTER_SIZE DOWNTO 2),
        output_port             => output_reg,
        output_valid            => outputValid_addressFound,
        output_registerNumber   => blank_regNum
    );

    srcLookup : Lookup
    PORT MAP(
        tableRegisterOutput(NUM_REGISTERS DOWNTO 0),
        input_register          => input_signal(FRAME_SIZE DOWNTO 50),
        output_port             => blank_output_reg,
        output_valid            => is_src_there,
        output_registerNumber   => myLookup_registerNumber(4 DOWNTO 0)
    );

    myRandom : random
    PORT MAP(
        clk         => clock,
        random_num  => rand(4 DOWNTO 0)   --output vector
    );

    myMux: twoMux
    PORT MAP(
        data0x  => rand(4 DOWNTO 0),
        data1x  => myLookup_registerNumber(4 DOWNTO 0),
        sel     => is_src_there,
        result  => writeEnable(4 DOWNTO 0)
    );

    address_found <= outputValid_addressFound;

END Table_Architecture;
