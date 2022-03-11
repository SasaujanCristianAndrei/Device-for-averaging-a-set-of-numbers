library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity sumator_numere_nou_biti is
  port(
 		 SUMA1: in std_logic_vector(9 downto 0);	
  		 SUMA2 : in std_logic_vector(9 downto 0);
   		 SUM : out std_logic_vector(9 downto 0));
end sumator_numere_nou_biti;		

architecture sumator_nou of sumator_numere_nou_biti is
signal SUMA_SALVATA: std_logic_vector(9 downto 0);		 
  begin
    SUMA_SALVATA <= conv_std_logic_vector((conv_integer(SUMA1) + conv_integer(SUMA2)),10);
    SUM <= SUMA_SALVATA(9 downto 0);
end sumator_nou;