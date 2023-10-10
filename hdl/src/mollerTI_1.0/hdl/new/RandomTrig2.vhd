----------------------------------------------------------------------------------
-- Company:  Thomas Jefferson National Accelerator Facility
-- Engineer: GU
-- 
-- Create Date: 03/09/2020 03:40:02 PM
-- Design Name:  Trigger Interface
-- Module Name: RandomTrig1 - Behavioral
-- Project Name:    TIFPGA
-- Target Devices:  XCKU3P-1FFA676
-- Tool Versions:   Vivado 2019.1
-- Description:     Random trigger rate generation.
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

entity RandomTrig2 is
  Port (Clock : in STD_LOGIC;
    RTrgRate  : in  std_logic_vector (7 downto 0); 
    TrigOut   : out STD_LOGIC );
end RandomTrig2;

architecture Behavioral of RandomTrig2 is

  signal FeedBkMid  : std_logic_vector(25 downto 0);
  signal FeedBkFnl  : std_logic_vector(25 downto 0);
  signal FeedBkIntA : std_logic_vector(25 downto 0);
  signal FeedBkIntB : std_logic_vector(25 downto 0);
  signal FeedBkIntC : std_logic_vector(25 downto 0);
  signal FeedBkIntD : std_logic_vector(25 downto 0);
  signal FeedIn     : std_logic_vector(25 downto 0);
  signal RTrigEn    : std_logic;
  signal TrigIntA   : std_logic;
  signal CarryOut   : std_logic_vector(15 downto 0);

begin

  RTrigEn <= RTrgRate(7) and (not ( (RTrgRate(0) xor RTrgRate(4)) or 
            (RTrgRate(1) xor RTrgRate(5)) or (RTrgRate(2) xor RTrgRate(6)))); 

  GenerateRandomFeedIn:
    for IModule in 1 to 25 generate
      begin
        FeedIn(IModule) <= RTrigEn and (FeedBkMid(IModule) xnor FeedBkFnl(IModule));
  end generate;
  
  FeedBkFnl(0) <= '0';
  
  -- Linear Feed shift register 95
  LFSR95First : SRLC32E
    generic map (INIT => X"00000000", -- Initial contents of shift register
      IS_CLK_INVERTED => '0' )        -- Optional inversion for CLK
    port map (Q => open,     -- 1-bit output: SRL Data
      Q31 => FeedBkIntB(15), -- 1-bit output: SRL Cascade Data
      A   => "10100",        -- 5-bit input: Selects SRL depth
      CE  => '1',            -- 1-bit input: Clock enable
      CLK => Clock,          -- 1-bit input: Clock
      D   => FeedIn(15) );   -- 1-bit input: SRL Data
  LFSR95Second : SRLC32E
    generic map (INIT => X"00000000", -- Initial contents of shift register
      IS_CLK_INVERTED => '0' )        -- Optional inversion for CLK
    port map (Q => FeedBkIntC(15),    -- 1-bit output: SRL Data
      Q31 => FeedBkIntD(15),   -- 1-bit output: SRL Cascade Data
      A   => "10100",          -- 5-bit input: Selects SRL depth
      CE  => '1',              -- 1-bit input: Clock enable
      CLK => Clock,            -- 1-bit input: Clock
      D   => FeedBkIntB(15) ); -- 1-bit input: SRL Data
  LFSR95FeedMid : SRLC32E
    generic map (INIT => X"00000000", -- Initial contents of shift register
      IS_CLK_INVERTED => '0' )        -- Optional inversion for CLK
    port map (Q => FeedBkMid(15),     -- 1-bit output: SRL Data
      Q31 => open,             -- 1-bit output: SRL Cascade Data
      A   => "11110",          -- 5-bit input: Selects SRL depth
      CE  => '1',              -- 1-bit input: Clock enable
      CLK => Clock,            -- 1-bit input: Clock
      D   => FeedBkIntC(15) ); -- 1-bit input: SRL Data
  LFSR95FeedLast : SRLC32E
    generic map (INIT => X"00000000", -- Initial contents of shift register
      IS_CLK_INVERTED => '0' )        -- Optional inversion for CLK
    port map (Q => FeedBkFnl(15),     -- 1-bit output: SRL Data
      Q31 => open,             -- 1-bit output: SRL Cascade Data
      A   => "11110",          -- 5-bit input: Selects SRL depth
      CE  => '1',              -- 1-bit input: Clock enable
      CLK => Clock,            -- 1-bit input: Clock
      D   => FeedBkIntD(15) ); -- 1-bit input: SRL Data
  
  -- Linear Feed shift register 94
  LFSR94First : SRLC32E
    generic map (INIT => X"00000000", -- Initial contents of shift register
      IS_CLK_INVERTED => '0' )        -- Optional inversion for CLK
    port map (Q => open,     -- 1-bit output: SRL Data
      Q31 => FeedBkIntB(1),  -- 1-bit output: SRL Cascade Data
      A   => "01010",        -- 5-bit input: Selects SRL depth
      CE  => '1',            -- 1-bit input: Clock enable
      CLK => Clock,          -- 1-bit input: Clock
      D   => FeedIn(1) );    -- 1-bit input: SRL Data
  LFSR94Second : SRLC32E
    generic map (INIT => X"00000000", -- Initial contents of shift register
      IS_CLK_INVERTED => '0' )        -- Optional inversion for CLK
    port map (Q => FeedBkIntC(1),     -- 1-bit output: SRL Data
      Q31 => FeedBkIntD(1),    -- 1-bit output: SRL Cascade Data
      A   => "01010",          -- 5-bit input: Selects SRL depth
      CE  => '1',              -- 1-bit input: Clock enable
      CLK => Clock,            -- 1-bit input: Clock
      D   => FeedBkIntB(1) );  -- 1-bit input: SRL Data
  LFSR94FeedMid : SRLC32E
    generic map (INIT => X"00000000", -- Initial contents of shift register
      IS_CLK_INVERTED => '0' )        -- Optional inversion for CLK
    port map (Q => FeedBkMid(1),      -- 1-bit output: SRL Data
      Q31 => open,            -- 1-bit output: SRL Cascade Data
      A   => "11101",         -- 5-bit input: Selects SRL depth
      CE  => '1',             -- 1-bit input: Clock enable
      CLK => Clock,           -- 1-bit input: Clock
      D   => FeedBkIntC(1) ); -- 1-bit input: SRL Data
  LFSR94FeedLast : SRLC32E
    generic map (INIT => X"00000000", -- Initial contents of shift register
      IS_CLK_INVERTED => '0' )        -- Optional inversion for CLK
    port map (Q => FeedBkFnl(1),      -- 1-bit output: SRL Data
      Q31 => open,             -- 1-bit output: SRL Cascade Data
      A   => "11101",          -- 5-bit input: Selects SRL depth
      CE  => '1',              -- 1-bit input: Clock enable
      CLK => Clock,            -- 1-bit input: Clock
      D   => FeedBkIntD(1) );  -- 1-bit input: SRL Data
  
  -- Linear Feed shift register 93
  LFSR93First : SRLC32E
    generic map (INIT => X"00000000", -- Initial contents of shift register
      IS_CLK_INVERTED => '0' )        -- Optional inversion for CLK
    port map (Q => open,     -- 1-bit output: SRL Data
      Q31 => FeedBkIntB(2),  -- 1-bit output: SRL Cascade Data
      A   => "11101",        -- 5-bit input: Selects SRL depth
      CE  => '1',            -- 1-bit input: Clock enable
      CLK => Clock,          -- 1-bit input: Clock
      D   => FeedIn(2) );    -- 1-bit input: SRL Data
  LFSR93Second : SRLC32E
    generic map (INIT => X"00000000", -- Initial contents of shift register
      IS_CLK_INVERTED => '0' )        -- Optional inversion for CLK
    port map (Q => FeedBkIntC(2),     -- 1-bit output: SRL Data
      Q31 => FeedBkIntD(2),    -- 1-bit output: SRL Cascade Data
      A   => "11101",          -- 5-bit input: Selects SRL depth
      CE  => '1',              -- 1-bit input: Clock enable
      CLK => Clock,            -- 1-bit input: Clock
      D   => FeedBkIntB(2) );  -- 1-bit input: SRL Data
  LFSR93FeedMid : SRLC32E
    generic map (INIT => X"00000000", -- Initial contents of shift register
      IS_CLK_INVERTED => '0' )        -- Optional inversion for CLK
    port map (Q => FeedBkMid(2),      -- 1-bit output: SRL Data
      Q31 => open,            -- 1-bit output: SRL Cascade Data
      A   => "11100",         -- 5-bit input: Selects SRL depth
      CE  => '1',             -- 1-bit input: Clock enable
      CLK => Clock,           -- 1-bit input: Clock
      D   => FeedBkIntC(2) ); -- 1-bit input: SRL Data
  LFSR93FeedLast : SRLC32E
    generic map (INIT => X"00000000", -- Initial contents of shift register
      IS_CLK_INVERTED => '0' )        -- Optional inversion for CLK
    port map (Q => FeedBkFnl(2),      -- 1-bit output: SRL Data
      Q31 => open,             -- 1-bit output: SRL Cascade Data
      A   => "11100",          -- 5-bit input: Selects SRL depth
      CE  => '1',              -- 1-bit input: Clock enable
      CLK => Clock,            -- 1-bit input: Clock
      D   => FeedBkIntD(2) );  -- 1-bit input: SRL Data
  
  -- Linear Feed shift register 89
  LFSR89First : SRLC32E
    generic map (INIT => X"00000000", -- Initial contents of shift register
      IS_CLK_INVERTED => '0' )        -- Optional inversion for CLK
    port map (Q => open,     -- 1-bit output: SRL Data
      Q31 => FeedBkIntB(3),  -- 1-bit output: SRL Cascade Data
      A   => "10100",        -- 5-bit input: Selects SRL depth
      CE  => '1',            -- 1-bit input: Clock enable
      CLK => Clock,          -- 1-bit input: Clock
      D   => FeedIn(3) );    -- 1-bit input: SRL Data
  LFSR89FeedMid : SRLC32E
    generic map (INIT => X"00000000", -- Initial contents of shift register
      IS_CLK_INVERTED => '0' )        -- Optional inversion for CLK
    port map (Q => FeedBkMid(3),      -- 1-bit output: SRL Data
      Q31 => FeedBkIntD(3),           -- 1-bit output: SRL Cascade Data
      A   => "10010",         -- 5-bit input: Selects SRL depth
      CE  => '1',             -- 1-bit input: Clock enable
      CLK => Clock,           -- 1-bit input: Clock
      D   => FeedBkIntB(3) ); -- 1-bit input: SRL Data
  LFSR89FeedLast : SRLC32E
    generic map (INIT => X"00000000", -- Initial contents of shift register
      IS_CLK_INVERTED => '0' )        -- Optional inversion for CLK
    port map (Q => FeedBkFnl(3),      -- 1-bit output: SRL Data
      Q31 => open,             -- 1-bit output: SRL Cascade Data
      A   => "11000",          -- 5-bit input: Selects SRL depth
      CE  => '1',              -- 1-bit input: Clock enable
      CLK => Clock,            -- 1-bit input: Clock
      D   => FeedBkIntD(3) );  -- 1-bit input: SRL Data
  
  -- Linear Feed shift register 87
  LFSR87First : SRLC32E
    generic map (INIT => X"00000000", -- Initial contents of shift register
      IS_CLK_INVERTED => '0' )        -- Optional inversion for CLK
    port map (Q => open,     -- 1-bit output: SRL Data
      Q31 => FeedBkIntB(4),  -- 1-bit output: SRL Cascade Data
      A   => "10010",        -- 5-bit input: Selects SRL depth
      CE  => '1',            -- 1-bit input: Clock enable
      CLK => Clock,          -- 1-bit input: Clock
      D   => FeedIn(4) );    -- 1-bit input: SRL Data
  LFSR87Second : SRLC32E
    generic map (INIT => X"00000000", -- Initial contents of shift register
      IS_CLK_INVERTED => '0' )        -- Optional inversion for CLK
    port map (Q => FeedBkIntC(4),     -- 1-bit output: SRL Data
      Q31 => FeedBkIntD(4),    -- 1-bit output: SRL Cascade Data
      A   => "10010",          -- 5-bit input: Selects SRL depth
      CE  => '1',              -- 1-bit input: Clock enable
      CLK => Clock,            -- 1-bit input: Clock
      D   => FeedBkIntB(4) );  -- 1-bit input: SRL Data
  LFSR87FeedMid : SRLC32E
    generic map (INIT => X"00000000", -- Initial contents of shift register
      IS_CLK_INVERTED => '0' )        -- Optional inversion for CLK
    port map (Q => FeedBkMid(4),      -- 1-bit output: SRL Data
      Q31 => open,            -- 1-bit output: SRL Cascade Data
      A   => "10110",         -- 5-bit input: Selects SRL depth
      CE  => '1',             -- 1-bit input: Clock enable
      CLK => Clock,           -- 1-bit input: Clock
      D   => FeedBkIntC(4) ); -- 1-bit input: SRL Data
  LFSR87FeedLast : SRLC32E
    generic map (INIT => X"00000000", -- Initial contents of shift register
      IS_CLK_INVERTED => '0' )        -- Optional inversion for CLK
    port map (Q => FeedBkFnl(4),      -- 1-bit output: SRL Data
      Q31 => open,             -- 1-bit output: SRL Cascade Data
      A   => "10110",          -- 5-bit input: Selects SRL depth
      CE  => '1',              -- 1-bit input: Clock enable
      CLK => Clock,            -- 1-bit input: Clock
      D   => FeedBkIntD(4) );  -- 1-bit input: SRL Data
  
  -- Linear Feed shift register 41
  LFSR41Second : SRLC32E
    generic map (INIT => X"00000000", -- Initial contents of shift register
      IS_CLK_INVERTED => '0' )        -- Optional inversion for CLK
    port map (Q => FeedBkIntC(5),     -- 1-bit output: SRL Data
      Q31 => FeedBkIntD(5),  -- 1-bit output: SRL Cascade Data
      A   => "11100",        -- 5-bit input: Selects SRL depth
      CE  => '1',            -- 1-bit input: Clock enable
      CLK => Clock,          -- 1-bit input: Clock
      D   => FeedIn(5) );    -- 1-bit input: SRL Data
  LFSR41FeedMid : SRLC32E
    generic map (INIT => X"00000000", -- Initial contents of shift register
      IS_CLK_INVERTED => '0' )        -- Optional inversion for CLK
    port map (Q => FeedBkMid(5),      -- 1-bit output: SRL Data
      Q31 => open,            -- 1-bit output: SRL Cascade Data
      A   => "01000",         -- 5-bit input: Selects SRL depth
      CE  => '1',             -- 1-bit input: Clock enable
      CLK => Clock,           -- 1-bit input: Clock
      D   => FeedBkIntC(5) ); -- 1-bit input: SRL Data
  LFSR41FeedLast : SRLC32E
    generic map (INIT => X"00000000", -- Initial contents of shift register
      IS_CLK_INVERTED => '0' )        -- Optional inversion for CLK
    port map (Q => FeedBkFnl(5),      -- 1-bit output: SRL Data
      Q31 => open,             -- 1-bit output: SRL Cascade Data
      A   => "01000",          -- 5-bit input: Selects SRL depth
      CE  => '1',              -- 1-bit input: Clock enable
      CLK => Clock,            -- 1-bit input: Clock
      D   => FeedBkIntD(5) );  -- 1-bit input: SRL Data
  
  -- Linear Feed shift register 39
  LFSR39Second : SRLC32E
    generic map (INIT => X"00000000", -- Initial contents of shift register
      IS_CLK_INVERTED => '0' )        -- Optional inversion for CLK
    port map (Q => FeedBkIntC(6),     -- 1-bit output: SRL Data
      Q31 => FeedBkIntD(6),  -- 1-bit output: SRL Cascade Data
      A   => "11011",        -- 5-bit input: Selects SRL depth
      CE  => '1',            -- 1-bit input: Clock enable
      CLK => Clock,          -- 1-bit input: Clock
      D   => FeedIn(6) );    -- 1-bit input: SRL Data
  LFSR39FeedMid : SRLC32E
    generic map (INIT => X"00000000", -- Initial contents of shift register
      IS_CLK_INVERTED => '0' )        -- Optional inversion for CLK
    port map (Q => FeedBkMid(6),      -- 1-bit output: SRL Data
      Q31 => open,            -- 1-bit output: SRL Cascade Data
      A   => "00110",         -- 5-bit input: Selects SRL depth
      CE  => '1',             -- 1-bit input: Clock enable
      CLK => Clock,           -- 1-bit input: Clock
      D   => FeedBkIntC(6) ); -- 1-bit input: SRL Data
  LFSR39FeedLast : SRLC32E
    generic map (INIT => X"00000000", -- Initial contents of shift register
      IS_CLK_INVERTED => '0' )        -- Optional inversion for CLK
    port map (Q => FeedBkFnl(6),      -- 1-bit output: SRL Data
      Q31 => open,             -- 1-bit output: SRL Cascade Data
      A   => "00110",          -- 5-bit input: Selects SRL depth
      CE  => '1',              -- 1-bit input: Clock enable
      CLK => Clock,            -- 1-bit input: Clock
      D   => FeedBkIntD(6) );  -- 1-bit input: SRL Data
  
  -- Linear Feed shift register 36
  LFSR36Second : SRLC32E
    generic map (INIT => X"00000000", -- Initial contents of shift register
      IS_CLK_INVERTED => '0' )        -- Optional inversion for CLK
    port map (Q => FeedBkIntC(7),     -- 1-bit output: SRL Data
      Q31 => FeedBkIntD(7),  -- 1-bit output: SRL Cascade Data
      A   => "10100",        -- 5-bit input: Selects SRL depth
      CE  => '1',            -- 1-bit input: Clock enable
      CLK => Clock,          -- 1-bit input: Clock
      D   => FeedIn(7) );    -- 1-bit input: SRL Data
  LFSR36FeedMid : SRLC32E
    generic map (INIT => X"00000000", -- Initial contents of shift register
      IS_CLK_INVERTED => '0' )        -- Optional inversion for CLK
    port map (Q => FeedBkMid(7),      -- 1-bit output: SRL Data
      Q31 => open,            -- 1-bit output: SRL Cascade Data
      A   => "00011",         -- 5-bit input: Selects SRL depth
      CE  => '1',             -- 1-bit input: Clock enable
      CLK => Clock,           -- 1-bit input: Clock
      D   => FeedBkIntC(7) ); -- 1-bit input: SRL Data
  LFSR36FeedLast : SRLC32E
    generic map (INIT => X"00000000", -- Initial contents of shift register
      IS_CLK_INVERTED => '0' )        -- Optional inversion for CLK
    port map (Q => FeedBkFnl(7),      -- 1-bit output: SRL Data
      Q31 => open,             -- 1-bit output: SRL Cascade Data
      A   => "00011",          -- 5-bit input: Selects SRL depth
      CE  => '1',              -- 1-bit input: Clock enable
      CLK => Clock,            -- 1-bit input: Clock
      D   => FeedBkIntD(7) );  -- 1-bit input: SRL Data
  
  -- Linear Feed shift register 47
  LFSR47Second : SRLC32E
    generic map (INIT => X"00000000", -- Initial contents of shift register
      IS_CLK_INVERTED => '0' )        -- Optional inversion for CLK
    port map (Q => FeedBkIntC(8),     -- 1-bit output: SRL Data
      Q31 => FeedBkIntD(8),  -- 1-bit output: SRL Cascade Data
      A   => "11010",        -- 5-bit input: Selects SRL depth
      CE  => '1',            -- 1-bit input: Clock enable
      CLK => Clock,          -- 1-bit input: Clock
      D   => FeedIn(8) );    -- 1-bit input: SRL Data
  LFSR47FeedMid : SRLC32E
    generic map (INIT => X"00000000", -- Initial contents of shift register
      IS_CLK_INVERTED => '0' )        -- Optional inversion for CLK
    port map (Q => FeedBkMid(8),      -- 1-bit output: SRL Data
      Q31 => open,            -- 1-bit output: SRL Cascade Data
      A   => "01110",         -- 5-bit input: Selects SRL depth
      CE  => '1',             -- 1-bit input: Clock enable
      CLK => Clock,           -- 1-bit input: Clock
      D   => FeedBkIntC(8) ); -- 1-bit input: SRL Data
  LFSR47FeedLast : SRLC32E
    generic map (INIT => X"00000000", -- Initial contents of shift register
      IS_CLK_INVERTED => '0' )        -- Optional inversion for CLK
    port map (Q => FeedBkFnl(8),      -- 1-bit output: SRL Data
      Q31 => open,             -- 1-bit output: SRL Cascade Data
      A   => "01110",          -- 5-bit input: Selects SRL depth
      CE  => '1',              -- 1-bit input: Clock enable
      CLK => Clock,            -- 1-bit input: Clock
      D   => FeedBkIntD(8) );  -- 1-bit input: SRL Data
  
  -- Linear Feed shift register 49
  LFSR49Second : SRLC32E
    generic map (INIT => X"00000000", -- Initial contents of shift register
      IS_CLK_INVERTED => '0' )        -- Optional inversion for CLK
    port map (Q => FeedBkIntC(9),     -- 1-bit output: SRL Data
      Q31 => FeedBkIntD(9),  -- 1-bit output: SRL Cascade Data
      A   => "10110",        -- 5-bit input: Selects SRL depth
      CE  => '1',            -- 1-bit input: Clock enable
      CLK => Clock,          -- 1-bit input: Clock
      D   => FeedIn(9) );    -- 1-bit input: SRL Data
  LFSR49FeedMid : SRLC32E
    generic map (INIT => X"00000000", -- Initial contents of shift register
      IS_CLK_INVERTED => '0' )        -- Optional inversion for CLK
    port map (Q => FeedBkMid(9),      -- 1-bit output: SRL Data
      Q31 => open,            -- 1-bit output: SRL Cascade Data
      A   => "10000",         -- 5-bit input: Selects SRL depth
      CE  => '1',             -- 1-bit input: Clock enable
      CLK => Clock,           -- 1-bit input: Clock
      D   => FeedBkIntC(9) ); -- 1-bit input: SRL Data
  LFSR49FeedLast : SRLC32E
    generic map (INIT => X"00000000", -- Initial contents of shift register
      IS_CLK_INVERTED => '0' )        -- Optional inversion for CLK
    port map (Q => FeedBkFnl(9),      -- 1-bit output: SRL Data
      Q31 => open,             -- 1-bit output: SRL Cascade Data
      A   => "10000",          -- 5-bit input: Selects SRL depth
      CE  => '1',              -- 1-bit input: Clock enable
      CLK => Clock,            -- 1-bit input: Clock
      D   => FeedBkIntD(9) );  -- 1-bit input: SRL Data
  
  -- Linear Feed shift register 52
  LFSR52Second : SRLC32E
    generic map (INIT => X"00000000", -- Initial contents of shift register
      IS_CLK_INVERTED => '0' )        -- Optional inversion for CLK
    port map (Q => FeedBkIntC(10),    -- 1-bit output: SRL Data
      Q31 => FeedBkIntD(10), -- 1-bit output: SRL Cascade Data
      A   => "11100",        -- 5-bit input: Selects SRL depth
      CE  => '1',            -- 1-bit input: Clock enable
      CLK => Clock,          -- 1-bit input: Clock
      D   => FeedIn(10) );   -- 1-bit input: SRL Data
  LFSR52FeedMid : SRLC32E
    generic map (INIT => X"00000000", -- Initial contents of shift register
      IS_CLK_INVERTED => '0' )        -- Optional inversion for CLK
    port map (Q => FeedBkMid(10),     -- 1-bit output: SRL Data
      Q31 => open,             -- 1-bit output: SRL Cascade Data
      A   => "10011",          -- 5-bit input: Selects SRL depth
      CE  => '1',              -- 1-bit input: Clock enable
      CLK => Clock,            -- 1-bit input: Clock
      D   => FeedBkIntC(10) ); -- 1-bit input: SRL Data
  LFSR52FeedLast : SRLC32E
    generic map (INIT => X"00000000", -- Initial contents of shift register
      IS_CLK_INVERTED => '0' )        -- Optional inversion for CLK
    port map (Q => FeedBkFnl(10),     -- 1-bit output: SRL Data
      Q31 => open,             -- 1-bit output: SRL Cascade Data
      A   => "10011",          -- 5-bit input: Selects SRL depth
      CE  => '1',              -- 1-bit input: Clock enable
      CLK => Clock,            -- 1-bit input: Clock
      D   => FeedBkIntD(10) ); -- 1-bit input: SRL Data

  -- Linear Feed shift register 57
  LFSR57Second : SRLC32E
    generic map (INIT => X"00000000", -- Initial contents of shift register
      IS_CLK_INVERTED => '0' )        -- Optional inversion for CLK
    port map (Q => FeedBkIntC(11),    -- 1-bit output: SRL Data
      Q31 => FeedBkIntD(11), -- 1-bit output: SRL Cascade Data
      A   => "11000",        -- 5-bit input: Selects SRL depth
      CE  => '1',            -- 1-bit input: Clock enable
      CLK => Clock,          -- 1-bit input: Clock
      D   => FeedIn(11) );   -- 1-bit input: SRL Data
  LFSR57FeedMid : SRLC32E
    generic map (INIT => X"00000000", -- Initial contents of shift register
      IS_CLK_INVERTED => '0' )        -- Optional inversion for CLK
    port map (Q => FeedBkMid(11),     -- 1-bit output: SRL Data
      Q31 => open,             -- 1-bit output: SRL Cascade Data
      A   => "11000",          -- 5-bit input: Selects SRL depth
      CE  => '1',              -- 1-bit input: Clock enable
      CLK => Clock,            -- 1-bit input: Clock
      D   => FeedBkIntC(11) ); -- 1-bit input: SRL Data
  LFSR57FeedLast : SRLC32E
    generic map (INIT => X"00000000", -- Initial contents of shift register
      IS_CLK_INVERTED => '0' )        -- Optional inversion for CLK
    port map (Q => FeedBkFnl(11),     -- 1-bit output: SRL Data
      Q31 => open,             -- 1-bit output: SRL Cascade Data
      A   => "11000",          -- 5-bit input: Selects SRL depth
      CE  => '1',              -- 1-bit input: Clock enable
      CLK => Clock,            -- 1-bit input: Clock
      D   => FeedBkIntD(11) ); -- 1-bit input: SRL Data

  -- Linear Feed shift register 58
  LFSR58Second : SRLC32E
    generic map (INIT => X"00000000", -- Initial contents of shift register
      IS_CLK_INVERTED => '0' )        -- Optional inversion for CLK
    port map (Q => FeedBkIntC(12),    -- 1-bit output: SRL Data
      Q31 => FeedBkIntD(12), -- 1-bit output: SRL Cascade Data
      A   => "01100",        -- 5-bit input: Selects SRL depth
      CE  => '1',            -- 1-bit input: Clock enable
      CLK => Clock,          -- 1-bit input: Clock
      D   => FeedIn(12) );   -- 1-bit input: SRL Data
  LFSR58FeedMid : SRLC32E
    generic map (INIT => X"00000000", -- Initial contents of shift register
      IS_CLK_INVERTED => '0' )        -- Optional inversion for CLK
    port map (Q => FeedBkMid(12),     -- 1-bit output: SRL Data
      Q31 => open,             -- 1-bit output: SRL Cascade Data
      A   => "11001",          -- 5-bit input: Selects SRL depth
      CE  => '1',              -- 1-bit input: Clock enable
      CLK => Clock,            -- 1-bit input: Clock
      D   => FeedBkIntC(12) ); -- 1-bit input: SRL Data
  LFSR58FeedLast : SRLC32E
    generic map (INIT => X"00000000", -- Initial contents of shift register
      IS_CLK_INVERTED => '0' )        -- Optional inversion for CLK
    port map (Q => FeedBkFnl(12),     -- 1-bit output: SRL Data
      Q31 => open,             -- 1-bit output: SRL Cascade Data
      A   => "11001",          -- 5-bit input: Selects SRL depth
      CE  => '1',              -- 1-bit input: Clock enable
      CLK => Clock,            -- 1-bit input: Clock
      D   => FeedBkIntD(12) ); -- 1-bit input: SRL Data

  -- Linear Feed shift register 60
  LFSR60Second : SRLC32E
    generic map (INIT => X"00000000", -- Initial contents of shift register
      IS_CLK_INVERTED => '0' )        -- Optional inversion for CLK
    port map (Q => FeedBkIntC(13),    -- 1-bit output: SRL Data
      Q31 => FeedBkIntD(13), -- 1-bit output: SRL Cascade Data
      A   => "11110",        -- 5-bit input: Selects SRL depth
      CE  => '1',            -- 1-bit input: Clock enable
      CLK => Clock,          -- 1-bit input: Clock
      D   => FeedIn(13) );   -- 1-bit input: SRL Data
  LFSR60FeedMid : SRLC32E
    generic map (INIT => X"00000000", -- Initial contents of shift register
      IS_CLK_INVERTED => '0' )        -- Optional inversion for CLK
    port map (Q => FeedBkMid(13),     -- 1-bit output: SRL Data
      Q31 => open,             -- 1-bit output: SRL Cascade Data
      A   => "11011",          -- 5-bit input: Selects SRL depth
      CE  => '1',              -- 1-bit input: Clock enable
      CLK => Clock,            -- 1-bit input: Clock
      D   => FeedBkIntC(13) ); -- 1-bit input: SRL Data
  LFSR60FeedLast : SRLC32E
    generic map (INIT => X"00000000", -- Initial contents of shift register
      IS_CLK_INVERTED => '0' )        -- Optional inversion for CLK
    port map (Q => FeedBkFnl(13),     -- 1-bit output: SRL Data
      Q31 => open,             -- 1-bit output: SRL Cascade Data
      A   => "11011",          -- 5-bit input: Selects SRL depth
      CE  => '1',              -- 1-bit input: Clock enable
      CLK => Clock,            -- 1-bit input: Clock
      D   => FeedBkIntD(13) ); -- 1-bit input: SRL Data

  -- Linear Feed shift register 55
  LFSR55FeedMid : SRLC32E
    generic map (INIT => X"00000000", -- Initial contents of shift register
      IS_CLK_INVERTED => '0' )        -- Optional inversion for CLK
    port map (Q => FeedBkMid(14),     -- 1-bit output: SRL Data
      Q31 => FeedBkIntD(14), -- 1-bit output: SRL Cascade Data
      A   => "11100",        -- 5-bit input: Selects SRL depth
      CE  => '1',            -- 1-bit input: Clock enable
      CLK => Clock,          -- 1-bit input: Clock
      D   => FeedIn(14) );   -- 1-bit input: SRL Data
  LFSR55FeedLast : SRLC32E
    generic map (INIT => X"00000000", -- Initial contents of shift register
      IS_CLK_INVERTED => '0' )        -- Optional inversion for CLK
    port map (Q => FeedBkFnl(14),     -- 1-bit output: SRL Data
      Q31 => open,             -- 1-bit output: SRL Cascade Data
      A   => "10110",          -- 5-bit input: Selects SRL depth
      CE  => '1',              -- 1-bit input: Clock enable
      CLK => Clock,            -- 1-bit input: Clock
      D   => FeedBkIntD(14) ); -- 1-bit input: SRL Data

-- for the random trigger differences between random1 and random2
  -- Linear Feed shift register 81
  LFSR81First : SRLC32E
    generic map (INIT => X"00000000", -- Initial contents of shift register
      IS_CLK_INVERTED => '0' )        -- Optional inversion for CLK
    port map (Q => open,     -- 1-bit output: SRL Data
      Q31 => FeedBkIntB(25), -- 1-bit output: SRL Cascade Data
      A   => "11011",        -- 5-bit input: Selects SRL depth
      CE  => '1',            -- 1-bit input: Clock enable
      CLK => Clock,          -- 1-bit input: Clock
      D   => FeedIn(25) );   -- 1-bit input: SRL Data
  LFSR81Second : SRLC32E
    generic map (INIT => X"00000000", -- Initial contents of shift register
      IS_CLK_INVERTED => '0' )        -- Optional inversion for CLK
    port map (Q => FeedBkIntC(25),    -- 1-bit output: SRL Data
      Q31 => FeedBkIntD(25),   -- 1-bit output: SRL Cascade Data
      A   => "11011",          -- 5-bit input: Selects SRL depth
      CE  => '1',              -- 1-bit input: Clock enable
      CLK => Clock,            -- 1-bit input: Clock
      D   => FeedBkIntB(25) ); -- 1-bit input: SRL Data
  LFSR81FeedMid : SRLC32E
    generic map (INIT => X"00000000", -- Initial contents of shift register
      IS_CLK_INVERTED => '0' )        -- Optional inversion for CLK
    port map (Q => FeedBkMid(25),     -- 1-bit output: SRL Data
      Q31 => open,             -- 1-bit output: SRL Cascade Data
      A   => "10000",          -- 5-bit input: Selects SRL depth
      CE  => '1',              -- 1-bit input: Clock enable
      CLK => Clock,            -- 1-bit input: Clock
      D   => FeedBkIntC(25) ); -- 1-bit input: SRL Data
  LFSR81FeedLast : SRLC32E
    generic map (INIT => X"00000000", -- Initial contents of shift register
      IS_CLK_INVERTED => '0' )        -- Optional inversion for CLK
    port map (Q => FeedBkFnl(25),     -- 1-bit output: SRL Data
      Q31 => open,             -- 1-bit output: SRL Cascade Data
      A   => "10000",          -- 5-bit input: Selects SRL depth
      CE  => '1',              -- 1-bit input: Clock enable
      CLK => Clock,            -- 1-bit input: Clock
      D   => FeedBkIntD(25) ); -- 1-bit input: SRL Data
  
  -- Linear Feed shift register 79
  LFSR79First : SRLC32E
    generic map (INIT => X"00000000", -- Initial contents of shift register
      IS_CLK_INVERTED => '0' )        -- Optional inversion for CLK
    port map (Q => open,     -- 1-bit output: SRL Data
      Q31 => FeedBkIntB(24), -- 1-bit output: SRL Cascade Data
      A   => "10110",        -- 5-bit input: Selects SRL depth
      CE  => '1',            -- 1-bit input: Clock enable
      CLK => Clock,          -- 1-bit input: Clock
      D   => FeedIn(24) );   -- 1-bit input: SRL Data
  LFSR79Second : SRLC32E
    generic map (INIT => X"00000000", -- Initial contents of shift register
      IS_CLK_INVERTED => '0' )        -- Optional inversion for CLK
    port map (Q => FeedBkIntC(24),    -- 1-bit output: SRL Data
      Q31 => FeedBkIntD(24),   -- 1-bit output: SRL Cascade Data
      A   => "10110",          -- 5-bit input: Selects SRL depth
      CE  => '1',              -- 1-bit input: Clock enable
      CLK => Clock,            -- 1-bit input: Clock
      D   => FeedBkIntB(24) ); -- 1-bit input: SRL Data
  LFSR79FeedMid : SRLC32E
    generic map (INIT => X"00000000", -- Initial contents of shift register
      IS_CLK_INVERTED => '0' )        -- Optional inversion for CLK
    port map (Q => FeedBkMid(24),     -- 1-bit output: SRL Data
      Q31 => open,             -- 1-bit output: SRL Cascade Data
      A   => "01110",          -- 5-bit input: Selects SRL depth
      CE  => '1',              -- 1-bit input: Clock enable
      CLK => Clock,            -- 1-bit input: Clock
      D   => FeedBkIntC(24) ); -- 1-bit input: SRL Data
  LFSR79FeedLast : SRLC32E
    generic map (INIT => X"00000000", -- Initial contents of shift register
      IS_CLK_INVERTED => '0' )        -- Optional inversion for CLK
    port map (Q => FeedBkFnl(24),     -- 1-bit output: SRL Data
      Q31 => open,             -- 1-bit output: SRL Cascade Data
      A   => "01110",          -- 5-bit input: Selects SRL depth
      CE  => '1',              -- 1-bit input: Clock enable
      CLK => Clock,            -- 1-bit input: Clock
      D   => FeedBkIntD(24) ); -- 1-bit input: SRL Data
  
  -- Linear Feed shift register 73
  LFSR73First : SRLC32E
    generic map (INIT => X"00000000", -- Initial contents of shift register
      IS_CLK_INVERTED => '0' )        -- Optional inversion for CLK
    port map (Q => open,     -- 1-bit output: SRL Data
      Q31 => FeedBkIntB(23), -- 1-bit output: SRL Cascade Data
      A   => "00110",        -- 5-bit input: Selects SRL depth
      CE  => '1',            -- 1-bit input: Clock enable
      CLK => Clock,          -- 1-bit input: Clock
      D   => FeedIn(23) );   -- 1-bit input: SRL Data
  LFSR73Second : SRLC32E
    generic map (INIT => X"00000000", -- Initial contents of shift register
      IS_CLK_INVERTED => '0' )        -- Optional inversion for CLK
    port map (Q => FeedBkIntC(23),    -- 1-bit output: SRL Data
      Q31 => FeedBkIntD(23),   -- 1-bit output: SRL Cascade Data
      A   => "00110",          -- 5-bit input: Selects SRL depth
      CE  => '1',              -- 1-bit input: Clock enable
      CLK => Clock,            -- 1-bit input: Clock
      D   => FeedBkIntB(23) ); -- 1-bit input: SRL Data
  LFSR73FeedMid : SRLC32E
    generic map (INIT => X"00000000", -- Initial contents of shift register
      IS_CLK_INVERTED => '0' )        -- Optional inversion for CLK
    port map (Q => FeedBkMid(23),     -- 1-bit output: SRL Data
      Q31 => open,             -- 1-bit output: SRL Cascade Data
      A   => "01000",          -- 5-bit input: Selects SRL depth
      CE  => '1',              -- 1-bit input: Clock enable
      CLK => Clock,            -- 1-bit input: Clock
      D   => FeedBkIntC(23) ); -- 1-bit input: SRL Data
  LFSR73FeedLast : SRLC32E
    generic map (INIT => X"00000000", -- Initial contents of shift register
      IS_CLK_INVERTED => '0' )        -- Optional inversion for CLK
    port map (Q => FeedBkFnl(23),     -- 1-bit output: SRL Data
      Q31 => open,             -- 1-bit output: SRL Cascade Data
      A   => "01000",          -- 5-bit input: Selects SRL depth
      CE  => '1',              -- 1-bit input: Clock enable
      CLK => Clock,            -- 1-bit input: Clock
      D   => FeedBkIntD(23) ); -- 1-bit input: SRL Data
  
  -- Linear Feed shift register 71
  LFSR71First : SRLC32E
    generic map (INIT => X"00000000", -- Initial contents of shift register
      IS_CLK_INVERTED => '0' )        -- Optional inversion for CLK
    port map (Q => open,     -- 1-bit output: SRL Data
      Q31 => FeedBkIntB(22), -- 1-bit output: SRL Cascade Data
      A   => "11001",        -- 5-bit input: Selects SRL depth
      CE  => '1',            -- 1-bit input: Clock enable
      CLK => Clock,          -- 1-bit input: Clock
      D   => FeedIn(22) );   -- 1-bit input: SRL Data
  LFSR71Second : SRLC32E
    generic map (INIT => X"00000000", -- Initial contents of shift register
      IS_CLK_INVERTED => '0' )        -- Optional inversion for CLK
    port map (Q => FeedBkIntC(22),    -- 1-bit output: SRL Data
      Q31 => FeedBkIntD(22),   -- 1-bit output: SRL Cascade Data
      A   => "11001",          -- 5-bit input: Selects SRL depth
      CE  => '1',              -- 1-bit input: Clock enable
      CLK => Clock,            -- 1-bit input: Clock
      D   => FeedBkIntB(22) ); -- 1-bit input: SRL Data
  LFSR71FeedMid : SRLC32E
    generic map (INIT => X"00000000", -- Initial contents of shift register
      IS_CLK_INVERTED => '0' )        -- Optional inversion for CLK
    port map (Q => FeedBkMid(22),     -- 1-bit output: SRL Data
      Q31 => open,             -- 1-bit output: SRL Cascade Data
      A   => "00110",          -- 5-bit input: Selects SRL depth
      CE  => '1',              -- 1-bit input: Clock enable
      CLK => Clock,            -- 1-bit input: Clock
      D   => FeedBkIntC(22) ); -- 1-bit input: SRL Data
  LFSR71FeedLast : SRLC32E
    generic map (INIT => X"00000000", -- Initial contents of shift register
      IS_CLK_INVERTED => '0' )        -- Optional inversion for CLK
    port map (Q => FeedBkFnl(22),     -- 1-bit output: SRL Data
      Q31 => open,             -- 1-bit output: SRL Cascade Data
      A   => "00110",          -- 5-bit input: Selects SRL depth
      CE  => '1',              -- 1-bit input: Clock enable
      CLK => Clock,            -- 1-bit input: Clock
      D   => FeedBkIntD(22) ); -- 1-bit input: SRL Data
  
  -- Linear Feed shift register 68
  LFSR68First : SRLC32E
    generic map (INIT => X"00000000", -- Initial contents of shift register
      IS_CLK_INVERTED => '0' )        -- Optional inversion for CLK
    port map (Q => open,     -- 1-bit output: SRL Data
      Q31 => FeedBkIntB(21), -- 1-bit output: SRL Cascade Data
      A   => "10110",        -- 5-bit input: Selects SRL depth
      CE  => '1',            -- 1-bit input: Clock enable
      CLK => Clock,          -- 1-bit input: Clock
      D   => FeedIn(21) );   -- 1-bit input: SRL Data
  LFSR68Second : SRLC32E
    generic map (INIT => X"00000000", -- Initial contents of shift register
      IS_CLK_INVERTED => '0' )        -- Optional inversion for CLK
    port map (Q => FeedBkIntC(21),    -- 1-bit output: SRL Data
      Q31 => FeedBkIntD(21),   -- 1-bit output: SRL Cascade Data
      A   => "10110",          -- 5-bit input: Selects SRL depth
      CE  => '1',              -- 1-bit input: Clock enable
      CLK => Clock,            -- 1-bit input: Clock
      D   => FeedBkIntB(21) ); -- 1-bit input: SRL Data
  LFSR68FeedMid : SRLC32E
    generic map (INIT => X"00000000", -- Initial contents of shift register
      IS_CLK_INVERTED => '0' )        -- Optional inversion for CLK
    port map (Q => FeedBkMid(21),     -- 1-bit output: SRL Data
      Q31 => open,             -- 1-bit output: SRL Cascade Data
      A   => "00011",          -- 5-bit input: Selects SRL depth
      CE  => '1',              -- 1-bit input: Clock enable
      CLK => Clock,            -- 1-bit input: Clock
      D   => FeedBkIntC(21) ); -- 1-bit input: SRL Data
  LFSR68FeedLast : SRLC32E
    generic map (INIT => X"00000000", -- Initial contents of shift register
      IS_CLK_INVERTED => '0' )        -- Optional inversion for CLK
    port map (Q => FeedBkFnl(21),     -- 1-bit output: SRL Data
      Q31 => open,             -- 1-bit output: SRL Cascade Data
      A   => "00011",          -- 5-bit input: Selects SRL depth
      CE  => '1',              -- 1-bit input: Clock enable
      CLK => Clock,            -- 1-bit input: Clock
      D   => FeedBkIntD(21) ); -- 1-bit input: SRL Data
  
  -- Linear Feed shift register 84
  LFSR84First : SRLC32E
    generic map (INIT => X"00000000", -- Initial contents of shift register
      IS_CLK_INVERTED => '0' )        -- Optional inversion for CLK
    port map (Q => open,     -- 1-bit output: SRL Data
      Q31 => FeedBkIntB(20), -- 1-bit output: SRL Cascade Data
      A   => "10010",        -- 5-bit input: Selects SRL depth
      CE  => '1',            -- 1-bit input: Clock enable
      CLK => Clock,          -- 1-bit input: Clock
      D   => FeedIn(20) );   -- 1-bit input: SRL Data
  LFSR84Second : SRLC32E
    generic map (INIT => X"00000000", -- Initial contents of shift register
      IS_CLK_INVERTED => '0' )        -- Optional inversion for CLK
    port map (Q => FeedBkIntC(20),    -- 1-bit output: SRL Data
      Q31 => FeedBkIntD(20),   -- 1-bit output: SRL Cascade Data
      A   => "10010",          -- 5-bit input: Selects SRL depth
      CE  => '1',              -- 1-bit input: Clock enable
      CLK => Clock,            -- 1-bit input: Clock
      D   => FeedBkIntB(20) ); -- 1-bit input: SRL Data
  LFSR84FeedMid : SRLC32E
    generic map (INIT => X"00000000", -- Initial contents of shift register
      IS_CLK_INVERTED => '0' )        -- Optional inversion for CLK
    port map (Q => FeedBkMid(20),     -- 1-bit output: SRL Data
      Q31 => open,             -- 1-bit output: SRL Cascade Data
      A   => "10011",          -- 5-bit input: Selects SRL depth
      CE  => '1',              -- 1-bit input: Clock enable
      CLK => Clock,            -- 1-bit input: Clock
      D   => FeedBkIntC(20) ); -- 1-bit input: SRL Data
  LFSR84FeedLast : SRLC32E
    generic map (INIT => X"00000000", -- Initial contents of shift register
      IS_CLK_INVERTED => '0' )        -- Optional inversion for CLK
    port map (Q => FeedBkFnl(20),     -- 1-bit output: SRL Data
      Q31 => open,             -- 1-bit output: SRL Cascade Data
      A   => "10011",          -- 5-bit input: Selects SRL depth
      CE  => '1',              -- 1-bit input: Clock enable
      CLK => Clock,            -- 1-bit input: Clock
      D   => FeedBkIntD(20) ); -- 1-bit input: SRL Data
  
  TrigIntA <= FeedBkFnl(20) and FeedBkFnl(21) and FeedBkFnl(22) and FeedBkFnl(23) and FeedBkFnl(24) and FeedBkFnl(25);
  -- Trigger rate AND using CarryChain design
  TriggerANDwithCarryA : CARRY8
    generic map (CARRY_TYPE => "SINGLE_CY8" ) -- 8-bit or dual 4-bit carry (DUAL_CY4, SINGLE_CY8)
    port map (
CO => CarryOut(7 downto 0),     -- 8-bit output: Carry-out
      O      => open,       -- 8-bit output: Carry chain XOR data out
      CI     => '0',        -- 1-bit input: Lower Carry-In
      CI_TOP => '0',        -- 1-bit input: Upper Carry-In
      DI(0)  => TrigIntA,   -- 8-bit input: Carry-MUX data in
      DI(7 downto 1) => "0000000", 
      S     => FeedBkFnl(7 downto 0) ); -- 8-bit input: Carry-mux select
  TriggerANDwithCarryB : CARRY8
    generic map (CARRY_TYPE => "SINGLE_CY8" ) -- 8-bit or dual 4-bit carry (DUAL_CY4, SINGLE_CY8)
    port map (CO => CarryOut(15 downto 8),     -- 8-bit output: Carry-out
      O      => open,        -- 8-bit output: Carry chain XOR data out
      CI     => CarryOut(7), -- 1-bit input: Lower Carry-In
      CI_TOP => '0',         -- 1-bit input: Upper Carry-In
      DI     => "00000000",  -- 8-bit input: Carry-MUX data in
      S      => FeedBkFnl(15 downto 8) ); -- 8-bit input: Carry-mux select
  process (Clock)
  begin
    if (Clock'event and Clock = '1') then
      case (RTrgRate(3 downto 0)) is
        when "0000" =>
          TrigOut <= CarryOut(0);
        when "0001" =>
          TrigOut <= CarryOut(1);
        when "0010" =>
          TrigOut <= CarryOut(2);
        when "0011" =>
          TrigOut <= CarryOut(3);
        when "0100" =>
          TrigOut <= CarryOut(4);
        when "0101" =>
          TrigOut <= CarryOut(5);
        when "0110" =>
          TrigOut <= CarryOut(6);
        when "0111" =>
          TrigOut <= CarryOut(7);
        when "1000" =>
          TrigOut <= CarryOut(8);
        when "1001" =>
          TrigOut <= CarryOut(9);
        when "1010" =>
          TrigOut <= CarryOut(10);
        when "1011" =>
          TrigOut <= CarryOut(11);
        when "1100" =>
          TrigOut <= CarryOut(12);
        when "1101" =>
          TrigOut <= CarryOut(13);
        when "1110" =>
          TrigOut <= CarryOut(14);
        when "1111" =>
          TrigOut <= CarryOut(15);
      end case;
    end if;
  end process;

end Behavioral;
