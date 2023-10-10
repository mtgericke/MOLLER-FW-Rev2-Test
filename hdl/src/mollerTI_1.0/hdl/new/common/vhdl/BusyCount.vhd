----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:57:08 05/21/2015 
-- Design Name: 
-- Module Name:    BusyCount - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity BusyCount is
  Port ( Clock : in  STD_LOGIC;
    Enable : in  STD_LOGIC;
    Latch : in  STD_LOGIC;
    Reset : in  STD_LOGIC;
    COUT : out  STD_LOGIC_VECTOR (31 downto 0));
end BusyCount;

architecture Behavioral of BusyCount is

  COMPONENT Count48DSP
    PORT (CLK : IN STD_LOGIC;
      CE : IN STD_LOGIC;
      SCLR : IN STD_LOGIC;
      Q : OUT STD_LOGIC_VECTOR(47 DOWNTO 0)  );
  END COMPONENT;

  signal ICount : std_logic_vector(39 downto 0);

begin

-- Use DSP counter, instead of the fabric counter
  BusyCounterDSP : Count48DSP
    PORT MAP (CLK => Clock,       -- IN STD_LOGIC;
      CE          => Enable,    -- IN STD_LOGIC;
      SCLR        => Reset,        -- IN STD_LOGIC;
      Q(39 downto 0)  => ICount, -- OUT STD_LOGIC_VECTOR(47 DOWNTO 0)
      Q(47 downto 40) => open   );
  process(Clock)
  begin
    if (Clock'event and Clock = '1') then
      if (Latch = '1') then
        COUT <= ICount(39 downto 8);
      end if;
    end if;
  end process;

--  process (Clock, Reset) 
--    begin
--      if (Reset = '1') then 
--        ICount <= (others => '0');
--      elsif (Clock = '1' and Clock'event) then
--        if (Enable = '1') then
--           ICount <= ICount + 1;
--        end if;
--        if (Latch = '1') then
--        COUT <= ICount(39 downto 8);
--      end if;
--      end if;
--  end process;

end Behavioral;

