

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity Decode is
    port(
    clk,RegWrite,RegDST,ExtOp:in std_logic;
    Instr, WriteData:in std_logic_vector(15 downto 0);
    RD1,RD2,EXTIm:out std_logic_vector(15 downto 0);
    sa:out std_logic;
    func:out std_logic_vector (2 downto 0)
    );
end Decode;

architecture Behavioral of Decode is
signal wa  : std_logic_vector(2 downto 0) := b"000";

component register_file
  port (wen,clk : in  std_logic;
    ra1:in  std_logic_vector(2  downto 0);
    ra2:in  std_logic_vector(2  downto 0);
    wa:in  std_logic_vector(2  downto 0);
    wd:in  std_logic_vector(15 downto 0);
    rd1:out std_logic_vector(15 downto 0);
    rd2:out std_logic_vector(15 downto 0)
  );
  end component;

begin
  reg_file_inst : register_file
  port map (
    clk => clk,
    ra1 => instr(12 downto 10),
    ra2 => instr(9  downto 7),
    wa  => wa,
    wd  => WriteData,
    wen => RegWrite,
    rd1 => rd1,
    rd2 => rd2
  );
  
 --ext Unit 
process(ExtOp,Instr)
begin
    case ExtOp is
        when '1' => 
            case(Instr(6)) is
                 when '1' => EXTIm <= "111111111" & Instr(6 downto 0);
                 when others => EXTIm <= "000000000" & Instr(6 downto 0);
            end case;
        when others => EXTIm  <= "000000000" & Instr(6 downto 0);
    end case;
end process;

  sa   <= instr(3);
  func <= instr(2 downto 0);
  
  --Mux
  wa <= instr(6 downto 4) when RegDST = '1' else instr(9 downto 7);

end Behavioral;

