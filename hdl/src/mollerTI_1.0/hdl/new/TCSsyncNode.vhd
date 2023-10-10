----------------------------------------------------------------------------------
-- Company:  Thomas Jefferson National Accelerator Facility
-- Engineer:   GU
-- 
-- Create Date: 02/26/2020 09:14:58 AM
-- Design Name: 
-- Module Name: TCSsync - Behavioral
-- Project Name: 
-- Target Devices:  xcku3p-1FFVA676C
-- Tool Versions:   Vivado 2019.1
-- Description:   Sync command generation, and Sync_Reset decoding
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
library UNISIM;
use UNISIM.VComponents.all;

entity TCSsyncNode is
  Port ( CLock : in STD_LOGIC;
    ClkSlow    : in std_logic;
    SyncIn_P   : in STD_LOGIC;
    SyncIn_N   : in STD_LOGIC;
    ReadStart  : out STD_LOGIC;
    WriteStart : out STD_LOGIC;
    TSRdStart  : out STD_LOGIC;
    TSWrStart  : out STD_LOGIC;
    DlyReady   : out STD_LOGIC;
    ClkLockEn  : in STD_LOGIC;
    SyncSrcEn  : in std_logic_vector(7 downto 0);
    ResetWidth : in std_logic_vector(7 downto 0);
    VmeRst     : in std_logic_vector(15 downto 0);
    SResetOut  : out STD_LOGIC_VECTOR (15 downto 0);
    Reset      : inout std_logic;
    SyncRst_P  : out std_logic;
    SyncRst_N  : out std_logic;
    FPsync     : in STD_LOGIC;
    TSInhibit  : out STD_LOGIC;
    SCReadEn   : in std_logic;
    SyncDelay  : in STD_LOGIC_VECTOR (31 downto 0);
    MasterMode : in STD_LOGIC_VECTOR (3 downto 1);
    SyncCodeIn : in STD_LOGIC_VECTOR (7 downto 0);
    SyncGenDly : in STD_LOGIC_VECTOR (7 downto 0);
    SyncCodeEn : in STD_LOGIC;
    ClkVme     : in STD_LOGIC;
    TIBusy     : in STD_LOGIC_VECTOR (8 downto 0);
    BusySrcEn  : in STD_LOGIC_VECTOR (15 downto 0);
    SRespTI    : in STD_LOGIC_VECTOR (8 downto 0);
    SReqSet    : in STD_LOGIC;
    TrgSyncOutEn : in std_logic;
    SetClkSrc    : in std_logic; 
    IODlyRst     : in std_logic;
    TrgSendEn   : out STD_LOGIC;
    SyncCodedA  : out STD_LOGIC;
    SyncCodedB  : out STD_LOGIC;
    TestPt      : out std_logic_vector(8 downto 1);
    SyncRead    : out std_logic_vector(31 downto 0);
    StatSync    : out std_logic_vector(7 downto 0);
    SyncCode    : out STD_LOGIC_VECTOR (39 downto 0));
end TCSsyncNode;

architecture Behavioral of TCSsyncNode is

  component ClkEdgeAvoid is
    Port (
      ClkRef   : in STD_LOGIC;  -- Reference clock to the Delay elements
      Clock    : in STD_LOGIC;  -- clock to sync the SigIn
      SigIn    : in STD_LOGIC;  -- signal to be captured (to avoid the clock edge)
      AlignIn  : in STD_LOGIC;  -- alignment initiate signal
      SigOut   : out STD_LOGIC;  -- registered signal (clock edge avoided)
      SigInvert : out std_logic := '0';
      AlignRdy : out std_logic;  -- alignment ready
      CntDly   : out STD_LOGIC_VECTOR (19 downto 0) );  -- (8:0): Idelay count value  (17:9): Odelay value
                                                      -- (18) : Increament   (19): Inc/Decrement enable
  end component ClkEdgeAvoid;

  component SigDelay is
    Port (SigIn : in STD_LOGIC;
      Clock     : in STD_LOGIC;
      DelayVal  : in STD_LOGIC_VECTOR (7 downto 0);
      SigOut    : out STD_LOGIC);
  end component SigDelay;

  component SyncDecode is
    Port (Clock  : in STD_LOGIC;
      CLkSlow    : in std_logic;
      SyncIn     : in STD_LOGIC;
      SyncDly    : in STD_LOGIC_VECTOR (7 downto 0);
      Reset      : out STD_LOGIC;
      ReadStart  : out STD_LOGIC;
      WriteStart : out STD_LOGIC;
      ValidCode  : out STD_LOGIC;
      SyncRst    : out STD_LOGIC_VECTOR (15 downto 0);
      SyncMon    : out STD_LOGIC_VECTOR (3 downto 0));
  end component SyncDecode;

  component RstPulsGen is
    Port (Clock : in STD_LOGIC;
      ClkSlow   : in STD_LOGIC;
      TsTdRst   : in STD_LOGIC;
      SubRst    : in STD_LOGIC;
      TsRst     : in STD_LOGIC;
      SyncSrcEn : in STD_LOGIC_VECTOR (7 downto 0);
      WidthSet  : in STD_LOGIC_VECTOR (7 downto 0);
      SyncRst   : in STD_LOGIC_VECTOR (15 downto 0);
      SToutEn   : in STD_LOGIC;
      Reset     : out STD_LOGIC;
      SyncRst_P : out STD_LOGIC;
      SyncRst_N : out STD_LOGIC);
  end component RstPulsGen;

  component SyncSGen is
    Port ( Clock : in STD_LOGIC;
      ClkSlow    : in STD_LOGIC;
      SyncCode   : in STD_LOGIC_VECTOR (7 downto 0);
      SyncDelay  : in STD_LOGIC_VECTOR (7 downto 0);
      SyncCodeEn : in STD_LOGIC;
      ClkCode    : in STD_LOGIC;
      TIBusy     : in STD_LOGIC_VECTOR (8 downto 0);
      SRespTI    : in std_logic_vector(8 downto 0);
      SReqSet    : in std_logic;
      BusySrcEn  : in STD_LOGIC_VECTOR (15 downto 0);
      SyncMode   : in STD_LOGIC;
      Reset      : in STD_LOGIC;
      AutoSyncEn : in STD_LOGIC;
      SyncRegFP  : in STD_LOGIC;
      SyncValid  : out STD_LOGIC;
      TrgSendEn  : out STD_LOGIC;
      SyncOut    : out STD_LOGIC;
      SyncCodedA : out STD_LOGIC;
      SyncCodedB : out STD_LOGIC;
      TestPt     : out STD_LOGIC_VECTOR (7 downto 0));
  end component SyncSGen;

  component SyncHistRead is
    Port ( Clock  : in STD_LOGIC;
      ClkSlow     : in STD_LOGIC;
      SyncMonitor : in STD_LOGIC_VECTOR (15 downto 0);
      ValidTSTD   : in STD_LOGIC;
      ValidSub    : in STD_LOGIC;
      ValidTS     : in STD_LOGIC;
      SCValid     : in STD_LOGIC;
      ResetMem    : in STD_LOGIC;
      ReadEn      : in STD_LOGIC;
      ClkRead     : in STD_LOGIC;
      DataCode    : out STD_LOGIC_VECTOR (39 downto 0));
  end component SyncHistRead;

  signal SyncGlobal : std_logic;
  signal SyncSub    : std_logic;
  signal SyncLpbk   : std_logic;
  signal AlignCnt   : std_logic_vector(59 downto 0);
  signal AlignedSyncG : std_logic;  
  signal AlignedSyncS : std_logic;  
  signal PreAlignedSyncG : std_logic;
  signal PreAlignedSyncS : std_logic;
  signal SigInvertG : std_logic := '0';
  signal SigInvertS : std_logic := '0';
  signal AlignedSyncL : std_logic;  
  signal PulseRstG   : std_logic;
  signal PulseRstS   : std_logic;
  signal PulseRstL   : std_logic;
  signal ValidGCode  : std_logic;  -- Global Sync code valid
  signal ValidSCode  : std_logic;  -- SubSys Sync code valid
  signal ValidLCode  : std_logic;  -- Loopback sync code valid
  signal ValidGenCode : std_logic; -- TImaster/TS generation code valid
  signal GSyncRst   : std_logic_vector(15 downto 0);
  signal SSyncRst   : std_logic_vector(15 downto 0);
  signal LSyncRst   : std_logic_vector(15 downto 0);
  signal SReset     : std_logic_vector(15 downto 0);
  signal SyncMon    : std_logic_vector(15 downto 0);
  signal DlyRst     : std_logic;
  signal DLYRDY     : std_logic_vector(3 downto 0);
  signal DelayRdyG : std_logic;
  signal DelayRdyS : std_logic;
  

begin

-- DelayControl
  IDELAYCTRL_inst : IDELAYCTRL
    generic map (SIM_DEVICE => "ULTRASCALE")  -- Must be set to "ULTRASCALE" 
    port map (RDY => DLYRDY(0),       -- 1-bit output: Ready output
      REFCLK => Clock, -- 1-bit input: Reference clock input
      RST => DlyRst ); -- 1-bit input: Active high reset input. Asynchronous assert, synchronous deassert to REFCLK

  process(Clock)
  begin
    if (Clock'event and Clock = '1') then
      DlyRst <= IODlyRst;
      DLYRDY(1) <= DLYRDY(0);
      DLYRDY(2) <= DLYRDY(1);
      if (SetClkSrc = '1') then
        DLYRDY(3) <= '0';
      elsif (DLYRDY(1) = '1' and DLYRDY(2) = '0') then
        DLYRDY(3) <= '1';
      end if;
    end if;
  end process;
  DlyReady <= DLYRDY(3) and DLYRDY(1);
  StatSync(0) <= DlyRDY(1);
  StatSync(1) <= DlyRDY(3);
-- The TS/TD sync (fiber#1, Global) Sync receiver
  TSTD_SYNC_Receiver : IBUFDS
    port map (O => SyncGlobal, -- 1-bit output: Buffer output
      I  => SyncIn_P,          -- 1-bit input: Diff_p buffer input (connect directly to top-level port)
      IB => SyncIn_N );        -- 1-bit input: Diff_n buffer input (connect directly to top-level port)
--  SyncGlobalPullup : PULLUP
--    port map (O => SyncIn_P );  -- 1-bit output: Pullup output (connect directly to top-level port)
--  SyncGlobalPulldown : PULLDOWN
--    port map (O => SyncIn_N );  -- 1-bit output: Pullup output (connect directly to top-level port)
  GlobalSyncPhase : ClkEdgeAvoid
    Port map(ClkRef => Clock, -- in STD_LOGIC;  -- Reference clock to the Delay elements
      Clock    => Clock,      -- in STD_LOGIC;  -- clock to sync the SigIn
      SigIn    => SyncGlobal, -- in STD_LOGIC;  -- signal to be captured (to avoid the clock edge)
      AlignIn  => VmeRst(11), -- in STD_LOGIC;  -- alignment initiate signal
      SigOut   => PreAlignedSyncG, --  out STD_LOGIC;  -- registered signal (clock edge avoided)
      SigInvert => SigInvertG, --  out std_logic := '0';
      AlignRdy => DelayRdyG, -- TestPt(4), --open, -- DlyReady,     -- out std_logic;  -- alignment ready
      CntDly   => AlignCnt(19 downto 0) ); -- out STD_LOGIC_VECTOR (19 downto 0) );  -- (8:0): Idelay count value
                                           --  (17:9): Odelay value (18): Increament (19): Inc/Decrement enable
  AlignedSyncG <= (SigInvertG xor PreAlignedSyncG);  -- to invert the AlignedSyncG here
  TestPt(3 downto 1) <= AlignedSyncG & AlignedSyncS & VmeRst(11);
  TestPt(8 downto 5) <= PulseRstG & PulseRstS & PulseRstL & Reset;
  StatSync(2) <= DelayRdyG;
  StatSync(3) <= SigInvertG;
  StatSync(4) <= ValidGCode;
  TestPt(4)   <= DelayRdyG;
  GlobalSyncDecode : SyncDecode
    Port map( Clock => Clock, -- in STD_LOGIC;
      ClkSlow => ClkSlow,
      SyncIn  => AlignedSyncG, -- in STD_LOGIC;
      SyncDly => SyncDelay(15 downto 8), -- in STD_LOGIC_VECTOR (7 downto 0);
      Reset   => PulseRstG,       -- out STD_LOGIC;
      ReadStart  => ReadStart,   -- out STD_LOGIC;
      WriteStart => WriteStart, -- out STD_LOGIC;
      ValidCode  => ValidGCode,  -- out STD_LOGIC;
      SyncRst    => GSyncRst(15 downto 0), -- out STD_LOGIC_VECTOR (15 downto 0);
      SyncMon    => SyncMon(3 downto 0) ); -- out STD_LOGIC_VECTOR (3 downto 0));

--    port map (O => SyncIn_N );  -- 1-bit output: Pullup output (connect directly to top-level port)
  SubsysSyncPhase : ClkEdgeAvoid
    Port map(ClkRef => Clock, -- in STD_LOGIC;  -- Reference clock to the Delay elements
      Clock    => Clock,      -- in STD_LOGIC;  -- clock to sync the SigIn
      SigIn    => SyncSub,    -- in STD_LOGIC;  -- signal to be captured (to avoid the clock edge)
      AlignIn  => VmeRst(12), -- in STD_LOGIC;  -- alignment initiate signal
      SigOut   => PreAlignedSyncS,     --  out STD_LOGIC;  -- registered signal (clock edge avoided)
      SigInvert => SigInvertS, --  out std_logic := '0';
      AlignRdy => DelayRdyS, -- open, --DlyReady, -- out std_logic;  -- alignment ready
      CntDly   => AlignCnt(39 downto 20) ); -- out STD_LOGIC_VECTOR (19 downto 0) );  -- (8:0): Idelay count value
                                            --  (17:9): Odelay value (18): Increament (19): Inc/Decrement enable
  AlignedSyncS <= (SigInvertS xor PreAlignedSyncS);  -- to invert the AlignedSyncG here
  StatSync(5) <= DelayRdyS;
  StatSync(6) <= SigInvertS;
  StatSync(7) <= ValidSCode;
  ValidSCode <= '0';
  SSyncRst(15 downto 0) <= x"0000";
-- The Loopback sync Sync receiver
  LoopbackSyncDecode : SyncDecode
    Port map( Clock => Clock,  -- in STD_LOGIC;
      ClkSlow => ClkSlow,
      SyncIn  => AlignedSyncL,  -- in STD_LOGIC;
      SyncDly => SyncDelay(23 downto 16), -- in STD_LOGIC_VECTOR (7 downto 0);
      Reset   => PulseRstL,      -- out STD_LOGIC;
      ReadStart  => TsRdStart,  -- out STD_LOGIC;
      WriteStart => TsWrStart, -- out STD_LOGIC;
      ValidCode  => ValidLCode, -- out STD_LOGIC;
      SyncRst    => LSyncRst(15 downto 0),  -- out STD_LOGIC_VECTOR (15 downto 0);
      SyncMon    => SyncMon(11 downto 8) ); -- out STD_LOGIC_VECTOR (3 downto 0));

-- Combine the three Decoded code together (similar to the RstComb schematics design)
  process (Clock)
  begin            -- should use a generate statement for more concise code
    if (Clock'event and Clock = '1') then 
      SReset(1)  <= (GSyncRst(1)  and SyncSrcEn(1)) or (SSyncRst(1)  and SyncSrcEn(2)) or (LSyncRst(1)  and SyncSrcEn(4));
      SReset(2)  <= (GSyncRst(2)  and SyncSrcEn(1)) or (SSyncRst(2)  and SyncSrcEn(2)) or (LSyncRst(2)  and SyncSrcEn(4));
      SReset(3)  <= (GSyncRst(3)  and SyncSrcEn(1)) or (SSyncRst(3)  and SyncSrcEn(2)) or (LSyncRst(3)  and SyncSrcEn(4));
      SReset(4)  <= (GSyncRst(4)  and SyncSrcEn(1)) or (SSyncRst(4)  and SyncSrcEn(2)) or (LSyncRst(4)  and SyncSrcEn(4));
      SReset(5)  <= (GSyncRst(5)  and SyncSrcEn(1)) or (SSyncRst(5)  and SyncSrcEn(2)) or (LSyncRst(5)  and SyncSrcEn(4));
      SReset(6)  <= (GSyncRst(6)  and SyncSrcEn(1)) or (SSyncRst(6)  and SyncSrcEn(2)) or (LSyncRst(6)  and SyncSrcEn(4));
      SReset(7)  <= (GSyncRst(7)  and SyncSrcEn(1)) or (SSyncRst(7)  and SyncSrcEn(2)) or (LSyncRst(7)  and SyncSrcEn(4));
      SReset(8)  <= (GSyncRst(8)  and SyncSrcEn(1)) or (SSyncRst(8)  and SyncSrcEn(2)) or (LSyncRst(8)  and SyncSrcEn(4));
      SReset(9)  <= (GSyncRst(9)  and SyncSrcEn(1)) or (SSyncRst(9)  and SyncSrcEn(2)) or (LSyncRst(9)  and SyncSrcEn(4));
      SReset(10) <= (GSyncRst(10) and SyncSrcEn(1)) or (SSyncRst(10) and SyncSrcEn(2)) or (LSyncRst(10) and SyncSrcEn(4));
      SReset(11) <= (GSyncRst(11) and SyncSrcEn(1)) or (SSyncRst(11) and SyncSrcEn(2)) or (LSyncRst(11) and SyncSrcEn(4));
      SReset(12) <= (GSyncRst(12) and SyncSrcEn(1)) or (SSyncRst(12) and SyncSrcEn(2)) or (LSyncRst(12) and SyncSrcEn(4));
      SReset(13) <= (GSyncRst(13) and SyncSrcEn(1)) or (SSyncRst(13) and SyncSrcEn(2)) or (LSyncRst(13) and SyncSrcEn(4));
      SReset(14) <= (GSyncRst(14) and SyncSrcEn(1)) or (SSyncRst(14) and SyncSrcEn(2)) or (LSyncRst(14) and SyncSrcEn(4));
    end if;
  end process;
  SReset(0)  <= '0';
  SReset(15) <= '0';
  SResetOut <= SReset;

-- Reset generation
  ResetPulseGeneration : RstPulsGen
    Port map(Clock => Clock, -- in STD_LOGIC;
      ClkSlow   => ClkSlow, -- in STD_LOGIC;
      TsTdRst   => PulseRstG, -- in STD_LOGIC;
      SubRst    => PulseRstS, -- in STD_LOGIC;
      TsRst     => PulseRstL, -- in STD_LOGIC;
      SyncSrcEn => SyncSrcEn(7 downto 0), -- in STD_LOGIC_VECTOR (7 downto 0);
      WidthSet  => ResetWidth(7 downto 0), -- in STD_LOGIC_VECTOR (7 downto 0);
      SyncRst   => SReset(15 downto 0), -- in STD_LOGIC_VECTOR (15 downto 0);
      SToutEn   => TrgSyncOutEn, -- in STD_LOGIC;
      Reset     => Reset, -- out STD_LOGIC;
      SyncRst_P => SyncRst_P, -- out STD_LOGIC;
      SyncRst_N => SyncRst_N );-- out STD_LOGIC);

-- Front panel  inhibit input
  process (Clock)
  begin
    if (Clock'event and Clock = '1') then
      if (SyncSrcEn(3) = '0') then
        TSInhibit <= '0';
      else
        TSInhibit <= FPsync;
      end if;
    end if;
  end process;

-- Sync generation either as TS or TI master
  SyncMasterGen : SyncSGen
    Port map(Clock => Clock,    -- in STD_LOGIC;
      ClkSlow    => ClkSlow,    -- in STD_LOGIC;
      SyncCode   => SyncCodeIn, -- in STD_LOGIC_VECTOR (7 downto 0);
      SyncDelay  => SyncGenDly, -- in STD_LOGIC_VECTOR (7 downto 0);
      SyncCodeEn => SyncCodeEn, -- in STD_LOGIC;
      ClkCode    => ClkVme,     -- in STD_LOGIC;
      TIBusy     => TIBusy,     -- in STD_LOGIC_VECTOR (8 downto 0);
      SRespTI    => SRespTI,    -- in std_logic_vector(8 downto 0);
      SReqSet    => SReqSet,    -- in std_logic;
      BusySrcEn  => BusySrcEn,  -- in STD_LOGIC_VECTOR (15 downto 0);
      SyncMode   => MasterMode(3), -- in STD_LOGIC;
      Reset      => Reset,         --  in STD_LOGIC;
      AutoSyncEn => SyncSrcEn(6),  -- in STD_LOGIC;
      SyncRegFP  => AlignedSyncG,  -- in STD_LOGIC;
      SyncValid  => ValidGenCode,  --  out STD_LOGIC;
      TrgSendEn  => TrgSendEn,     --  out STD_LOGIC;
      SyncOut    => AlignedSyncL,  --  out STD_LOGIC;
      SyncCodedA => SyncCodedA,    -- out STD_LOGIC;
      SyncCodedB => SyncCodedB,    -- out STD_LOGIC;
      TestPt     => open ); --TestPt );        -- out STD_LOGIC_VECTOR (7 downto 0));

  SyncMon(15 downto 12) <= SyncCodeIn(7 downto 4);
  SyncHistoryReadout : SyncHistRead
    Port map(Clock => Clock,       -- in STD_LOGIC;
      ClkSlow     => ClkSlow,      -- in STD_LOGIC;
      SyncMonitor => SyncMon(15 downto 0), -- in STD_LOGIC_VECTOR (15 downto 0);
      ValidTSTD   => ValidGCode,   -- in STD_LOGIC;
      ValidSub    => ValidSCode,   -- in STD_LOGIC;
      ValidTS     => ValidLCode,   -- in STD_LOGIC;
      SCValid     => ValidGenCode, -- in STD_LOGIC;
      ResetMem    => VmeRst(6),    -- in STD_LOGIC;
      ReadEn      => SCReadEn,     -- in STD_LOGIC;
      ClkRead     => ClkVme,       -- in STD_LOGIC;
      DataCode    => SyncCode );   -- out STD_LOGIC_VECTOR (39 downto 0)

  process (ClkVme)
  begin
    if (ClkVme'event and ClkVme = '1') then
      SyncRead(23 downto 20) <= ValidGCode & ValidSCode & ValidLCode & ValidGenCode;
      if (MasterMode(3) = '1') then
        SyncRead(31 downto 24) <= SyncDelay(15 downto 8);
        SyncRead(19 downto 0) <= AlignCnt(19 downto 0);
      elsif (MasterMode(2) = MasterMode(1)) then
        SyncRead(31 downto 24) <= SyncDelay(23 downto 16);
        SyncRead(19 downto 0) <= AlignCnt(19 downto 0);
      else
        SyncRead(31 downto 24) <= SyncDelay(23 downto 16);
        if (MasterMode(1) = '1') then
          SyncRead(19 downto 0) <= AlignCnt(19 downto 0);
        else
          SyncRead(19 downto 0) <= AlignCnt(39 downto 20);
        end if;
      end if;
    end if;
  end process;          
        
end Behavioral;
