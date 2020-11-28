
library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity main_tb is

end main_tb;

architecture arch_main_tb of main_tb is

component main is
port (
	clk, reset: in std_logic;
	datin_main: in unsigned (15 downto 0);
	piztu: in std_logic
);
END component;

	signal clk: std_logic:='0';
	signal reset: std_logic;
	signal datin_main: unsigned (15 downto 0);
	signal piztu: std_logic;

begin

M1: main port map (
     clk=>clk, reset=>reset, datin_main=>datin_main, PIZTU=>PIZTU
);

clk<= not clk after 10 ns;

process
begin
	reset<='1';
	piztu<='0';
	datin_main<= to_unsigned (56,16);
	wait for 40 ns;
	reset<='0';
	wait for 100 ns;
	piztu<='1';
	wait for 80 ns;
	
wait;

end process;

end arch_main_tb;
