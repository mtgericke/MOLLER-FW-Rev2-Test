----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/28/2020 01:53:29 PM
-- Design Name: 
-- Module Name: TrigCheck - Behavioral
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
--use ieee.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity TrigCheck is
  Port ( Clock : in STD_LOGIC;
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
end TrigCheck;

architecture Behavioral of TrigCheck is

  signal DiffCount : std_logic_vector(7 downto 0) := (others => '0');
  signal SentCount : std_logic_vector(7 downto 0) := (others => '0');
  signal BusyTrigC : std_logic_vector(7 downto 0) := (others => '0');
  signal BusyTrigInt : std_logic;
  signal DiffCEN   : std_logic;
  signal SentCEN   : std_logic;
  signal BusyCEN   : std_logic;
  signal SentDCok  : std_logic;  -- OK for down Count
  signal DiffDCok  : std_logic;
  
begin

  BusyCEN <= PulseTrig xor (TrigRcvd and BusyTrigInt);
  SentCEN <= ((BlkAckd and SentDCok) or NewBlock) and (NewBlock xor BlkAckd);
  DiffCEN <= ((BlkRcvd and DiffDCok) or NewBlock) and (NewBlock xor BlkRcvd);
  SentDCok <= SentCount(7) or SentCount(6) or SentCount(5) or SentCount(4) or
              SentCount(3) or SentCount(2) or SentCount(1) or SentCount(0);
  DiffDCok <= DiffCount(7) or DiffCount(6) or DiffCount(5) or DiffCount(4) or
              DiffCount(3) or DiffCount(2) or DiffCount(1) or DiffCount(0);
  process (Clock)
  begin
    if (Clock'event and Clock = '1') then
      -- counters
      if (Reset = '1') then
        DiffCount <= (others => '0');
        SentCount <= (others => '0');
        BusyTrigC <= (others => '0');
      else
        -- BusyTrig counter
        if (BusyCEN = '1') then
          if (PulseTrig = '1') then
            BusyTrigC <= BusyTrigC + 1;
          else
            BusyTrigC <= BusyTrigC - 1;
          end if;  -- Up/Down count
        end if;    -- Counter Enable

        -- Block sent counter
        if (SentCEN = '1') then
          if (NewBlock = '1') then
            SentCount <= SentCount + 1;
          else
            SentCount <= SentCount - 1;
          end if;
        end if;
      
        -- Block Difference counter
        if (DiffCEN = '1') then
          if (NewBlock = '1') then
            DiffCount <= DiffCount + 1;
          else
            DiffCount <= DiffCount - 1;
          end if;
        end if;
      end if;   -- Reset

      if (SentCount >= BusyTh) then
        BusyBlk <= '1';
      else
        BusyBlk <= '0';
      end if;
      
      TooManyAck <= BlkAckd and (not SentDCok);
    end if;     -- Clock
  end process;
    
  BusyTrigInt <= BusyTrigC(0) or BusyTrigC(1);
  BusyTrig <= BusyTrigInt;
  BlockSent(7 downto 0) <= SentCount(7 downto 0);
  BlockDiff(7 downto 0) <= DiffCount(7 downto 0);
    
end Behavioral;
