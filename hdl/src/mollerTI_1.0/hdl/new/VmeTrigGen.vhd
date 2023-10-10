----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/09/2020 02:30:52 PM
-- Design Name: 
-- Module Name: VmeTrigGen - Behavioral
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

entity VmeTrigGen is
  Port (ClkVme : in STD_LOGIC;
    Busy       : in    std_logic; 
    NTrgLoad   : in    std_logic; 
    NTrgSet    : in    std_logic_vector (15 downto 0); 
    Reset      : in    std_logic; 
    TrgRate    : in    std_logic_vector (15 downto 0); 
    VmeTrgEn   : in    std_logic; 
    Clock      : in STD_LOGIC;
    TrigOut    : out STD_LOGIC);
end VmeTrigGen;

architecture Behavioral of VmeTrigGen is

  component  VmeTrgRate is
    Port (Count : in  STD_LOGIC_VECTOR (31 downto 0);
      Rate : in  STD_LOGIC_VECTOR (15 downto 0);
      Clk : in  STD_LOGIC;
      Timed : out  STD_LOGIC);
  end component VmeTrgRate;

  COMPONENT Count48DSP
    PORT (CLK : IN STD_LOGIC;
      CE : IN STD_LOGIC;
      SCLR : IN STD_LOGIC;
      Q : OUT STD_LOGIC_VECTOR(47 DOWNTO 0)  );
  END COMPONENT;

  signal TrigNeed  : std_logic_vector(15 downto 0) :=(others => '0');
  signal MoreEvent : std_logic;
  signal NoLimit   : std_logic;
  signal CntL1A    : std_logic;
  signal CnTrig    : std_logic_vector(31 downto 0);
  signal VTrgEn    : std_logic;
  signal PreTrigOut : std_logic;
  signal TrigOutInt : std_logic;
  
begin

--  NoLimit <= TrigNeed(15) and TrigNeed(14) and TrigNeed(13) and TrigNeed(12)
--         and TrigNeed(11) and TrigNeed(10) and TrigNeed(9)  and TrigNeed(8)
--         and TrigNeed(7)  and TrigNeed(6)  and TrigNeed(5)  and TrigNeed(4)
--         and TrigNeed(3 ) and TrigNeed(2)  and TrigNeed(1)  and TrigNeed(0);
  NoLimit <= NTrgSet(15) and NTrgSet(14) and NTrgSet(13) and NTrgSet(12) and NTrgSet(11)
         and NTrgSet(10) and NTrgSet(9) and NTrgSet(8) and NTrgSet(7) and NTrgSet(6)
         and NTrgSet(5) and NTrgSet(4) and NTrgSet(3) and NTrgSet(2) and NTrgSet(1) and NTrgSet(0); 
  MoreEvent <= TrigNeed(15) or TrigNeed(14) or TrigNeed(13) or TrigNeed(12)
            or TrigNeed(11) or TrigNeed(10) or TrigNeed(9)  or TrigNeed(8)
            or TrigNeed(7)  or TrigNeed(6)  or TrigNeed(5)  or TrigNeed(4)
            or TrigNeed(3)  or TrigNeed(2)  or TrigNeed(1)  or TrigNeed(0);

-- Use DSP counter, instead of the fabric counter
  CnTrigCounterDSP : Count48DSP
    PORT MAP (CLK => ClkVme,     -- IN STD_LOGIC;
      CE          => VTrgEn,     -- IN STD_LOGIC;
      SCLR        => CntL1A,     -- IN STD_LOGIC;
      Q(31 downto 0)  => CnTrig(31 downto 0), -- OUT STD_LOGIC_VECTOR(47 DOWNTO 0)
      Q(47 downto 32) => open   );
  process (ClkVme)
  begin
    if (ClkVme'event and ClkVme = '1') then
      if (Reset = '1') then
        TrigNeed <= (others => '0');
      elsif (NTrgLoad = '1') then
        TrigNeed <= NTrgSet(15 downto 0);
      elsif ((CntL1A= '1') and (MoreEvent = '1') and (NoLimit = '0')) then
        TrigNeed <= TrigNeed -1;
      end if;
      VTrgEn <= MoreEvent;
--      if (CntL1A = '1') then
--        CnTrig(31 downto 0) <= (others => '0');
--      elsif (VTrgEn = '1') then
--        CnTrig <= CnTrig + 1;
--      end if;
    end if;
  end process;

-- FDCE  
  process (ClkVme, TrigOutInt, Busy)
  begin
    if (TrigOutInt = '1' or Busy = '1') then
      PreTrigOut <= '0';
    elsif (ClkVme'event and ClkVme = '1') then
      if (CntL1A = '1') then
        PreTrigOut <= '1';
      end if;
    end if;
  end process;

-- FDRE
  process (Clock) 
  begin
    if (Clock'event and Clock = '1') then
      if (TrigOutInt = '1') then
        TrigOutInt <= '0';
      elsif (VmeTrgEn = '1') then
        TrigOutInt <= PreTrigOut;
      end if;
    end if;
  end process;
  TrigOut <= TrigOutInt;
    
  VmeTriggerRateCheck : VmeTrgRate
    Port map(Count => CnTrig(31 downto 0), -- in  STD_LOGIC_VECTOR (31 downto 0);
      Rate  => TrgRate(15 downto 0),       -- in  STD_LOGIC_VECTOR (15 downto 0);
      Clk   => ClkVme,                     -- in  STD_LOGIC;
      Timed => CntL1A  );                  -- out  STD_LOGIC);

end Behavioral;
