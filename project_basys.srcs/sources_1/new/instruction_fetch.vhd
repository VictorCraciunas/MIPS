
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity instruction_fetch is
  Port( WE,reset,clk,PC_src,jump:in std_logic;
        branch_ADDR, jump_ADDR:in std_logic_vector(15 downto 0);
        PC_OUT,Instr:out std_logic_vector(15 downto 0)
  );
end instruction_fetch;

architecture Behavioral of instruction_fetch is

--ROM
type t_rom is array (0 to 255) of std_logic_vector(15 downto 0);
  signal rom : t_rom := (
    b"000_001_001_001_0_110", -- xor A, A
    b"000_010_010_010_0_110", -- xor B, B
    b"000_011_011_011_0_110", -- xor C, C
    b"001_001_001_0000001", -- A addi 1
    b"001_010_010_0000001", -- B addi 1
    b"000_001_010_011_0_000", -- C <- A add B
    b"000_010_010_010_0_110", -- xor B, B
    b"000_001_010_010_0_000", -- B <- A
    b"000_001_001_001_0_110", -- xor A, A
    b"000_001_011_001_0_000", -- A <- C
    b"111_0000000000101", -- jump 
    others => (others => '1')
  );

--signals for IF
signal PC:std_logic_vector(15 downto 0) := (others => '0');
signal NextAddr:std_logic_vector(15 downto 0) := (others => '0');
signal MUXbranchOUT:std_logic_vector(15 downto 0) := (others => '0');
signal PC1:std_logic_vector(15 downto 0) := (others => '0');


begin

--PC
process(clk,reset)
begin
    if reset = '1' then
        PC <= x"0000";
    else
        if rising_edge(clk) and WE='1' then
            PC <= NextAddr; 
        end if;
    end if;    
end process;

--MUX branch
process(PC_src,branch_ADDR,PC1)
begin
    case (PC_src) is
        when '0' => MUXbranchOUT <= PC1;
        when others => MUXbranchOUT <= branch_ADDR;
    end case;    
end process;


--MUX jump
process (jump,MUXbranchOUT,jump_ADDR)
begin
    case (jump) is
        when '0' => NextAddr <= MUXbranchOUT;
        when others => NextAddr <= jump_ADDR;
    end case;    
end process;


PC1 <= PC + 1;
PC_OUT <= PC1;
Instr <= rom(conv_integer(PC));

end Behavioral;
