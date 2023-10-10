----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/28/2020 12:31:37 PM
-- Design Name: 
-- Module Name: TIinBusy - Behavioral
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

entity TIinBusy is
  port (SwaBusy : in    std_logic; 
    SwbBusy     : in    std_logic; 
    BusySrcEn   : in    std_logic_vector (15 downto 0); 
    Clock       : in    std_logic; 
    CountLatch  : in    std_logic; 
    CountReset  : in    std_logic; 
    FadcBusy    : in    std_logic; 
    FPBusy      : in    std_logic; 
    FtdcBusy    : in    std_logic; 
    P2Busy      : in    std_logic; 
    TIFifoFull  : in    std_logic; 
    BusyCounter : out   std_logic_vector (191 downto 0); 
    StatBusy    : out   std_logic_vector (5 downto 0); 
    TIBusy      : out   std_logic);
end TIinBusy;

architecture Behavioral of TIinBusy is

  component BusyCount is
    Port (Clock : in  STD_LOGIC;
      Enable : in  STD_LOGIC;
      Latch : in  STD_LOGIC;
      Reset : in  STD_LOGIC;
      COUT : out  STD_LOGIC_VECTOR (31 downto 0));
  end component BusyCount;

  signal P2inBusy  : std_logic;
  signal TdcBusy   : std_logic;
  signal AdcBusy   : std_logic;
  signal CrateBusy : std_logic;
  
begin


  CrateBusy <= (SwaBusy and BusySrcEn(0)) or (SwbBusy and BusySrcEn(1))
            or (P2Busy and BusySrcEn(2)) or (FtdcBusy and BusySrcEn(3))
            or (FadcBusy and BusySrcEn(4));
  TIBusy <= CrateBusy or TIFifoFull or (FPBusy and BusySrcEn(5));

-- Busy timers (count when the BUSY is true, even when the busy is not enabled
  SWAbusyCount : BusyCount
    Port map(Clock => Clock,  -- in  STD_LOGIC;
      Enable => SwaBusy,      -- in  STD_LOGIC;
      Latch  => CountLatch,   -- in  STD_LOGIC;
      Reset  => CountReset,   -- in  STD_LOGIC;
      COUT   => BusyCounter(31 downto 0) ); -- out  STD_LOGIC_VECTOR (31 downto 0));
  SWBbusyCount : BusyCount
    Port map(Clock => Clock,  -- in  STD_LOGIC;
      Enable => SwbBusy,      -- in  STD_LOGIC;
      Latch  => CountLatch,   -- in  STD_LOGIC;
      Reset  => CountReset,   -- in  STD_LOGIC;
      COUT   => BusyCounter(63 downto 32) ); -- out  STD_LOGIC_VECTOR (31 downto 0));
  P2busyCount : BusyCount
    Port map(Clock => Clock,  -- in  STD_LOGIC;
      Enable => P2Busy,      -- in  STD_LOGIC;
      Latch  => CountLatch,   -- in  STD_LOGIC;
      Reset  => CountReset,   -- in  STD_LOGIC;
      COUT   => BusyCounter(95 downto 64) ); -- out  STD_LOGIC_VECTOR (31 downto 0));
  FTDCbusyCount : BusyCount
    Port map(Clock => Clock,  -- in  STD_LOGIC;
      Enable => FtdcBusy,      -- in  STD_LOGIC;
      Latch  => CountLatch,   -- in  STD_LOGIC;
      Reset  => CountReset,   -- in  STD_LOGIC;
      COUT   => BusyCounter(127 downto 96) ); -- out  STD_LOGIC_VECTOR (31 downto 0));
  TADCbusyCount : BusyCount
    Port map(Clock => Clock,  -- in  STD_LOGIC;
      Enable => FadcBusy,      -- in  STD_LOGIC;
      Latch  => CountLatch,   -- in  STD_LOGIC;
      Reset  => CountReset,   -- in  STD_LOGIC;
      COUT   => BusyCounter(159 downto 128) ); -- out  STD_LOGIC_VECTOR (31 downto 0));
  FPbusyCount : BusyCount
    Port map(Clock => Clock,  -- in  STD_LOGIC;
      Enable => FPBusy,      -- in  STD_LOGIC;
      Latch  => CountLatch,   -- in  STD_LOGIC;
      Reset  => CountReset,   -- in  STD_LOGIC;
      COUT   => BusyCounter(191 downto 160) ); -- out  STD_LOGIC_VECTOR (31 downto 0));
-- Busy Status output
  StatBusy(5 downto 0) <= FPBusy & FadcBusy & FtdcBusy & P2Busy & SwbBusy & SwaBusy;
  
end Behavioral;
