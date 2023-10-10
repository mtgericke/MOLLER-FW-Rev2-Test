--------------------------------------------------------------------------------
-- Copyright (c) 1995-2012 Xilinx, Inc.  All rights reserved.
--------------------------------------------------------------------------------
--   ____  ____ 
--  /   /\/   / 
-- /___/  \  /    Vendor: Xilinx 
-- \   \   \/     Version : 14.5
--  \   \         Application : sch2hdl
--  /   /         Filename : FastMatchVeto.vhf
-- /___/   /\     Timestamp : 12/11/2019 14:54:46
-- \   \  /  \ 
--  \___\/\___\ 
--
--Command: sch2hdl -sympath C:/fpga/common/ipcores/TrgDlyFifo -sympath C:/fpga/common/ipcores/bram18to36 -sympath C:/fpga/common/ipcores/BRAM36SC -sympath C:/fpga/common/ipcores/buf72to36 -sympath C:/fpga/common/ipcores/bram36to9 -sympath C:/fpga/TIFPGAC/buf36to9 -sympath C:/fpga/common/ipcores/Ram16to32 -sympath C:/fpga/common/ipcores -sympath C:/fpga/common/ipcores/ram12 -sympath C:/fpga/common/ipcores/BRAM36 -sympath C:/fpga/common/ipcores/DataBuffer -sympath C:/fpga/common/ipcores/fifo4k36 -sympath C:/fpga/common/ipcores/trgtable -sympath C:/fpga/common/ipcores/GTPTILE -intstyle ise -family virtex5 -flat -suppress -vhdl C:/fpga/TIFPGAC/FastMatchVeto.vhf -w C:/fpga/common/schematic/FastMatchVeto.sch
--Design Name: FastMatchVeto
--Device: virtex5
--Purpose:
--    This vhdl netlist is translated from an ECS schematic. It can be 
--    synthesized and simulated, but it should not be modified. 
--
----- CELL OR6_HXILINX_FastMatchVeto -----
  
library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;
library UNISIM;
use UNISIM.Vcomponents.ALL;

-- The inputs are divided into three groups, so that the same design can be used for various input width
entity FastMatchVeto is
  port ( Clk250   : in    std_logic; 
    Din      : in    std_logic_vector (6 downto 1);   -- width extended inputs
    DinB     : in    std_logic_vector (10 downto 1); 
    DinC     : in    std_logic_vector (16 downto 1); 
    Inhibit  : in    std_logic_vector (7 downto 0);    -- the setting is 7-bit (bit#7 not used)
    Reset    : in    std_logic; 
    SDin     : in    std_logic_vector (6 downto 1);   -- one clock (4ns) wide inputs
    SDinB    : in    std_logic_vector (10 downto 1); 
    SDinC    : in    std_logic_vector (16 downto 1); 
    Window   : in    std_logic_vector (7 downto 0);   -- the setting is 7-bit (bit#7 not used)
    Dout     : out   std_logic_vector (6 downto 1); 
    DoutB    : out   std_logic_vector (10 downto 1); 
    DoutC    : out   std_logic_vector (16 downto 1); 
    LookupEn : out   std_logic;   -- MatchEn, LookupEn, and Douts have the same timing (aligned)
    MatchEn  : out   std_logic; 
    TestPt   : out   std_logic_vector (4 downto 1));
  attribute maxdelay : string ;
  attribute maxdelay of MatchEn : signal is "2ns";
end FastMatchVeto;

architecture BEHAVIORAL of FastMatchVeto is

  component SigDelay is
    Port ( SigIn : in STD_LOGIC;
      Clock     : in STD_LOGIC;
      DelayVal  : in STD_LOGIC_VECTOR (7 downto 0);
      SigOutMax : out std_logic;
      SigOut    : out STD_LOGIC);
  end component SigDelay;

  signal VetoEnable : std_logic := '0';
  signal PreMatch   : std_logic := '0';
  signal VetoRst    : std_logic := '0';
  signal Veto       : std_logic := '0';
  signal MatchRst   : std_logic := '0';
  signal Match      : std_logic := '0';
  signal DlyMatch   : std_logic := '0';
  signal LookupInt  : std_logic := '0';
  signal Qout       : std_logic_vector(32 downto 1) := (others => '0');
  signal PreMatchEn : std_logic;

begin

  VetoEnable <= (SDinC(16) or SDinC(15) or SDinC(14) or SDinC(13) or SDinC(12) or SDinC(11)
              or SDinC(10) or SDinC(9) or SDinC(8) or SDinC(7) or SDinC(6) or SDinC(5) or SDinC(4)
              or SDinC(3) or SDinC(2) or SDinC(1) or SDinB(10)  or SDinB(9) or SDinB(8) or SDinB(7)
              or SDinB(6) or SDinB(5) or SDinB(4) or SDinB(3) or SDinB(2) or SDinB(1) or SDin(6)
              or SDin(5) or SDin(4) or SDin(3) or SDin(2) or SDin(1) ) and (not Veto);
              
  process (Clk250)
  begin
    if (Clk250'event and Clk250 = '1') then
      if (VetoRst = '1' or Reset = '1') then
        Veto <= '0';
      elsif (VetoEnable = '1') then
        Veto <= '1';
      end if;
      if (Reset = '1') then
        PreMatch <= '0';
      else
        PreMatch <= VetoEnable;
      end if;
      if (MatchRst = '1' or Reset = '1') then
        Match <= '0';
      elsif (VetoEnable = '1') then
        Match <= '1';
      end if;
      DlyMatch <= Match;
      MatchEn <= PreMatchEn;
      if (LookupInt = '1') then
        LookupInt <= '0';
      elsif (PreMatchEn = '1') then
        LookupInt <= '1';
      end if;      
    end if;
  end process;
  LookupEn <= LookupInt;
  PreMatchEn <= DlyMatch and (not Match);
  WindowDelay : SigDelay
    port map( SigIn => PreMatch, -- in STD_LOGIC;
      Clock     => Clk250, -- in STD_LOGIC;
      DelayVal  => Window(7 downto 0), -- in STD_LOGIC_VECTOR (7 downto 0);
      SigOutMax => open, -- out std_logic;
      SigOut    => MatchRst ); -- out STD_LOGIC);
  InhibitDelay : SigDelay
    port map( SigIn => MatchRst, -- in STD_LOGIC;
      Clock     => Clk250, -- in STD_LOGIC;
      DelayVal  => Inhibit(7 downto 0), -- in STD_LOGIC_VECTOR (7 downto 0);
      SigOutMax => open, -- out std_logic;
      SigOut    => VetoRst ); -- out STD_LOGIC);
  TestPt(4 downto 1) <= Match & Veto & MatchRst & LookupInt;

  DoutGenerateC : for Ichannel in 1 to 16 generate
  begin
    DinDelayC : SRL16E
      generic map (INIT => X"0000",  -- Initial contents of shift register
        IS_CLK_INVERTED => '0' )     -- Optional inversion for CLK
      port map ( Q => Qout(16+iChannel), -- 1-bit output: SRL Data
        CE  => '1',                      -- 1-bit input: Clock enable
        CLK => Clk250,                   -- 1-bit input: Clock
        D   => DinC(iChannel),           -- 1-bit input: SRL Data
        A0  => '1',
        A1  => '1',
        A2  => '0',
        A3  => '0' );
    process (Clk250)
    begin
      if (Clk250'event and Clk250 = '1') then
        if (LookupInt = '1') then
          DoutC(iChannel) <= '0';
        elsif (PreMatchEn = '1') then
          DoutC(iChannel) <= Qout(16 + iChannel);
        end if;
      end if;
    end process;
  end generate;

  DoutGenerateB : for Ichannel in 1 to 10 generate
  begin
    DinDelayC : SRL16E
      generic map (INIT => X"0000",  -- Initial contents of shift register
        IS_CLK_INVERTED => '0' )     -- Optional inversion for CLK
      port map ( Q => Qout(6+iChannel), -- 1-bit output: SRL Data
        CE  => '1',                      -- 1-bit input: Clock enable
        CLK => Clk250,                   -- 1-bit input: Clock
        D   => DinB(iChannel),           -- 1-bit input: SRL Data
        A0  => '1',
        A1  => '1',
        A2  => '0',
        A3  => '0' );
    process (Clk250)
    begin
      if (Clk250'event and Clk250 = '1') then
        if (LookupInt = '1') then
          DoutB(iChannel) <= '0';
        elsif (PreMatchEn = '1') then
          DoutB(iChannel) <= Qout(6 + iChannel);
        end if;
      end if;
    end process;
  end generate;

  DoutGenerate : for Ichannel in 1 to 6 generate
  begin
    DinDelay : SRL16E
      generic map (INIT => X"0000",  -- Initial contents of shift register
        IS_CLK_INVERTED => '0' )     -- Optional inversion for CLK
      port map ( Q => Qout(iChannel), -- 1-bit output: SRL Data
        CE  => '1',                      -- 1-bit input: Clock enable
        CLK => Clk250,                   -- 1-bit input: Clock
        D   => Din(iChannel),           -- 1-bit input: SRL Data
        A0  => '1',
        A1  => '1',
        A2  => '0',
        A3  => '0' );
    process (Clk250)
    begin
      if (Clk250'event and Clk250 = '1') then
        if (LookupInt = '1') then
          Dout(iChannel) <= '0';
        elsif (PreMatchEn = '1') then
          Dout(iChannel) <= Qout(iChannel);
        end if;
      end if;
    end process;
  end generate;
  
end BEHAVIORAL;


