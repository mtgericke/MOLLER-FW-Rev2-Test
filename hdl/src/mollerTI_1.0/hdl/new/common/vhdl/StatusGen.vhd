----------------------------------------------------------------------------------
-- Company:   Thomas Jefferson National Accelerator Facility
-- Engineer:   GU
-- 
-- Create Date:    14:57:42 11/25/2013 
-- Design Name: 
-- Module Name:    StatusGen - Behavioral 
-- Project Name:   12 GeV upgrade
-- Target Devices:  Xilinx Virtex-5
-- Tool versions: 
-- Description:   16-bit status word generation.  This status word is transmitted
--      in the second fiber of the Trigger link from TI to TImaster, TD, or TS.
--      This word includes BUSY, Trigger acknowledge (trigger 1 and trigger 2), 
--      SyncReset Request, Block received acknowledge and Block readout acknowledge.
--      These are using dedicated bits and can be sent simultanously, and have 
--      higher priority.
--          In addition to these, the status word also includes some static status:
--      BoardID, Block Level, Trigger enable etc.  The TI_master or TD can check
--      these status to confirm the connected TI.  (system consistent check).  These
--      status have lower priority.  For example, if the TI is always BUSY, these
--      static status will not be sent.
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

entity StatusGen is
    Port (   TrgEnDis : in  STD_LOGIC;
           ForceTrgSrcSet : in std_logic;
        StatusIn : in  STD_LOGIC_VECTOR (15 downto 0);
        StatusOut : inout  STD_LOGIC_VECTOR (15 downto 0);
        GtpTxEn : out  STD_LOGIC;
        Clk  : in std_logic;
        SRstReq : in  STD_LOGIC;
        SendID  : in std_logic;
        BlkSizeUD : in std_logic;
        NewBlkSize : in std_logic_vector (31 downto 0);
        BufSizeUD : in std_logic;
        CrateID : in  STD_LOGIC_VECTOR (7 downto 0);
        TrgSrc : in  STD_LOGIC_VECTOR (15 downto 0);
        TestPt  : out  std_logic_vector (4 downto 1));
end StatusGen;

architecture Behavioral of StatusGen is

  signal TrgAcks : std_logic;
  signal BusyRst  : std_logic;
  signal TrgInfo  : std_logic;
  signal DelayGtp : std_logic;
  signal SyncBusy : std_logic;
  
begin
-- StatusIn(7): ROCack; statusIn(8): BlkReceived; StatusIn(9): Trg2Ack; StatusIn(10): Trg1Ack;
-- 
  TrgAcks <= StatusIn(7) or StatusIn(8) or StatusIn(9) or StatusIn(10);
  BusyRst <= SRstReq or SyncBusy; -- use the Synced busy, not StatusIn(11);
  process (Clk)
  begin
    if (Clk'event and Clk = '1') then

-- Sync the Status(11) and SendID to Clk625
      SyncBusy <= StatusIn(11);
      
--        DelayGtp <= GtpTxEn;
      if (ForceTrgSrcSet = '1') then  -- ForceTrgSrcSet should stay for at least three clock cycles.
          StatusOut(13 downto 12) <= "10";
          StatusOut(11 downto 9) <= "010";
          StatusOut(8) <= '1'; --TrgSrc(10) or TrgSrc(7) or TrgSrc(6) or TrgSrc(5) or 
                       -- TrgSrc(4) or TrgSrc(3) or TrgSrc(2) or TrgSrc(1);  -- Board Active
          StatusOut(7 downto 0) <= TrgSrc(7 downto 0);
          GtpTxEn <= '1';
      elsif (TrgAcks = '1' or BusyRst = '1') then
        StatusOut(13 downto 12) <= "01";
        StatusOut(11) <= SyncBusy; -- StatusIn(11);
        StatusOut(10) <= TrgAcks;
        StatusOut(9) <= SRstReq;
        StatusOut(8) <= not SRstReq;
        StatusOut(7) <= SyncBusy;
        StatusOut(6 downto 0) <= StatusIn(10 downto 4);
        GtpTxEn <= '1';
      elsif (SendID = '1') then
        StatusOut(13 downto 12) <= "10";
        StatusOut(11 downto 8) <= "0010";
        StatusOut(7 downto 0) <= CrateID;
        GtpTxEn <= '1';
      elsif (TrgEnDis = '1') then
        StatusOut(13 downto 12) <= "10";
        StatusOut(11 downto 9) <= "010";
        StatusOut(8) <= TrgSrc(10) or TrgSrc(7) or TrgSrc(6) or TrgSrc(5) or 
                        TrgSrc(4) or TrgSrc(3) or TrgSrc(2) or TrgSrc(1);  -- Board Active
        StatusOut(7 downto 0) <= TrgSrc(7 downto 0);
        GtpTxEn <= '1';
      elsif (BlkSizeUD = '1') then
        StatusOut(13 downto 12) <= "10";
        StatusOut(11 downto 8) <= "0110";
        StatusOut(7 downto 0) <= NewBlkSize(15 downto 8);
        GtpTxEn <= '1';
      elsif (BufSizeUD = '1') then
        StatusOut(13 downto 12) <= "10";
        StatusOut(11 downto 8) <= "0111";
        StatusOut(7 downto 0) <= NewBlkSize(31 downto 24);
        GtpTxEn <= '1';
      else
        GtpTxEn <= '0';
        StatusOut(13 downto 0) <= "00000000000000";
      end if;
    end if;
  end process;

  TestPt(1) <= TrgAcks;
  TestPt(2) <= BusyRst;
  TestPt(3) <= TrgEnDis;
  TestPt(4) <= BlkSizeUD;

  StatusOut(15) <= StatusOut(13) xor StatusOut(12) xor StatusOut(11) 
          xor StatusOut(9) xor StatusOut(8) xor StatusOut(7) xor StatusOut(6) 
          xor StatusOut(5) xor StatusOut(4) xor StatusOut(3) xor StatusOut(2)
          xor StatusOut(1) xor StatusOut(0) xor StatusOut(10); 

  StatusOut(14) <= StatusOut(15);
end Behavioral;

