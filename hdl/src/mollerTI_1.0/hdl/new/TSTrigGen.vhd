----------------------------------------------------------------------------------
-- Company:  Thomas Jefferson National Accelerator Facility
-- Engineer: GU
-- 
-- Create Date: 03/09/2020 03:40:02 PM
-- Design Name:  Trigger Interface
-- Module Name: TSTrigGen - Behavioral
-- Project Name:    TIFPGA
-- Target Devices:  XCKU3P-1FFA676
-- Tool Versions:   Vivado 2019.1
-- Description:  Trigger generation as in TS or TI in master mode
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
use ieee.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
library UNISIM;
use UNISIM.VComponents.all;

entity TSTrigGen is
  port ( BlkEnd          : in    std_logic; 
    BlockSize       : in    std_logic_vector (7 downto 0); 
    Busy            : in    std_logic; 
    ChannelDelay    : in    std_logic_vector (63 downto 0); 
    ClKSelTrgRule   : in    std_logic; 
 --   ClkSlow         : in    std_logic; 
    ClkVme          : in    std_logic; 
    Clk250          : in    std_logic; 
    Clk625          : in    std_logic; 
    EndOfRun        : in    std_logic; 
    EndOfRunBlk     : in    std_logic_vector (31 downto 0); 
    FiberTrged      : in    std_logic; 
    ForceSyncEvt    : in    std_logic; 
    FPTrgIn         : in    std_logic; 
    MasterMode      : in    std_logic; 
    MinRuleWidth    : in    std_logic_vector (31 downto 0); 
    PeriodA         : in    std_logic_vector (31 downto 0); 
    PSFactor        : in    std_logic_vector (15 downto 0); 
    P2TrgIn         : in    std_logic; 
    Reset           : in    std_logic; 
    RTrgRate        : in    std_logic_vector (15 downto 0); 
    ScalarEnableSet : in    std_logic_vector (2 downto 1); 
    ScalarLatch     : in    std_logic; 
    ScalarReset     : in    std_logic; 
    SReqSet         : in    std_logic; 
    SyncEvtGen      : in    std_logic_vector (31 downto 0); 
    TrgSrcEn        : in    std_logic_vector (15 downto 0); 
    TrgTblAdr       : in    std_logic_vector (3 downto 0); 
    TrgTblData      : in    std_logic_vector (31 downto 0); 
    TrgTblWE        : in    std_logic; 
    TrgWidth        : in    std_logic_vector (7 downto 0); 
    TSEn            : in    std_logic_vector (6 downto 1); 
    TsIn            : in    std_logic_vector (6 downto 1); 
    TsMatch         : in    std_logic_vector (31 downto 0); 
    TsPreScale      : in    std_logic_vector (24 downto 1); 
    TsVmeCmd        : in    std_logic_vector (11 downto 0); 
    TsVmeEn         : in    std_logic; 
    VmeEvtType      : in    std_logic_vector (31 downto 0); 
    VmeTrg1Load     : in    std_logic; 
    VmeTrg1Set      : in    std_logic_vector (31 downto 0); 
    VmeTrg2Load     : in    std_logic; 
    VmeTrg2Set      : in    std_logic_vector (31 downto 0); 
    DisTrg          : out   std_logic; 
    EndOfRunBR      : out   std_logic; 
    FillEvent       : out   std_logic; 
    GrsTrged        : out   std_logic; 
    GrsTrgNum       : out   std_logic_vector (31 downto 0); 
    PreTable        : out   std_logic_vector (6 downto 1); 
    PromptTrg       : out   std_logic; 
    SyncBlkEnd      : out   std_logic; 
    TDTrig          : out   std_logic; 
    TempBusy        : out   std_logic; 
    TestPt          : out   std_logic_vector (24 downto 1); 
    TrigCode        : out   std_logic; 
    Triggered       : out   std_logic; 
    TsData          : out   std_logic_vector (15 downto 0); 
    Monitor         : out   std_logic_vector(31 downto 0);
    TsScalar        : out   std_logic_vector (191 downto 0); 
    TsValid         : out   std_logic_vector (31 downto 0));
end TSTrigGen;

architecture Behavioral of TSTrigGen is

  component TimerRstGen is
    Port (Clock : in STD_LOGIC;
      ClkSlow   : in STD_LOGIC;
      RstIn     : in STD_LOGIC;
      RstOut    : out STD_LOGIC  );
  end component TimerRstGen;

  component ROM64X1
      -- synopsys translate_off
    generic( INIT : bit_vector :=  x"0000000000000000");
      -- synopsys translate_on
    port ( A0 : in    std_logic; 
      A1 : in    std_logic; 
      A2 : in    std_logic; 
      A3 : in    std_logic; 
      A4 : in    std_logic; 
      A5 : in    std_logic; 
      O  : out   std_logic);
  end component;
 
  component TrgTable
    port (dina  : in std_logic_vector (31 downto 0); 
      addra  : in    std_logic_vector (3 downto 0); 
      wea    : in    std_logic_vector (0 downto 0); 
      clka   : in    std_logic; 
      addrb  : in    std_logic_vector (5 downto 0); 
      clkb   : in    std_logic; 
      doutb  : out   std_logic_vector (7 downto 0));
  end component;

  component TrigPrescale is
    Port (Clock : in STD_LOGIC;
      TrigIn    : in STD_LOGIC;
      PreScale  : in STD_LOGIC_VECTOR (15 downto 0);
      Reset     : in STD_LOGIC;
      TrigOut   : out STD_LOGIC  );  -- out rate = In_rate/(Prescale(15:0)+1)
  end component TrigPrescale;

  component RandomTrig1 is
    Port (Clock : in STD_LOGIC;
      RTrgRate : in    std_logic_vector (7 downto 0); 
      TrigOut  : out STD_LOGIC );
  end component RandomTrig1;

  component RandomTrig2 is
    Port (Clock : in STD_LOGIC;
      RTrgRate  : in  std_logic_vector (7 downto 0); 
      TrigOut   : out STD_LOGIC );
  end component RandomTrig2;

  component VmeTrigGen is
    Port (ClkVme : in STD_LOGIC;
      Busy       : in    std_logic; 
      NTrgLoad   : in    std_logic; 
      NTrgSet    : in    std_logic_vector (15 downto 0); 
      Reset      : in    std_logic; 
      TrgRate    : in    std_logic_vector (15 downto 0); 
      VmeTrgEn   : in    std_logic; 
      Clock      : in STD_LOGIC;
      TrigOut    : out STD_LOGIC);
  end component VmeTrigGen;

  component TriggerRules is
    port ( Busy    : in  std_logic; 
--      ClkSlowIn    : in  std_logic; 
      Clock        : in  std_logic; 
      SuperSlowEn  : in  std_logic;
      EndOfRun     : in  std_logic; 
      MinRuleWidth : in  std_logic_vector (31 downto 0); 
      PeriodA      : in  std_logic_vector (31 downto 0); 
      Reset        : in  std_logic; 
      TrigIn       : in  std_logic; 
      TestPt       : out std_logic_vector(16 downto 1);
      BusyRule     : out std_logic; 
      PreTrgD      : out std_logic; 
      PreTrged     : out std_logic; 
      TrigOut      : out std_logic);
  end component TriggerRules;

  component FPReceiver
    port ( Clk             : in    std_logic; 
      FPPreMatch      : inout std_logic; 
      ClkTable        : in    std_logic; 
      Reset           : in    std_logic; 
      ScalarLatch     : in    std_logic; 
      ScalarReset     : in    std_logic; 
      TsIn            : in    std_logic_vector (6 downto 1); 
      TrigEn          : in    std_logic_vector (6 downto 1); 
      MatchWindow     : in    std_logic_vector (7 downto 0); 
      TrigInhibit     : in    std_logic_vector (7 downto 0); 
      TrigPreScale    : in    std_logic_vector (24 downto 1); 
      TestPt          : out   std_logic_vector (8 downto 1); 
      FPCount         : inout std_logic_vector (191 downto 0); 
      TableValid      : inout std_logic_vector (31 downto 0); 
      TblReg          : inout std_logic_vector (6 downto 1); 
      ChannelDelay    : in    std_logic_vector (63 downto 0); 
      PreTable        : out   std_logic_vector (6 downto 1); 
      LevelReadEn     : in    std_logic; 
      ScalarEnableSet : in    std_logic_vector (2 downto 1));
  end component;

  component TrigInReg is
    Port ( Clock : in STD_LOGIC;    -- 4ns clock
      ClkSlow : in    std_logic;    -- 16ns clock
      Enable  : in    std_logic; 
      Reset   : in    std_logic; 
      TrgIn    : in    std_logic;   -- input 
      TrgFast : out   std_logic;    -- keeps at 4ns wide, syced with Clock
      TrgReg  : out   std_logic  ); -- keeps at 16ns wide, synced with ClkSlow
  end component TrigInReg;

  component TsType
    port ( Clk625      : in    std_logic; 
      TsBit       : in    std_logic_vector (8 downto 1); 
      TrgSrc      : in    std_logic_vector (8 downto 0); 
      Tsxbit      : out   std_logic_vector (9 downto 0); 
      Busy        : in    std_logic; 
      MHEvtType   : in    std_logic_vector (31 downto 0); 
      Clk250      : in    std_logic; 
      FPtriggered : out   std_logic; 
      Type0Out    : out   std_logic);
  end component;

  component TSDataGen
    port ( ForceSync  : in    std_logic; 
      PeriodSync : in    std_logic; 
      Clock      : in    std_logic; 
      PreTSData  : in    std_logic_vector (15 downto 0); 
      TSData     : out   std_logic_vector (15 downto 0); 
      TrgDelay   : in    std_logic_vector (1 downto 0); 
      TrgByTrg2  : in    std_logic);
  end component;

  component BRamFIFO36x9 IS
    PORT (
      clk : IN STD_LOGIC;
      srst : IN STD_LOGIC;
      din : IN STD_LOGIC_VECTOR(35 DOWNTO 0);
      wr_en : IN STD_LOGIC;
      rd_en : IN STD_LOGIC;
      dout : OUT STD_LOGIC_VECTOR(8 DOWNTO 0);
      full : OUT STD_LOGIC;
      empty : OUT STD_LOGIC;
      wr_rst_busy : OUT STD_LOGIC;
      rd_rst_busy : OUT STD_LOGIC );
  END component BRamFIFO36x9;

  component TrigWordDecode is
    Port (TrigCode : in std_logic_vector(15 downto 0);
      TrigCodeEn   : in std_logic;
      SubTsEn      : in std_logic_vector(4 downto 1);
      Trigger1     : out std_logic;
      Trigger2     : out std_logic;
      TrigSync     : out std_logic;
      SubTsTrig    : out std_logic  );
  end component TrigWordDecode;

  COMPONENT TriggerDelay
    PORT(TrgAIn : IN std_logic;
      Clock   : IN std_logic;
      TrgADly : IN std_logic_vector(7 downto 0);          
      TrgAOut : OUT std_logic );
  END COMPONENT;

  component ram12
    port ( din    : in    std_logic_vector (11 downto 0); 
      wr_en  : in    std_logic; 
      rd_en  : in    std_logic; 
      wr_clk : in    std_logic; 
      rd_clk : in    std_logic; 
      rst    : in    std_logic; 
      dout   : out   std_logic_vector (11 downto 0); 
      full   : out   std_logic; 
     empty  : out   std_logic);
  end component;

  COMPONENT Count48DSP
    PORT (CLK : IN STD_LOGIC;
      CE : IN STD_LOGIC;
      SCLR : IN STD_LOGIC;
      Q : OUT STD_LOGIC_VECTOR(47 DOWNTO 0)  );
  END COMPONENT;

  signal TimerReset  : std_logic;
-- Front Panel TS Code trigger related signals
  signal PreTsScalar : std_logic_vector(191 downto 0);
  signal PreTsValid  : std_logic_vector(31 downto 0);
  signal TsReg       : std_logic_vector(6 downto 1);
  signal TsBit       : std_logic_vector(8 downto 1);
  signal TsPreMatch  : std_logic;
  signal TrigCodeInt : std_logic;
  signal ExtCodeTrg  : std_logic;
  signal ExtPrePSTrg : std_logic;
  signal ExtPSTrg    : std_logic;
  signal DlyVmeTrg1Load : std_logic;
  signal DlyVmeTrg2Load : std_logic;
  signal VmeTrg     : std_logic;
  signal VmePre     : std_logic;
  signal VmeTrged   : std_logic;
  signal RndmTrg    : std_logic;
  signal RndmPre    : std_logic;
  signal RndmTrged  : std_logic;
  signal VmeTrg2    : std_logic;
  signal Vme2Pre    : std_logic;
  signal VmeTrg2ed  : std_logic;
  signal RndmTrg2   : std_logic;
  signal Rndm2Pre   : std_logic;
  signal RndmTrg2ed : std_logic;
  signal FPPre      : std_logic;
  signal FPTrged    : std_logic;
  signal TrgSrc     : std_logic_vector(8 downto 0);
  signal FillTrg    : std_logic;
  signal TsxBit      : std_logic_vector(11 downto 0);
  signal DisTrgInt   : std_logic;
  signal FPTriggered : std_logic;
  signal PreTSData   : std_logic_vector(15 downto 0);
  signal TsDataInt   : std_logic_vector(15 downto 0);
  signal TrigedInt   : std_logic;  -- Triggered from the Trigger_Rule
  signal Trigger2ed  : std_logic;
  signal TsTrged  : std_logic;     -- TrigedInt or Trigger2ed
  signal Triged   : std_logic;  -- 4ns trigger
  signal CntOut   : std_logic;
  signal CtlOut   : std_logic;
  signal Timer    : std_logic_vector(15 downto 0);
  signal TrgCtl   : std_logic_vector(15 downto 0);
  signal TrgCnt   : std_logic_vector(15 downto 0);
  signal ForcedSEvt : std_logic;
  signal TrgByTrg2  : std_logic;
  signal TrgByTrg2ed : std_logic;
  signal TrgByTrg2Pre : std_logic;
  signal PrePSEvt   : std_logic;
  signal TrgTime0   : std_logic;
  signal TrgTime1   : std_logic;
  signal RegTime    : std_logic_vector(15 downto 0);
  signal CntEmpty  : std_logic;   -- Counter fifo ram36x9
  signal CntReadEn : std_logic;
  signal CntRamIn  : std_logic_vector(35 downto 0);
  signal PreTrgD   : std_logic;
  signal BusyRule    : std_logic;  -- busy from trigger rule block
  signal BusyRuleIn  : std_logic;  -- Trigger Rules
  signal GrsTsTrg    : std_logic;
  signal TempBusyInt : std_logic;
  signal PreTrged    : std_logic; -- 16ns wide, used to generate PromptTrigger
  signal EndOfRunInt : std_logic;
  signal EndOfRunEn  : std_logic;  -- total block count threshold
  signal TotBlkCnt   : std_logic_vector(31 downto 0);
  signal PreBlock    : std_logic;  
  signal TotBlkGEset : std_logic;
  signal FillEventInt : std_logic;    
  signal NumTrg       : std_logic_vector(7 downto 0);
  signal FillTimer    : std_logic_vector(15 downto 0);
  signal SyncBlkEndInt : std_logic;
  signal NewBlock      : std_logic;
  signal DlyNewBlk     : std_logic;
  signal PeriodSEvt  : std_logic;
  signal TempBusyCnt : std_logic_vector(7 downto 0);
  signal Pre2ForcedEvt : std_logic;
  signal PreForcedEvt  : std_logic;
  signal BlkCnt    : std_logic_vector(19 downto 0); -- Periodic Sync Event
  signal BlkCntRst : std_logic;
  signal PeriodSEn   : std_logic;
  signal PPrePSEvt   : std_logic;
  signal P2TrgInt : std_logic_vector(4 downto 0);  -- different stages of the P2Trg
  signal TDTrigInt : std_logic;
  signal TDTrigMid : std_logic;
  signal PreTDTrig : std_logic;
  signal PromptInt : std_logic_vector(11 downto 0);  -- internal signals for prompt trigger logic
  signal PrePrompt : std_logic;
  signal TrgClear  : std_logic;
  signal CodedTrg2  : std_logic;  -- Trigger generated by trigger2
  signal DlyCodedTrg2 : std_logic;
  signal GrsTrgCnt  : std_logic_vector(31 downto 0);
  signal Ram12ReadEn : std_logic;  --Vme control command
  signal Ram12Empty  : std_logic;
  signal Clock625Mon : std_logic :='0';
  signal Clock3125Mon : std_logic := '0';
   
begin

-- Re-sync the Reset to the Clk250 and CLk625 for Timer reset, and the Timer
  TimerResetGeneration : TimerRstGen
    Port map(Clock => Clk250, -- in STD_LOGIC;
      ClkSlow => Clk625,      -- in STD_LOGIC;
      RstIn   => Reset,       -- in STD_LOGIC;
      RstOut  => TimerReset ); -- out STD_LOGIC
  process (Clk250)
  begin
    if (CLk250'event and Clk250 = '1') then
      if (TimerReset = '1') then
        Timer <= (others => '0');
      else
        Timer <= Timer + 1;
      end if;
    end if;
  end process;
  
  TestPt(8 downto 1) <= BusyRule & SReqSet & Busy & TempBusyInt & TrigedInt & RndmTrged & RndmPre & RndmTrg; 

-- Front panel trigger generation (TS_code inputs):receiver
  FrontPanelReceiver : FPReceiver
    port map( Clk  => Clk250,      -- in    std_logic; 
      FPPreMatch   => TsPreMatch,  -- inout std_logic; 
      ClkTable     => Clk250,      -- in    std_logic; 
      Reset        => Reset,       -- in    std_logic; 
      ScalarLatch  => ScalarLatch, -- in    std_logic; 
      ScalarReset  => ScalarReset, -- in    std_logic; 
      TsIn         => TsIn(6 downto 1),   -- in    std_logic_vector (6 downto 1); 
      TrigEn       => TSEn(6 downto 1),     -- in    std_logic_vector (6 downto 1); 
      MatchWindow  => TSMatch(7 downto 0),  -- in    std_logic_vector (7 downto 0); 
      TrigInhibit  => TsMatch(15 downto 8), -- in    std_logic_vector (7 downto 0); 
      TrigPreScale => TsPreScale(24 downto 1), -- in    std_logic_vector (24 downto 1); 
      TestPt       => Monitor(19 downto 12), -- open,                 -- out   std_logic_vector (4 downto 1); 
      FPCount      => PreTsScalar(191 downto 0), -- inout std_logic_vector (191 downto 0); 
      TableValid   => PreTsValid(31 downto 0),   -- inout std_logic_vector (31 downto 0); 
      TblReg       => TsReg(6 downto 1),          -- inout std_logic_vector (6 downto 1); 
      ChannelDelay => ChannelDelay(63 downto 0), -- in    std_logic_vector (63 downto 0); 
      PreTable     => PreTable(6 downto 1),      -- out   std_logic_vector (6 downto 1); 
      LevelReadEn  => TsMatch(31),               -- in    std_logic; 
      ScalarEnableSet => ScalarEnableSet(2 downto 1) ); -- in    std_logic_vector (2 downto 1));
  TsScalar <= PreTsScalar;
  TsValid  <= PreTsValid;
  Monitor(11 downto 0) <= TsIn(3 downto 1) & TSEn(3 downto 1) & TsReg(6 downto 1);
  Monitor(20) <= TrgTblWE; -- & TrgTblAdr(3 downto 0);
  Monitor(23 downto 21) <= TrigCodeInt & ExtCodeTrg & Reset;
  FPTriggerTable : TrgTable
    port map( dina => TrgTblData(31 downto 0), -- in std_logic_vector (31 downto 0); 
      addra  => TrgTblAdr(3 downto 0), -- in std_logic_vector (3 downto 0); 
      wea(0) => TrgTblWE,            -- in std_logic_vector (0 downto 0); 
      clka   => ClkVme,              -- in std_logic; 
      addrb  => TsReg(6 downto 1),   -- in std_logic_vector (5 downto 0); 
      clkb   => Clk250,              -- in std_logic; 
      doutb  => TsBit(8 downto 1) ); -- out std_logic_vector (7 downto 0)

  process (Clk250)
  begin
    if (CLk250'event and Clk250 = '1') then
      if (Reset = '1') then
        TrigCodeInt <= '0';
      elsif (TrgSrcEn(5) = '1') then
        TrigCodeInt <=  TsReg(1) or TsReg(2) or TsReg(3) or TsReg(4) or TsReg(5) or TsReg(6);
      end if;
    end if;
  end process;
  TrigCode <= TrigCodeInt;
-- prescale for FP TS code
  FPTScodePrescale : TrigPrescale
    Port map(Clock => Clk250,    -- in STD_LOGIC;
      TrigIn    => TrigCodeInt,  -- in STD_LOGIC;
      PreScale  => PSFactor(15 downto 0), -- in STD_LOGIC_VECTOR (15 downto 0);
      Reset     => Reset,        -- in STD_LOGIC;
      TrigOut   => ExtCodeTrg ); -- out STD_LOGIC, out rate = In_rate/(Prescale(15:0)+1)

-- FP pulse trigger receive
  FrontPanelTriggerRegister : TrigInReg
    Port map(Clock => Clk250, -- in STD_LOGIC;    -- 4ns clock
      ClkSlow => Clk625,      -- in    std_logic;    -- 16ns clock
      Enable  => '1',         -- in    std_logic; 
      Reset   => Reset,       -- in    std_logic; 
      TrgIn   => FPTrgIn,     -- in    std_logic;   -- input 
      TrgFast => FPPre,       -- out   std_logic;    -- keeps at 4ns wide, syced with Clock
      TrgReg  => FPTrged );   -- out   std_logic -- keeps at 16ns wide, synced with ClkSlow
-- prescale for FP pulse trigger
  ExtPrePSTrg <= FPPre and TrgSrcEn(3);
  FPpulseTrigPrescale : TrigPrescale
    Port map(Clock => Clk250,   -- in STD_LOGIC;
      TrigIn    => ExtPrePSTrg, -- in STD_LOGIC;
      PreScale  => PSFactor(15 downto 0), -- in STD_LOGIC_VECTOR (15 downto 0);
      Reset     => Reset,       -- in STD_LOGIC;
      TrigOut   => ExtPSTrg );  -- out STD_LOGIC, out rate = In_rate/(Prescale(15:0)+1)
  Monitor(27 downto 24) <= FPTrgIn & FPTrged & FPPre & ExtPSTrg;
-- VME trigger generation
  process (ClkVme)
  begin
    if (ClkVme'event and ClkVme = '1') then
      DlyVmeTrg2Load <= VmeTrg2Load;
      DlyVmeTrg1Load <= VmeTrg1Load;
    end if;
  end process;
  -- Vme Trigger1 generation
  VmeTrigger1Generation : VmeTrigGen
    Port map(ClkVme => ClkVme,    -- in STD_LOGIC;
      Busy     => Busy,           -- in std_logic; 
      NTrgLoad => DlyVmeTrg1Load, -- in std_logic; 
      NTrgSet  => VmeTrg1Set(15 downto 0), -- in std_logic_vector (15 downto 0); 
      Reset    => Reset,          -- in  std_logic; 
      TrgRate  => VmeTrg1Set(31 downto 16), -- in std_logic_vector (15 downto 0); 
      VmeTrgEn => TrgSrcEN(4),    -- in std_logic; 
      Clock    => Clk625,         -- in STD_LOGIC;
      TrigOut  => VmeTrg );       -- out STD_LOGIC);
  -- Vme Trigger2 generation
  VmeTrigger2Generation : VmeTrigGen
    Port map(ClkVme => ClkVme,    -- in STD_LOGIC;
      Busy     => Busy,           -- in std_logic; 
      NTrgLoad => DlyVmeTrg2Load, -- in std_logic; 
      NTrgSet  => VmeTrg2Set(15 downto 0), -- in std_logic_vector (15 downto 0); 
      Reset    => Reset,          -- in  std_logic; 
      TrgRate  => VmeTrg2Set(31 downto 16), -- in std_logic_vector (15 downto 0); 
      VmeTrgEn => TrgSrcEN(4),    -- in std_logic; 
      Clock    => Clk625,         -- in STD_LOGIC;
      TrigOut  => VmeTrg2 );       -- out STD_LOGIC);
  -- Trigger Input Registers (generated trigger source --> One clock wide
  VmeTriggerRegister : TrigInReg
    Port map(Clock => Clk250, -- in STD_LOGIC;    -- 4ns clock
      ClkSlow => Clk625,      -- in    std_logic;    -- 16ns clock
      Enable  => '1',         -- in    std_logic; 
      Reset   => Reset,       -- in    std_logic; 
      TrgIn   => VmeTrg,     -- in    std_logic;   -- input 
      TrgFast => VmePre,     -- out   std_logic;    -- keeps at 4ns wide, syced with Clock
      TrgReg  => VmeTrged ); -- out   std_logic -- keeps at 16ns wide, synced with ClkSlow
  VmeTrigger2Register : TrigInReg
    Port map(Clock => Clk250, -- in STD_LOGIC;    -- 4ns clock
      ClkSlow => Clk625,      -- in    std_logic;    -- 16ns clock
      Enable  => '1',         -- in    std_logic; 
      Reset   => Reset,       -- in    std_logic; 
      TrgIn   => VmeTrg2,     -- in    std_logic;   -- input 
      TrgFast => Vme2Pre,     -- out   std_logic;    -- keeps at 4ns wide, syced with Clock
      TrgReg  => VmeTrg2ed ); -- out   std_logic -- keeps at 16ns wide, synced with ClkSlow

-- Random trigger generation:
  RandomTrigger1Generation : RandomTrig1
    Port map(Clock => Clk625,           -- in STD_LOGIC;
      RTrgRate => RTrgRate(7 downto 0), -- in std_logic_vector (7 downto 0); 
      TrigOut  => RndmTrg );            -- out STD_LOGIC );
  RandomTrigger2Generation : RandomTrig2
    Port map(Clock => Clk625,            -- in STD_LOGIC;
      RTrgRate => RTrgRate(15 downto 8), -- in std_logic_vector (7 downto 0); 
      TrigOut  => RndmTrg2 );            -- out STD_LOGIC );
  RandomTriggerRegister : TrigInReg
    Port map(Clock => Clk250, -- in STD_LOGIC;    -- 4ns clock
      ClkSlow => Clk625,      -- in    std_logic;    -- 16ns clock
      Enable  => '1',         -- in    std_logic; 
      Reset   => Reset,       -- in    std_logic; 
      TrgIn   => RndmTrg,     -- in    std_logic;   -- input 
      TrgFast => RndmPre,     -- out   std_logic;    -- keeps at 4ns wide, syced with Clock
      TrgReg  => RndmTrged ); -- out   std_logic -- keeps at 16ns wide, synced with ClkSlow
  RandomTrigger2Register : TrigInReg
    Port map(Clock => Clk250, -- in STD_LOGIC;    -- 4ns clock
      ClkSlow => Clk625,      -- in    std_logic;    -- 16ns clock
      Enable  => '1',         -- in    std_logic; 
      Reset   => Reset,       -- in    std_logic; 
      TrgIn   => RndmTrg2,     -- in    std_logic;   -- input 
      TrgFast => Rndm2Pre,     -- out   std_logic;    -- keeps at 4ns wide, syced with Clock
      TrgReg  => RndmTrg2ed ); -- out   std_logic -- keeps at 16ns wide, synced with ClkSlow
  TrgByTrg2TriggerRegister : TrigInReg
    Port map(Clock => Clk250, -- in STD_LOGIC;    -- 4ns clock
      ClkSlow => Clk625,      -- in    std_logic;    -- 16ns clock
      Enable  => '1',         -- in    std_logic; 
      Reset   => Reset,       -- in    std_logic; 
      TrgIn   => TrgByTrg2,     -- in    std_logic;   -- input 
      TrgFast => TrgByTrg2Pre,     -- out   std_logic;    -- keeps at 4ns wide, syced with Clock
      TrgReg  => TrgByTrg2ed ); -- out   std_logic -- keeps at 16ns wide, synced with ClkSlow

  -- TestPt(8 downto 2) <= ExtPSTrg & ExtCodeTrg & VmeTrged & RndmTrg & VmeTrg & RndmTrg2 & TrigCodeInt;
-- TS Type generation
  TrgSrc(0) <= ExtPSTrg;
  TrgSrc(1) <= ExtCodeTrg;
  TrgSrc(2) <= VmeTrged and TrgSrcEn(4);
  TrgSrc(3) <= RndmTrged and TrgSrcEn(7);
  TrgSrc(4) <= TrigCodeInt;
  TrgSrc(5) <= VmeTrg2ed and TrgSrcEn(4);
  TrgSrc(6) <= RndmTrg2ed and TrgSrcEn(7);
  TrgSrc(7) <= FillTrg;
  TrgSrc(8) <= TrgByTrg2ed and TrgSrcEn(11);
  TStypeGeneration : TsType
    port map(Clk625  => Clk625,          -- in std_logic; 
      TsBit       => TsBit(8 downto 1),  -- in std_logic_vector (8 downto 1); 
      TrgSrc      => TrgSrc(8 downto 0), -- in std_logic_vector (7 downto 0); 
      Tsxbit      => TsxBit(9 downto 0), -- out std_logic_vector (9 downto 0); 
      Busy        => DisTrgInt,          -- in std_logic; 
      MHEvtType   => VmeEvtType(31 downto 0), -- in std_logic_vector (31 downto 0); 
      Clk250      => Clk250,      -- in  std_logic; 
      FPtriggered => FPTriggered, -- out std_logic; 
      Type0Out    => open ); -- TestPt(1) ); -- out std_logic);

-- TS data generation
  TSTrged <= TrigedInt or Trigger2ed;
  Triggered <= TrigedInt;
  process (Clk625)
  begin
    if (Clk625'event and Clk625 = '1') then
      if (TSTrged = '1') then
        PreTSData(11 downto 9) <= TsxBit(11 downto 9);
        PreTSData(8) <= TrigedInt;
        if (TsxBit(7 downto 0) = "00000000") then
          PreTSData(7 downto 0) <= "11110000";
        else
          PreTSData(7 downto 0) <= TsxBit(7 downto 0);
        end if;
      else
        if (CntOut = '1') then
          PreTSData(11 downto 0) <= TrgCnt(11 downto 0);
        else
          if (CtlOut = '1') then
            PreTSData(11 downto 0) <= TrgCtl(11 downto 0);
          else
            PreTSData(11 downto 0) <= Timer(13 downto 2);
          end if;
        end if;
      end if;
      PreTSData(12) <= (CntOut or CtlOut) and (not TsTrged);
      PreTSData(13) <= TsTrged or CntOut;
      PreTSData(14) <= '1';
      PreTSData(15) <= '0';
    end if;
  end process;
  TSTriggerData : TSDataGen
    port map(ForceSync => ForcedSEvt, -- in std_logic; 
      PeriodSync => PrePSEvt,         -- in std_logic; 
      Clock      => Clk625,           -- in std_logic; 
      PreTSData  => PreTSData(15 downto 0), -- in  std_logic_vector (15 downto 0); 
      TSData     => TsDataInt(15 downto 0),    -- out std_logic_vector (15 downto 0); 
      TrgDelay   => TsMatch(17 downto 16),  -- in  std_logic_vector (1 downto 0); 
      TrgByTrg2  => '0' ); -- TrgByTrg2  );           -- in  std_logic);
  TsData(15 downto 0) <= TsDataInt(15 downto 0);

-- Trigger2ed generation
  process (Clk625)
  begin
    if (Clk625'event and Clk625 = '1') then
      Trigger2ed <= (VmeTrg2ed and TrgSrcEn(4)) or (RndmTrg2ed and TrgSrcEn(7)) or
                    (ExtCodeTrg and TsBit(8) and (not TsBit(7))); 
      TsxBit(10) <= TrgTime0;
      TsxBit(11) <= TrgTime1;
      CntOut <= not CntEmpty;
    end if;
  end process;
  
-- TimerCounter output control
  Triged <= (VmePre and TrgSrcEn(4)) or (RndmPre and TrgSrcEn(7)) or (TrgByTrg2Pre and TrgSrcEn(11))
         or (TsPreMatch and TrgSrcEn(5)) or (FPPre and TrgSrcEn(3));
  process(Clk250)
  begin
    if (Clk250'event and Clk250 = '1') then
      if (Triged = '1') then
        TrgTime0 <= Timer(0);
        TrgTime1 <= Timer(1);
        RegTime(15 downto 0) <= Timer(15 downto 0);
      end if;
      Clock625Mon <= (not Clock625Mon);
    end if;
  end process;
  CntReadEn <= (not CntEmpty) and (not TsTrged);
  CntRamIn(35 downto 0) <= '1' & RegTime(15 downto 8) & '1' & RegTime(7 downto 0)
                         & TrgSrcEn(7 downto 0) & TrgSrc(3 downto 0) & TsReg(6 downto 1);
  TimeCounterMemoty : BRamFIFO36x9
    PORT map(clk  => Clk625,    -- IN STD_LOGIC;
      srst        => Reset,     -- IN STD_LOGIC;
      din         => CntRamIn,  -- IN STD_LOGIC_VECTOR(35 DOWNTO 0);
      wr_en       => PreTrgD,   -- IN STD_LOGIC;
      rd_en       => CntReadEn, -- IN STD_LOGIC;
      dout        => TrgCnt(8 downto 0), -- OUT STD_LOGIC_VECTOR(8 DOWNTO 0);
      full        => open,     -- OUT STD_LOGIC;
      empty       => CntEmpty, -- OUT STD_LOGIC;
      wr_rst_busy => open,     -- OUT STD_LOGIC;
      rd_rst_busy => open );   --- OUT STD_LOGICbram36to9
  TrgCnt(11 downto 9) <= "000";
  
 -- Forced Sync Event:
  process (ForcedSEvt, Clk625, ForceSyncEvt)
  begin
    if (ForcedSEvt = '1') then
      Pre2ForcedEvt <= '0';
    elsif (ForceSyncEvt'event and ForceSyncEvt = '1') then
      Pre2ForcedEvt <= '1';
    end if;
    if (Clk625'event and Clk625 = '1') then
      PreForcedEvt <= Pre2ForcedEvt;
      ForcedSEvt <= PreForcedEvt;
    end if;
  end process;

-- Trigger Rule application
  GrsTsTrg <= FillTrg or FPtriggered or (VmeTrged and TrgSrcEn(4)) or (RndmTrged and TrgSrcEn(7)) or (TrgByTrg2ed and TrgSrcEn(11));
  BusyRuleIn <= TempBusyInt or Busy or SReqSet;
  TriggerRulesMod : TriggerRules
    port map( Busy => BusyRuleIn, -- in  std_logic; 
--      ClkSlowIn    => ClkSlow, -- in  std_logic; 
      Clock        => Clk625, -- in  std_logic; 
      SuperSlowEn  => ClkSelTrgRule, -- in  std_logic;
      EndOfRun     => EndOfRunInt, -- in  std_logic; 
      MinRuleWidth => MinRuleWidth, -- in  std_logic_vector (31 downto 0); 
      PeriodA      => PeriodA, -- in  std_logic_vector (31 downto 0); 
      Reset        => Reset, -- in  std_logic; 
      TestPt       => TestPt(24 downto 9), --open, -- TestPt, -- out std_logic_vector(8 downto 1);
      TrigIn       => GrsTsTrg, -- in  std_logic; 
      BusyRule     => BusyRule, -- out std_logic; 
      PreTrgD      => PreTrgD, -- out std_logic; 
      PreTrged     => PreTrged, -- out std_logic; 
      TrigOut      => TrigedInt ); -- out std_logic);
  DisTrgInt <= BusyRule or Busy;
  TempBusy <= TempBusyInt;
  DisTrg   <= DisTrgInt;
  
-- Use DSP counter, instead of the fabric counter
  TotBlkCounterDSP : Count48DSP
    PORT MAP (CLK => Clk625,     -- IN STD_LOGIC;
      CE          => PreBlock,   -- IN STD_LOGIC;
      SCLR        => Reset,      -- IN STD_LOGIC;
      Q(31 downto 0)  => TotBlkCnt(31 downto 0), -- OUT STD_LOGIC_VECTOR(47 DOWNTO 0)
      Q(47 downto 32) => open   );
  BlkCntRst <= PrePSEvt or Reset;
  BlkCounterDSP : Count48DSP
    PORT MAP (CLK => Clk625,     -- IN STD_LOGIC;
      CE          => PreBlock,   -- IN STD_LOGIC;
      SCLR        => BlkCntRst,      -- IN STD_LOGIC;
      Q(19 downto 0)  => BlkCnt(19 downto 0), -- OUT STD_LOGIC_VECTOR(47 DOWNTO 0)
      Q(47 downto 20) => open   );

-- End Of Run logic 
  process (Clk625) 
  begin
    if (Clk625'event and Clk625 = '1') then
--      if (Reset = '1') then             -- Total block number limit
--        TotBlkCnt <= (others => '0');
--      elsif (PreBlock = '1') then
--        TotBlkCnt <= TotBlkCnt + 1;
--      end if;
--      if (PrePSEvt = '1' or Reset = '1') then  -- Periodic Sync Event
--        BlkCnt <= (others => '0');
--      elsif (PreBlock = '1') then
--        BlkCnt <= BlkCnt + 1;
--      end if;
      PeriodSEvt <= PrePSEvt;
    end if;
  end process;
  process (BlkCnt, SyncEvtGen)
  begin
    if (SyncEvtGen(19 downto 0) > x"00000" ) then
      PeriodSEn <= '1';
    else
      PeriodSEn <= '0';
    end if;
    if (BlkCnt(19 downto 0) = SyncEvtGen(19 downto 0)) then
      PPrePSEvt <= '1';
    else
      PPrePSEvt <= '0';
    end if;
  end process;
  PrePSEvt <= PPrePSEvt and PeriodSEn;

  process(TotBlkCnt, EndOfRunBlk, EndOfRunEn, TotBlkCnt)
  begin
    if ((EndOfRunEn = '1') and (TotBlkCnt >= EndOfRunBlk)) then
      TotBlkGEset <= '1';
    else 
      TotBlkGEset <= '0';
    end if;
    if (EndOfRunBlk > x"00000000") then
      EndOfRunEn <= '1';
    else
      EndOfRunEn <= '0';
    end if;
  end process;
  EndOfRunInt <= EndOfRunEn and TotBlkGEset;
  EndOfRunBR <= EndOfRunInt;

-- Fill Trigger
  process (ClkVme, BlkEnd, Reset)
  begin
    if ((BlkEnd = '1') or (Reset = '1')) then
      FillEventInt <= '0';
    else
      if (ClkVme'event and ClkVme = '1') then
        if (EndOfRun = '1') then
          FillEventInt <= NumTrg(7) or NumTrg(6) or NumTrg(5) or NumTrg(4) 
                       or NumTrg(3) or NumTrg(2) or NumTrg(1) or NumTrg(0);
        end if;
      end if;
    end if;
  end process;
  FillEvent <= FillEventInt;
  process (Clk625)
  begin
    if (Clk625'event and Clk625 = '1') then
      if ((EndOfRun = '1') or (FillTrg = '1')) then  -- Fill Trigger logic
        FillTrg <= '0';
        FillTimer <= (others => '0');
      elsif (FillEventInt = '1') then
        FillTimer <= FillTimer + 1;
        FillTrg <= FillTimer(8) and FillTimer(6);
      end if;
      if ((Reset = '1') or (PreBlock = '1') or (SyncBlkEndInt = '1')) then
        NumTrg <= (others => '0');
      elsif (TrigedInt = '1') then
        NumTrg <= NumTrg + 1;
      end if;
      NewBlock <= PreBlock;
      DlyNewBlk <= NewBlock;
      if (TempBusyCnt >= "11111100") then
        TempBusyInt <= '0';
        TempBusyCnt <= (others => '0');
      else
        if ((PrePSEvt = '1') or (FOrcedSEvt = '1')) then
          TempBusyInt <= '1';
        end if;
        if (TempBusyInt = '1') then
          TempBusyCnt <= TempBusyCnt + 1;
        end if;
      end if;
    end if;
  end process;
  PreBlock <= (NumTrg(7) xnor BlockSize(7)) and (NumTrg(6) xnor BlockSize(6))
          and (NumTrg(5) xnor BlockSize(5)) and (NumTrg(4) xnor BlockSize(4))
          and (NumTrg(3) xnor BlockSize(3)) and (NumTrg(2) xnor BlockSize(2))
          and (NumTrg(1) xnor BlockSize(1)) and (NumTrg(0) xnor BlockSize(0));
  SyncBlkEndInt <= PeriodSEvt or ForcedSEvt or (DlyNewBlk and (not TempBusyInt));
  SyncBlkEnd <= SyncBlkEndInt;
  TempBusy <= TempBusyInt;
  
-- P2Trg generation, not used?
  process (Clk250)
  begin
    if (Clk250'event and Clk250 = '1') then
      P2TrgInt(0) <= P2TrgIn;
      P2TrgInt(1) <= P2TrgInt(0);
      P2TrgInt(2) <= P2TrgInt(0) and (not P2TrgInt(1));  
      if (P2TrgInt(4) = '1') then
        P2TrgInt(3) <= '0';
      elsif (P2TrgInt(2) = '1') then
        P2TrgInt(3) <= '1';
      end if;
    end if;
  end process;
  process (CLk625)
  begin
    if (Clk625'event and Clk625 = '1') then
      if (P2TrgInt(4) = '1') then
        P2TrgInt(4) <= '0';
      else
        P2TrgInt(4) <= P2TrgInt(3);
      end if;
    end if;
  end process;
--   P2Trg <= P2TrgInt(4);

-- TDTrig, and Prompt trigger generation
  process (Clk250)
  begin
    if (Clk250'event and Clk250 = '1') then
      if (TDTrigInt = '1') then
        TDTrigMid <= '0';
      elsif (PreTDTrig = '1') then
        TDTrigMid <= '1';
      end if;
      PromptInt(1) <= PromptInt(0);
      if (MasterMode = '1') then
        PreTDTrig <= PromptInt(2);
      else
        PreTDTrig <= FiberTrged;
      end if;
      PromptInt(3) <= PreTDTrig;
      PrePrompt <= PreTDTrig and (not PromptInt(3));
      if (TrgClear = '1') then
        PromptTrg <= '0';
      elsif  (PrePrompt = '1') then
        PromptTrg <= '1';
      end if;
      case (TrgWidth(6 downto 5)) is
        when ("00") => 
          TrgClear <= PromptInt(4);
        when ("01") => 
          TrgClear <= PromptInt(5);
        when ("10") => 
          TrgClear <= PromptInt(6);
        when ("11") => 
          TrgClear <= PromptInt(7);
      end case;
    end if;
  end process;
  process(Clk625)
  begin
    if (Clk625'event and Clk625 = '1') then
      TDTrigInt <= TDTrigMid;
      PromptInt(0) <= PreTrged;
    end if;
  end process;
  QuadTimeADjust : SRLC32E
    generic map (INIT => X"00000000", -- Initial contents of shift register
      IS_CLK_INVERTED => '0' )        -- Optional inversion for CLK
    port map (
Q => PromptInt(2),      -- 1-bit output: SRL Data
      Q31  => open,           -- 1-bit output: SRL Cascade Data
      A(0) => TrgTime0,       -- 5-bit input: Selects SRL depth
      A(1) => TrgTime1,       -- 5-bit input: Selects SRL depth
      A(4 downto 2) => "000", -- 5-bit input: Selects SRL depth
      CE   => '1',            -- 1-bit input: Clock enable
      CLK  => Clk250,         -- 1-bit input: Clock
      D    => PromptInt(1) ); -- 1-bit input: SRL Data
  PromptWidth1 : SRLC32E
    generic map (INIT => X"00000000", -- Initial contents of shift register
      IS_CLK_INVERTED => '0' )        -- Optional inversion for CLK
    port map (Q => PromptInt(4),      -- 1-bit output: SRL Data
      Q31  => PromptInt(8),           -- 1-bit output: SRL Cascade Data
      A    => TrgWidth(4 downto 0),   -- 5-bit input: Selects SRL depth
      CE   => '1',         -- 1-bit input: Clock enable
      CLK  => Clk250,      -- 1-bit input: Clock
      D    => PrePrompt ); -- 1-bit input: SRL Data
  PromptWidth2 : SRLC32E
    generic map (INIT => X"00000000", -- Initial contents of shift register
      IS_CLK_INVERTED => '0' )        -- Optional inversion for CLK
    port map (Q => PromptInt(5),      -- 1-bit output: SRL Data
      Q31  => PromptInt(9),           -- 1-bit output: SRL Cascade Data
      A    => TrgWidth(4 downto 0),   -- 5-bit input: Selects SRL depth
      CE   => '1',            -- 1-bit input: Clock enable
      CLK  => Clk250,         -- 1-bit input: Clock
      D    => PromptInt(8) ); -- 1-bit input: SRL Data
  PromptWidth3 : SRLC32E
    generic map (INIT => X"00000000", -- Initial contents of shift register
      IS_CLK_INVERTED => '0' )        -- Optional inversion for CLK
    port map (Q => PromptInt(6),      -- 1-bit output: SRL Data
      Q31  => PromptInt(10),           -- 1-bit output: SRL Cascade Data
      A    => TrgWidth(4 downto 0),   -- 5-bit input: Selects SRL depth
      CE   => '1',            -- 1-bit input: Clock enable
      CLK  => Clk250,         -- 1-bit input: Clock
      D    => PromptInt(9) ); -- 1-bit input: SRL Data
  PromptWidth4 : SRLC32E
    generic map (INIT => X"00000000", -- Initial contents of shift register
      IS_CLK_INVERTED => '0' )        -- Optional inversion for CLK
    port map (Q => PromptInt(7),      -- 1-bit output: SRL Data
      Q31  => open,                   -- 1-bit output: SRL Cascade Data
      A    => TrgWidth(4 downto 0),   -- 5-bit input: Selects SRL depth
      CE   => '1',            -- 1-bit input: Clock enable
      CLK  => Clk250,         -- 1-bit input: Clock
      D    => PromptInt(10) ); -- 1-bit input: SRL Data
  
  TDTrig <= TDTrigInt;

-- Trigger by trigger2 code
  Trigger2Decoding : TrigWordDecode
    Port map(TrigCode => TsDataInt(15 downto 0), -- in std_logic_vector(15 downto 0);
      TrigCodeEn   => TrgSrcEn(11),              -- in std_logic;
      SubTsEn      => TrgSrcEn(15 downto 12),    -- in std_logic_vector(4 downto 1);
      Trigger1     => open,      -- out std_logic;
      Trigger2     => CodedTrg2, -- out std_logic;
      TrigSync     => open,      -- out std_logic;
      SubTsTrig    => open );   -- out std_logic 

-- Use DSP counter, instead of the fabric counter
  GrsTrgCounterDSP : Count48DSP
    PORT MAP (CLK => Clk625,       -- IN STD_LOGIC;
      CE          => GrsTsTrg,    -- IN STD_LOGIC;
      SCLR        => Reset,        -- IN STD_LOGIC;
      Q(31 downto 0)  => GrsTrgCnt, -- OUT STD_LOGIC_VECTOR(47 DOWNTO 0)
      Q(47 downto 32) => open   );
  process (CLk625)
  begin
    if (CLk625'event and Clk625 = '1') then
      DlyCodedTrg2 <= CodedTrg2;
      GrsTrged <= GrsTsTrg;
      CtlOut <= not Ram12Empty;
--      if (Reset = '1') then
--        GrsTrgCnt(31 downto 0) <= (others => '0');
--      elsif (GrsTsTrg = '1') then
--        GrsTrgCnt <= GrsTrgCnt + 1;
--      end if;
    end if;
  end process;
  GrsTrgNum <= GrsTrgCnt;
  Ram12ReadEn <= (not Ram12Empty) and (not TsTrged) and CntEmpty;
  Trigger1Delay : TriggerDelay
    PORT MAP(TrgAIn => DlyCodedTrg2,   -- IN std_logic;
      Clock => Clk625,                  -- IN std_logic;
      TrgADly(7 downto 1) => TsMAtch(24 downto 18), -- IN std_logic_vector(7 downto 0);          
      TrgADly(0) => '0',
      TrgAOut => TrgByTrg2 );    -- OUT std_logic );
  VmeCntrolBuffer : ram12
    port map(din => TsVmeCmd(11 downto 0), -- in std_logic_vector (11 downto 0); 
      wr_en  => TsVmeEn,     -- in  std_logic; 
      rd_en  => Ram12ReadEn, -- in  std_logic; 
      wr_clk => ClkVme,      -- in  std_logic; 
      rd_clk => CLk625,      -- in  std_logic; 
      rst    => Reset,       -- in  std_logic; 
      dout   => TrgCtl(11 downto 0), -- out std_logic_vector (11 downto 0); 
      full   => open,         -- out std_logic; 
      empty  => Ram12Empty ); -- out std_logic);

end Behavioral;
