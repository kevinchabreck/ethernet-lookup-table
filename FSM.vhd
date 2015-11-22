library ieee;
use IEEE.std_logic_1164.all;
use Work.tableState.all;

ENTITY FSM IS
PORT ( 
	clock : IN STD_LOGIC;
	input_valid : IN STD_LOGIC;
	tableRegisterOutput : IN VECTOR_MAC_PORT(NUM_REGISTERS DOWNTO 0);
	destLookupFSM : OUT VECTOR_MAC_PORT(NUM_REGISTERS DOWNTO 0);
	srcLookupFSM : OUT VECTOR_MAC_PORT(NUM_REGISTERS DOWNTO 0)
	);
END FSM;

ARCHITECTURE FSM_Architecture OF FSM IS

TYPE state_type is (A, B, C);
SIGNAL current_state, next_state: state_type; 

BEGIN

	PROCESS (clock)
	BEGIN
		if(rising_edge(clock))  then
			current_state <= next_state;
		end if;
	END PROCESS;


	PROCESS(current_state, input_valid)
	BEGIN
		case current_state is
			when A =>
			if(input_valid = '1') then
				next_state <= B;
			else
				next_state <= A;
			end if;

			when B =>
				next_state <= A;
				destLookupFSM <= tableRegisterOutput;

			when C =>
				srcLookupFSM <= tableRegisterOutput;
				next_state <= A;
			end case;
	END PROCESS;

END FSM_Architecture;
