----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/28/2020 03:16:44 PM
-- Design Name: 
-- Module Name: BusyCode - Behavioral
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

entity BusyCode is
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
end BusyCode;

architecture Behavioral of BusyCode is

  signal PreStatEn : std_logic_vector(3 downto 0) := (others => '0'); -- the status_en can not be consecutive
  signal RxDParity : std_logic;
  signal AckEn     : std_logic;
  signal DataEn    : std_logic;
  signal BlkAckdInt : std_logic;
  signal SRstReqInt : std_logic;
  signal BlkRcvdInt : std_logic;
  signal TrigRcvdInt : std_logic;
  signal TrgSrcReg  : std_logic;
  signal BlkSizeEn  : std_logic;
  signal BufSizeEn  : std_logic;
  signal CrateIDEn  : std_logic;
begin

 -- Input data check parity OK
  RxDParity <= GTPRxEn and (Status(15) xnor Status(14)) and (not
              (Status(14) xor Status(13) xor Status(12) xor Status(11) xor Status(10)
               xor Status(9) xor Status(8) xor Status(7) xor Status(6) xor Status(5) 
               xor Status(4) xor Status(3) xor Status(2) xor Status(1) xor Status(0)) );
  AckEn  <= Status(12) and (not Status(13));
  DataEn <= Status(13) and (not Status(12));
  TrgSrcReg <= Status(10) and DataEn and RxDParity and 
               (not Status(11)) and (not Status(9));
  CrateIDEn <= DataEn and RxDParity and Status(9) and
              (not Status(10)) and (not Status(11)) and (not Status(8));
  BlkSizeEn <= DataEn and RxDParity and Status(9) and
               Status(10) and (not Status(11)) and (not Status(8));
  BufSizeEn <= DataEn and RxDParity and Status(9) and
               Status(10) and (not Status(11)) and Status(8); 
  
  process (Clock)
  begin
    if (Clock'event and Clock = '1') then
-- Decode checking, but the StatEn is not used
-- The STATUS must not transmitted continously
      PreStatEn(3) <= GTPRxEn;
      PreStatEn(2) <= (not PreStatEn(3)) and (not GTPRxEn);
      PreStatEn(0) <= PreStatEn(2);  -- (0) is the sane StatEn

-- decoding
      BusyTI <= AckEn and RxDParity and Status(7);
      if (BlkAckdInt = '1') then
        BlkAckdInt <= '0';
      else
        BlkAckdInt <= RxDParity and AckEn and Status(3);
      end if;
      if (SRstReqInt = '1') then
        SRstReqInt <= '0';
      else
        SRstReqInt <= RxDParity and AckEn and Status(9) and (not Status(8));
      end if;
      if (BlkRcvdInt = '1') then
        BlkRcvdInt <= '0';
      else
        BlkRcvdInt <= RxDParity and AckEn and Status(4);
      end if;
      if (TrigRcvdInt = '1') then
        TrigRcvdInt <= '0';
      else
        TrigRcvdInt <= RxDParity and AckEn and Status(6);
      end if;
-- TI board settings
      if (ResetFS = '1') then
        TrgSrc(7 downto 0) <= (others => '0');
        BrdReady <= '0';
        NewBufSize(7 downto 0) <= (others =>'0');
        BoardID(7 downto 0) <= (others => '0');
        NewBlkSize(7 downto 0) <= (others =>'0');
      else
        if (TrgSrcReg = '1') then
          TrgSrc <= Status(7 downto 0);
          BrdReady <= Status(8);
        end if;
        if (BufSizeEn = '1') then
          NewBufSize(7 downto 0) <= Status(7 downto 0);
        end if;
        if (BlkSizeEn = '1') then
          NewBlkSize(7 downto 0) <= Status(7 downto 0);
        end if;
        if (CrateIDEn = '1') then
          BoardID(7 downto 0) <= Status(7 downto 0);
        end if;
      end if;
    end if;
  end process;
-- assign the Internal signal to output port  
  BlkAckd  <= BlkAckdInt;
  SRstReq  <= SRstReqInt;
  TrigRcvd <= TrigRcvdInt;
  BlkRcvd  <= BlkRcvdInt;
  TestPt(4 downto 1) <= CrateIDEn & GtpRxEn & RxDParity & DataEn;
  
end Behavioral;
