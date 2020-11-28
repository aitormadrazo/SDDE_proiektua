
library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity au_out_tb is

end au_out_tb;

architecture arch_au_out_tb of au_out_tb is


component AU_OUT is
port (
	clk, reset: in std_logic;
	LAGIN: in unsigned (15 downto 0);
	DACLRC: in std_logic;
	BCLK: in std_logic;
	DACDAT: out std_logic;
	PIZTU: in std_logic;
	READY: out std_logic
);
END component;

signal clk: std_logic:='0';
signal reset: std_logic;
signal LAGIN: unsigned (15 downto 0);
signal DACLRC: std_logic;
signal BCLK: std_logic:='0';
signal DACDAT: std_logic;
signal PIZTU: std_logic;
signal READY: std_logic;


begin
O1: AU_OUT port map (
     clk=> clk, reset=>reset, LAGIN=>LAGIN, DACLRC=>DACLRC, BCLK=>BCLK, DACDAT=>DACDAT, PIZTU=>PIZTU, READY=>READY 
);
clk<= not clk after 10 ns;
bclk<= not bclk after 160 ns;

process
begin
	reset<='1';
	piztu<='0';
	lagin<= to_unsigned (56,16);
	daclrc<='0';
	wait for 40 ns;
	reset<='0';
	piztu<='1';
	wait for 80 ns;
	daclrc<='1';
	wait for 61440 ns;
	daclrc<='0';
	wait for 61440 ns;
	
wait;

end process;

end arch_au_out_tb;

