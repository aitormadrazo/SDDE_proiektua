
library ieee;
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all; 
--use work.ramsinc.all;

---------------------Hasieraketak-----------------------

entity main is
port (
	clk, reset: in std_logic;
	datin_main: in unsigned (15 downto 0);
	piztu: in std_logic
);
END main;

architecture arch_main of main is

	type EGOERA is (e0,e1, e2, e3, e4, e5);
	signal UE,HE: EGOERA;
	signal LDKONT: std_logic;
	signal E: std_logic;
	signal UP: std_logic;
	signal TC: std_logic;
	signal kont: unsigned(15 downto 0);
	signal LD_AuOut: std_logic_vector(15 downto 0);
	signal DatOut: std_logic_vector(15 downto 0);
	signal LD_Dat: std_logic;
	

component ramsinc is
port (
	clk, reset_l: in std_logic;
	we, re: in std_logic;
	addr: in  std_logic_vector(15 downto 0);
	datin: in  std_logic_vector(15 downto 0);
	WriteDone: out  std_logic;
	ReadDone: out  std_logic;
	datout: out std_logic_vector(15 downto 0)
);
end component;

--signal clk: std_logic;
signal reset_l: std_logic;
signal re: std_logic;
signal we: std_logic;
signal addr: std_logic_vector(15 downto 0);
signal datin: std_logic_vector(15 downto 0);
signal WriteDone: std_logic;
signal ReadDone: std_logic;
--signal datout: std_logic_vector(15 downto 0);


component AU_OUT is
port (
	clk, reset: in std_logic;
	LAGIN: in unsigned (15 downto 0);
	DACLRC: in std_logic;
	BCLK: in std_logic;
	DACDAT: out std_logic;
	PIZTU_AUOUT: in std_logic;
	READY: out std_logic
);
END component;

--signal clk, reset: std_logic;
signal LAGIN: unsigned (15 downto 0);
signal DACLRC: std_logic;
signal BCLK: std_logic;
signal DACDAT: std_logic;
signal PIZTU_AUOUT: std_logic;
signal READY: std_logic;

begin

R1: ramsinc port map (
     clk=>clk, reset_l=>reset_l, we=>we, re=>re, addr=>addr, datin=>datin, WriteDone=>WriteDone, ReadDone=>ReadDone, datout=>datout
);

A1: AU_OUT port map (
     clk=>clk, reset=>reset, LAGIN=>LAGIN, DACLRC=>DACLRC, BCLK=>BCLK, DACDAT=>DACDAT, PIZTU_AUOUT=>PIZTU_AUOUT, READY=>READY
);


----------------Prozesu unitatea---------------------------

reset_l <= '1' when reset='0' else '0';

process (LDKONT, E, UP, clk) begin

	TC <= '0';
	
	if LDKONT = '1' then
            kont <= "0000000000000000";
        elsif (clk'event and clk='1') then
            if E= '1' and UP= '0' then
					if kont = "0000000000000000" then
						kont <= "1111111111111111";
					else
						kont <= kont-1;
					end if;
				elsif E= '1' and UP= '1' then
					
					if kont = "1111111111111111" then
						kont <= "0000000000000000";
					else
						kont <= kont+1;
					end if;
						
					
					
		END IF;		
        end if;
	if kont="1111111111111111" then
		TC <= '1';
	end if;
end process;


process(clk)
begin
	if (clk'event and clk='1') then
		LD_AuOut <= DatOut;
	end if;
end process;


----------------Kontrol unitatea---------------------------

process (UE, PIZTU, ReadDone, Ready, TC)
begin
	case UE is
		when E0 => if PIZTU='0' then HE<=E0;
			else HE<=E1;
			end if;
		when E1 => HE<=E2;
		when E2 => if ReadDone='0' then HE<=E2;
			else HE<=E3;
			end if;
		when E3 => if Ready='0' then HE<=E3;
			else HE<=E4;
			end if;
		when E4 => if TC='0' then HE<=E2;
			else HE<=E5;
			end if;
		when E5 => HE<=E0;
	end case;
end process;

process (clk, reset)
begin
	if reset='1' then UE<=E0;
	elsif (clk'event and clk='1') then UE<=HE;
	end if;
end process;

LDKONT <= '1' when (UE=E1) else '0';
RE <= '1' when (UE=E2) else '0';
Piztu_AuOut <= '1' when (UE=E3) else '0';
E <= '1' when (UE=E4) else '0';
UP <= '1' when (UE=E4) else '0';
LD_DAT <= '1' when (UE=E2 and ReadDone='1') else '0';

end arch_main;


