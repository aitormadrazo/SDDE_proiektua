
---------------HASIERAKETAK---------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity AU_OUT is
port (
	clk, reset: in std_logic;
	LAGIN: in unsigned (15 downto 0);
	DACLRC: in std_logic;
	BCLK: in std_logic;
	DACDAT: out std_logic;
	PIZTU_AUOUT: in std_logic;
	READY: out std_logic
);
END AU_OUT;

architecture a of AU_OUT is
	type EGOERA is (e0,e1, e2, e3, e4, e5, e6, e7, e8);
	signal UE,HE: EGOERA;
	signal LDLAGIN, DESPEZK, LDKONT, DEKKONT, AUKBIT: std_logic;
	signal BCLKSINK, CHEZK, CHESK: std_logic;
	signal DACLRCS1, DACLRCS0: std_logic;
	signal UP: std_logic;
	signal Q: std_logic;
	signal O: unsigned(15 downto 0);
	signal kont: unsigned(3 downto 0);
	signal D: unsigned(3 downto 0);
	signal SR: std_logic;
	signal BUKKONT: std_logic;
begin

	



----------------Prozesu unitatea---------------------------

process(clk)
begin
	if (clk'event and clk='1') then
		DACLRCS1 <= DACLRC;
	end if;
end process;

process(clk)
begin
	if (clk'event and clk='1') then
		DACLRCS0 <= DACLRCS1;
	end if;
end process;

process(clk)
begin
	if (clk'event and clk='1') then
		BCLKSINK <= BCLK;
	end if;
end process;

DACDAT <= Q when AUKBIT='1' else '0';

CHEZK <= '1'  when (DACLRCS1='1' and DACLRCS0='0') else '0';
CHESK <= '1'  when (DACLRCS1='0' and DACLRCS0='1') else '0';

process (D, LDKONT, DEKKONT, UP, clk) begin
	
	if LDKONT = '1' then
            kont <= "1111";
        elsif (clk'event and clk='1') then
            if DEKKONT= '1' and UP= '0' then
					if kont = "0000" then
						kont <= "1111";
					else
						kont <= kont-1;
					end if;
				elsif DEKKONT= '1' and UP= '1' then
					
					if kont = "1111" then
						kont <= "0000";
					else
						kont <= kont+1;
					end if;
						
					
					
		END IF;		
        end if;
	if kont="0000" then
		BUKKONT <= '1';
	end if;
end process;
 



process (LAGIN, LDLAGIN, DESPEZK, SR,clk) begin
	if (clk'event and clk='1') then
		if LDLAGIN = '1' then
			O <= LAGIN;
		end if;
		if DESPEZK = '1' then 
			O <= O(14 DOWNTO 0) & SR;
			
		end if;
	end if;
	
    end process;
Q <= O(15);
---------------Kontrol unitatea----------------------------

process (UE, PIZTU_AUOUT, BCLKSINK, CHEZK, BUKKONT, DACLRCS1, CHESK)
begin
	case UE is
		when E0 => if PIZTU_AUOUT='0' then HE<=E0;
			else HE<=E1;
			end if;
		when E1 => HE<=E2;
		when E2 => if CHEZK='0' then HE<=E2;
			else HE<=E3;
			end if;
		when E3 => if BCLKSINK='1' then HE<=E3;
			else HE<=E4;
			end if;
		when E4 => if BCLKSINK='1' then HE<=E5;
			else HE<=E4;
			end if;
		when E5 => if BCLKSINK='1' then HE<=E5;
			elsif (BUKKONT='0') then HE<=E4;
			else HE<=E6;
			end if;
		when E6 => if DACLRCS1='1' then HE<=E7;
			else HE<=E8;
			end if;
		when E7 => if CHESK='0' then HE<=E7;
			else HE<=E3;
			end if;
		when E8 => HE<=E0;
	end case;
end process;

process (clk, reset)
begin
	if reset='1' then UE<=E0;
	elsif (clk'event and clk='1') then UE<=HE;
	end if;
end process;

LDLAGIN <= '1' when (UE=E1) else '0';
LDKONT <= '1' when (UE=E1) else '0';
AUKBIT <= '1' when (UE=E4 or UE=E5) else '0';
DESPEZK <= '1' when (UE=E5 and BCLKSINK='0') else '0';
DEKKONT <= '1' when (UE=E5 and BCLKSINK='0') else '0';
READY <= '1' when (UE=E8) else '0';

end a;

