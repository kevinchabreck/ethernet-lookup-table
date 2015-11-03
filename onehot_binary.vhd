library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity onehot_binary is
  port    ( onehot_in  : in  std_logic_vector;
            binary_out : out std_logic_vector  );
  begin
    assert 2**binary_out'length = onehot_in'length severity failure;

end;

architecture rtl of onehot_binary is

  function one_hot_to_binary (
    One_Hot : std_logic_vector ;
    size    : natural
  ) return std_logic_vector is

    variable Bin_Vec_Var : std_logic_vector(size-1 downto 0);

  begin

    Bin_Vec_Var := (others => '0');

    for I in One_Hot'range loop
      if One_Hot(I) = '1' then
        Bin_Vec_Var := Bin_Vec_Var or std_logic_vector(to_unsigned(I,size));
      end if;
    end loop;
    return Bin_Vec_Var;
  end function;

begin

  binary_out <= one_hot_to_binary(onehot_in, binary_out'length);

end;
