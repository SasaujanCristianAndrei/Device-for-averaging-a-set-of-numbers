library ieee; 
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;


entity sumator_numere_8_biti is
  port(
    SUMA1,SUMA2: in std_logic_vector(7 downto 0);
    SUM : out std_logic_vector(8 downto 0));
end sumator_numere_8_biti;		

architecture sumator of sumator_numere_8_biti is
signal SUMA_SALVATA: std_logic_vector(8 downto 0);		 
begin																			 
	
    SUMA_SALVATA <= conv_std_logic_vector((conv_integer(SUMA1) + conv_integer(SUMA2)),9);
    SUM <= SUMA_SALVATA;
end sumator; 