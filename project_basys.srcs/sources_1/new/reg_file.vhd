---- reg file

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity register_file is
    port(wen,clk:in std_logic;
        ra1,ra2:in std_logic_vector(2 downto 0);
        wa:in std_logic_vector(2 downto 0);
        wd:in std_logic_vector(15 downto 0);
        rd1,rd2:out std_logic_vector(15 downto 0)  
    );
end register_file;

architecture Behavioral of register_file is

type reg_file is array(7 downto 0) of std_logic_vector(15 downto 0);
signal myreg:reg_file :=(
    x"0000", 
    x"0001", 
    x"0002", 
    x"0003", 
    x"0004", 
    x"0005", 
    x"0006", 
    x"0007"  
);

begin
process(clk)

begin
    if (rising_edge(clk)) then
        if(wen ='1') then
            myreg(conv_integer(wa)) <= wd;
        end if;
    end if;

end process;

rd1 <= myreg(conv_integer(ra1));
rd2 <= myreg(conv_integer(ra2));

end Behavioral;

