----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/04/2020 01:50:19 PM
-- Design Name: 
-- Module Name: TrigWordDecode - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity TrigWordDecode is
  Port (TrigCode : in std_logic_vector(15 downto 0);
    TrigCodeEn   : in std_logic;
    SubTsEn      : in std_logic_vector(4 downto 1);
    Trigger1     : out std_logic;
    Trigger2     : out std_logic;
    TrigSync     : out std_logic;
    SubTsTrig    : out std_logic  );
end TrigWordDecode;

architecture Behavioral of TrigWordDecode is

  signal TrigValid : std_logic;
  
begin

  TrigValid <= TrigCodeEn and (TrigCode(15) xor TrigCode(14)) and (TrigCode(13) xor TrigCode(12));
  Trigger1 <= TrigValid and TrigCode(8);  -- TrigSync (code 11) will also set Trigger1 true
  Trigger2 <= TrigValid and TrigCode(9) and (not TrigCode(8));
  TrigSync <= TrigValid and TrigCode(9) and TrigCode(8);
  SubTsTrig <= (TrigCode(15) and (not TrigCode(14)) and TrigCode(13) and TrigCode(12)) and --SubTS Valid
              (((TrigCode(11) or TrigCode(10) or TrigCode(9)) and SubTsEn(4)) or  -- SubTS#4
               ((TrigCode(8)  or TrigCode(7)  or TrigCode(6)) and SubTsEn(3)) or  -- SubTS#3
               ((TrigCode(5)  or TrigCode(4)  or TrigCode(3)) and SubTsEn(2)) or  -- SubTS#2
               ((TrigCode(2)  or TrigCode(1)  or TrigCode(0)) and SubTsEn(1)) );  -- SubTS#1
end Behavioral;
