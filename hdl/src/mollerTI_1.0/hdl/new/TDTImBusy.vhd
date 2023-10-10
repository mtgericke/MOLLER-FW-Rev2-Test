----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/28/2020 03:22:04 PM
-- Design Name: 
-- Module Name: TDTImBusy - Behavioral
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
use IEEE.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity TDTImBusy is
  port (BlockTh : in    std_logic_vector (7 downto 0); 
    BusySrcEn   : in    std_logic_vector (15 downto 0); 
    ClkVme      : in    std_logic; 
    Clk625      : in    std_logic; 
    ClkRead     : in    std_logic;
    CountLatch  : in    std_logic; 
    CountReset  : in    std_logic; 
    GTPRxEn     : in    std_logic_vector (8 downto 0); 
    LpBkEn      : in    std_logic; 
    PulseTrig   : in    std_logic; 
    ReadAen     : in    std_logic; 
    ReadBen     : in    std_logic; 
    Reset       : in    std_logic; 
    ResetFS     : in    std_logic; 
    ROCEN       : in    std_logic_vector (31 downto 0); 
    StatusA     : in    std_logic_vector (15 downto 0); 
    StatusB     : in    std_logic_vector (15 downto 0); 
    StatusC     : in    std_logic_vector (15 downto 0); 
    StatusD     : in    std_logic_vector (15 downto 0); 
    StatusE     : in    std_logic_vector (15 downto 0); 
    StatusF     : in    std_logic_vector (15 downto 0); 
    StatusG     : in    std_logic_vector (15 downto 0); 
    StatusH     : in    std_logic_vector (15 downto 0); 
    StatusZ     : in    std_logic_vector (15 downto 0); 
    SyncBlkEnd  : in    std_logic; 
    TempBusy    : in    std_logic; 
    TSInhibit   : in    std_logic; 
    BoardRdy    : out   std_logic_vector (8 downto 0); 
    BusyCounter : out   std_logic_vector (319 downto 0); 
    BusyTI      : out   std_logic_vector (8 downto 0); 
    ExtraAck    : out   std_logic; 
    ReadAout    : out   std_logic_vector (35 downto 0); 
    ReadBout    : out   std_logic_vector (35 downto 0); 
    SReqSet     : out   std_logic; 
    SRespTI     : out   std_logic_vector (8 downto 0); 
    TestPt      : out   std_logic_vector (4 downto 1); 
    TIBusy      : out   std_logic_vector (8 downto 0); 
    TIinfo      : out   std_logic_vector (287 downto 0); 
    TIResetReq  : out   std_logic_vector (8 downto 0); 
    TrgLossBusy : out   std_logic; 
    TSBusy      : out   std_logic; 
    TsReadB     : out   std_logic_vector (159 downto 0));
end TDTImBusy;

architecture Behavioral of TDTImBusy is

  component BusyCode is
    port (Clock  : in    std_logic; 
      GTPRxEn    : in    std_logic; 
      ResetFS    : in    std_logic; 
      Status     : in    std_logic_vector (15 downto 0); 
      BlkAckd    : out   std_logic; 
      BlkRcvd    : out   std_logic; 
      BoardID    : out   std_logic_vector (7 downto 0); 
      BrdReady   : out   std_logic; 
      BusyTI     : out   std_logic; 
      NewBlkSize : out   std_logic_vector (7 downto 0); 
      NewBufSize : out   std_logic_vector (7 downto 0); 
      SRstReq    : out   std_logic; 
      TestPt     : out   std_logic_vector (4 downto 1); 
      TrgSrc     : out   std_logic_vector (7 downto 0); 
      TrigRcvd   : out   std_logic);
  end component BusyCode;
  component TrigCheck is
    Port (Clock : in STD_LOGIC;
      NewBlock : in STD_LOGIC;
      BlkRcvd : in STD_LOGIC;
      BlkAckd : in STD_LOGIC;
      TrigRcvd : in STD_LOGIC;
      PulseTrig : in STD_LOGIC;
      Reset : in STD_LOGIC;
      BusyTh : in STD_LOGIC_VECTOR (7 downto 0);
      BusyTrig : out STD_LOGIC;
      TooManyAck : out std_logic;
      BlockSent : out STD_LOGIC_VECTOR (7 downto 0);
      BlockDiff : out STD_LOGIC_VECTOR (7 downto 0);
      BusyBlk : out STD_LOGIC);
  end component TrigCheck;
  component BusyCount is
    Port (Clock : in  STD_LOGIC;
      Enable : in  STD_LOGIC;
      Latch : in  STD_LOGIC;
      Reset : in  STD_LOGIC;
      COUT : out  STD_LOGIC_VECTOR (31 downto 0));
  end component BusyCount;

  component FiberFifo is
    port ( DataA : in std_logic_vector(15 downto 0);
      DataB : in std_logic_vector(15 downto 0);
      WriteA : in std_logic;
      WriteB : in std_logic;
      ClkW   : in std_logic;
      ClkR   : in std_logic;
      ReadAen : in std_logic;
      ReadBen : in std_logic;
      Reset   : in std_logic;
      outA    : out std_logic_vector(35 downto 0);
      outB    : out std_logic_vector(35 downto 0) );
  end component;

  signal DStatusA : std_logic_vector(15 downto 0);
  signal DStatusB : std_logic_vector(15 downto 0);
  signal DStatusC : std_logic_vector(15 downto 0);
  signal DStatusD : std_logic_vector(15 downto 0);
  signal DStatusE : std_logic_vector(15 downto 0);
  signal DStatusF : std_logic_vector(15 downto 0);
  signal DStatusG : std_logic_vector(15 downto 0);
  signal DStatusH : std_logic_vector(15 downto 0);
  signal DStatusZ : std_logic_vector(15 downto 0);
  signal DWriteEn  : std_logic_vector(8 downto 0);
  signal SRstReqTI : std_logic_vector(8 downto 0);
  signal ResetReqInt : std_logic_vector(8 downto 0);
  signal TrigRcvd  : std_logic_vector(8 downto 0);
  signal BlkRcvd   : std_logic_vector(8 downto 0);
  signal BlkAckd   : std_logic_vector(8 downto 0);
  signal BusyTICode : std_logic_vector(8 downto 0);
--  signal NewBlkSizeA : std_logic_vector(7 downto 0);
--  signal NewBlkSizeB : std_logic_vector(7 downto 0);
--  signal NewBlkSizeC : std_logic_vector(7 downto 0);
--  signal NewBlkSizeD : std_logic_vector(7 downto 0);
--  signal NewBlkSizeE : std_logic_vector(7 downto 0);
--  signal NewBlkSizeF : std_logic_vector(7 downto 0);
--  signal NewBlkSizeG : std_logic_vector(7 downto 0);
--  signal NewBlkSizeH : std_logic_vector(7 downto 0);
--  signal NewBlkSizeZ : std_logic_vector(7 downto 0);
--  signal NewBufSizeA : std_logic_vector(7 downto 0);
--  signal NewBufSizeB : std_logic_vector(7 downto 0);
--  signal NewBufSizeC : std_logic_vector(7 downto 0);
--  signal NewBufSizeD : std_logic_vector(7 downto 0);
--  signal NewBufSizeE : std_logic_vector(7 downto 0);
--  signal NewBufSizeF : std_logic_vector(7 downto 0);
--  signal NewBufSizeG : std_logic_vector(7 downto 0);
--  signal NewBufSizeH : std_logic_vector(7 downto 0);
--  signal NewBufSizeZ : std_logic_vector(7 downto 0);
--  signal NewTrgSrcA : std_logic_vector(7 downto 0);
--  signal NewTrgSrcB : std_logic_vector(7 downto 0);
--  signal NewTrgSrcC : std_logic_vector(7 downto 0);
--  signal NewTrgSrcD : std_logic_vector(7 downto 0);
--  signal NewTrgSrcE : std_logic_vector(7 downto 0);
--  signal NewTrgSrcF : std_logic_vector(7 downto 0);
--  signal NewTrgSrcG : std_logic_vector(7 downto 0);
--  signal NewTrgSrcH : std_logic_vector(7 downto 0);
--  signal NewTrgSrcZ : std_logic_vector(7 downto 0);
--  signal BoardIDA  : std_logic_vector(7 downto 0);
--  signal BoardIDB  : std_logic_vector(7 downto 0);
--  signal BoardIDC  : std_logic_vector(7 downto 0);
--  signal BoardIDD  : std_logic_vector(7 downto 0);
--  signal BoardIDE  : std_logic_vector(7 downto 0);
--  signal BoardIDF  : std_logic_vector(7 downto 0);
--  signal BoardIDG  : std_logic_vector(7 downto 0);
--  signal BoardIDH  : std_logic_vector(7 downto 0);
--  signal BoardIDZ  : std_logic_vector(7 downto 0);
-- outputs from the TrigCheck block
  signal BusyTrig : std_logic_vector(8 downto 0);
  signal BusyBlk  : std_logic_vector(8 downto 0);
  signal TooManyAck : std_logic_vector(8 downto 0);
  signal TooManyCom : std_logic;
  signal TooManyCnt : std_logic_vector(15 downto 0) := (others => '0');
  signal BlockSent : std_logic_vector(71 downto 0);
  signal BlockDiff : std_logic_vector(71 downto 0);
-- The Busy counter
  signal TIBusyInt : std_logic_vector(8 downto 0);
--  signal BusyCounter : std_logic_vector(319 downto 0);
  signal TsThEnable : std_logic;
  signal TrgLossbusyInt : std_logic;
  
begin

  TsThEnable <= BlockTh(0) or BlockTh(1) or BlockTh(2) or BlockTh(3) or 
                BlockTh(4) or BlockTh(5) or BlockTh(6) or BlockTh(7); 
-- register the Status inputs
  process (Clk625)
  begin
    if (Clk625'event and Clk625 = '1') then
      DStatusA <= StatusA;
      DStatusB <= StatusB;
      DStatusC <= StatusC;
      DStatusD <= StatusD;
      DStatusE <= StatusE;
      DStatusF <= StatusF;
      DStatusG <= StatusG;
      DStatusH <= StatusH;
      DStatusZ <= StatusZ;
      DWriteEn <= GTPRxEn(8 downto 0);
      ExtraAck <= BlkAckd(1) or TooManyCom;
      if (Reset = '1') then
        TooManyCnt <= (others => '0');
        ResetReqInt <= (others =>'0');
      else
        if (TooManyCom = '1') then
          TooManyCnt <= TooManyCnt + 1;
        end if;
--        ResetReqTIrepeat :
--        for iti in 0 to 8 generate
--        begin
--          if (SRstReqTI(iti) = '1') then
--            ResetReqInt(iti) <= '1';
--          end if;
--        end generate;
        if (SRstReqTI(0) = '1') then
          ResetReqInt(0) <= '1';
        end if;
        if (SRstReqTI(1) = '1') then
          ResetReqInt(1) <= '1';
        end if;
        if (SRstReqTI(2) = '1') then
          ResetReqInt(2) <= '1';
        end if;
        if (SRstReqTI(3) = '1') then
          ResetReqInt(3) <= '1';
        end if;
        if (SRstReqTI(4) = '1') then
          ResetReqInt(4) <= '1';
        end if;
        if (SRstReqTI(5) = '1') then
          ResetReqInt(5) <= '1';
        end if;
        if (SRstReqTI(6) = '1') then
          ResetReqInt(6) <= '1';
        end if;
        if (SRstReqTI(7) = '1') then
          ResetReqInt(7) <= '1';
        end if;
        if (SRstReqTI(8) = '1') then
          ResetReqInt(8) <= '1';
        end if;
      end if;
    end if;
  end process;
  TsReadB(159 downto 144) <= TooManyCnt(15 downto 0);
  TIResetReq(8 downto 0) <= ResetReqInt(8 downto 0);
  SReqSet <= (ROCEN(10) and ResetReqInt(0) and BusySrcEn(7)) or 
             (ROCEN(11) and ResetReqInt(1) and BusySrcEn(8)) or 
             (ROCEN(12) and ResetReqInt(2) and BusySrcEn(9)) or 
             (ROCEN(13) and ResetReqInt(3) and BusySrcEn(10)) or 
             (ROCEN(14) and ResetReqInt(4) and BusySrcEn(11)) or 
             (ROCEN(15) and ResetReqInt(5) and BusySrcEn(12)) or 
             (ROCEN(16) and ResetReqInt(6) and BusySrcEn(13)) or 
             (ROCEN(17) and ResetReqInt(7) and BusySrcEn(14)) or 
             (ROCEN(18) and ResetReqInt(8) and BusySrcEn(15)); 
  -- Status Decoding
  Fiber1Decoding : BusyCode
    port map(Clock  => Clk625, -- in    std_logic; 
    GTPRxEn    => DWriteEn(1), -- in    std_logic; 
    ResetFS    => ResetFS, -- in    std_logic; 
    Status     => DStatusA, -- in    std_logic_vector (15 downto 0); 
    BlkAckd    => BlkAckd(1), -- out   std_logic; 
    BlkRcvd    => BlkRcvd(1), -- out   std_logic; 
    BoardID    => TIinfo(79 downto 72), --BoardIDA(7 downto 0), -- out   std_logic_vector (7 downto 0); 
    BrdReady   => BoardRdy(1), -- out   std_logic; 
    BusyTI     => BusyTICode(1), -- out   std_logic; 
    NewBlkSize => TIinfo(151 downto 144), --NewBlkSizeA(7 downto 0), -- out   std_logic_vector (7 downto 0); 
    NewBufSize => TIinfo(223 downto 216), --NewBufSizeA(7 downto 0), -- out   std_logic_vector (7 downto 0); 
    SRstReq    => SRstReqTI(1), -- out   std_logic; 
    TestPt     => TestPt(4 downto 1), -- out   std_logic_vector (4 downto 1); 
    TrgSrc     => TIinfo(7 downto 0), --NewTrgSrcA(7 downto 0), -- out   std_logic_vector (7 downto 0); 
    TrigRcvd   => TrigRcvd(1) ); -- out   std_logic);
  Fiber2Decoding : BusyCode
    port map(Clock  => Clk625, -- in    std_logic; 
    GTPRxEn    => DWriteEn(2), -- in    std_logic; 
    ResetFS    => ResetFS, -- in    std_logic; 
    Status     => DStatusB, -- in    std_logic_vector (15 downto 0); 
    BlkAckd    => BlkAckd(2), -- out   std_logic; 
    BlkRcvd    => BlkRcvd(2), -- out   std_logic; 
    BoardID    => TIinfo(87 downto 80), --BoardIDB(7 downto 0), -- out   std_logic_vector (7 downto 0); 
    BrdReady   => BoardRdy(2), -- out   std_logic; 
    BusyTI     => BusyTICode(2), -- out   std_logic; 
    NewBlkSize => TIinfo(159 downto 152), --NewBlkSizeB(7 downto 0), -- out   std_logic_vector (7 downto 0); 
    NewBufSize => TIinfo(231 downto 224), --NewBufSizeB(7 downto 0), -- out   std_logic_vector (7 downto 0); 
    SRstReq    => SRstReqTI(2), -- out   std_logic; 
    TestPt     => open, --TestPt(4 downto 1), -- out   std_logic_vector (4 downto 1); 
    TrgSrc     => TIinfo(15 downto 8), --NewTrgSrcB(7 downto 0), -- out   std_logic_vector (7 downto 0); 
    TrigRcvd   => TrigRcvd(2) ); -- out   std_logic);
  Fiber3Decoding : BusyCode
    port map(Clock  => Clk625, -- in    std_logic; 
    GTPRxEn    => DWriteEn(3), -- in    std_logic; 
    ResetFS    => ResetFS, -- in    std_logic; 
    Status     => DStatusC, -- in    std_logic_vector (15 downto 0); 
    BlkAckd    => BlkAckd(3), -- out   std_logic; 
    BlkRcvd    => BlkRcvd(3), -- out   std_logic; 
    BoardID    => TIinfo(95 downto 88), --BoardIDC(7 downto 0), -- out   std_logic_vector (7 downto 0); 
    BrdReady   => BoardRdy(3), -- out   std_logic; 
    BusyTI     => BusyTICode(3), -- out   std_logic; 
    NewBlkSize => TIinfo(167 downto 160), --NewBlkSizeC(7 downto 0), -- out   std_logic_vector (7 downto 0); 
    NewBufSize => TIinfo(239 downto 232), --NewBufSizeC(7 downto 0), -- out   std_logic_vector (7 downto 0); 
    SRstReq    => SRstReqTI(3), -- out   std_logic; 
    TestPt     => open, --TestPt(4 downto 1), -- out   std_logic_vector (4 downto 1); 
    TrgSrc     => TIinfo(23 downto 16), --NewTrgSrcC(7 downto 0), -- out   std_logic_vector (7 downto 0); 
    TrigRcvd   => TrigRcvd(3) ); -- out   std_logic);
  Fiber4Decoding : BusyCode
    port map(Clock  => Clk625, -- in    std_logic; 
    GTPRxEn    => DWriteEn(4), -- in    std_logic; 
    ResetFS    => ResetFS, -- in    std_logic; 
    Status     => DStatusD, -- in    std_logic_vector (15 downto 0); 
    BlkAckd    => BlkAckd(4), -- out   std_logic; 
    BlkRcvd    => BlkRcvd(4), -- out   std_logic; 
    BoardID    => TIinfo(103 downto 96), --BoardIDD(7 downto 0), -- out   std_logic_vector (7 downto 0); 
    BrdReady   => BoardRdy(4), -- out   std_logic; 
    BusyTI     => BusyTICode(4), -- out   std_logic; 
    NewBlkSize => TIinfo(175 downto 168), --NewBlkSizeD(7 downto 0), -- out   std_logic_vector (7 downto 0); 
    NewBufSize => TIinfo(247 downto 240), --NewBufSizeD(7 downto 0), -- out   std_logic_vector (7 downto 0); 
    SRstReq    => SRstReqTI(4), -- out   std_logic; 
    TestPt     => open, --TestPt(4 downto 1), -- out   std_logic_vector (4 downto 1); 
    TrgSrc     => TIinfo(31 downto 24), --NewTrgSrcD(7 downto 0), -- out   std_logic_vector (7 downto 0); 
    TrigRcvd   => TrigRcvd(4) ); -- out   std_logic);
  Fiber5Decoding : BusyCode
    port map(Clock  => Clk625, -- in    std_logic; 
    GTPRxEn    => DWriteEn(5), -- in    std_logic; 
    ResetFS    => ResetFS, -- in    std_logic; 
    Status     => DStatusE, -- in    std_logic_vector (15 downto 0); 
    BlkAckd    => BlkAckd(5), -- out   std_logic; 
    BlkRcvd    => BlkRcvd(5), -- out   std_logic; 
    BoardID    => TIinfo(111 downto 104), --BoardIDE(7 downto 0), -- out   std_logic_vector (7 downto 0); 
    BrdReady   => BoardRdy(5), -- out   std_logic; 
    BusyTI     => BusyTICode(5), -- out   std_logic; 
    NewBlkSize => TIinfo(183 downto 176), --NewBlkSizeE(7 downto 0), -- out   std_logic_vector (7 downto 0); 
    NewBufSize => TIinfo(255 downto 248), --NewBufSizeE(7 downto 0), -- out   std_logic_vector (7 downto 0); 
    SRstReq    => SRstReqTI(5), -- out   std_logic; 
    TestPt     => open, --TestPt(4 downto 1), -- out   std_logic_vector (4 downto 1); 
    TrgSrc     => TIinfo(39 downto 32), --NewTrgSrcE(7 downto 0), -- out   std_logic_vector (7 downto 0); 
    TrigRcvd   => TrigRcvd(5) ); -- out   std_logic);
  Fiber6Decoding : BusyCode
    port map(Clock  => Clk625, -- in    std_logic; 
    GTPRxEn    => DWriteEn(6), -- in    std_logic; 
    ResetFS    => ResetFS, -- in    std_logic; 
    Status     => DStatusF, -- in    std_logic_vector (15 downto 0); 
    BlkAckd    => BlkAckd(6), -- out   std_logic; 
    BlkRcvd    => BlkRcvd(6), -- out   std_logic; 
    BoardID    => TIinfo(119 downto 112), --BoardIDF(7 downto 0), -- out   std_logic_vector (7 downto 0); 
    BrdReady   => BoardRdy(6), -- out   std_logic; 
    BusyTI     => BusyTICode(6), -- out   std_logic; 
    NewBlkSize => TIinfo(191 downto 184), --NewBlkSizeF(7 downto 0), -- out   std_logic_vector (7 downto 0); 
    NewBufSize => TIinfo(263 downto 256), --NewBufSizeF(7 downto 0), -- out   std_logic_vector (7 downto 0); 
    SRstReq    => SRstReqTI(6), -- out   std_logic; 
    TestPt     => open, --TestPt(4 downto 1), -- out   std_logic_vector (4 downto 1); 
    TrgSrc     => TIinfo(47 downto 40), --NewTrgSrcF(7 downto 0), -- out   std_logic_vector (7 downto 0); 
    TrigRcvd   => TrigRcvd(6) ); -- out   std_logic);
  Fiber7Decoding : BusyCode
    port map(Clock  => Clk625, -- in    std_logic; 
    GTPRxEn    => DWriteEn(7), -- in    std_logic; 
    ResetFS    => ResetFS, -- in    std_logic; 
    Status     => DStatusG, -- in    std_logic_vector (15 downto 0); 
    BlkAckd    => BlkAckd(7), -- out   std_logic; 
    BlkRcvd    => BlkRcvd(7), -- out   std_logic; 
    BoardID    => TIinfo(127 downto 120), --BoardIDG(7 downto 0), -- out   std_logic_vector (7 downto 0); 
    BrdReady   => BoardRdy(7), -- out   std_logic; 
    BusyTI     => BusyTICode(7), -- out   std_logic; 
    NewBlkSize => TIinfo(199 downto 192), --NewBlkSizeG(7 downto 0), -- out   std_logic_vector (7 downto 0); 
    NewBufSize => TIinfo(271 downto 264), --NewBufSizeG(7 downto 0), -- out   std_logic_vector (7 downto 0); 
    SRstReq    => SRstReqTI(7), -- out   std_logic; 
    TestPt     => open, --TestPt(4 downto 1), -- out   std_logic_vector (4 downto 1); 
    TrgSrc     => TIinfo(55 downto 48), --NewTrgSrcG(7 downto 0), -- out   std_logic_vector (7 downto 0); 
    TrigRcvd   => TrigRcvd(7) ); -- out   std_logic);
  Fiber8Decoding : BusyCode
    port map(Clock  => Clk625, -- in    std_logic; 
    GTPRxEn    => DWriteEn(8), -- in    std_logic; 
    ResetFS    => ResetFS, -- in    std_logic; 
    Status     => DStatusH, -- in    std_logic_vector (15 downto 0); 
    BlkAckd    => BlkAckd(8), -- out   std_logic; 
    BlkRcvd    => BlkRcvd(8), -- out   std_logic; 
    BoardID    => TIinfo(135 downto 128), --BoardIDH(7 downto 0), -- out   std_logic_vector (7 downto 0); 
    BrdReady   => BoardRdy(8), -- out   std_logic; 
    BusyTI     => BusyTICode(8), -- out   std_logic; 
    NewBlkSize => TIinfo(207 downto 200), --NewBlkSizeH(7 downto 0), -- out   std_logic_vector (7 downto 0); 
    NewBufSize => TIinfo(279 downto 272), --NewBufSizeH(7 downto 0), -- out   std_logic_vector (7 downto 0); 
    SRstReq    => SRstReqTI(8), -- out   std_logic; 
    TestPt     => open, --TestPt(4 downto 1), -- out   std_logic_vector (4 downto 1); 
    TrgSrc     => TIinfo(63 downto 56), --NewTrgSrcH(7 downto 0), -- out   std_logic_vector (7 downto 0); 
    TrigRcvd   => TrigRcvd(8) ); -- out   std_logic);
  FiberLpBkDecoding : BusyCode
    port map(Clock  => Clk625, -- in    std_logic; 
    GTPRxEn    => DWriteEn(0), -- in    std_logic; 
    ResetFS    => ResetFS, -- in    std_logic; 
    Status     => DStatusZ, -- in    std_logic_vector (15 downto 0); 
    BlkAckd    => BlkAckd(0), -- out   std_logic; 
    BlkRcvd    => BlkRcvd(0), -- out   std_logic; 
    BoardID    => TIinfo(143 downto 136), --BoardIDZ(7 downto 0), -- out   std_logic_vector (7 downto 0); 
    BrdReady   => BoardRdy(0), -- out   std_logic; 
    BusyTI     => BusyTICode(0), -- out   std_logic; 
    NewBlkSize => TIinfo(215 downto 208), --NewBlkSizeZ(7 downto 0), -- out   std_logic_vector (7 downto 0); 
    NewBufSize => TIinfo(287 downto 280), --NewBufSizeZ(7 downto 0), -- out   std_logic_vector (7 downto 0); 
    SRstReq    => SRstReqTI(0), -- out   std_logic; 
    TestPt     => open, --TestPt(4 downto 1), -- out   std_logic_vector (4 downto 1); 
    TrgSrc     => TIinfo(71 downto 64), --NewTrgSrcZ(7 downto 0), -- out   std_logic_vector (7 downto 0); 
    TrigRcvd   => TrigRcvd(0) ); -- out   std_logic);

-- Trigger Check, use GENERATE
  TrigChkGenerate:
  for it in 1 to 9 generate
    begin
      TrigChkInst: TrigCheck
        Port map( Clock => Clk625, -- in STD_LOGIC;
          NewBlock => SyncBlkEnd, -- in STD_LOGIC;
          BlkRcvd  => BlkRcvd(it mod 9), -- in STD_LOGIC;
          BlkAckd  => BlkAckd(it mod 9), -- in STD_LOGIC;
          TrigRcvd => TrigRcvd(it mod 9), -- in STD_LOGIC;
          PulseTrig => PulseTrig, -- in STD_LOGIC;
          Reset  => Reset, -- in STD_LOGIC;
          BusyTh => BlockTh(7 downto 0), -- in STD_LOGIC_VECTOR (7 downto 0);
          BusyTrig => BusyTrig(it mod 9), -- out STD_LOGIC;
          TooManyAck => TooManyAck(it mod 9), -- out std_logic;
          BlockSent => TsReadB(16*(it)-9 downto 16*(it-1)),
                    -- BlockSent((it+1)*8-1 downto 8*it), --  out STD_LOGIC_VECTOR (7 downto 0);
          BlockDiff => TsReadB(16*(it)-1 downto 16*it-8),
                    -- BlockDiff((it+1)*8-1 downto 8*it), -- out STD_LOGIC_VECTOR (7 downto 0);
          BusyBlk => BusyBlk(it mod 9) ); -- out STD_LOGIC);
      BusyCountInst :  BusyCount
        Port map(Clock => ClkVme, -- in  STD_LOGIC;
          Enable => TIBusyInt(it-1), -- in  STD_LOGIC;
          Latch  => CountLatch, -- in  STD_LOGIC;
          Reset  => CountReset, -- in  STD_LOGIC;
          COUT   => BusyCounter(32*(it+1)-1 downto 32*(it)) ); -- out  STD_LOGIC_VECTOR (31 downto 0)
  -- The combination logics:
        TIBusyInt(it-1) <= BusyTICode(it-1) or (BusyBlk(it-1) and TsThEnable);

    SrespTIgeneration :
      process (Clk625) 
      begin
        if (Clk625'event and Clk625 = '1') then
          if (Reset = '1') then
            SRespTI(it-1) <= '0';
          elsif (SRstReqTI(it-1) = '1') then
            SRespTI(it-1) <= '1';
          end if;
        end if;
      end process;
  end generate;
-- BusyCount for Inhibit
  BusyCountInhibit :  BusyCount
    Port map(Clock => ClkVme, -- in  STD_LOGIC;
      Enable => TSInhibit, -- in  STD_LOGIC;
      Latch  => CountLatch, -- in  STD_LOGIC;
      Reset  => CountReset, -- in  STD_LOGIC;
      COUT   => BusyCounter(31 downto 0) ); -- out  STD_LOGIC_VECTOR (31 downto 0)
  TrgLossBusyInt <= (BusyTrig(0) and BusySrcEn(7)) or (BusyTrig(1) and BusySrcEn(8)) or
                    (BusyTrig(2) and BusySrcEn(9)) or (BusyTrig(3) and BusySrcEn(10)) or
                    (BusyTrig(4) and BusySrcEn(11)) or (BusyTrig(5) and BusySrcEn(12)) or
                    (BusyTrig(6) and BusySrcEn(13)) or (BusyTrig(7) and BusySrcEn(14)) or
                    (BusyTrig(8) and BusySrcEn(15)); 
  TSBusy <= TempBusy or TSInhibit or (BusySrcEn(6) and TrgLossBusyInt) or 
           (TIBusyInt(0) and BusySrcEn(7))  or (TIBusyInt(1) and BusySrcEn(8))  or
           (TIBusyInt(2) and BusySrcEn(9))  or (TIBusyInt(3) and BusySrcEn(10)) or
           (TIBusyInt(4) and BusySrcEn(11)) or (TIBusyInt(5) and BusySrcEn(12)) or
           (TIBusyInt(6) and BusySrcEn(13)) or (TIBusyInt(7) and BusySrcEn(14)) or
           (TIBusyInt(8) and BusySrcEn(15));
  TooManyCom <= (TooManyAck(0) and BusySrcEn(7))  or (TooManyAck(1) and BusySrcEn(8))  or
                (TooManyAck(2) and BusySrcEn(9))  or (TooManyAck(3) and BusySrcEn(10)) or
                (TooManyAck(4) and BusySrcEn(11)) or (TooManyAck(5) and BusySrcEn(12)) or
                (TooManyAck(6) and BusySrcEn(13)) or (TooManyAck(7) and BusySrcEn(14)) or
                (TooManyAck(8) and BusySrcEn(15));
  
  TIBusy(8 downto 0) <= TIBusyInt(8 downto 0);
  BusyTI(8 downto 0) <= BusyTICode(8 downto 0); 
  TrgLossBusy <= TrgLossBusyInt;

  FiberFifoReadout : FiberFifo
    port map(DataA => DStatusA(15 downto 0), -- in std_logic_vector(15 downto 0);
      DataB   => DStatusE(15 downto 0),      -- in std_logic_vector(15 downto 0);
      WriteA  => DWriteEn(1), -- in std_logic;
      WriteB  => DWriteEn(5), -- in std_logic;
      ClkW    => Clk625,  -- in std_logic;
      ClkR    => ClkRead, -- in std_logic;
      ReadAen => ReadAEn, -- in std_logic;
      ReadBen => ReadBEn, -- in std_logic;
      Reset   => Reset,   -- in std_logic;
      outA    => ReadAout(35 downto 0),   -- out std_logic_vector(35 downto 0);
      outB    => ReadBout(35 downto 0) ); -- out std_logic_vector(35 downto 0) );

end Behavioral;
