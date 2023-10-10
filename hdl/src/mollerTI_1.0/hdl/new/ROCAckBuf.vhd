----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/12/2020 08:31:11 AM
-- Design Name: 
-- Module Name: ROCAckBuf - Behavioral
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
use ieee.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ROCAckBuf is
  Port (Clock : in STD_LOGIC;
    ROCiAckIn : in STD_LOGIC;
    Reset     : in STD_LOGIC;
    ROCAckd   : in STD_LOGIC;
    ROCiReady : out std_logic;
    ROCAckBuf : out STD_LOGIC_VECTOR (7 downto 0));
end ROCAckBuf;

architecture Behavioral of ROCAckBuf is

  signal ROCAckCnt : std_logic_vector(7 downto 0):= (others => '0');
  signal CountEn   : std_logic;
  signal RCReady   : std_logic;
  signal ROCiAck   : std_logic := '0';
  signal PreROCiAck : std_logic := '0';

begin

-- receiving the ROCiAck, and set it to one CLOCK cycle
  process (Clock, Reset, ROCiAckIn, ROCiAck)
  begin
    if (Reset = '1' or ROCiAck = '1') then
      PreROCiAck <= '0';
    elsif (ROCiAckIn'event and ROCiAckIn = '1') then
      PreROCiAck <= '1';
    end if;
    if (Clock'event and Clock = '1') then
      ROCiAck <= PreROCiAck;
    end if;
  end process;
  
  RCReady <= ROCAckCnt(7) or ROCAckCnt(6) or ROCAckCnt(5) or ROCAckCnt(4)
          or ROCAckCnt(3) or ROCAckCnt(2) or ROCAckCnt(1) or ROCAckCnt(0);
  CountEn <= (ROCAckd xor ROCiAck) and (ROCiAck or (ROCAckd and RCReady)); 
-- Counter for ROCiAck over the global ROCack.  (This means that some ROCs can be ahead of others
  process (Clock)
  begin
    if (Clock'event and Clock = '1') then
      if (Reset = '1') then
        ROCAckCnt <= (others => '0');
      elsif (CountEn = '1') then
        if (ROCiAck = '1') then
          ROCAckCnt <= ROCAckCnt + 1;
        else
          ROCAckCnt <= ROCAckCnt - 1;
        end if;
      end if;
    end if;
  end process;
  ROCAckBuf <= ROCAckCnt;
  ROCiReady <= RCReady;
  
end Behavioral;
