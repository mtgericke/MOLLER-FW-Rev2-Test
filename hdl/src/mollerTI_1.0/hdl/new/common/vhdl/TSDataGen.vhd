----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:56:47 04/11/2013 
-- Design Name: 
-- Module Name:    TSDataGen - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity TSDataGen is
  Port ( PreTSData : in  STD_LOGIC_VECTOR (15 downto 0);
    ForceSync  : in  STD_LOGIC;
    PeriodSync : in  STD_LOGIC;
    Clock      : in  STD_LOGIC;
    TrgByTrg2  : in std_logic;
    TrgDelay   : in std_logic_vector(1 downto 0);
    TSData     : out  STD_LOGIC_VECTOR (15 downto 0));
end TSDataGen;

architecture Behavioral of TSDataGen is

signal D1TSData : std_logic_vector (15 downto 0);

begin
  process (Clock)
  begin
    if (Clock'event and Clock = '1') then
      if (ForceSync = '1') then
        D1TSData <= "0101001100000000"; 
         elsif (TrgByTrg2 = '1') then
         D1TSData <= "0101" & TrgDelay & "0110101001";
      else
         D1TSData <= PreTSData;
      end if;
      TSData(15 downto 10) <= D1TSData(15 downto 10);
      TSData(9) <= (D1TSData(9) or PeriodSync);
      TSData(8) <= (D1TSData(8) or PeriodSync);
      TSData(7 downto 0) <= D1TSData(7 downto 0);

-- The following logic can save one clock cycle if the PreTSData and PeriodSync have the same timing.
-- The reality is that the PeriodSync is one clock behind the PreTSData(15:0)
--      if (ForceSync = '1') then
--        TSData <= "0101001100000000";
--        elsif (TrgByTrg2 = '1') then
--         TSData <= "0101" & TrgDelay & PeriodSync & "110101001";
--      else
--         TSData(15 downto 10) <= PreTSData (15 downto 10);
--        TSData(9) <= PreTSData(9) or PeriodSync;
--        TSData(8) <= PreTSData(8) or PeriodSync;
--        TSData(7 downto 0) <= PreTSData(7 downto 0);
--      end if;

    end if;
  end process;
end Behavioral;

