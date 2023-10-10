----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/06/2020 01:49:37 PM
-- Design Name: 
-- Module Name: TrigInReg - Behavioral
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

entity TrigInReg is
  Port ( Clock : in STD_LOGIC;    -- 4ns clock
    ClkSlow : in    std_logic;    -- 16ns clock
    Enable  : in    std_logic; 
    Reset   : in    std_logic; 
    TrgIn    : in    std_logic;   -- input 
    TrgFast : out   std_logic;    -- keeps at 4ns wide, syced with Clock
    TrgReg  : out   std_logic  ); -- keeps at 16ns wide, synced with ClkSlow
end TrigInReg;

architecture Behavioral of TrigInReg is
  signal TrigRcvR  : std_logic := '0';
  signal TrigRcvF  : std_logic := '0';
  signal TrigRcv1  : std_logic;
  signal TrigRcv2  : std_logic;
  signal TrigRcv3  : std_logic;
  signal TrigRcv4  : std_logic;
  signal TrigRegInt : std_logic;
begin

  process(Clock)
  begin
    if (Clock'event and Clock = '0') then  -- falling edge of the clock
--      if (Reset = '1') then
--        TrigRcvF <= '0';
--      else
        TrigRcvF <= TrgIn;  -- there is no need to add the reset to it.
--      end if;
    end if;
    if (Clock'event and Clock = '1') then   -- rising edge of the clock
        TrigRcvR <= TrgIn; -- there is no need to add the reset to it, more it out of the reset
      if (Reset = '1') then
--        TrigRcvR <= '0';
        TrigRcv1 <= '0';
        TrgFast  <= '0';
      else
--        TrigRcvR <= TrgIn;
        if (Enable = '1') then
          TrigRcv1 <= TrigRcvR or TrigRcvF;
        end if;
        TrgFast <= TrigRcv1 and (not TrigRcv2);
      end if;
      TrigRcv2 <= TrigRcv1;
      if (TrigRegInt = '1') then
        TrigRcv3 <= '0';
      elsif (TrigRcv1 = '1' and TrigRcv2 = '0') then
        TrigRcv3 <= '1';
      end if;
      TrigRcv4 <= TrigRcv3;
    end if;
  end process;
  
  process (ClkSlow)
  begin
    if (ClkSlow'event and ClkSlow = '0') then
      if (Reset = '1' or TrigRegInt = '1') then
        TrigRegInt <= '0';
      else 
        TrigRegInt <= TrigRcv4;
      end if;
    end if;
  end process;
  TrgReg <= TrigRegInt;
         
end Behavioral;
