
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity test_env is
    port(
    clk: in std_logic;
    btn: in std_logic_vector(4 downto 0);
    sw: in std_logic_vector(15 downto 0);
    led: out std_logic_vector(15 downto 0);
    an: out std_logic_vector(3 downto 0);
    cat: out std_logic_vector(6 downto 0)
    );
end test_env;

architecture Behavioral of test_env is

signal s_mpg_out : std_logic_vector(4  downto 0) := b"0_0000";

signal s_digits       : std_logic_vector(31 downto 0) := x"0000_0000";
signal s_digits_upper : std_logic_vector(15 downto 0) := x"0000";
signal s_digits_lower : std_logic_vector(15 downto 0) := x"0000";

signal s_if_in_jump_address : std_logic_vector(15 downto 0) := x"0000";
signal s_if_out_instruction : std_logic_vector(15 downto 0) := x"0000";
signal s_if_out_pc_plus_one : std_logic_vector(15 downto 0) := x"0000";

signal s_ctrl_reg_dst: std_logic:= '0';
signal s_ctrl_ext_op: std_logic:= '0';
signal s_ctrl_alu_src: std_logic:= '0';
signal s_ctrl_branch: std_logic:= '0';
signal s_ctrl_jump: std_logic:= '0';
signal s_ctrl_alu_op: std_logic_vector(2 downto 0) := b"000";
signal s_ctrl_mem_write: std_logic:= '0';
signal s_ctrl_mem_to_reg:std_logic:= '0';
signal s_ctrl_reg_write: std_logic:= '0';

signal s_id_in_reg_write : std_logic                     := '0';
signal s_id_in_wd: std_logic_vector(15 downto 0) := x"0000";
signal s_id_out_ext_imm: std_logic_vector(15 downto 0) := x"0000";
signal s_id_out_func: std_logic_vector(2  downto 0) := b"000";
signal s_id_out_rd1: std_logic_vector(15 downto 0) := x"0000";
signal s_id_out_rd2: std_logic_vector(15 downto 0) := x"0000";
signal s_id_out_sa: std_logic                     := '0';

signal s_eu_out_alu_res : std_logic_vector(15 downto 0) := x"0000";
signal s_eu_out_bta: std_logic_vector(15 downto 0) := x"0000";
signal s_eu_out_zero: std_logic                     := '0';

signal s_mu_in_mem_write : std_logic := '0';
signal s_mu_out_mem_data : std_logic_vector(15 downto 0) := x"0000";
signal s_mu_out_alu_res: std_logic_vector(15 downto 0) := x"0000";

signal s_wb_out_wd : std_logic_vector(15 downto 0) := x"0000";


component instruction_fetch is
  Port( we,reset,clk,PC_src,jump:in std_logic;
        branch_ADDR, jump_ADDR:in std_logic_vector(15 downto 0);
        PC_OUT,Instr:out std_logic_vector(15 downto 0)
  );
end component;

component Decode is
    port(
    clk,RegWrite,RegDST,ExtOp:in std_logic;
    Instr, WriteData:in std_logic_vector(15 downto 0);
    RD1,RD2,EXTIm:out std_logic_vector(15 downto 0);
    sa:out std_logic;
    func:out std_logic_vector (2 downto 0)
    );
end component;

component Control_Unit is
  port (
    op_code : in std_logic_vector(2 downto 0);
    reg_dst:out std_logic;
    ext_op:out std_logic;
    alu_src:out std_logic;
    branch:out std_logic;
    jump:out std_logic;
    alu_op:out std_logic_vector(2 downto 0);
    mem_write:out std_logic;
    mem_to_reg:out std_logic;
    reg_write:out std_logic 
  );
end component;

component Execution_Unit is
    Port ( PCOut : in STD_LOGIC_VECTOR (15 downto 0);
           ReadD1 : in STD_LOGIC_VECTOR (15 downto 0);
           ReadD2 : in STD_LOGIC_VECTOR (15 downto 0);
           ExImm : in STD_LOGIC_VECTOR (15 downto 0);
           ALUSrc : in STD_LOGIC;
           ALUOp : in STD_LOGIC_VECTOR (2 downto 0);
           SA : in STD_LOGIC;
           Func : in STD_LOGIC_VECTOR (2 downto 0);
           ALURes : out STD_LOGIC_VECTOR (15 downto 0);
           BranchAdd : out STD_LOGIC_VECTOR (15 downto 0);
           Zero : out STD_LOGIC);
end component;

component mem is
    port (
      clk        : in std_logic;
      alu_res_in : in std_logic_vector(15 downto 0);
      rd2        : in std_logic_vector(15 downto 0);
      mem_write : in std_logic;
      mem_data    : out std_logic_vector(15 downto 0);
      alu_res_out : out std_logic_vector(15 downto 0)
    );
end component;

component SSD is
  Port (
    clk    : in  std_logic;
    digits : in  std_logic_vector(31 downto 0);
    an     : out std_logic_vector(3  downto 0);
    cat    : out std_logic_vector(6  downto 0)
  );
end component;

component mono_pulse_gener is
  port (
    clk    : in  std_logic;
    btn    : in  std_logic_vector(4  downto 0);
    enable : out std_logic_vector(4  downto 0)
  );
end component;



begin
mpg : mono_pulse_gener port map (clk => clk, btn => btn,enable => s_mpg_out);
ssdd : ssd port map (clk => clk, digits => s_digits, an => an, cat=> cat); 
fetch: instruction_fetch port map(
    we => s_mpg_out(0), 
    reset => s_mpg_out(1), 
    clk => clk, 
    PC_src => s_ctrl_branch, 
    jump => s_ctrl_jump, 
    branch_ADDR => s_eu_out_bta, 
    jump_ADDR => s_if_in_jump_address, 
    PC_OUT => s_if_out_pc_plus_one, 
    Instr => s_if_out_instruction
);
instr_decode_inst : Decode port map (
    clk => clk,
    RegWrite => s_id_in_reg_write,
    RegDST => s_ctrl_reg_dst,
    ExtOp => s_ctrl_ext_op,
    Instr => s_if_out_instruction,
    WriteData => s_id_in_wd,
    RD1 => s_id_out_rd1,
    RD2 => s_id_out_rd2,
    EXTIm => s_id_out_ext_imm,
    sa => s_id_out_sa,
    func => s_id_out_func
);
main_control_inst : Control_Unit port map (
    op_code => s_if_out_instruction(15 downto 13),
    reg_dst => s_ctrl_reg_dst,
    ext_op => s_ctrl_ext_op,
    alu_src => s_ctrl_alu_src,
    branch => s_ctrl_branch,
    jump => s_ctrl_jump,
    alu_op => s_ctrl_alu_op,
    mem_write => s_ctrl_mem_write,
    mem_to_reg => s_ctrl_mem_to_reg,
    reg_write => s_ctrl_reg_write
);
exec_unit_inst : Execution_Unit port map (
    PCOut => s_if_out_pc_plus_one,
    ReadD1 => s_id_out_rd1,
    ReadD2 => s_id_out_rd2,
    ExImm => s_id_out_ext_imm,
    ALUSrc => s_ctrl_alu_src,
    ALUOp => s_ctrl_alu_op,
    SA => s_id_out_sa,
    Func => s_id_out_func,
    ALURes => s_eu_out_alu_res,
    BranchAdd => s_eu_out_bta,
    Zero => s_eu_out_zero
);
mem_unit_inst : mem port map (
    clk        => clk,
    alu_res_in => s_eu_out_alu_res,    
    rd2        => s_id_out_rd2,    
    mem_write  => s_mu_in_mem_write,   
    mem_data   => s_mu_out_mem_data,  
    alu_res_out=> s_mu_out_alu_res   
); 

s_if_in_jump_address <= x"00" & s_if_out_instruction(7 downto 0);

s_id_in_reg_write <= s_ctrl_reg_write and s_mpg_out(0);
s_id_in_wd        <= s_wb_out_wd;

s_mu_in_mem_write <= s_ctrl_mem_write and s_mpg_out(0);

--write back
s_wb_out_wd <= s_mu_out_mem_data when s_ctrl_mem_to_reg = '1' else s_mu_out_alu_res;
  
process (sw(11 downto 9), s_if_out_pc_plus_one, s_if_out_instruction, s_id_out_rd1, s_id_out_rd2, s_id_in_wd)
  begin
    case sw(11 downto 9) is
      when "000"  => s_digits_upper <= s_if_out_instruction;
      when "001"  => s_digits_upper <= s_if_out_pc_plus_one;
      when "010"  => s_digits_upper <= s_id_out_rd1;
      when "011"  => s_digits_upper <= s_id_out_rd2;
      when "100"  => s_digits_upper <= s_id_out_ext_imm;
      when "101"  => s_digits_upper <= s_eu_out_alu_res;
      when "110"  => s_digits_upper <= s_mu_out_mem_data;
      when "111"  => s_digits_upper <= s_wb_out_wd;
    end case;
  end process;

  process (sw(6 downto 4), s_if_out_pc_plus_one, s_if_out_instruction, s_id_out_rd1, s_id_out_rd2, s_id_in_wd)
  begin
    case sw(6 downto 4) is
      when "000"  => s_digits_lower <= s_if_out_instruction;
      when "001"  => s_digits_lower <= s_if_out_pc_plus_one;
      when "010"  => s_digits_lower <= s_id_out_rd1;
      when "011"  => s_digits_lower <= s_id_out_rd2;
      when "100"  => s_digits_lower <= s_id_out_ext_imm;
      when "101"  => s_digits_lower <= s_eu_out_alu_res;
      when "110"  => s_digits_lower <= s_mu_out_mem_data;
      when "111"  => s_digits_lower <= s_wb_out_wd;
    end case;
end process;

  s_digits <= s_digits_upper & s_digits_lower;

end Behavioral;


