----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/25/2020 07:34:02 AM
-- Design Name: 
-- Module Name: RstPulsGen - Behavioral
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
library UNISIM;
use UNISIM.VComponents.all;

entity RstPulsGen is
    Port ( Clock : in STD_LOGIC;
           ClkSlow : in STD_LOGIC;
           TsTdRst : in STD_LOGIC;
           SubRst : in STD_LOGIC;
           TsRst : in STD_LOGIC;
           SyncSrcEn : in STD_LOGIC_VECTOR (7 downto 0);
           WidthSet : in STD_LOGIC_VECTOR (7 downto 0);
           SyncRst : in STD_LOGIC_VECTOR (15 downto 0);
           SToutEn : in STD_LOGIC;
           Reset : out STD_LOGIC;
           ATCArst : out std_logic;
           SyncRst_P : out STD_LOGIC;
           SyncRst_N : out STD_LOGIC);
end RstPulsGen;

architecture Behavioral of RstPulsGen is

  component SigDelay is
    Port ( SigIn : in STD_LOGIC;
      Clock : in STD_LOGIC;
      DelayVal : in STD_LOGIC_VECTOR (7 downto 0);
      SigOutMax : out std_logic;
      SigOut : out STD_LOGIC);
  end component;

  signal PreRst : std_logic_vector(7 downto 0) := (others => '0');
  signal RstEnd : std_logic;
  signal Cnt4us : std_logic_vector(7 downto 0);
  signal TC4us  : std_logic;
  signal ShortW : std_logic;
  signal LongW  : std_logic;
begin

-- PreRst(0): the OR of the three Reset sources (code 0xDD) ==> PreRst(1)
-- PreRst(2): SyncCode 0xCC
-- PreRst(3): fixed width reset (0xEE) ~4us
-- PreRst(4): Forced reset, enabled by 0x99, disabled by 0xcc
-- PreRst(7): The internal reset of RESET
  PreRst(0) <= (TsTdRst and SyncSrcEn(1)) or (SubRst and SyncSrcEn(2)) or (TsRst and SyncSrcEn(4));
  Reset <= PreRst(7);
  SyncDiffOut : OBUFDS
    port map (O => SyncRst_P,   -- 1-bit output: Diff_p output (connect directly to top-level port)
             OB => SyncRst_N,   -- 1-bit output: Diff_n output (connect directly to top-level port)
             I  => PreRst(6) ); -- 1-bit input: Buffer input

  ATCArst <= PreRst(6);

  process (Clock) 
  begin
   -- Reset width range selection
    if (Clock'event and Clock = '1') then
      if (WidthSet(7) = '1') then
        RstEnd <= LongW;
      else
        RstEnd <= ShortW;
      end if;
    -- code 0xDD generates the width adjusted reset, but for TI only.
      if (RstEnd = '1') then
        PreRst(1) <= '0';
      elsif (PreRst(0) = '1') then
        PreRst(1) <= '1';
      end if;
   -- code 0xCC generates a TI (only) reset
      if (PreRst(7) = '1') then
        PreRst(2) <= '0';
      elsif (SyncSrcEn(7) = '1' and SyncRst(12) = '1') then
        PreRst(2) <= '1';
      end if;
   -- code 0xEE, 4us width
      if (TC4us = '1') then
        PreRst(3) <= '0';
      elsif (SyncRst(14) = '1') then
        PreRst(3) <= '1';
      end if;
   -- Code 0x99 set the reset, code 0xCC void the reset
      if ((SyncRst(12)= '1') or (SyncSrcEn(7) = '0') ) then
        PreRst(4) <= '0';
      elsif ((SyncRst(9) = '1') and (SyncSrcEn(7) = '1')) then
        PreRst(4) <= '1';
      end if;
      PreRst(7) <= PreRst(1) or PreRst(2) or PreRst(3);
      PReRst(6) <= (PreRst(4) or PreRst(3)) and SToutEn;
    end if;
  end process;
  
-- 4us counter
  process (ClkSlow)
  begin
    if (ClkSlow'event and ClkSlow = '1') then
      if (PreRst(3) = '0') then
        Cnt4us <= (others => '0');
      elsif (PreRst(3) = '1') then
        Cnt4us <= Cnt4us + 1;
      end if;
      TC4us <= (Cnt4us(7) and Cnt4us(6) and Cnt4us(5) and Cnt4us(4) and Cnt4us(3) and Cnt4us(2) and Cnt4us(1) and Cnt4us(0));
    end if;
  end process;
-- Signal delay, or pulse width adjustment
  ShortRange : SigDelay
    Port map (SigIn        => PreRst(1), --  in STD_LOGIC;
      Clock                => Clock,     -- in STD_LOGIC;
      DelayVal(6 downto 0) => WidthSet(6 downto 0), -- in STD_LOGIC_VECTOR (7 downto 0);
      DelayVal(7)          => '0',
      SigOutMax            => open, -- out std_logic;
      SigOut               => ShortW );  -- out STD_LOGIC);
  LongRange : SigDelay
    Port map (SigIn        => PreRst(1), --  in STD_LOGIC;
      Clock                => ClkSlow,   -- in STD_LOGIC;
      DelayVal(7 downto 1) => WidthSet(6 downto 0), -- in STD_LOGIC_VECTOR (7 downto 0);
      DelayVal(0)          => '1',
      SigOutMax            => open, -- out std_logic;
      SigOut               => LongW );   -- out STD_LOGIC);

end Behavioral;
