library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;  
use ieee.std_logic_unsigned.all;  

entity medie_4_nr is
    generic ( LUNGIME : integer :=  8 ); 
	port (CMD1,CMD2,CMD3 : in std_logic;
	 CLK : inout std_logic;  
	 NR1,NR2,NR3,NR4,NR5,NR6:in std_logic_vector(7 downto 0); ---folosit ptr 6 digit sequence trb sa dam cu binary counter neap?
	 MED:out std_logic_vector(7 downto 0);
	 MED_6_NR:out std_logic_vector(6 downto 0);
	 iesire : out STD_LOGIC_VECTOR(3 downto 0)----folosit la square wavef
	 );  
		
end medie_4_nr;

architecture secventa_medie of medie_4_nr is	
----- sumator_numere  8 biti--------
component sumator_numere_8_biti is 
	port(
		  SUMA1,SUMA2: in std_logic_vector(7 downto 0);
    	  SUM : out std_logic_vector(8 downto 0)
		  );
end component;
----- sumator_numere 9 biti--------
component sumator_numere_9_biti is
  port(
  		 SUMA1,SUMA2 : in std_logic_vector(8 downto 0);
   		 SUM : out std_logic_vector(9 downto 0)
   		);
end component;

component sumator_numere_nou_biti is
  port(
 		 SUMA1: in std_logic_vector(9 downto 0);	
  		 SUMA2 : in std_logic_vector(9 downto 0);
   		 SUM : out std_logic_vector(9 downto 0));
end component;
-----square wave-------------

signal REGISTRU1, REGISTRU2, REGISTRU3, REGISTRU4, REGISTRU5, REGISTRU6, REGISTRU7, REGISTRU8 : std_logic_vector(7 downto 0); 
signal SUM1,SUM2,SUM3,SUM4: std_logic_vector(8 downto 0);	
signal SUM5,SUM6,SUM7: std_logic_vector(9 downto 0);
signal MEDIE1,MEDIE2:std_logic_vector(3 downto 0); 	
signal NEW_CLK:STD_LOGIC;
begin
	
STEP1:process(CLK)---facem suma a 4 a numere, suma primelor 2 o tinem in SUM1, suma ultimelor in SUM2, la final FACEM SUM3=SUM1+SUM2	

variable nr_generat_copie : std_logic_vector (LUNGIME-1 downto 0):=(others=>'1');-- ptr cazul de 255
variable nr_generat_copie_15 : std_logic_vector (LUNGIME-4 downto 0):=(others=>'1');--ptr cazul de 15
variable XOR_bistabil: std_logic := '0';
variable mare,mic:integer:=0; 
variable stare:STD_LOGIC_VECTOR(3 downto 0):="0000";
  begin  								
  if(CLK'event) then
	  
	  if (CMD1='0'and CMD2='0'and CMD3='0') then
		  		REGISTRU1 <= "00000000";
 				REGISTRU2 <= "00000000";
 				REGISTRU3 <= "00000000";													
 				REGISTRU4 <= "00000000";
				REGISTRU5 <= "00000000";													
 				REGISTRU6 <= "00000000";
				REGISTRU7 <= "00000000";													
 				REGISTRU8 <= "00000000";
				 
	  end if;
	  
	    if (CMD1 ='0'and CMD2='1'and CMD3='0') then
		  		REGISTRU1 <= NR1;	
 				REGISTRU2 <= NR2;
 				REGISTRU3 <= NR3;													
 				REGISTRU4 <= NR4;
				REGISTRU5 <= NR5;
				REGISTRU6 <= NR6;
				REGISTRU7 <= NR1;													
 				REGISTRU8 <= NR2;
	  end if;---CAZUL (OFF ON OFF) STUDENTUL 1 PRIMESTE O SECV DE NR PE 6 BITI  
	  
	  if (CMD1='0'and CMD2='1'and CMD3='1') then
		  		REGISTRU1 <= NR1;
 				REGISTRU2 <= NR2;
 				REGISTRU3 <= NR3;													
 				REGISTRU4 <= NR4;
				REGISTRU5 <= NR5;
				REGISTRU6 <= NR6;
				REGISTRU7 <= NR1;													
 				REGISTRU8 <= NR2;
	  end if;---CAZUL (OFF ON ON) STUDENTUL 2 PRIMESTE O SECV DE NR PE 6 BITI 
	  
	  if (CMD1='0'and CMD2='0'and CMD3='1') then 
		  if(CLK'event and CLK='1') then
		 	stare := stare + "0001";
			if (stare = "0100") then
				NEW_CLK<='1';
				stare := "0000";
			else
				NEW_CLK<='0';
			end if;
				iesire <= stare;
		end if;
		end if;
	  
	  if (CMD1='1'and CMD2='1'and CMD3='1') then
	  if mare<255 then
		 XOR_bistabil :=nr_generat_copie(LUNGIME-1) xor nr_generat_copie(LUNGIME-2);
         nr_generat_copie(LUNGIME-1 downto 1) := nr_generat_copie(LUNGIME-2 downto 0);
         nr_generat_copie(0) := XOR_bistabil;
		 REGISTRU1 <= nr_generat_copie;
		 REGISTRU2 <= REGISTRU1;
		 REGISTRU3 <= REGISTRU2;													
		 REGISTRU4 <= REGISTRU3;	
		 mare:=mare+1;
	  end if; 
	end if;
	
	 if (CMD1='1'and CMD2='1'and CMD3='0') then
       if mic<15 then
		 XOR_bistabil := nr_generat_copie(LUNGIME-5) xor nr_generat_copie(LUNGIME-6);
         nr_generat_copie(LUNGIME-5 downto 1) := nr_generat_copie(LUNGIME-6 downto 0);
         nr_generat_copie(0) := XOR_bistabil;		
		 nr_generat_copie(LUNGIME-1 downto LUNGIME-4) := (others=>'0');
		 REGISTRU1 <= nr_generat_copie;
		 REGISTRU2 <= REGISTRU1;
		 REGISTRU3 <= REGISTRU2;													
		 REGISTRU4 <= REGISTRU3;	
		 mic:=mic+1;
	  end if;
	end if;
end if;
	
end process STEP1;
 
PAS1:sumator_numere_8_biti port map(REGISTRU1,REGISTRU2,SUM1);
PAS2:sumator_numere_8_biti port map(REGISTRU3,REGISTRU4,SUM2);
PAS3:sumator_numere_8_biti port map(REGISTRU5,REGISTRU6,SUM3); 
PAS4:sumator_numere_8_biti port map(REGISTRU7,REGISTRU8,SUM4);
PAS5:sumator_numere_9_biti port map(SUM1,SUM2,SUM5);  
PAS6:sumator_numere_9_biti port map(SUM3,SUM4,SUM6);
PAS7:sumator_numere_nou_biti port map(SUM5,SUM6,SUM7);


STEP2:process(SUM7)---in sum3 avem suma celor 4 numere,pentru a calcula media a 4 numere trebuie sa impartim cu 4
begin
	if (CMD1 ='0'and CMD2='1'and CMD3='0')then
		MED_6_NR<=SUM7(9 downto 3);
  elsif (CMD1='0'and CMD2='1'and CMD3='1') then
	  MED_6_NR<=SUM7(9 downto 3); 
  else	  
  MED<=SUM7(9 downto 2);   
  MEDIE1(3 downto 0)<=SUM5(9 downto 6);
  MEDIE2(3 downto 0)<=SUM5(5 downto 2); 
  end if;
  end process STEP2;

  
---EXEMPLU DACA AVEM IN SUM3 0001001111 =79 => 79/4=19.75
---MED<=00010011=19
end secventa_medie;