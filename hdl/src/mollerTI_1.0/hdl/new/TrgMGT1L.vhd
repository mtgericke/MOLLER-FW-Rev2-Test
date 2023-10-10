----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/18/2019 02:22:42 PM
-- Design Name: 
-- Module Name: TrgMGT - Behavioral
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
library UNISIM;
use UNISIM.VComponents.all;

entity TrgMGT1L is
  Port ( ClkRef : in STD_LOGIC;
    ClkRcvd : out std_logic;
    ClkFree   : in std_logic;
    MasterMode : in STD_LOGIC_VECTOR (3 downto 1);
    WriteStart : in STD_LOGIC;
    ReadStart : in STD_LOGIC;
    StatusEn : in std_logic;
    RxGT_P : in STD_LOGIC;
    RxGT_N : in STD_LOGIC;
    TxGT_P : out STD_LOGIC;
    TxGT_N : out STD_LOGIC;
    Status : in STD_LOGIC_VECTOR (15 downto 0);
    TsData : in STD_LOGIC_VECTOR (15 downto 0);
    Reset : in STD_LOGIC;
    TrgSendEn : in STD_LOGIC;
    Clk250 : in STD_LOGIC;
    Clk625 : in STD_LOGIC;
    
 -- newly added signals
    RstGtp : in std_logic;
    VRstGtp : inout std_logic;
    SyncedRst : out std_logic;
    VmeReset : in std_logic_vector(31 downto 0); 
    FiberRdy : in std_logic;
    TsWrStart : in std_logic;
    TsRdStart : in std_logic;
    TrgBufE   : out std_logic_vector(9 downto 0);
    GTPStA    : out std_logic_vector(31 downto 0);
--

    TrgAProm : out STD_LOGIC;
    TrgData : out STD_LOGIC_VECTOR (15 downto 0);
    StatusA : inout STD_LOGIC_VECTOR (15 downto 0);
    TsLpData : out STD_LOGIC_VECTOR (15 downto 0);
    GT5Data  : out std_logic_vector(15 downto 0);
    GT5K     : out std_logic_vector(1 downto 0);
    RxAErr : out STD_LOGIC;
    RxEn   : out std_logic_vector(1 downto 0);
    GTStatus : inout STD_LOGIC_VECTOR (95 downto 0));
end TrgMGT1L;

architecture Behavioral of TrgMGT1L is

COMPONENT TI1_x0y14
  PORT (
    gtwiz_userclk_tx_reset_in : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    gtwiz_userclk_tx_srcclk_out : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    gtwiz_userclk_tx_usrclk_out : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    gtwiz_userclk_tx_usrclk2_out : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    gtwiz_userclk_tx_active_out : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    gtwiz_userclk_rx_reset_in : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    gtwiz_userclk_rx_srcclk_out : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    gtwiz_userclk_rx_usrclk_out : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    gtwiz_userclk_rx_usrclk2_out : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    gtwiz_userclk_rx_active_out : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    gtwiz_buffbypass_tx_reset_in : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    gtwiz_buffbypass_tx_start_user_in : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    gtwiz_buffbypass_tx_done_out : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    gtwiz_buffbypass_tx_error_out : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    gtwiz_buffbypass_rx_reset_in : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    gtwiz_buffbypass_rx_start_user_in : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    gtwiz_buffbypass_rx_done_out : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    gtwiz_buffbypass_rx_error_out : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    gtwiz_reset_clk_freerun_in : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    gtwiz_reset_all_in : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    gtwiz_reset_tx_pll_and_datapath_in : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    gtwiz_reset_tx_datapath_in : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    gtwiz_reset_rx_pll_and_datapath_in : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    gtwiz_reset_rx_datapath_in : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    gtwiz_reset_rx_cdr_stable_out : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    gtwiz_reset_tx_done_out : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    gtwiz_reset_rx_done_out : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    gtwiz_userdata_tx_in : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    gtwiz_userdata_rx_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
    gtrefclk00_in : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    qpll0outclk_out : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    qpll0outrefclk_out : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    gthrxn_in : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    gthrxp_in : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    rx8b10ben_in : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    rxcommadeten_in : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    rxmcommaalignen_in : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    rxpcommaalignen_in : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    tx8b10ben_in : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    txctrl0_in : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    txctrl1_in : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    txctrl2_in : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    gtpowergood_out : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    gthtxn_out : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    gthtxp_out : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    rxbyteisaligned_out : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    rxbyterealign_out : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    rxcommadet_out : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    rxctrl0_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
    rxctrl1_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
    rxctrl2_out : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
    rxctrl3_out : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
    rxpmaresetdone_out : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
--    rxrecclkout_out : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    txpmaresetdone_out : OUT STD_LOGIC_VECTOR(0 DOWNTO 0)  );
END COMPONENT;

  COMPONENT DataBuffer
    PORT (clka : IN STD_LOGIC;
      wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
      addra : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
      dina : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
      clkb : IN STD_LOGIC;
      addrb : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
      doutb : OUT STD_LOGIC_VECTOR(15 DOWNTO 0) );
  END COMPONENT;


  signal CLKTXUSER2 : std_logic;
  signal CLKRXUSER2 : std_logic_vector(1 downto 0);
  signal GTDATAIN : std_logic_vector(31 downto 0);
  signal GTKIN    : std_logic_vector(3 downto 0);
  signal GTDATAOUT : std_logic_vector(31 downto 0);
  signal GTKOUT    : std_logic_vector(3 downto 0);
  signal RxValid : std_logic_vector(1 downto 0);
-- Reset logic related signals
  signal GTPReset : std_logic;
-- Ts LoopBack Data
  signal ClkLP : std_logic;
  signal TsLpBk : std_logic;
  signal TsInData : std_logic_vector(15 downto 0);
  signal TsAddR : std_logic_vector(9 downto 0);
  signal TsAddW : std_logic_vector(9 downto 0);
-- Fiber#1
  signal ClkTrg : std_logic;
  signal AddWrite : std_logic_vector(9 downto 0);
  signal AddRead : std_logic_vector(9 downto 0);
  signal Time1Q0 : std_logic;
  signal Time1Q1 : std_logic;
  signal TrgTrue : std_logic;
  signal D1TrgTrue : std_logic;
  signal D2TrgTrue : std_logic;

  signal SyncedVmeRst : std_logic_vector(10 downto 1);
  signal RegVmeRst : std_logic_vector(4 downto 1);

begin

-- Sync the VmeReset to Clk625.  Assuming that the ClkVme is always alower than 2xClk250
  process (Clk250) 
  begin
    if (Clk250'event and Clk250 = '1') then
      if (SyncedVmeRst(1) = '1') then
        RegVmeRst(1) <= '0';
      elsif (VmeReset(10) = '1') then  -- Whole MGT reset
        RegVmeRst(1) <= '1';
      end if;
      if (SyncedVmeRst(2) = '1') then
        RegVmeRst(2) <= '0';
      elsif (VmeReset(22) = '1') then  -- Rx of MGT reset only
        RegVmeRst(2) <= '1';
      end if;
    end if;
    if (Clk250'event and Clk250 = '0') then
      if (SyncedVmeRst(1) = '1') then
        RegVmeRst(3) <= '0';
      elsif (VmeReset(10) = '1') then  -- Whole MGT reset
        RegVmeRst(3) <= '1';
      end if;
      if (SyncedVmeRst(2) = '1') then
        RegVmeRst(4) <= '0';
      elsif (VmeReset(22) = '1') then  -- Rx of MGT reset only
        RegVmeRst(4) <= '1';
      end if;
    end if;
  end process;
  process (Clk625)
  begin
    if (Clk625'event and Clk625 = '1') then
      SyncedVmeRst(1) <= RegVmeRst(1) or RegVmeRst(3);  -- rising edge and falling edge of Clk250
      SyncedVmeRst(2) <= RegVmeRst(2) or RegVmeRst(4);
    end if;
  end process;

  TI1_TRx0y14 : TI1_x0y14
    PORT map(
      gtwiz_userclk_tx_reset_in(0)    =>  '0', --SyncedVmeRst(1), --TxSetPHA, --'0', -- Reset, -- IN STD_LOGIC_VECTOR(0 DOWNTO 0);
      gtwiz_userclk_tx_srcclk_out(0)  => open, -- OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
      gtwiz_userclk_tx_usrclk_out(0)  => open, -- OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
      gtwiz_userclk_tx_usrclk2_out(0) => CLKTXUSER2, -- OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
      gtwiz_userclk_tx_active_out(0)  => GTStatus(0), -- OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
      gtwiz_userclk_rx_reset_in(0)    =>  '0', --SyncedVmeRst(4), --RxPMASet, -- Reset, -- IN STD_LOGIC_VECTOR(1 DOWNTO 0);
      gtwiz_userclk_rx_srcclk_out(0)  => open, -- OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
      gtwiz_userclk_rx_usrclk_out(0)  => open, -- OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
      gtwiz_userclk_rx_usrclk2_out    => CLKRXUSER2(1 downto 1), -- OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
      gtwiz_userclk_rx_active_out     => GTStatus(1 downto 1), -- OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
      gtwiz_buffbypass_tx_reset_in(0) =>  '0', --SyncedVmeRst(5), --Reset, -- IN STD_LOGIC_VECTOR(0 DOWNTO 0);
      gtwiz_buffbypass_tx_start_user_in  => "0", -- IN STD_LOGIC_VECTOR(0 DOWNTO 0);
      gtwiz_buffbypass_tx_done_out   => GTStatus(2 downto 2), -- OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
      gtwiz_buffbypass_tx_error_out  => GTStatus(3 downto 3), -- OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
      gtwiz_buffbypass_rx_reset_in(0)    =>  '0', --SyncedVmeRst(6), --Reset, -- IN STD_LOGIC_VECTOR(1 DOWNTO 0);
      gtwiz_buffbypass_rx_start_user_in  => "0", -- IN STD_LOGIC_VECTOR(1 DOWNTO 0);
      gtwiz_buffbypass_rx_done_out   => GTStatus(4 downto 4), -- OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
      gtwiz_buffbypass_rx_error_out  => GTStatus(5 downto 5), -- OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
      gtwiz_reset_clk_freerun_in(0)  => ClkFree, -- IN STD_LOGIC_VECTOR(0 DOWNTO 0);
      gtwiz_reset_all_in(0)   => VRstGtp, --GTPReset, -- Reset, -- IN STD_LOGIC_VECTOR(0 DOWNTO 0);
      gtwiz_reset_tx_pll_and_datapath_in(0)  => '0', --SyncedVmeRst(3), --GTPReset, -- Reset, -- IN STD_LOGIC_VECTOR(0 DOWNTO 0);
      gtwiz_reset_tx_datapath_in(0)          =>  '0', --SyncedVmeRst(7), --Reset, -- IN STD_LOGIC_VECTOR(0 DOWNTO 0);
      gtwiz_reset_rx_pll_and_datapath_in(0)  =>  SyncedVmeRst(2), --GTPReset, -- Reset, -- IN STD_LOGIC_VECTOR(0 DOWNTO 0);
      gtwiz_reset_rx_datapath_in(0)  =>  '0', --SyncedVmeRst(8), --Reset, -- IN STD_LOGIC_VECTOR(0 DOWNTO 0);
      gtwiz_reset_rx_cdr_stable_out  => GTStatus(6 downto 6), -- OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
      gtwiz_reset_tx_done_out  => GTStatus(7 downto 7), -- OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
      gtwiz_reset_rx_done_out  => GTStatus(8 downto 8), -- OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
      gtwiz_userdata_tx_in     => GTDATAIN(31 downto 16), -- IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      gtwiz_userdata_rx_out    => GTDATAOUT(31 downto 16), -- OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
-- QPLL option
      gtrefclk00_in(0)  => CLKREF, -- IN STD_LOGIC_VECTOR(1 DOWNTO 0);
      qpll0outclk_out   => open, -- OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
      qpll0outrefclk_out(0)  => open, --CLKREFOUT, -- OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
--      rxrecclkout_out(0)     => CLKRCVD, --open, -- OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
      
      gthrxn_in(0)  => RxGT_N, -- IN STD_LOGIC_VECTOR(1 DOWNTO 0);
      gthrxp_in(0)  => RxGT_P, -- IN STD_LOGIC_VECTOR(1 DOWNTO 0);
      rx8b10ben_in     => "1", -- IN STD_LOGIC_VECTOR(1 DOWNTO 0);
      rxcommadeten_in  => "1", -- IN STD_LOGIC_VECTOR(1 DOWNTO 0);
      rxmcommaalignen_in  => "1", -- IN STD_LOGIC_VECTOR(1 DOWNTO 0);
      rxpcommaalignen_in  => "1", -- IN STD_LOGIC_VECTOR(1 DOWNTO 0);
      tx8b10ben_in  => "1", -- IN STD_LOGIC_VECTOR(1 DOWNTO 0);
      txctrl0_in    => x"0000", -- IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      txctrl1_in    => x"0000", -- IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      txctrl2_in(7 downto 2)  => "000000", -- IN STD_LOGIC_VECTOR(15 DOWNTO 0);
      txctrl2_in(1 downto 0)  => GTKIN(3 downto 2), -- IN STD_LOGIC_VECTOR(15 DOWNTO 0);
      gtpowergood_out  => GTStatus(13 downto 13), -- OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
      gthtxn_out(0)  => TxGT_N, -- OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
      gthtxp_out(0)  => TxGT_P, -- OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
      rxbyteisaligned_out  => GTStatus(15 downto 15), -- OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
      rxbyterealign_out  => GTStatus(17 downto 17), -- OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
      rxcommadet_out  => GTStatus(19 downto 19), -- OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
      rxctrl0_out(15 downto 2)   => open, -- OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      rxctrl0_out( 1 downto 0)   => GTKOUT(3 downto 2), -- OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      rxctrl1_out(15 downto 2)   => open, -- OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      rxctrl1_out(1  downto 0)   => GTStatus(23 downto 22), -- OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      rxctrl2_out(7  downto 2)   => open, -- OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
      rxctrl2_out(1  downto 0)   => GTStatus(27 downto 26), -- OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
      rxctrl3_out(7  downto 2)   => open, -- OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
      rxctrl3_out(1  downto 0)   => GTStatus(31 downto 30), -- OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
      rxpmaresetdone_out  => GTStatus(33 downto 33), -- OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
      txpmaresetdone_out  => GTStatus(35 downto 35) );

  process(CLK625)
    begin
      if (CLK625'event and CLK625 = '1') then
        if (VRstGtp = '1') then  -- changed from RESET, Oct. 20, 2020
          GTDATAIN <= x"50bc50bc"; -- D16.2 (010 10000) & K28.5 (101 11100)
          GTKIN <= "0101";
        else
          if (MasterMode(3) = '1') then  -- TI in cascade mode
            GTDATAIN(15 downto 0) <= GTDATAOUT(31 downto 16);
            GTKIN(1 downto 0) <= GTKOUT(3 downto 2);
            if (StatusEn = '1') then
              GTDATAIN(31 downto 16) <= Status(15 downto 0);
              GTKIN(3 downto 2) <= "00";
            else 
              GTDATAIN(31 downto 16) <= x"50bc";
              GTKIN(3 downto 2) <= "01";
            end if;
          else  -- TI in non-cascade mode
            if (MasterMode(1) = MasterMode(2)) then  -- master mode
              if (TrgSendEn = '1') then
                GTDATAIN(31 downto 0) <= TsData(15 downto 0) & TsData(15 downto 0);
                GTKIN(3 downto 0) <= "0000";
              else
                GTDATAIN <= x"50bc50bc"; -- D16.2 (010 10000) & K28.5 (101 11100)
                GTKIN <= "0101";
              end if;
            else -- slave mode
              if (StatusEn = '1') then  -- 
                GTDATAIN(31 downto 0) <= Status(15 downto 0) & Status(15 downto 0);
                GTKIN(3 downto 0) <= "0000";
              else
                GTDATAIN <= x"50bc50bc"; -- D16.2 (010 10000) & K28.5 (101 11100)
                GTKIN <= "0101";
              end if;
            end if;  -- end of MasterMode
          end if;    -- end of cascade mode
        end if;      -- end of reset
      end if;        -- end of clock
  end process;

  GT5Data  <= GTDATAIN(15 downto 0);
  GT5K     <= GTKIN(1 downto 0);

  RxValid(1) <= (not GTKOUT(3)) and (not GTKOUT(2))  -- K = 00
            and (not GTStatus(22)) and (not GTStatus(23)) -- no disparity error
            and (not GTStatus(30)) and (not GTStatus(31)); -- no not-in-table
  RxAErr <= (GTStatus(22) or GTStatus(23) or GTStatus(30) or GTStatus(31)) and FiberRdy;
    
  process (Clk625)  -- change to CLk625 from Clk250 as the Rd/WrStart is on clk625
    begin
      if (Clk625'event and Clk625 = '1') then
        if (WriteStart = '1') then
          TrgBufE(9 downto 0) <= (others => '0');
        elsif (ReadStart = '1') then
          TrgBufE(9 downto 0) <= AddWrite(9 downto 0);
        end if;
        if (TsWrStart = '1') then
          GTPStA(25 downto 16) <= (others => '0');
        elsif (TsRdStart = '1') then
          GTPStA(25 downto 16) <= TsAddW(9 downto 0);
        end if;
      end if;
  end process;
  
--  process (CLKRXUSER2(0)) 
--    begin
--      if ( CLKRXUSER2(0)'event and CLKRXUSER2(0) = '1' ) then
  process (CLK625) 
    begin
      if ( Clk625'event and CLK625 = '1' ) then
        StatusA <= GTDATAOUT(31 downto 16); --  xor x"50bc";
        RxEn(1) <= RxValid(1);  -- Fiber#1
        RxEn(0) <= TrgSendEn; -- loopback

        -- save the error status
        if (Reset = '1') then
          GTStatus(41 downto 36) <= "000000";
        else
          if (GTStatus(22) = '1') then
            GTStatus(36) <= '1';     end if;
          if (GTStatus(23) = '1') then
            GTStatus(37) <= '1';     end if;
          if (GTStatus(26) = '1') then
            GTStatus(38) <= '1';     end if;
          if (GTStatus(27) = '1') then
            GTStatus(39) <= '1';     end if;
          if (GTStatus(30) = '1') then
            GTStatus(40) <= '1';     end if;
          if (GTStatus(31) = '1') then
            GTStatus(41) <= '1';     end if;
        end if;  -- end of Reset
      end if;    -- end of CLKRXUSER2
  end process;

  GTStatus(51 downto 50) <= GTKOUT(3 downto 2);
  GTStatus(58 downto 52) <= VRstGtp & Reset & RstGtp & SyncedVmeRst(4 downto 1);
  VRstGtp <= RstGtp or SyncedVmeRst(1); -- VmeReset(10);
  SyncedRst <= SyncedVmeRst(2);

-- For loopback data, 
  LoopBackTrigger : DataBuffer
    PORT MAP (clka => ClkLP, -- IN STD_LOGIC;
      wea(0)   => TsLpBk, -- IN STD_LOGIC_VECTOR(0 DOWNTO 0);
      addra => TsAddW(9 downto 0), --  IN STD_LOGIC_VECTOR(9 DOWNTO 0);
      dina  => TsInData(15 downto 0), -- IN STD_LOGIC_VECTOR(15 DOWNTO 0);
      clkb  => ClkLP, -- IN STD_LOGIC;
      addrb => TsAddR(9 downto 0), -- IN STD_LOGIC_VECTOR(9 DOWNTO 0);
      doutb => TsLpData(15 downto 0) ); -- OUT STD_LOGIC_VECTOR(15 DOWNTO 0)clka,
  CLKLP <= Clk625;
  process (ClkLP)
    begin
      if (ClkLP'event and ClkLP = '1') then
        TsInData <= TsData;
        TsLpBk <= TrgSendEn;
        if (TsWrStart = '1') then
          TsAddW <= (others => '0');
        elsif (TsLpBk = '1') then
          TsAddW <= TsAddW + 1;
        end if;
        if (TsRdStart = '1') then
          TsAddR <= (others => '0');
        else
          TsAddR <= TsAddR + 1;
        end if;
      end if;
  end process;
  
-- For Fiber#1 data, 
  Fiber1Trigger : DataBuffer
    PORT MAP (clka => ClkTrg, -- IN STD_LOGIC;
      wea(0)   => RxValid(1), -- IN STD_LOGIC_VECTOR(0 DOWNTO 0);
      addra => AddWrite(9 downto 0), --  IN STD_LOGIC_VECTOR(9 DOWNTO 0);
      dina  => GTDATAOUT(31 downto 16), -- IN STD_LOGIC_VECTOR(15 DOWNTO 0);
      clkb  => ClkTrg, -- IN STD_LOGIC;
      addrb => AddRead(9 downto 0), -- IN STD_LOGIC_VECTOR(9 DOWNTO 0);
      doutb => TrgData(15 downto 0) ); -- OUT STD_LOGIC_VECTOR(15 DOWNTO 0)clka,
  CLKTrg <= Clk625; -- ClkTXUser2;
  process (ClkTrg)
    begin
      if (ClkTrg'event and ClkTrg = '1') then
        if (WriteStart = '1') then
          AddWrite <= (others => '0');
        elsif (RxValid(1) = '1') then
          AddWrite <= AddWrite + 1;
        end if;
        if (ReadStart = '1') then
          AddRead <= (others => '0');
        else
          AddRead <= AddRead + 1;
        end if;
      end if;
  end process;

-- Trigger strobe, from StatusA
  TrgTrue <= ((not StatusA(15)) and StatusA(14) and StatusA(13) and (not StatusA(12)))
         or (StatusA(15) and (not StatusA(14)) and 
             ((StatusA(13) and (not StatusA(12))) or ((not StatusA(13)) and StatusA(12))));
  process(ClkTrg)
    begin
      if (ClkTrg'event and ClkTrg = '1') then
        D1TrgTrue <= TrgTrue;
        if (TrgTrue = '1') then
          Time1Q1 <= StatusA(11);
          Time1Q0 <= StatusA(10);
        end if;
      end if;
  end process;
  process (Clk250)
    begin
      if (Clk250'event and Clk250 = '1') then
        D2TrgTrue <= D1TrgTrue;  -- clock domain transfer
      end if;
  end process;
  DelayTrgTrue : SRL16E
    generic map (INIT => X"0000",        -- Initial contents of shift register
      IS_CLK_INVERTED => '0' ) -- Optional inversion for CLK
    port map ( Q => TrgAProm,     -- 1-bit output: SRL Data
     CE => '1',   -- 1-bit input: Clock enable
     CLK => Clk250, -- 1-bit input: Clock
     D => D2TrgTrue,     -- 1-bit input: SRL Data
     -- Depth Selection inputs: A0-A3 select SRL depth
     A0 => Time1Q0,
     A1 => Time1Q1,
     A2 => '0',
     A3 => '0'   );
end Behavioral;

  