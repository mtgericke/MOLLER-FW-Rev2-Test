----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/09/2020 10:00:19 AM
-- Design Name: 
-- Module Name: TriggerRule - Behavioral
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

entity TriggerRule is
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
end TriggerRule;

architecture Behavioral of TriggerRule is

  signal TrigFast  : std_logic_vector(6 downto 0);
  signal TrigSlow  : std_logic_vector(6 downto 0);
  signal TrigOutF  : std_logic;
  signal DlyTrigF  : std_logic;
  signal TrigOutS  : std_logic;
  signal DlyTrigS  : std_logic;
  signal ClrRstTrig : std_logic:='0';
  signal TrigGiga   : std_logic;
  signal TrigOutSyncS : std_logic := '0';
  signal RstTrigGiga  : std_logic := '0';
  signal TrigOut    : std_logic;
  signal TrigCntInt : std_logic_vector(2 downto 0):=(others => '0');
  signal TrigCntEn  : std_logic;
  signal DownCntEn  : std_logic;
  signal StuckCnt   : std_logic_vector(10 downto 0);
  signal ResetTrigGiga : std_logic;
  signal ClkFastMon    : std_logic := '0';
  
begin

  -- Fast clock trigger rule
  FastClkDelay1 : SRLC32E
    generic map (INIT => X"00000000", -- Initial contents of shift register
      IS_CLK_INVERTED => '0' )        -- Optional inversion for CLK
    port map (Q => TrigFast(0),       -- 1-bit output: SRL Data
      Q31 => TrigFast(4),          -- 1-bit output: SRL Cascade Data
      A   => TrigRule(4 downto 0), -- 5-bit input: Selects SRL depth
      CE  => TrigFEn,              -- 1-bit input: Clock enable
      CLK => ClkFast,              -- 1-bit input: Clock
      D   => TrigFIn );            -- 1-bit input: SRL Data
  FastClkDelay2 : SRLC32E
    generic map (INIT => X"00000000", -- Initial contents of shift register
      IS_CLK_INVERTED => '0' )        -- Optional inversion for CLK
    port map (Q => TrigFast(1),       -- 1-bit output: SRL Data
      Q31 => TrigFast(5),          -- 1-bit output: SRL Cascade Data
      A   => TrigRule(4 downto 0), -- 5-bit input: Selects SRL depth
      CE  => TrigFEn,              -- 1-bit input: Clock enable
      CLK => ClkFast,              -- 1-bit input: Clock
      D   => TrigFast(4) );        -- 1-bit input: SRL Data
  FastClkDelay3 : SRLC32E
    generic map (INIT => X"00000000", -- Initial contents of shift register
      IS_CLK_INVERTED => '0' )        -- Optional inversion for CLK
    port map (Q => TrigFast(2),       -- 1-bit output: SRL Data
      Q31 => TrigFast(6),          -- 1-bit output: SRL Cascade Data
      A   => TrigRule(4 downto 0), -- 5-bit input: Selects SRL depth
      CE  => TrigFEn,              -- 1-bit input: Clock enable
      CLK => ClkFast,              -- 1-bit input: Clock
      D   => TrigFast(5) );        -- 1-bit input: SRL Data
  FastClkDelay4 : SRLC32E
    generic map (INIT => X"00000000", -- Initial contents of shift register
      IS_CLK_INVERTED => '0' )        -- Optional inversion for CLK
    port map (Q => TrigFast(3),       -- 1-bit output: SRL Data
      Q31 => open, --TrigFast(7),          -- 1-bit output: SRL Cascade Data
      A   => TrigRule(4 downto 0), -- 5-bit input: Selects SRL depth
      CE  => TrigFEn,              -- 1-bit input: Clock enable
      CLK => ClkFast,              -- 1-bit input: Clock
      D   => TrigFast(6) );        -- 1-bit input: SRL Data
  process (TrigFast, TrigRule)
  begin
    case (TrigRule(6 downto 5)) is
      when ("00") =>   TrigOutF <= TrigFast(0);
      when ("01") =>   TrigOutF <= TrigFast(1);
      when ("10") =>   TrigOutF <= TrigFast(2);
      when ("11") =>   TrigOutF <= TrigFast(3);
    end case;
  end process;
  process (ClkFast)
  begin
    if (ClkFast'event and ClkFast = '1') then
      if (DlyTrigF = '1') then
        DlyTrigF <= '0';
      elsif (TrigFEn = '1') then
        DlyTrigF <= TrigOutF;
      end if;
--      TestPt(1) <= TrigGiga;
    end if;
  end process;
  process (ClkFast, TrigCntInt(0))
  begin
    if (TrigCntInt(0) = '0') then
      StuckCnt <= (others => '0');
    else
      if (ClkFast'event and ClkFast = '1') then
        StuckCnt <= StuckCnt + 1;
      end if;
    end if;
  end process;
  TestPt(8 downto 1) <= StuckCnt(10) & ResetTrigGiga & TrigGiga & TrigCntEn & TrigOutSyncS & TrigIn & RstTrigGiga & TrigSIn;
  TestPt(12 downto 9) <= ClkFastMon & TrigOutS & TrigSlow(0) & ClrRstTrig;
  process (TrigGiga, DlyTrigF, TrigRule)
  begin
    if (TrigRule(7) = '1') then
      TrigOut <= TrigGiga;
    else
      TrigOut <= DlyTrigF;
    end if;
  end process;
  DownCntEn <= TrigCntInt(0) or TrigCntInt(1) or TrigCntint(2);
  TrigCnt <= TrigCntInt;
  TrigCntEn <= TrigIn xor (DownCntEn and TrigOut);

  ResetTrigGiga <= RstTrigGiga or TrigGiga;
  
  process (ClkFast)
  begin
    if (ClkFast'event and ClkFast = '1') then
      if (ResetTrigGiga = '1') then  -- This RstTrigGiga is part of the RstTrigGiga of the schematic design
        TrigOutSyncS <= '0';
        TrigGiga <= '0';
      else
        TrigOutSyncS <= TrigOutS;
        TrigGiga <= TrigOutS and TrigOutSyncS;
      end if;
      ClkFastMon <= (not ClkFastMon);
    end if;
  end process;    
  process (ClkFast, ClrRstTrig)
  begin
    if (ClrRstTrig = '1') then
      RstTrigGiga <= '0';
    else
      if (ClkFast'event and ClkFast = '1') then
        if (TrigGiga = '1') then
          RstTrigGiga <= '1';
        end if;
      end if;
    end if;   -- end of ClkFast rising edge
  end process;
  
  process (ClkFast, Reset)
  begin
    if (Reset = '1') then
      TrigCntInt <= (others => '0');
    else
      if (ClkFast'event and ClkFast = '0') then
        if (TrigCntEn = '1') then
          if (TrigIn = '1') then
            TrigCntInt <= TrigCntInt + 1;
          else
            TrigCntInt <= TrigCntInt - 1;
          end if;
        end if;
      end if;
    end if;  -- end of RESET
  end process;

  -- Slow clock trigger rule
  SlowClkDelay1 : SRLC32E
    generic map (INIT => X"00000000", -- Initial contents of shift register
      IS_CLK_INVERTED => '0' )        -- Optional inversion for CLK
    port map (Q => TrigSlow(0),       -- 1-bit output: SRL Data
      Q31 => TrigSlow(4),          -- 1-bit output: SRL Cascade Data
      A   => TrigRule(4 downto 0), -- 5-bit input: Selects SRL depth
      CE  => TrigSEn,              -- 1-bit input: Clock enable
      CLK => ClkSlow,              -- 1-bit input: Clock
      D   => TrigSIn );            -- 1-bit input: SRL Data
  SlowClkDelay2 : SRLC32E
    generic map (INIT => X"00000000", -- Initial contents of shift register
      IS_CLK_INVERTED => '0' )        -- Optional inversion for CLK
    port map (Q => TrigSlow(1),       -- 1-bit output: SRL Data
      Q31 => TrigSlow(5),          -- 1-bit output: SRL Cascade Data
      A   => TrigRule(4 downto 0), -- 5-bit input: Selects SRL depth
      CE  => TrigSEn,              -- 1-bit input: Clock enable
      CLK => ClkSlow,              -- 1-bit input: Clock
      D   => TrigSlow(4) );        -- 1-bit input: SRL Data
  SlowClkDelay3 : SRLC32E
    generic map (INIT => X"00000000", -- Initial contents of shift register
      IS_CLK_INVERTED => '0' )        -- Optional inversion for CLK
    port map (Q => TrigSlow(2),       -- 1-bit output: SRL Data
      Q31 => TrigSlow(6),          -- 1-bit output: SRL Cascade Data
      A   => TrigRule(4 downto 0), -- 5-bit input: Selects SRL depth
      CE  => TrigSEn,              -- 1-bit input: Clock enable
      CLK => ClkSlow,              -- 1-bit input: Clock
      D   => TrigSlow(5) );        -- 1-bit input: SRL Data
  SlowClkDelay4 : SRLC32E
    generic map (INIT => X"00000000", -- Initial contents of shift register
      IS_CLK_INVERTED => '0' )        -- Optional inversion for CLK
    port map (Q => TrigSlow(3),       -- 1-bit output: SRL Data
      Q31 => open, --TrigSlow(7),          -- 1-bit output: SRL Cascade Data
      A   => TrigRule(4 downto 0), -- 5-bit input: Selects SRL depth
      CE  => TrigSEn,              -- 1-bit input: Clock enable
      CLK => ClkSlow,              -- 1-bit input: Clock
      D   => TrigSlow(6) );        -- 1-bit input: SRL Data
  process (TrigSlow, TrigRule)
  begin
    case (TrigRule(6 downto 5)) is
      when ("00") =>   TrigOutS <= TrigSlow(0);
      when ("01") =>   TrigOutS <= TrigSlow(1);
      when ("10") =>   TrigOutS <= TrigSlow(2);
      when ("11") =>   TrigOutS <= TrigSlow(3);
    end case;
  end process;
  
  process (ClkSlow, TrigGiga)
  begin
    if (TrigGiga = '1') then
      ClrRstTrig <= '0';
    else
      if (ClkSlow'event and ClkSlow = '1') then
        if (TrigSEn = '1') then
          ClrRstTrig <= TrigOutS;
        end if;
      end if;
    end if;
  end process;

end Behavioral;
