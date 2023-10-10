----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/24/2020 02:50:49 PM
-- Design Name: 
-- Module Name: SyncDecode - Behavioral
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

entity SyncDecode is
    Port ( Clock : in STD_LOGIC;
           ClkSlow : in std_logic;
           SyncIn : in STD_LOGIC;
           SyncDly : in STD_LOGIC_VECTOR (7 downto 0);
           Reset : out STD_LOGIC;
           ReadStart : out STD_LOGIC;
           WriteStart : out STD_LOGIC;
           ValidCode : out STD_LOGIC;
           SyncRst : out STD_LOGIC_VECTOR (15 downto 0);
           SyncMon : out STD_LOGIC_VECTOR (3 downto 0));
end SyncDecode;

architecture Behavioral of SyncDecode is
  component SigDelay
    Port ( SigIn : in STD_LOGIC;
      Clock : in STD_LOGIC;
      DelayVal : in STD_LOGIC_VECTOR (7 downto 0);
      SigOutMax : out std_logic;
      SigOut : out STD_LOGIC);
  end component;

  signal SigDelayed : std_logic;
  signal ParSync    : std_logic_vector(15 downto 0) := (others => '0');
  signal ValidInt   : std_logic;
  signal ReadStartReg : std_logic;
  signal ReadStartInt : std_logic;
  signal WriteStartReg : std_logic;
  signal WriteStartInt : std_logic;
begin

-- Sync input delay
  Sync_delay : SigDelay
    Port map ( SigIn => SyncIn, -- in STD_LOGIC;
      Clock => Clock, -- in STD_LOGIC;
      DelayVal => SyncDly, -- in STD_LOGIC_VECTOR (7 downto 0);
      SigOutMax => open, -- out std_logic;
      SigOut => SigDelayed ); -- out STD_LOGIC);

-- Shift register, serial --> Parallel
  process (Clock)
  begin
    if (Clock'event and Clock = '1') then
      ParSync(15 downto 0) <= ParSync(14 downto 0) & SigDelayed;
    end if;
  end process;

-- Decode the Valid code
  ValidInt <= ParSync(12) and ParSync(11) and ParSync(10) and ParSync(9) and (not ParSync(8))
          and ParSync(3) and   ParSync(2) and ParSync(1) and ParSync(0);  
  ValidCode <= ValidInt;
  process (Clock)
  begin
    if (Clock'event and Clock = '1') then
      if (ValidInt = '1') then
        SyncMon <= ParSync(7 downto 4);
      end if;
      if (ReadStartInt = '1') then
        ReadStartReg <= '0';
      elsif ((ValidInt = '1') and (ParSync(7) = '0') and (ParSync(6) = '1') and (ParSync(5) = '0') and (ParSync(4) = '1')) then
        ReadStartReg <= '1'; --ValidInt and (not ParSync(7)) and ParSync(6) and (not ParSync(5)) and ParSync(4);
      end if;
      if (WriteStartInt = '1') then
        WriteStartReg <= '0';
      elsif ((ValidInt = '1') and (ParSync(7) = '0') and (ParSync(6) = '1') and (ParSync(5) = '1') and (ParSync(4) = '1')) then
        WriteStartReg <= '1'; --ValidInt and (not ParSync(7)) and ParSync(6) and (not ParSync(5)) and ParSync(4);
      end if;
        
      SyncRst(1)  <= ValidInt and (not ParSync(7)) and (not ParSync(6)) and (not ParSync(5)) and ParSync(4);
      SyncRst(2)  <= ValidInt and (not ParSync(7)) and (not ParSync(6)) and ParSync(5) and (not ParSync(4));
      SyncRst(3)  <= ValidInt and (not ParSync(7)) and (not ParSync(6)) and ParSync(5) and ParSync(4);
      SyncRst(4)  <= ValidInt and (not ParSync(7)) and ParSync(6) and (not ParSync(5)) and (not ParSync(4));
      SyncRst(6)  <= ValidInt and (not ParSync(7)) and ParSync(6) and ParSync(5) and (not ParSync(4));
      SyncRst(8)  <= ValidInt and ParSync(7) and (not ParSync(6)) and (not ParSync(5)) and (not ParSync(4));
      SyncRst(9)  <= ValidInt and ParSync(7) and (not ParSync(6)) and (not ParSync(5)) and ParSync(4);
      SyncRst(10) <= ValidInt and ParSync(7) and (not ParSync(6)) and ParSync(5) and (not ParSync(4));
      SyncRst(11) <= ValidInt and ParSync(7) and (not ParSync(6)) and ParSync(5) and ParSync(4);
      SyncRst(12) <= ValidInt and ParSync(7) and ParSync(6) and (not ParSync(5)) and (not ParSync(4));
      Reset       <= ValidInt and ParSync(7) and ParSync(6) and (not ParSync(5)) and ParSync(4);
      SyncRst(14) <= ValidInt and ParSync(7) and ParSync(6) and ParSync(5) and (not ParSync(4));
    end if;
  end process;
  process(ClkSLow)
  begin
    if (ClkSlow'event and ClkSlow = '1') then
      ReadStartInt  <= ReadStartReg;
      WriteStartInt <= WriteStartReg;
    end if;
  end process;
  ReadStart  <= ReadStartInt;
  WriteStart <= WriteStartInt;
end Behavioral;
