library ieee;
use ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

entity TableTester IS
  port(
    clock         : in  std_logic;                    -- clock
    reset         : in  std_logic;                    -- reset
    start_test    : in  std_logic;
    start_test_out: out std_logic;
    src_port      : out std_logic_vector(1 downto 0); -- indicates valid data in output_reg
    src_address   : out std_logic_vector(3 downto 0); -- indicates valid data in output_reg
    dst_address   : out std_logic_vector(3 downto 0); -- indicates valid data in output_reg
    --tbl_input     : out std_logic_vector(97 downto 0);
    input_valid   : out std_logic;
    output_valid  : out std_logic;                    -- indicates valid data in output_reg
    address_found : out std_logic;                    -- indicates table contains entry for dst address
    output_reg    : out std_logic_vector(1 downto 0)  -- return same port if src not in table
  );
end TableTester;

architecture TableTester_Architecture of TableTester is

  component Table
  port(
    clock         : IN  STD_LOGIC;                      -- clock
    reset         : IN  STD_LOGIC;                      -- reset
    input_valid   : IN  STD_LOGIC;                      -- indicates valid data in input_reg
    input_reg     : IN  STD_LOGIC_VECTOR(97 downto 0);  -- port | source | destination
    --write_enable  : OUT STD_LOGIC;                    -- indicates we have read input_reg
    output_valid  : OUT STD_LOGIC;                      -- indicates valid data in output_reg
    address_found : OUT STD_LOGIC;                      -- indicates table contains entry for dst address
    output_reg    : OUT STD_LOGIC_VECTOR(1 downto 0)    -- return same port if src not in table
  );
  end component;

  type state_type is (initialize, lookUpAddressA, waitForAddressA, lookUpAddressB, waitForAddressB);
  signal state_reg, state_next: state_type;
  signal inputvalid : std_logic;
  signal input_reg   : std_logic_vector(97 downto 0);
  constant a: integer := 16#A#;
  constant b: integer := 16#B#;

begin

  start_test_out <= start_test;

  table_inst : Table
  PORT MAP(
    clock => clock,
    reset => reset,
    input_valid => inputvalid,
    input_reg => input_reg,
    --write_enable => write_enable,
    output_valid => output_valid,
    address_found => address_found,
    output_reg => output_reg
  );

  --00000000000000000000000000000000000000000000000011111111111111111111111111111111111111111111111101
  --11111111111111111111111111111111111111111111111100000000000000000000000000000000000000000000000010

  -- clock and asynch reset
  process (clock, reset)
  begin
      if (reset='1') then
        state_reg   <= initialize;
      elsif rising_edge(clock) then
        state_reg   <= state_next;
      end if;
  end process;

  -- next-state & Mealy output logic
  --process (state_reg, receive_data_valid, clk_counter)
  process (state_reg, start_test)
  begin
    case state_reg is
      when initialize =>
        src_port    <= "00";
        src_address <= "0000";
        dst_address <= "0000";
        --tbl_input   <= conv_std_logic_vector(0, 98);
        input_reg   <= conv_std_logic_vector(0, 98);
        inputvalid  <= '0';
        input_valid <= '0';
        if start_test = '1' then
          state_next  <= lookUpAddressA;
        else
          state_next  <= initialize;
        end if;
      when lookUpAddressA =>
        src_port    <= "01";
        src_address <= conv_std_logic_vector(b, 4);
        dst_address <= conv_std_logic_vector(a, 4);
        --tbl_input   <= conv_std_logic_vector(a, 48) & conv_std_logic_vector(b, 48) & "01";
        input_reg   <= conv_std_logic_vector(a, 48) & conv_std_logic_vector(b, 48) & "01";
        inputvalid  <= '1';
        input_valid <= '1';
        state_next  <= waitForAddressA;
      when waitForAddressA =>
        src_port    <= "01";
        src_address <= conv_std_logic_vector(b, 4);
        dst_address <= conv_std_logic_vector(a, 4);
        --tbl_input   <= conv_std_logic_vector(a, 48) & conv_std_logic_vector(b, 48) & "01";
        input_reg   <= conv_std_logic_vector(a, 48) & conv_std_logic_vector(b, 48) & "01";
        inputvalid  <= '1';
        input_valid <= '1';
        state_next  <= lookUpAddressB;
      when lookUpAddressB =>
        src_port    <= "10";
        src_address <= conv_std_logic_vector(a, 4);
        dst_address <= conv_std_logic_vector(b, 4);
        --tbl_input   <= conv_std_logic_vector(b, 48) & conv_std_logic_vector(a, 48) & "10";
        input_reg   <= conv_std_logic_vector(b, 48) & conv_std_logic_vector(a, 48) & "10";
        inputvalid  <= '1';
        input_valid <= '1';
        state_next  <= waitForAddressB;
      when waitForAddressB =>
        src_port    <= "10";
        src_address <= conv_std_logic_vector(a, 4);
        dst_address <= conv_std_logic_vector(b, 4);
        --tbl_input   <= conv_std_logic_vector(b, 48) & conv_std_logic_vector(a, 48) & "10";
        input_reg   <= conv_std_logic_vector(b, 48) & conv_std_logic_vector(a, 48) & "10";
        inputvalid  <= '1';
        input_valid <= '1';
        state_next  <= lookUpAddressA;
    end case;
  end process;

end TableTester_Architecture;
