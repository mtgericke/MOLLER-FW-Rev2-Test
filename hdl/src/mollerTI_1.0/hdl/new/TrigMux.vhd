----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/05/2020 09:18:29 AM
-- Design Name: 
-- Module Name: TrigMux - Behavioral
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
library UNISIM;
use UNISIM.VComponents.all;

entity TrigMux is
  port ( ClkUsr  : in    std_logic; 
    Clk250       : in    std_logic; 
    GtpRxEn      : in    std_logic_vector (8 downto 0); 
    LBTrig       : in    std_logic_vector (15 downto 0); 
    Reset        : in    std_logic; 
    Rev2TS       : in    std_logic_vector (7 downto 0); 
    SoftSW       : in    std_logic_vector (3 downto 1); 
    SubTrig      : in    std_logic_vector (15 downto 0); 
    TrigCode     : in    std_logic_vector (15 downto 0); 
    TrgLenDly    : in    std_logic_vector (31 downto 0); 
    TrgSrcEn     : in    std_logic_vector (15 downto 0); 
    TrgSrcSet    : in    std_logic; 
    TrgSyncOutEn : in    std_logic; 
    TSrev2TrgIn  : in    std_logic; 
    TsStrobe     : in    std_logic; 
    VmeUpdtEn    : in    std_logic; 
    AddTrgType   : out   std_logic_vector (16 downto 0); 
    DSyncEvt     : out   std_logic; 
    EvtTypeOut   : out   std_logic_vector (7 downto 0); 
    L1Trged      : out   std_logic; 
    NewBlkSize   : out   std_logic_vector (31 downto 0); 
    RegTrgTime   : out   std_logic; 
    SyncEvt      : out   std_logic; 
    TestPt       : out   std_logic_vector (4 downto 1); 
    TrgStat      : out   std_logic_vector (7 downto 0); 
    Trg1Ack      : out   std_logic; 
    Trg2Ack      : out   std_logic; 
    Trigger1     : out   std_logic; 
    Trigger2     : out   std_logic; 
    TSrev2Sync   : out   std_logic; 
    UpdateBS     : out   std_logic; 
    UpdateBuf    : out   std_logic  );
end TrigMux;

architecture Behavioral of TrigMux is
  component  TrigWordDecode is
    Port (TrigCode : in std_logic_vector(15 downto 0);
      TrigCodeEn   : in std_logic;
      SubTsEn      : in std_logic_vector(4 downto 1);
      Trigger1     : out std_logic;
      Trigger2     : out std_logic;
      TrigSync     : out std_logic;
      SubTsTrig    : out std_logic  );
  end component TrigWordDecode;

  component TrigPulCond is
    Port (Clock : in STD_LOGIC;  -- 250 MHz
      ClkUsr    : in STD_LOGIC;  -- 62.5 MHz
      TrigIn    : in STD_LOGIC;
      WidthSet  : in STD_LOGIC_VECTOR (7 downto 0);
      TrigQuadL : in STD_LOGIC;
      TrigQuadH : in STD_LOGIC;
      TrigOut   : out STD_LOGIC;
      TrigAck   : out STD_LOGIC;
      Reset     : in std_logic );
  end component TrigPulCond;

  component ReadOutType is
    Port (SDTrg : in  STD_LOGIC;
      TS2Trg  : in  STD_LOGIC;
      Clock   : in std_logic;
      SDType  : in  STD_LOGIC_VECTOR (7 downto 0);
      TS2Type : in  STD_LOGIC_VECTOR (7 downto 0);
      OutType : out  STD_LOGIC_VECTOR (7 downto 0)  );
  end component ReadOutType;

  COMPONENT TriggerDelay
    PORT(TrgAIn : IN std_logic;
      Clock   : IN std_logic;
      TrgADly : IN std_logic_vector(7 downto 0);          
      TrgAOut : OUT std_logic );
  END COMPONENT;

  component EvtType is
    Port (TrgCode : in  STD_LOGIC_VECTOR (15 downto 0);
      LBCode    : in  STD_LOGIC_VECTOR (15 downto 0);
      SubCode   : in std_logic_vector (15 downto 0);
      TrgSrcEn  : in std_logic_vector (15 downto 0);
      ClkUsr    : in  STD_LOGIC;
      SelTS      : in std_logic;
      SelSub    : in std_logic;
      SelLB     : in  STD_LOGIC;
      SubTS     : in std_logic;
      AddTrgType : out std_logic_vector(16 downto 0);
      EvtTypeOut : out  STD_LOGIC_VECTOR (7 downto 0) );
  end component EvtType;

  signal PreQuadL    : std_logic := '0';
  signal PreQuadH    : std_logic := '0';
  signal TrigQuadL   : std_logic := '0';
  signal TrigQuadL2  : std_logic := '0';
  signal TrigQuadLS  : std_logic := '0';
  signal TrigQuadH   : std_logic := '0';
  signal TrigQuadH2  : std_logic := '0';
  signal TrigQuadHS  : std_logic := '0';
  signal BlockSizeSet : std_logic_vector(11 downto 0);
  signal BlockSizeEn   : std_logic;
  signal LBTrigBSEn    : std_logic;
  signal SubTrigBSEn   : std_logic;
  signal TrigCodeBSEn  : std_logic;
  signal BufferSizeEn   : std_logic;
  signal LBTrigBufEn    : std_logic;
  signal SubTrigBufEn   : std_logic;
  signal TrigCodeBufEn  : std_logic;
  signal TSTrigSync  : std_logic;
  signal TSTrigO1    : std_logic := '0';
  signal TSTrigO2    : std_logic := '0';
  signal TSPartTrig  : std_logic := '0';
  signal LBTrigSync  : std_logic := '0';
  signal LBTrigO1    : std_logic := '0';
  signal LBTrigO2    : std_logic := '0';
  signal SubTrigSync : std_logic := '0';
  signal SubTrigO1   : std_logic := '0';
  signal SubTrigO2   : std_logic := '0';
  signal EvtTypeM    : std_logic_vector(7 downto 0);
  signal MasterMode  : std_logic;
  signal HFBRSel     : std_logic;
  signal Trig1       : std_logic;
  signal Trig2       : std_logic;
  signal TrigSync    : std_logic;
  signal NewBlockSize : std_logic_vector(31 downto 0):= x"01010101";
  signal DlyBSEn    : std_logic_vector(3 downto 0);
  signal BlkSizeUD  : std_logic;
  signal DlySyncEvt : std_logic;
  signal Dly250SyncEvt : std_logic;
  signal SyncEvtInt : std_logic;
  signal InstUpdate : std_logic;
  signal InstUDBuf  : std_logic;
  signal DlyBufEn   : std_logic_vector(3 downto 0);
  signal BufSizeUD  : std_logic;
  signal L1TimeTrig : std_logic;
  signal DlyL1TimeTrig : std_logic;
  signal SDTrigRead : std_logic;
  signal SDTrig1  : std_logic;
  signal SDTrig2  : std_logic;
  signal DlydTrig1  : std_logic;
  signal DlydTrig2  : std_logic;
-- TI Rev2 related trigger/strobe
  signal Rev2Trig   : std_logic;
  signal TSRev2Strb  : std_logic;
  signal TS2Data     : std_logic_vector(7 downto 0);
  signal TrueTSrev2Read : std_logic;
  signal RegTsStrobe  : std_logic;
  signal DlyTsRev2Strb : std_logic;
  signal TsRev2Read   : std_logic;
  signal ForcedSync   : std_logic;
  signal FPTrigRcvd  : std_logic;
  signal PreFPTrig   : std_logic;
  signal DlyFPTrigRcvd : std_logic;
  signal DlyFPTrig   : std_logic;
  signal Rev2TrigRst : std_logic;
  signal TSrev2SyncInt : std_logic;
  signal Pre2TSr2Sync  : std_logic;
  signal PreTSr2Sync   : std_logic;

--Read Out Trigger signals
  signal ReadTrig1 : std_logic;
  signal Read250Trig : std_logic;
  signal ReadTrigAdj : std_logic;
  signal DlyRTrigAdj : std_logic;
  
begin

-- Trigger decoding
  TsTdTriggerDecoding : TrigWordDecode
    Port map(TrigCode => TrigCode,  -- in std_logic_vector(15 downto 0);
      TrigCodeEn   => GtpRxEn(1),   -- in std_logic;
      SubTsEn      => TrgSrcEn(15 downto 12), -- in std_logic_vector(4 downto 1);
      Trigger1     => TSTrigO1,     -- out std_logic;
      Trigger2     => TSTrigO2,     -- out std_logic;
      TrigSync     => TSTrigSync,   -- out std_logic;
      SubTsTrig    => TSPartTrig ); -- out std_logic  );
  
  LoopBackTriggerDecoding : TrigWordDecode
    Port map(TrigCode => LBTrig,  -- in std_logic_vector(15 downto 0);
      TrigCodeEn   => GtpRxEn(0), -- in std_logic;
      SubTsEn      => TrgSrcEn(15 downto 12), -- in std_logic_vector(4 downto 1);
      Trigger1     => LBTrigO1,   -- out std_logic;
      Trigger2     => LBTrigO2,   -- out std_logic;
      TrigSync     => LBTrigSync, -- out std_logic;
      SubTsTrig    => open    );  -- out std_logic  );
   SubTSTriggerDecoding : TrigWordDecode
    Port map(TrigCode => SubTrig,  -- in std_logic_vector(15 downto 0);
      TrigCodeEn   => GtpRxEn(5),  -- in std_logic;
      SubTsEn      => TrgSrcEn(15 downto 12), -- in std_logic_vector(4 downto 1);
      Trigger1     => SubTrigO1,   -- out std_logic;
      Trigger2     => SubTrigO2,   -- out std_logic;
      TrigSync     => SubTrigSync, -- out std_logic;
      SubTsTrig    => open );      -- out std_logic  );
-- Trigger combinations
  Trig1 <= TSPartTrig or (TSTrigO1 and TrgSrcEn(1)) or
          (LBTrigO1 and TrgSrcEn(2)) or (SubTrigO1 and TrgSrcEn(10));
  Trig2 <=(TSTrigO2 and TrgSrcEn(1)) or    -- SubTrig: Fiber#5
          (LBTrigO2 and TrgSrcEn(2)) or (SubTrigO2 and TrgSrcEn(10));
  TrigSync <= (TSTrigSync and TrgSrcEn(1)) or
              (LBTrigSync and TrgSrcEn(2)) or (SubTrigSync and TrgSrcEn(10));
          
  MasterMode <= (SoftSW(1) xnor SoftSW(2)) and (not SoftSW(3));
  HFBRSel <= SoftSW(1) and (not SoftSW(2));
  process (MasterMode, HFBRSel, LBTrig, SubTrig, TrigCode, GtpRxEn, LBTrigBSEn,
           LBTrigBufEn, SubTrigBSEn, SubTrigBufEn, TrigCodeBSEn, TrigCodeBufEn)
  begin
    TrigCodeBufEn <= GtpRxEN(1) and (not TrigCode(15)) and TrigCode(14)
                and (not TrigCode(13)) and TrigCode(12) and TrigCode(11)
                and TrigCode(10) and (not TrigCode(9)) and (not TrigCode(8));
    TrigCodeBSEn <= GtpRxEN(1) and (not TrigCode(15)) and TrigCode(14)
                and (not TrigCode(13)) and TrigCode(12) and TrigCode(11)
                and (not TrigCode(10)) and (not TrigCode(9)) and (not TrigCode(8));
    LBTrigBufEn <= GtpRxEN(0) and (not LBTrig(15)) and LBTrig(14)
                and (not LBTrig(13)) and LBTrig(12) and LBTrig(11)
                and LBTrig(10) and (not LBTrig(9)) and (not LBTrig(8));
    LBTrigBSEn <= GtpRxEN(0) and (not LBTrig(15)) and LBTrig(14)
                and (not LBTrig(13)) and LBTrig(12) and LBTrig(11)
                and (not LBTrig(10)) and (not LBTrig(9)) and (not LBTrig(8));
    SubTrigBufEn <= GtpRxEN(5) and (not SubTrig(15)) and SubTrig(14)
                and (not SubTrig(13)) and SubTrig(12) and SubTrig(11)
                and SubTrig(10) and (not SubTrig(9)) and (not SubTrig(8));
    SubTrigBSEn <= GtpRxEN(5) and (not SubTrig(15)) and SubTrig(14)
                and (not SubTrig(13)) and SubTrig(12) and SubTrig(11)
                and (not SubTrig(10)) and (not SubTrig(9)) and (not SubTrig(8));
    if (MasterMode = '1') then
      PreQuadL <= LBTrig(10);
      PreQuadH <= LBTrig(11);
      BlockSizeSet(11 downto 0) <= LBTrig(11 downto 0);
      BlockSizeEn  <= LBTrigBSEn;
      BufferSizeEn <= LBTrigBufEn;
    elsif (HFBRSel = '1') then
      PreQuadL <= SubTrig(10);
      PreQuadH <= SubTrig(11);
      BlockSizeSet(11 downto 0) <= SubTrig(11 downto 0);
      BlockSizeEn  <= SubTrigBSEn;
      BufferSizeEn <= SubTrigBufEn;
    else 
      PreQuadL <= TrigCode(10);
      PreQuadH <= TrigCode(11);
      BlockSizeSet(11 downto 0) <= TrigCode(11 downto 0);
      BlockSizeEn  <= TrigCodeBSEn;
      BufferSizeEn <= TrigCodeBufEn;
    end if;
  end process;
  

  process (ClkUsr)
  begin
    if (ClkUsr'event and ClkUsr = '1') then
      if (Trig1 = '1') then
        TrigQuadL <= PreQuadL;
        TrigQuadH <= PreQuadH;
      end if;
      if (Trig2 = '1') then
        TrigQuadL2 <= PreQuadL;
        TrigQuadH2 <= PreQuadH;
      end if;
      if (TrigSync = '1') then
        TrigQuadLS <= PreQuadL;
        TrigQuadHS <= PreQuadH;
      end if;
      if (BlockSizeEn = '1') then
        NewBlockSize(15 downto 8) <= BlockSizeSet(7 downto 0);
      end if;
      if (BlkSizeUD = '1' or TrgSrcSet = '1' or InstUpdate = '1' or DlySyncEvt = '1') then
        NewBlockSize(7 downto 0) <= NewBlockSize(15 downto 8);
      end if;
      if (BufferSizeEn = '1') then
        NewBlockSize(31 downto 24) <= BlockSizeSet(7 downto 0);
      end if;
      if (BufSizeUD = '1' or TrgSrcSet = '1' or InstUDBuf = '1' or DlySyncEvt = '1') then
        NewBlockSize(23 downto 16) <= NewBlockSize(31 downto 24);
      end if;

      if (Reset = '1') then
        TrgStat(5 downto 0) <= (others => '0');
      else
        if (TSTrigO1 = '1') then
          TrgStat(0) <= '1';
        end if;
        if (TSTrigO2 = '1') then
          TrgStat(1) <= '1';
        end if;
        if (LBTrigO1 = '1') then
          TrgStat(2) <= '1';
        end if;
        if (LBTrigO2 = '1') then 
          TrgStat(3) <= '1';
        end if;
        if (SubTrigO1 = '1') then
          TrgStat(4) <= '1';
        end if;
        if (SubTrigO2 = '1') then
          TrgStat(5) <= '1';
        end if;
      end if;
      InstUpdate <= VmeUpdtEn and BlockSizeEn;
      InstUDBuf  <= VmeUpdtEn and BufferSizeEn;
  
      if (Reset = '1' or BlkSizeUD = '1') then
        DlyBSEn(1) <= '0';
        BlkSizeUD  <= '0';
      else
        DlyBSEn(1) <= BlockSizeEn;
        BlkSizeUD  <= DlyBSEn(1);
      end if;
      DlyBSEn(2) <= DlyBSEn(1);
      DlyBSEn(3) <= DlyBSEn(2);
      UpdateBS <= DlyBSEn(3);

      if (Reset = '1' or BufSizeUD = '1') then
        DlyBufEn(1) <= '0';
        BufSizeUD  <= '0';
      else
        DlyBufEn(1) <= BufferSizeEn;
        BufSizeUD  <= DlyBufEn(1);
      end if;
      DlyBufEn(2) <= DlyBufEn(1);
      DlyBufEn(3) <= DlyBufEn(2);
      UpdateBuf <= DlyBufEn(3);
      
      SyncEvtInt <= TrigSync;
      ReadTrig1 <= Trig1;

    end if;
  end process;
  NewBlkSize(31 downto 0) <= NewBlockSize(31 downto 0);
  L1TimeTrig <= SDTrigRead or Rev2Trig;
  SyncEvt <= SyncEvtInt;
  -- SyncEvt delay
  SyncEvtDelay : SRLC32E
    generic map (INIT => X"00000000", -- Initial contents of shift register
      IS_CLK_INVERTED => '0' )        -- Optional inversion for CLK
    port map (Q => DlySyncEvt,  -- 1-bit output: SRL Data
      Q31  => open ,            -- 1-bit output: SRL Cascade Data
      A    => "01010",          -- 5-bit input: Selects SRL depth
      CE   => '1',              -- 1-bit input: Clock enable
      CLK  => ClkUsr,           -- 1-bit input: Clock
      D    => SyncEvtInt );     -- 1-bit input: SRL Data
  -- SyncEvt delay in Clk250 domain
  process (Clk250)
  begin
    if (CLk250'event and Clk250 = '1') then
      Dly250SyncEvt <= SyncEvtInt;
      Read250Trig <= ReadTrig1;
      DlyRTrigAdj <= ReadTrigAdj;
      SDTrigRead  <= ReadTrigAdj and (not DlyRTrigAdj);
      if (Reset = '1') then
        DlyL1TimeTrig <= '0';
        RegTrgTime <= '0';
      else
        DlyL1TimeTrig <= L1TimeTrig;
        RegTrgTime <= L1TimeTrig and (not DlyL1TimeTrig);
      end if;
      if (Reset = '1') then
        Trigger1 <= '0';
        Trigger2 <= '0';
      else
        Trigger1 <= TrgSyncOutEn and (Rev2Trig or SDTrig1);
        Trigger2 <= TrgSyncOutEn and SDTrig2;
      end if;
    end if;
  end process;
  L1Trged <= SDTrigRead or TrueTSrev2Read;
  
  SyncEvtDelayInClk250 : SRLC32E
    generic map (INIT => X"00000000", -- Initial contents of shift register
      IS_CLK_INVERTED => '0' )        -- Optional inversion for CLK
    port map (Q     => DSyncEvt,  -- 1-bit output: SRL Data
      Q31           => open ,     -- 1-bit output: SRL Cascade DataF
      A(0)          => TrigQuadLS,
      A(1)          => TrigQuadHS,
      A(4 downto 2) => "000",   -- 5-bit input: Selects SRL depth
      CE   => '1',              -- 1-bit input: Clock enable
      CLK  => Clk250,           -- 1-bit input: Clock
      D    => DLy250SyncEvt );  -- 1-bit input: SRL Data
  ReadOutTrigAdjust : SRLC32E
    generic map (INIT => X"00000000", -- Initial contents of shift register
      IS_CLK_INVERTED => '0' )        -- Optional inversion for CLK
    port map (Q => ReadTrigAdj,  -- 1-bit output: SRL Data
      Q31  => open ,             -- 1-bit output: SRL Cascade Data
      A(0) => TrigQuadL,
      A(1) => TriGQuadH,
      A(4 downto 2) => "000",   -- 5-bit input: Selects SRL depth
      CE   => '1',              -- 1-bit input: Clock enable
      CLK  => Clk250,           -- 1-bit input: Clock
      D    => Read250Trig );    -- 1-bit input: SRL Data
-- Trigger Output Delay
  
-- Event Type
  EventTypeComb : EvtType
    Port map(TrgCode => TrigCode, -- in  STD_LOGIC_VECTOR (15 downto 0);
      LBCode     => LBTrig,       -- in  STD_LOGIC_VECTOR (15 downto 0);
      SubCode    => SubTrig,      -- in std_logic_vector (15 downto 0);
      TrgSrcEn   => TrgSrcEn(15 downto 0), -- in std_logic_vector (15 downto 0);
      ClkUsr     => ClkUsr,       -- in  STD_LOGIC;
      SelTS       => TSTrigO1,     -- in std_logic;
      SelSub     => SubTrigO1,    -- in std_logic;
      SelLB      => LBTrigO1,     -- in  STD_LOGIC;
      SubTS      => TSPartTrig,   -- in std_logic;
      AddTrgType => AddTrgType(16 downto 0), -- out std_logic_vector(16 downto 0);
      EvtTypeOut => EvtTypeM(7 downto 0) );  -- out  STD_LOGIC_VECTOR (7 downto 0) );
-- Delay triggers
  Trigger1Delay : TriggerDelay
    PORT MAP(TrgAIn => Trig1,           -- IN std_logic;
      Clock => ClkUsr,                  -- IN std_logic;
      TrgADly => TrgLenDly(7 downto 0), -- IN std_logic_vector(7 downto 0);          
      TrgAOut => DlydTrig1 );           -- OUT std_logic );
  Trigger2Delay : TriggerDelay
    PORT MAP(TrgAIn => Trig2,             -- IN std_logic;
      Clock => ClkUsr,                    -- IN std_logic;
      TrgADly => TrgLenDly(23 downto 16), -- IN std_logic_vector(7 downto 0);          
      TrgAOut => DlydTrig2 );             -- OUT std_logic );
-- Trigger Pulse Conditioning
  Trigger1PulseCondition : TrigPulCond
    Port map(Clock => Clk250, -- in STD_LOGIC;  -- 250 MHz
      ClkUsr    => ClkUsr,    -- in STD_LOGIC;  -- 62.5 MHz
      TrigIn    => DlydTrig1, -- in STD_LOGIC;
      WidthSet  => TrgLenDly(15 downto 8), -- in STD_LOGIC_VECTOR (7 downto 0);
      TrigQuadL => TrigQuadL, -- in STD_LOGIC;
      TrigQuadH => TrigQuadH, -- in STD_LOGIC;
      TrigOut   => SDTrig1,   -- out STD_LOGIC;
      TrigAck   => Trg1Ack,   --  out STD_LOGIC;
      Reset     => Reset   ); --  in std_logic
  Trigger2PulseCondition : TrigPulCond
    Port map(Clock => Clk250, -- in STD_LOGIC;  -- 250 MHz
      ClkUsr    => ClkUsr,    -- in STD_LOGIC;  -- 62.5 MHz
      TrigIn    => DlydTrig2, -- in STD_LOGIC;
      WidthSet  => TrgLenDly(31 downto 24), -- in STD_LOGIC_VECTOR (7 downto 0);
      TrigQuadL => TrigQuadL2, -- in STD_LOGIC;
      TrigQuadH => TrigQuadH2, -- in STD_LOGIC;
      TrigOut   => SDTrig2,   -- out STD_LOGIC;
      TrigAck   => Trg2Ack,   --  out STD_LOGIC;
      Reset     => Reset   ); --  in std_logic

 -- Readout Event type
  ReadOutEventType : ReadOutType
    Port map(SDTrg => SDTrigRead, -- in  STD_LOGIC;
      TS2Trg  => TSRev2Strb, -- in  STD_LOGIC;
      Clock   => Clk250,     -- in std_logic;
      SDType  => EvtTypeM,   -- in  STD_LOGIC_VECTOR (7 downto 0);
      TS2Type => TS2Data(7 downto 0),      -- in  STD_LOGIC_VECTOR (7 downto 0);
      OutType => EvtTypeOut(7 downto 0) ); -- out  STD_LOGIC_VECTOR (7 downto 0) 

-- TSrev2 Trigger logic
  Ts2Data <= not Rev2Ts;
  ForcedSync <= Rev2TS(7) and Rev2TS(6) and Rev2TS(5) and Rev2TS(4) and Rev2TS(3) and Rev2TS(2) and (not Rev2TS(0));
  process (Clk250)
  begin
    if (Clk250'event and Clk250 = '1') then
      if (TrgSrcEn(6) = '1') then
        RegTsStrobe <= not TsStrobe;
      end if;
      if (Reset = '1') then
        TsRev2Strb <= '0';
        FPTrigRcvd <= '0';
        PreFPTrig  <= '0';
      elsif (TrgSrcEn(6) = '1') then
        TsRev2Strb <= RegTsStrobe and (not TsStrobe);
        FPTrigRcvd <= TsRev2TrgIn;
        PreFPTrig  <= FPTrigRcvd and DlyFPTrigRcvd;
      end if;
      DlyFPTrigRcvd <= FPTrigRcvd;
      DlyTsRev2Strb <= TsRev2Strb;
      TsRev2Read <= TsRev2Strb and (not DlyTsRev2Strb);
      if (Reset = '1' or Rev2TrigRst = '1') then
        Rev2Trig <= '0';
      elsif (DlyFPTrig = '1') then
        Rev2Trig <= '1';
      end if;
      if (TSrev2SyncInt = '1') then
        Pre2TSr2Sync <= '0';
      elsif (TSrev2Read = '1') then
        Pre2TSr2Sync <= not Rev2TS(0);
      end if;
    end if;
  end process;
  TrueTSrev2Read <= TsRev2Read and (not ForcedSync);
-- TSrev2 trigger Delay
  TSrev2TriggerDelay : TriggerDelay
    PORT MAP(TrgAIn => PreFPTrig,       -- IN std_logic;
      Clock => Clk250,                  -- IN std_logic;
      TrgADly => TrgLenDly(7 downto 0), -- IN std_logic_vector(7 downto 0);          
      TrgAOut => DlyFPTrig );           -- OUT std_logic );
  Rev2TriggerWidth : SRLC32E
    generic map (INIT => X"00000000", -- Initial contents of shift register
      IS_CLK_INVERTED => '0' )        -- Optional inversion for CLK
    port map (Q => Rev2TrigRst,  -- 1-bit output: SRL Data
      Q31  => open ,             -- 1-bit output: SRL Cascade Data
      A    => TrgLenDly(12 downto 8),   -- 5-bit input: Selects SRL depth
      CE   => '1',              -- 1-bit input: Clock enable
      CLK  => Clk250,           -- 1-bit input: Clock
      D    => Rev2Trig );    -- 1-bit input: SRL Data
  process(ClkUsr)
  begin
    if (CLkUsr'event and ClkUsr = '1') then
      PreTSr2Sync <= Pre2TSr2Sync;
      if (Reset = '1') then
        TSrev2SyncInt <= '0';
      else
        TSrev2SyncInt <= Pre2TSr2Sync and (not PreTSr2Sync);
      end if;
    end if;
  end process;
  TSrev2Sync <= TSrev2SyncInt;
  TestPt(4 downto 1) <= SDTrig1 & Trig1 & SDTrig2 & Trig2;
end Behavioral;
