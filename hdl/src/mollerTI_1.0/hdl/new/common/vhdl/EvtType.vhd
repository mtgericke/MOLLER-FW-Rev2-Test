----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    08:28:08 02/07/2013 
-- Design Name: 
-- Module Name:    EvtType - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
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
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity EvtType is
    Port ( TrgCode : in  STD_LOGIC_VECTOR (15 downto 0);
           LBCode : in  STD_LOGIC_VECTOR (15 downto 0);
        SubCode  : in std_logic_vector (15 downto 0);
        TrgSrcEn  : in std_logic_vector (15 downto 0);
           ClkUsr : in  STD_LOGIC;
        SelTS  : in std_logic;
        SelSub  : in std_logic;
           SelLB : in  STD_LOGIC;
        SubTS : in std_logic;
        AddTrgType : out std_logic_vector(16 downto 0);
           EvtTypeOut : out  STD_LOGIC_VECTOR (7 downto 0));
end EvtType;

architecture Behavioral of EvtType is
  
  signal DlySelLB : std_logic;
  signal DlySelTS : std_logic;
  signal DlySelSub : std_logic;

begin
  process (ClkUsr)
  begin
    if (ClkUsr'event and ClkUsr = '1') then
      if (SelLB = '1' and TrgSrcEn(2) = '1') then
        EvtTypeOut <= LBCode(7 downto 0);
      elsif (SelTS = '1' and TrgSrcEn(1) = '1') then
        EvtTypeOut <= TrgCode (7 downto 0);
      elsif (SubTS = '1') then
        EvtTypeOut(7 downto 6) <= "10"; -- TrgSrcEn(10);
        EvtTypeOut(5 downto 2) <= TrgSrcEn(15 downto 12);
        EvtTypeOut(1 downto 0) <= TrgCode(1 downto 0);
      elsif (SelSub = '1' and TrgSrcEn(10) = '1') then
        EvtTypeOut <= SubCode(7 downto 0);
      end if;

       DlySelLB <= SelLB;
      DlySelTS <= SelTS;
      DlySelSub <= SelSub;
      if (DlySelLB = '1' and TrgSrcEn(2) = '1') then
        AddTrgType(15 downto 0) <= LBCode(15 downto 0);
         AddTrgType(16) <= (LBCode(11) and TrgSrcEn(15)) or (LBCode(10) and TrgSrcEn(14))
                       or (LBCode(9) and TrgSrcEn(13)) or (LBCode(8) and TrgSrcEn(12));
      elsif (DlySelTS = '1' and TrgSrcEn(1) = '1') then
        AddTrgType(15 downto 0) <= TrgCode (15 downto 0);
         AddTrgType(16) <= (TrgCode(11) and TrgSrcEn(15)) or (TrgCode(10) and TrgSrcEn(14))
                       or (TrgCode(9) and TrgSrcEn(13)) or (TrgCode(8) and TrgSrcEn(12));
      elsif (DlySelSub = '1' and TrgSrcEn(10) = '1') then
        AddTrgType(15 downto 0) <= SubCode(15 downto 0);
         AddTrgType(16) <= (SubCode(11) and TrgSrcEn(15)) or (SubCode(10) and TrgSrcEn(14))
                       or (SubCode(9) and TrgSrcEn(13)) or (SubCode(8) and TrgSrcEn(12));
      else
         AddTrgType(16) <= '0';
      end if;
      
    end if;
  end process;
end Behavioral;

