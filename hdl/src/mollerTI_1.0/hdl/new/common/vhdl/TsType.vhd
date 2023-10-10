----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    09:34:29 03/23/2011 
-- Design Name: 
-- Module Name:    TsType - Behavioral 
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity TsType is
  Port ( TsBit : in  STD_LOGIC_VECTOR (8 downto 1);
    TrgSrc : in  STD_LOGIC_VECTOR (8 downto 0);  -- TrgSrc(0)=FPTrg; TrgSrc(1)=GTP; TrgSrc(2)=VmeTrg; TrgSrc(3)=RandomTrg
    Clk625 : in  STD_LOGIC;
    Clk250 : in std_logic;
    MHEvtType : in std_logic_vector(31 downto 0);
    Busy: in std_logic;
    Type0Out : out std_logic;
    FPtriggered : out std_logic;     -- basically the OR of TrgSrc(0) and TrgSrc(1), for TrgRule  input
    Tsxbit : out  STD_LOGIC_VECTOR (9 downto 0));
end TsType;

architecture Behavioral of TsType is

signal TsData : STD_LOGIC_VECTOR(9 downto 0);
signal TsbitOut : std_logic_vector(8 downto 1);
signal TsbitPreRst : std_logic;
signal TsbitRst : std_logic;
signal TsTrgOK : std_logic;
signal FPTrgOK : std_logic;
signal FPSlowOK : std_logic;
signal TsSlowOK : std_logic;
signal Dlybusy : std_logic;
signal Type0Chk : std_logic;
signal Type0Err : std_logic;
signal Type0Slow : std_logic;
signal TsbitSlow : std_logic_vector(8 downto 1);

begin
   process (Clk250, Tsbit, FPslowOK, TsSlowOK, TrgSrc(4))
  begin
    if (Clk250'event and Clk250 ='1') then
    
      TsbitRst <= FPslowOK or TsSlowOK or DlyBusy; -- TsbitPreRst;  -- sync the TsbitRst to the Clk250;
                                                  -- Added the DlyBusy on Nov. 14, 2017

-- remove the TsBitOut reset logic.  Oct. 25, 2017     
--      if (TsbitRst = '1') then
--       TsbitOut <= "00000000";
--     elsif (TrgSrc(4) = '1') then
     if (TrgSrc(4) = '1' and TsTrgOK = '0') then  -- use TsTrgOK to mask off the TsBitOut update
       TsbitOut <= Tsbit;
      Type0Err <= not (TsBit(1) or TsBit(2) or TsBit(3) or TsBit(4) or TsBit(5) or TsBit(6));
         Type0Chk <= not (TsBitOut(1) or TsBitOut(2) or TsBitOut(3) or TsBitOut(4) or TsBitOut(5) or TsBitOut(6)); 
     end if;
     
     if (TsbitRst = '1') then
       TsTrgOK <= '0';
      FPTrgOk <= '0';
      Type0Err <= '0';
     elsif (TrgSrc(1) = '1') then
       TsTrgOK <= TrgSrc(1); -- '1';
     elsif (TrgSrc(0) = '1') then
       FPTrgOk <= TrgSrc(0); -- '1';
     end if;
    end if;
   end process;
  
  process (Clk625) 
  begin
    if (Clk625'event and Clk625 = '1') then
      if (FPSlowOK = '1' or TsSlowOK = '1' or Busy = '1' or DlyBusy = '1') then
       FPSlowOK <= '0';   -- make sure that they last for only one Clk625 cycles
      TsSlowOK <= '0';
      elsif (FPTrgOK ='1') then
       FPSlowOK <= FPTrgOK; -- '1';  -- FPSlowOk is synced with Clk625, 
     elsif (TsTrgOK = '1') then
       TsSlowOK <= TsTrgOK; -- '1';  -- TsSlowOK is synced with Clk625,
      TsbitSlow <= TsbitOut;
         Type0Slow <= not (TsbitSlow(1) or TsbitSlow(2) or TsbitSlow(3) or TsbitSlow(4) or TsbitSlow(5) or TsbitSlow(6));
     end if;
     DlyBusy <= Busy;
    end if;
  end process;
  
  Type0Out <= Type0Err or Type0Chk or Type0Slow;

  process (Clk625, TsBitOut, TsTrgOK, FPTrgOK, TrgSrc, Busy)
  begin
     if (Clk625'event and Clk625 = '1') then
     if (DlyBusy = '1') then  -- use DlyBusy, which is one Clk625 delayed Busy, Mar. 21, 2016
       TsData <= "0000000000";
       TsBitPreRst <= '1'; -- Added this line on Mar. 21, 2016 to reset the Busy blocked triggers
     elsif(FPSlowOK = '1') then
        TsData <= "0101000001";  -- TrgIn  (event type 1)
       TsbitPreRst <= '1';
     elsif (TsSlowOK = '1') then
       TsData(9 downto 8) <= TsBitSlow(8 downto 7); -- Out(8 downto 7);
       TsData(7 downto 6) <= Type0Err & Type0Chk; -- "00";  -- TSbit#1-6 (event type 0)
       TsData(5 downto 0) <= TsbitSlow(6 downto 1); -- TsBitOut(6 downto 1);
       TsbitPreRst <= '1';
     elsif (TrgSrc(2) = '1') then
       TsData <= "01" & MHEvtType(23 downto 16); -- "0111111101";  -- VME trigger  type 253, was type 2)
     elsif (TrgSrc(3) = '1') then
        TsData <= "01" & MHEvtType(31 downto 24); -- "0111111110";  -- Random trigger type 254, was type 3)
     elsif (TrgSrc(8) = '1') then
       TsData <= "01" & "10101001";  -- Trigger By Trigger2 
     elsif (TrgSrc(5) = '1') then
       TsData <= "10" & MHEvtType(23 downto 16); -- 11111101";  -- Trigger2, VME 
     elsif (TrgSrc(6) = '1') then
       TsData <= "10" & MHEvtType(31 downto 24); -- 11111110";  -- Trigger2, random
     elsif (TrgSrc(7) = '1') then
       TsData <= "0100000000";  -- trigger to fill the event block at the end_of_run(event type 0)
--     else
--        TsData <= "0000000000";  disable this line on Oct. 25, 2017
     end if;
     if (TsbitPreRst = '1') then
       TsbitPreRst <= '0';
     end if;
     
    end if;
  end process;
  
-- rename the TsData
  Tsxbit <= TsData;
  FPtriggered <= FPSlowOK or TsSlowOK;    -- The FPtriggered is one clock earlier than Tsxbit !
  
end Behavioral;

