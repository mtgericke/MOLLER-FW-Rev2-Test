----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/09/2020 07:57:41 AM
-- Design Name: 
-- Module Name: TriggerRules - Behavioral
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
library UNISIM;
use UNISIM.VComponents.all;

entity TriggerRules is
  port ( Busy    : in  std_logic; 
--    ClkSlowIn    : in  std_logic; 
    Clock        : in  std_logic; 
    SuperSlowEn  : in  std_logic;
    EndOfRun     : in  std_logic; 
    MinRuleWidth : in  std_logic_vector (31 downto 0); 
    PeriodA      : in  std_logic_vector (31 downto 0); 
    Reset        : in  std_logic; 
    TrigIn       : in  std_logic; 
    TestPt       : out std_logic_vector(16 downto 1);
    BusyRule     : out std_logic; 
    PreTrgD      : out std_logic; 
    PreTrged     : out std_logic; 
    TrigOut      : out std_logic);
end TriggerRules;

architecture Behavioral of TriggerRules is

  component TriggerClock is
    Port ( Clock : in STD_LOGIC;
      TrigIn  : in STD_LOGIC;
      ClockEn : in STD_LOGIC;
      TrigOut : out STD_LOGIC;
      Reset   : in STD_LOGIC);
  end component TriggerClock;
  component  TriggerClockSlow is
    Port ( Clock : in STD_LOGIC;
      TrigIn  : in  STD_LOGIC;
      ClkSlow : in  std_logic;
      ClockEn : in  STD_LOGIC;
      TrigOut : out STD_LOGIC;
      Reset   : in  STD_LOGIC);
  end component TriggerClockSlow;
  component TriggerRule is
    Port (ClkFast : in STD_LOGIC;  -- fast clock for trigger rule
      ClkSlow : in STD_LOGIC;  -- slow clock for trigger rule
      TrigFIn : in STD_LOGIC;  -- fast trigger in for fast clock rule
      TrigSIn : in STD_LOGIC;  -- slow trigger in for slow clock rule
      TrigFEn : in STD_LOGIC;  -- fast trigger rule enable
      TrigSEn : in STD_LOGIC;  -- slow trigger rule enable
      TrigIn  : in std_logic;  -- trigger input for the counter
      TrigRule : in std_logic_vector(7 downto 0);  -- trigger rule setting
      TestPt   : out std_logic_vector(12 downto 1); 
      Reset   : in std_logic;
      TrigCnt : out STD_LOGIC_VECTOR (2 downto 0)); -- counter of uotstanding triggers
  end component TriggerRule;

  component TriggerWMin is
    Port ( Clock : in STD_LOGIC;
      ClockW : in STD_LOGIC;
      TrigIn : in STD_LOGIC;
      MinWidth : in STD_LOGIC_VECTOR (7 downto 0);
      TrigInhibit : out STD_LOGIC);
  end component TriggerWMin;

  signal ClkSInt     : std_logic_vector(9 downto 0):=(others => '0');
  signal ClkSLow     : std_logic := '0';
  signal BusyRuleInt : std_logic;
  signal PreTrigD    : std_logic;
  signal PreTrigeD   : std_logic;
  signal TrigOutInt  : std_logic := '0';
  signal TrigRstA    : std_logic := '0';
  signal TrigRstB    : std_logic := '0';
  signal TrigRstC    : std_logic := '0';
  signal TrigRstD    : std_logic := '0';
  signal MinWidthB   : std_logic := '0';
  signal MinWidthC   : std_logic := '0';
  signal MinWidthD   : std_logic := '0';
  signal Clock2En    : std_logic := '0';
  signal Clock4En    : std_logic := '0';
  signal PreClock4En : std_logic := '0';
  signal ClockS2En    : std_logic := '0';
  signal ClockS4En    : std_logic := '0';
  signal ClockS8En    : std_logic := '0';
  signal PreClockS4En : std_logic := '0';
  signal PreClockS8En : std_logic := '0';
  signal TrigRuleCnt  : std_logic_vector(11 downto 0);
  signal TrigClk2   : std_logic;
  signal TrigClk4   : std_logic;
  signal TrigSlow   : std_logic;
  signal TrigSlow2  : std_logic;
  signal TrigSlow4  : std_logic;
  signal TrigSlow8  : std_logic;
  signal ClockMon   : std_logic := '0';

begin
-- slow clock generation
  process (Clock)
  begin
    if (Clock'event and Clock = '1') then
      if (Reset = '1') then
        ClkSInt(9 downto 0) <= (others => '0');
      else
        ClkSInt <= ClkSInt + 1;
      end if;
    end if;
  end process;
  SlowClockSelect : BUFGMUX_CTRL
   port map (O => ClkSlow,   -- 1-bit output: Clock output
     I0 => ClkSInt(4),     -- 1-bit input: Clock input (S=0)
     I1 => ClkSInt(9),    -- 1-bit input: Clock input (S=1)
     S  => SuperSlowEn ); -- 1-bit input: Clock select

--  TestPt(1) <= TrigIn;
--  TestPt(2) <= Clock2En;
--  TestPt(3) <= TrigRstA;
--  TestPt(4) <= Reset;
--  TestPt(5) <= TrigSlow;
--  TestPt(6) <= MinWidthB;
--  TestPt(7) <= PreTrigD;
--  TestPt(8) <= TrigRstB;
  TestPt(4 downto 1) <= TrigRuleCnt(0) & TrigRuleCnt(1) & TrigRstB & ClockMon; -- TrigRstC; -- & TrigRstD & MinWidthB & MinWidthC & MinWidthD;

-- Trigger Input, and Trigger Output
  PreTrigD <= TrigIn and (not Busy) and (not EndOfRun);
  BusyRuleInt <= TrigRstA or TrigRstB or TrigRstC or TrigRstD or MinWidthB or MinWidthC or MinWidthD;
  PreTriged <= PreTrigD and (not BusyRuleInt);
  PreTrgD  <= PreTrigD;
  PreTrged <= PreTriged;
  process (Clock)
  begin
    if (CLock'event and Clock = '1') then
      if ((Reset = '1') or (TrigOutInt = '1')) then
        TrigOutInt <= '0';
      else
        TrigOutInt <= PreTriged;
      end if;
    end if;
  end process;
  TrigOut <= TrigOutInt;
  BusyRule <= BusyRuleInt;
  
-- Clock enable logic;
  process (Clock)
  begin
    if (Clock'event and Clock = '1') then
      if (Clock2En = '1') then
        Clock2En <= '0';
      else 
        Clock2En <= '1';
      end if;
      if (Clock4En = '1') then
        Clock4En <= '0';
        PreClock4En <= '0';
      elsif (Clock2En = '1') then
        PreClock4En <= '1';
        Clock4En <= PreClock4En;
      end if;
      ClockMon <= (not ClockMon);
    end if;
  end process;  
  process (ClkSlow)
  begin
    if (ClkSlow'event and ClkSlow = '1') then
      if (ClockS2En = '1') then
        ClockS2En <= '0';
      else 
        ClockS2En <= '1';
      end if;
      if (ClockS4En = '1') then
        ClockS4En <= '0';
        PreClockS4En <= '0';
      elsif (ClockS2En = '1') then
        PreClockS4En <= '1';
        ClockS4En <= PreClockS4En;
      end if;
      if (ClockS8En = '1') then
        ClockS8En <= '0';
        PreClockS8En <= '0';
      elsif (ClockS4En = '1') then
        PreClockS8En <= '1';
        ClockS8En <= PreClockS8En;
      end if;
    end if;
  end process;  

  TrigClk2Generation : TriggerClock
    Port map( Clock => Clock, -- in STD_LOGIC;
      TrigIn  => TrigOutInt,  --  in STD_LOGIC;
      ClockEn => Clock2En,    -- in STD_LOGIC;
      TrigOut => TrigClk2,    -- out STD_LOGIC;
      Reset   => Reset );     -- in STD_LOGIC);
  TrigClk4Generation : TriggerClock
    Port map( Clock => Clock, -- in STD_LOGIC;
      TrigIn  => TrigOutInt,  --  in STD_LOGIC;
      ClockEn => Clock4En,    -- in STD_LOGIC;
      TrigOut => TrigClk4,    -- out STD_LOGIC;
      Reset   => Reset );     -- in STD_LOGIC);
  TrigClkSlowGeneration : TriggerClockSlow
    Port map(Clock => Clock, -- in STD_LOGIC;
      TrigIn  => TrigOutInt, -- in  STD_LOGIC;
      ClkSlow => ClkSlow,    --  in  std_logic;
      ClockEn => '1',        -- in  STD_LOGIC;
      TrigOut => TrigSlow,   -- out STD_LOGIC;
      Reset   => Reset );    -- in  STD_LOGIC);
  Trig2ClkSlowGeneration : TriggerClockSlow
    Port map(Clock => Clock, -- in STD_LOGIC;
      TrigIn  => TrigOutInt, -- in  STD_LOGIC;
      ClkSlow => ClkSlow,    --  in  std_logic;
      ClockEn => ClockS2En,  -- in  STD_LOGIC;
      TrigOut => TrigSlow2,  -- out STD_LOGIC;
      Reset   => Reset );    -- in  STD_LOGIC);
  Trig4ClkSlowGeneration : TriggerClockSlow
    Port map(Clock => Clock, -- in STD_LOGIC;
      TrigIn  => TrigOutInt, -- in  STD_LOGIC;
      ClkSlow => ClkSlow,    --  in  std_logic;
      ClockEn => ClockS4En,  -- in  STD_LOGIC;
      TrigOut => TrigSlow4,  -- out STD_LOGIC;
      Reset   => Reset );    -- in  STD_LOGIC);
  Trig8ClkSlowGeneration : TriggerClockSlow
    Port map(Clock => Clock, -- in STD_LOGIC;
      TrigIn  => TrigOutInt, -- in  STD_LOGIC;
      ClkSlow => ClkSlow,    --  in  std_logic;
      ClockEn => ClockS8En,  -- in  STD_LOGIC;
      TrigOut => TrigSlow8,  -- out STD_LOGIC;
      Reset   => Reset );    -- in  STD_LOGIC);

  -- no more than one trigger in Period(7:0)
  TriggerRule1 : TriggerRule
    Port map(ClkFast => Clock, -- in STD_LOGIC;  -- fast clock for trigger rule
      ClkSlow => ClkSlow,      --  in STD_LOGIC;  -- slow clock for trigger rule
      TrigFIn => TrigOutInt,   -- in STD_LOGIC;  -- fast trigger in for fast clock rule
      TrigSIn => TrigSlow,     -- in STD_LOGIC;  -- slow trigger in for slow clock rule
      TrigFEn => '1',          -- in STD_LOGIC;  -- fast trigger rule enable
      TrigSEn => '1',          -- in STD_LOGIC;  -- slow trigger rule enable
      TrigIn  => TrigOutInt,   -- in std_logic;  -- trigger input for the counter
      TrigRule => PeriodA(7 downto 0),      -- in std_logic_vector(7 downto 0);  -- trigger rule setting
      TestPt  => TestPt(16 downto 5), 
      Reset   => Reset,                     -- in std_logic;
      TrigCnt => TrigRuleCnt(2 downto 0) ); -- out STD_LOGIC_VECTOR (2 downto 0)); -- counter of uotstanding trigger
  TrigRstA <= TrigRuleCnt(0) or TrigRuleCnt(1) or TrigRuleCnt(2);  -- >= 1

  -- no more than two triggers in Period(15:8)
  TriggerRule2 : TriggerRule
    Port map(ClkFast => Clock, -- in STD_LOGIC;  -- fast clock for trigger rule
      ClkSlow => ClkSlow,      --  in STD_LOGIC;  -- slow clock for trigger rule
      TrigFIn => TrigOutInt,   -- in STD_LOGIC;  -- fast trigger in for fast clock rule
      TrigSIn => TrigSlow2,    -- in STD_LOGIC;  -- slow trigger in for slow clock rule
      TrigFEn => '1',          -- in STD_LOGIC;  -- fast trigger rule enable
      TrigSEn => ClockS2En,    -- in STD_LOGIC;  -- slow trigger rule enable
      TrigIn  => TrigOutInt,   -- in std_logic;  -- trigger input for the counter
      TrigRule => PeriodA(15 downto 8),     -- in std_logic_vector(7 downto 0);  -- trigger rule setting
      TestPt  => open,
      Reset   => Reset,                     -- in std_logic;
      TrigCnt => TrigRuleCnt(5 downto 3) ); -- out STD_LOGIC_VECTOR (2 downto 0)); -- counter of uotstanding triggers
  TrigRstB <= TrigRuleCnt(4) or TrigRuleCnt(5);  -- >= 2

  -- no more than three triggers in Period(23:16)
  TriggerRule3 : TriggerRule
    Port map(ClkFast => Clock, -- in STD_LOGIC;  -- fast clock for trigger rule
      ClkSlow => ClkSlow,      --  in STD_LOGIC;  -- slow clock for trigger rule
      TrigFIn => TrigClk2,     -- in STD_LOGIC;  -- fast trigger in for fast clock rule
      TrigSIn => TrigSlow4,    -- in STD_LOGIC;  -- slow trigger in for slow clock rule
      TrigFEn => Clock2En,     -- in STD_LOGIC;  -- fast trigger rule enable
      TrigSEn => ClockS4En,    -- in STD_LOGIC;  -- slow trigger rule enable
      TrigIn  => TrigOutInt,   -- in std_logic;  -- trigger input for the counter
      TrigRule => PeriodA(23 downto 16),    -- in std_logic_vector(7 downto 0);  -- trigger rule setting
      TestPt  => open,
      Reset   => Reset,                     -- in std_logic;
      TrigCnt => TrigRuleCnt(8 downto 6) ); -- out STD_LOGIC_VECTOR (2 downto 0)); -- counter of uotstanding triggers
  TrigRstC <= (TrigRuleCnt(6) and TrigRuleCnt(7)) or TrigRuleCnt(8);  -- >= 3

  -- no more than four triggers in Period(31:24)
  TriggerRule4 : TriggerRule
    Port map(ClkFast => Clock, -- in STD_LOGIC;  -- fast clock for trigger rule
      ClkSlow => ClkSlow,      --  in STD_LOGIC;  -- slow clock for trigger rule
      TrigFIn => TrigClk4,     -- in STD_LOGIC;  -- fast trigger in for fast clock rule
      TrigSIn => TrigSlow8,    -- in STD_LOGIC;  -- slow trigger in for slow clock rule
      TrigFEn => Clock4En,     -- in STD_LOGIC;  -- fast trigger rule enable
      TrigSEn => ClockS8En,    -- in STD_LOGIC;  -- slow trigger rule enable
      TrigIn  => TrigOutInt,   -- in std_logic;  -- trigger input for the counter
      TrigRule => PeriodA(31 downto 24),     -- in std_logic_vector(7 downto 0);  -- trigger rule setting
      TestPt  => open,
      Reset   => Reset,                      -- in std_logic;
      TrigCnt => TrigRuleCnt(11 downto 9) ); -- out STD_LOGIC_VECTOR (2 downto 0)); -- counter of uotstanding triggers
  TrigRstD <= TrigRuleCnt(11);  -- >= 4

-- Minimum trigger holdoff after trigger rule2
  TriggerInhibit2 : TriggerWMin
    Port map( Clock => Clock, -- in STD_LOGIC;
      ClockW   => Clock,      -- in STD_LOGIC;
      TrigIn   => TrigRstB,   -- in STD_LOGIC;
      MinWidth => MinRuleWidth(15 downto 8), -- in STD_LOGIC_VECTOR (7 downto 0);
      TrigInhibit => MinWidthB );            -- out STD_LOGIC);

-- Minimum trigger holdoff after trigger rule3
  TriggerInhibit3 : TriggerWMin
    Port map( Clock => Clock, -- in STD_LOGIC;
      ClockW   => ClkSlow,    -- in STD_LOGIC;
      TrigIn   => TrigRstC,   -- in STD_LOGIC;
      MinWidth => MinRuleWidth(23 downto 16), -- in STD_LOGIC_VECTOR (7 downto 0);
      TrigInhibit => MinWidthC );             -- out STD_LOGIC);

-- Minimum trigger holdoff after trigger rule4
  TriggerInhibit4 : TriggerWMin
    Port map( Clock => Clock, -- in STD_LOGIC;
      ClockW   => ClkSlow,    -- in STD_LOGIC;
      TrigIn   => TrigRstD,   -- in STD_LOGIC;
      MinWidth => MinRuleWidth(31 downto 24), -- in STD_LOGIC_VECTOR (7 downto 0);
      TrigInhibit => MinWidthD  );            -- out STD_LOGIC);

end Behavioral;
