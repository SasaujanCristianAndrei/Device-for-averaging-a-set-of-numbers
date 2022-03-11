library IEEE;
use IEEE.STD_LOGIC_1164.all;
use STD_LOGIC_SIGNED.all;

entity wave is
	 port(
		 CLK : in STD_LOGIC;
		 reset : in BIT;
		 iesire : out STD_LOGIC_VECTOR(3 downto 0);
		 Q:out std_logic_vector(3 downto 0)
	     );
end wave;


architecture Arhitectura of wave is 
signal NEW_CLK:STD_LOGIC_VECTOR(3 downto 0):="0000";	
begin
process(reset,CLK) 
variable stare:STD_LOGIC_VECTOR(3 downto 0):="0000";
begin
	if(CLK'event and CLK='1') then
 		if reset = '1' then
		iesire <= "0000";
	    else 
		 stare := stare + "0001";
			if stare = "0100" then
				NEW_CLK<=NEW_CLK+1;
				stare := "0000";
			end if;
				iesire <= stare;
		end if;	
	 end if;					 
end process;
Q<=NEW_CLK;

end Arhitectura;
