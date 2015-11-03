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
