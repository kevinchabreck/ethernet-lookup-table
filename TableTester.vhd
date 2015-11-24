library ieee;
use ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

entity TableTester IS
  port(
    clock         : in  std_logic;                    -- clock
    reset         : in  std_logic;                    -- reset
    trigger_in    : in  std_logic;                    -- logic analyzer trigger
    trigger_out   : out std_logic;                    -- logic analyzer trigger
    src_port      : out std_logic_vector(1 downto 0); -- src port (formatted for logic analyzer)
    src_address   : out std_logic_vector(3 downto 0); -- src address (formatted for logic analyzer)
    dst_address   : out std_logic_vector(3 downto 0); -- dst address (formatted for logic analyzer)
    input_valid   : out std_logic;                    -- indicates valid data in input_reg
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
    output_valid  : OUT STD_LOGIC;                      -- indicates valid data in output_reg
    address_found : OUT STD_LOGIC;                      -- indicates table contains entry for dst address
    output_reg    : OUT STD_LOGIC_VECTOR(1 downto 0)    -- return same port if src not in table
  );
  end component;

  type state_type is (initialize, lookUpAddressA, waitForAddressA, lookUpAddressB, waitForAddressB);
  signal state_reg, state_next: state_type;
  signal inputvalid : std_logic;
  signal input_reg  : std_logic_vector(97 downto 0);
  signal srcaddr: integer;
  signal dstaddr: integer;
  signal srcport: integer;
  signal clk_counter, clk_counter_next : integer;
  constant a: integer := 16#A#;
  constant b: integer := 16#B#;
  constant COMPTIME: integer := 1;

begin

  table_inst : Table
  PORT MAP(
    clock => clock,
    reset => reset,
    input_valid => inputvalid,
    input_reg => input_reg,
    output_valid => output_valid,
    address_found => address_found,
    output_reg => output_reg
  );

  -- clock and async reset
  process (clock, reset, clk_counter_next)
  begin
    if (reset='1') then
      state_reg   <= initialize;
      clk_counter <= 0;
    elsif rising_edge(clock) then
      state_reg   <= state_next;
      clk_counter <= clk_counter_next;
    end if;
  end process;

  -- next-state & Mealy output logic
  process (state_reg, trigger_in, clk_counter)
  begin
    case state_reg is
      when initialize =>
        clk_counter_next <= 0;
        srcport <= 0;
        srcaddr <= 0;
        dstaddr <= 0;
        inputvalid  <= '0';
        if trigger_in = '1' then
          state_next <= lookUpAddressA;
        else
          state_next <= initialize;
        end if;
      when lookUpAddressA =>
        clk_counter_next <= 0;
        srcport  <= 1;
        srcaddr  <= b;
        dstaddr  <= a;
        inputvalid <= '1';
        state_next <= waitForAddressA;
      when waitForAddressA =>
        clk_counter_next <= clk_counter+1;
        srcport <= 0;
        srcaddr <= 0;
        dstaddr <= 0;
        inputvalid <= '0';
        if clk_counter < COMPTIME then
          state_next <= waitForAddressA;
        else
          state_next <= lookUpAddressB;
        end if;
      when lookUpAddressB =>
        clk_counter_next <= 0;
        srcport <= 2;
        srcaddr <= a;
        dstaddr <= b;
        inputvalid <= '1';
        state_next <= waitForAddressB;
      when waitForAddressB =>
        clk_counter_next <= clk_counter+1;
        srcport <= 0;
        srcaddr <= 0;
        dstaddr <= 0;
        inputvalid <= '0';
        if clk_counter < COMPTIME then
          state_next <= waitForAddressB;
        else
          state_next <= lookUpAddressA;
        end if;
    end case;
  end process;

  process (trigger_in, srcport, srcaddr, dstaddr, inputvalid)
  begin
    trigger_out <= trigger_in;
    input_reg   <= conv_std_logic_vector(srcport, 2) & conv_std_logic_vector(srcaddr, 48) & conv_std_logic_vector(dstaddr, 48);
    input_valid <= inputvalid;
    src_port    <= conv_std_logic_vector(srcport, 2);
    src_address <= conv_std_logic_vector(srcaddr, 4);
    dst_address <= conv_std_logic_vector(dstaddr, 4);
  end process;

end TableTester_Architecture;
