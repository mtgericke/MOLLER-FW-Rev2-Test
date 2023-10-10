----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:00:57 05/13/2016 
-- Design Name: 
-- Module Name:    FDDelay - Behavioral 
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
library UNISIM;
use UNISIM.VComponents.all;

entity FDDelay is
    Port ( Din : in  STD_LOGIC;
           Dout : out  STD_LOGIC);
end FDDelay;

architecture Behavioral of FDDelay is

  attribute RLOC : string;
  attribute RLOC of LUT2_inst1: label is "X0Y0";
  attribute RLOC of LUT2_inst2: label is "X0Y0";
  attribute RLOC of LUT2_inst3: label is "X0Y0";
  attribute RLOC of LUT2_inst4: label is "X0Y0";
  attribute RLOC of FDCE_inst: label is "X0Y0";
  attribute KEEP_HIERARCHY : string;
  attribute KEEP_HIERARCHY of LUT2_inst1: label is "TRUE";
  attribute KEEP_HIERARCHY of LUT2_inst2: label is "TRUE";
  attribute KEEP_HIERARCHY of LUT2_inst3: label is "TRUE";
  attribute KEEP_HIERARCHY of LUT2_inst4: label is "TRUE";
  attribute KEEP_HIERARCHY of FDCE_inst: label is "TRUE";

  signal IntSig1 : std_logic;
  signal IntSig2 : std_logic;
  signal IntSig3 : std_logic;
  signal IntSig4 : std_logic;
  signal IntSig5 : std_logic;
  
begin
--  IntSig1 <= Din and Din;
--    LUT2_inst1 : LUT2
--      generic map (
--        INIT => X"0")
--      port map (
--        O => IntSig1,   -- LUT general output
--        I0 => Din, -- LUT input
--        I1 => Din  -- LUT input
--      );
    LUT2_inst1 : AND2
      port map (
        O => IntSig1,   -- LUT general output
        I0 => Din, -- LUT input
        I1 => Din  -- LUT input
      );

    LUT2_inst2 : AND2
      port map (
        O => IntSig2,   -- LUT general output
        I0 => IntSig1, -- LUT input
        I1 => IntSig1  -- LUT input
      );

    LUT2_inst3 : XOR2
      port map (
        O => IntSig3,   -- LUT general output
        I0 => IntSig2, -- LUT input
        I1 => Din  -- LUT input
      );

    LUT2_inst4 : INV
      port map (
        O => IntSig5,   -- LUT general output
        I => IntSig4   -- LUT input
      );

   FDCE_inst : FDCE
   generic map (
      INIT => '0') -- Initial value of register ('0' or '1')  
   port map (
      Q => IntSig4,      -- Data output
      C => IntSig3,      -- Clock input
      CE => '1',    -- Clock enable input
      CLR => '0',  -- Asynchronous clear input
      D => IntSig5       -- Data input
   );
   
	Dout <= IntSig4;


end Behavioral;

