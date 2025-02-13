library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;

entity ssd is
  Port (
    clk :in  std_logic;
    digits : in  std_logic_vector(31 downto 0);
    an:out std_logic_vector(3  downto 0); -- Change to 4 bits
    cat: out std_logic_vector(6  downto 0)
  );
end ssd;

architecture Behavioral of ssd is

  signal s_counter_out : std_logic_vector(15 downto 0) := x"0000";
  signal s_top_mux : std_logic_vector(3  downto 0) := x"0";

begin

  process(clk) 
  begin
    if rising_edge(clk) then
      s_counter_out <= s_counter_out + 1;
    end if;
  end process;
  
  process (s_counter_out(15 downto 13),digits)
  begin
     case s_counter_out(15 downto 13) is
       when "000"  => s_top_mux <= digits(3  downto 0);
       when "001"  => s_top_mux <= digits(7  downto 4);
       when "010"  => s_top_mux <= digits(11 downto 8);
       when "011"  => s_top_mux <= digits(15 downto 12);
       when "100"  => s_top_mux <= digits(19 downto 16);
       when "101"  => s_top_mux <= digits(23 downto 20);
       when "110"  => s_top_mux <= digits(27 downto 24);
       when others => s_top_mux <= digits(31 downto 28);
     end case;
  end process;
  
  process (s_counter_out(15 downto 13))
  begin
    case s_counter_out(15 downto 13) is
      when "000"  => an <= b"1110"; 
      when "001"  => an <= b"1101"; 
      when "010"  => an <= b"1011"; 
      when "011"  => an <= b"0111"; 
      when others => an <= b"1111";
    end case;
  end process;
  
  with s_top_mux select
    cat <= "1111001" when "0001",   --1
           "0100100" when "0010",   --2
           "0110000" when "0011",   --3
           "0011001" when "0100",   --4
           "0010010" when "0101",   --5
           "0000010" when "0110",   --6
           "1111000" when "0111",   --7
           "0000000" when "1000",   --8
           "0010000" when "1001",   --9
           "0001000" when "1010",   --A
           "0000011" when "1011",   --b
           "1000110" when "1100",   --C
           "0100001" when "1101",   --d
           "0000110" when "1110",   --E
           "0001110" when "1111",   --F
           "1000000" when others;   --0

end Behavioral;