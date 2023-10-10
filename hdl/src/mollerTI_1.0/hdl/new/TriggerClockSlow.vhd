----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/09/2020 12:32:31 PM
-- Design Name: 
-- Module Name: TriggerClockSlow - Behavioral
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
-- library UNISIM;
--use UNISIM.VComponents.all;

entity TriggerClockSlow is
  Port ( Clock : in STD_LOGIC;
    TrigIn  : in  STD_LOGIC;
    ClkSlow : in  std_logic;
    ClockEn : in  STD_LOGIC;
    TrigOut : out STD_LOGIC;
    Reset   : in  STD_LOGIC);
end TriggerClockSlow;

architecture Behavioral of TriggerClockSlow is
  COMPONENT TrigDelayFifo
    PORT (clk : IN STD_LOGIC;
    rst : IN STD_LOGIC;
    din : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    wr_en : IN STD_LOGIC;
    rd_en : IN STD_LOGIC;
    dout : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    full : OUT STD_LOGIC;
    empty : OUT STD_LOGIC  );
  END COMPONENT;
--  component TrgDlyFifo
--    port ( wr_clk : in    std_logic; 
--      rst    : in    std_logic; 
--      din    : in    std_logic_vector (0 downto 0); 
--      wr_en  : in    std_logic; 
--      rd_clk : in    std_logic; 
--      rd_en  : in    std_logic; 
--      empty  : out   std_logic; 
--      dout   : out   std_logic_vector (0 downto 0); 
--      full   : out   std_logic);
--  end component;
  signal TrigEmpty  : std_logic;
  signal TrigRise   : std_logic;
  signal TrigFall   : std_logic;
  signal PreTrigOut : std_logic;
  signal TrigOutInt : std_logic;
  signal TrigOutRst : std_logic;
  signal DlySTrigOut : std_logic := '0';
  signal Dly1TrigOut : std_logic := '0';
  signal Dly2TrigOut : std_logic := '0';

begin

-- to store the input trigger
  TriggerStorage : TrigDelayFifo
    PORT MAP (clk => Clock,
      rst => Reset,
      din => "0",
      wr_en => TrigIn,
      rd_en => TrigOutRst,
      dout => open,
      full => open,
      empty => TrigEmpty  );
--  TriggerStorage : TrgDlyFifo
--    port map(wr_clk => Clock, -- in    std_logic; 
--      rst    => Reset,        -- in    std_logic; 
--      din(0) => '0',          -- in    std_logic_vector (0 downto 0); 
--      wr_en  => TrigIn,       -- in    std_logic; 
--      rd_clk => Clock,        -- in    std_logic; 
--      rd_en  => TrigOutRst,   -- in    std_logic; 
--      empty  => TrigEmpty,    -- out   std_logic; 
--      dout   => open,         -- out   std_logic_vector (0 downto 0); 
--      full   => open );       -- out   std_logic);

  process (ClkSlow, TrigOutRst)
  begin
    if (TrigOutRst = '1') then
      TrigFall <= '0';
      TrigRise <= '0';
      DlySTrigOut <= '0';  -- PPreset in schematics
    else
      if (ClkSlow'event and ClkSlow = '0') then
        if (TrigEmpty = '0') then
          TrigFall <= '1';
        end if;
      end if;  -- end of CLock falling edge
      if (ClkSlow'event and ClkSlow = '1') then
        if (TrigEmpty = '0') then
          TrigRise <= '1';
        end if;
        if (ClockEn = '1') then
          DlySTrigOut <= Dly1TrigOut;
        end if;
      end if;
    end if;  -- end of CLock falling edge
  end process;

  process(Clock, TrigOutRst)
  begin
    if (TrigOutRst = '1') then
      Dly2TrigOut <= '0';
    else
      if (Clock'event and Clock = '1') then
        Dly2TrigOut <= DlySTrigOut;  -- Preset
      end if;
    end if;
  end process;
  
  process(Clock)
  begin
    if (Clock'event and Clock = '1') then
      if (TrigOutRst = '1') then
        PreTrigOut <= '0';
        TrigOutInt <= '0';
        Dly1TrigOut <= '0';
      else
        PreTrigOut <= TrigRise or TrigFall;
        TrigOutInt <= PreTrigOut;
        Dly1TrigOut <= TrigOutInt;
      end if;
      TrigOutRst <= Dly2TrigOut;
    end if;
  end process;
  
--  process (Clock)
--  begin
--    if (Clock'event and Clock ='1') then
--      if (TrigOutRst = '1') then
--        PreTrigOut <= '0';
--        TrigOutInt <= '0';
--        Dly1TrigOut <= '0';
--        Dly2TrigOut <= '0';
--      else
--        PreTrigOut <= TrigRise or TrigFall;
--        TrigOutInt <= PreTrigOut;
--        Dly1TrigOut <= TrigOutInt;
--        Dly2TrigOut <= DlySTrigOut;
--      end if;
--      TrigOutRst <= Dly2TrigOut;
--    end if;
--  end process;
  TrigOut <= TrigOutInt;
      
end Behavioral;
