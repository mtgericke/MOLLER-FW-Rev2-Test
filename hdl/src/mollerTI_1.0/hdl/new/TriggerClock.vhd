----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/09/2020 11:27:51 AM
-- Design Name: 
-- Module Name: TriggerClock - Behavioral
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

entity TriggerClock is
  Port ( Clock : in STD_LOGIC;
    TrigIn  : in STD_LOGIC;
    ClockEn : in STD_LOGIC;
    TrigOut : out STD_LOGIC;
    Reset   : in STD_LOGIC);
end TriggerClock;

architecture Behavioral of TriggerClock is
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
  
begin

-- to store the input trigger
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
  TriggerStorage : TrigDelayFifo
    PORT MAP (clk => Clock,
      rst => Reset,
      din => "0",
      wr_en => TrigIn,
      rd_en => TrigOutRst,
      dout => open,
      full => open,
      empty => TrigEmpty  );

  process (Clock, TrigOutRst)
  begin
    if (TrigOutRst = '1') then
      TrigFall <= '0';
      TrigRise <= '0';
    else
      if (Clock'event and Clock = '0') then
        if (TrigEmpty = '0') then
          TrigFall <= '1';
        end if;
      end if;
      if (Clock'event and Clock = '1') then
        if (TrigEmpty = '0') then
          TrigRise <= '1';
        end if;
      end if;
    end if;
  end process;
  
  process (Clock)
  begin
    if (Clock'event and Clock = '1') then
      if (TrigOutRst = '1') then
        PreTrigOut <= '0';
        TrigOutInt <= '0';
        TrigOutRst <= '0';
      else
        if (ClockEn = '1') then
          PreTrigOut <= TrigRise or TrigFall;
          TrigOutInt <= PreTrigOut;
          TrigOutRst <= TrigOutInt;
        end if; -- ClockEn
      end if;   -- TrigOutRst
    end if;     -- Clock
  end process;
    
--    if (Clock'event and Clock = '0') then
--      if (TrigOutRst = '1') then
--        TrigFall <= '0';
--      elsif (TrigEmpty = '0') then
--        TrigFall <= '1';
--      end if;
--    end if;  -- end of CLock falling edge
--    if (Clock'event and Clock = '1') then
--      if (TrigOutRst = '1') then
--        TrigRise <= '0';
--        PreTrigOut <= '0';
--        TrigOutInt <= '0';
--        TrigOutRst <= '0';
--      else
--        if (TrigEmpty = '0') then
--          TrigRise <= '1';
--        end if;
--        if (ClockEn = '1') then
--          PreTrigOut <= TrigRise or TrigFall;
--          TrigOutInt <= PreTrigOut;
--          TrigOutRst <= TrigOutInt;
--        end if;
--      end if;
--    end if;   -- end of clock rising edge
--  end process;
  TrigOut <= TrigOutInt;

end Behavioral;
