----------------------------------------------------------------------------------
-- Company: Thomas Jefferson National Accelerator Facility
-- Engineer:  GU
-- 
-- Create Date: 02/21/2020 11:13:03 AM
-- Design Name:  USTIpcie
-- Module Name: ClkEdgeAvoid - Behavioral
-- Project Name:  
-- Target Devices:  Xilinx XCKU3P-1FFVA676C 
-- Tool Versions:  Vivado 2019.1
-- Description:   By adjusting the SigIn IOdelay, the SigOut will be clock registered output.
--             The SigIn is Async to the Clock, but the SigOut is Synced to the Clock.
--             The SigOut is not on the Clock edge (the CarryChain out is on the clock edge)
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
-- use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
library UNISIM;
use UNISIM.VComponents.all;

entity ClkEdgeAvoid is
  Port (
    ClkRef   : in STD_LOGIC;  -- Reference clock to the Delay elements
    Clock    : in STD_LOGIC;  -- clock to sync the SigIn
    SigIn    : in STD_LOGIC;  -- signal to be captured (to avoid the clock edge)
    AlignIn  : in STD_LOGIC;  -- alignment initiate signal
    SigOut   : out STD_LOGIC;  -- registered signal (clock edge avoided)
    SigInvert : out std_logic := '0';
    AlignRdy : out std_logic;  -- alignment ready
    CntDly   : out STD_LOGIC_VECTOR (19 downto 0) );  -- (8:0): Idelay count value  (17:9): Odelay value
                                                      -- (18) : Increament   (19): Inc/Decrement enable
end ClkEdgeAvoid;

architecture Behavioral of ClkEdgeAvoid is

  component Carry8FD is
    generic (InvertClock : std_logic_vector(2 downto 1) := "00");
    Port (
      FFout  : out std_logic_vector(7 downto 0); -- added FD out
      Clock  : in  std_logic;                    -- register clock
      CO     : out std_logic_vector(7 downto 0); -- 8-bit output: Carry-out
      O      : out std_logic_vector(7 downto 0); -- 8-bit output: Carry chain XOR data out
      CI     : in  std_logic;                    -- 1-bit input: Lower Carry-In
      CI_TOP : in  std_logic;                    -- 1-bit input: Upper Carry-In
      DI     : in  std_logic_vector(7 downto 0); -- 8-bit input: Carry-MUX data in
      S      : in  std_logic_vector(7 downto 0) );  -- 8-bit input: Carry-mux select
  end Component;

  signal AStart   : std_logic;
  signal AReceive : std_logic;
  signal ADlyRcv  : std_logic;
  signal ADelay   : std_logic;
  signal DlySet   : std_logic_vector(8 downto 0);
  signal Aligning : std_logic := '0';
  signal AlignRst : std_logic := '0';
  signal SCarry   : std_logic_vector(7 downto 0);
  signal CASC_OUT : std_logic;
  signal DelayOut : std_logic;
  signal INC      : std_logic;
  signal LOAD     : std_logic;
  signal CntDlyIn : std_logic_vector(8 downto 0);
  signal FromODly : std_logic;
  signal CEdelay  : std_logic;
  signal Increm   : std_logic;
  signal COFirst  : std_logic;
  signal COSecond : std_logic;
  signal COThird  : std_logic;
  signal ATimer   : std_logic_vector(15 downto 0) := (others => '0');
  signal CheckInc : std_logic;
  signal COClkR   : std_logic; -- CO on the Clock rising edge
  signal COClkF   : std_logic; -- CO on the Clock falling edge
  signal DLyTimer : std_logic; -- to find the edge of the Timer(3)
  signal CNTVALUE : std_logic_vector(17 downto 0);
  signal SigOutInt : std_logic;
  signal SavedRedge : std_logic := '0';
  signal SavedFedge : std_logic := '0';
  signal Save2Redge : std_logic := '1';
  signal Save2Fedge : std_logic := '1';
  signal DummyFDout : std_logic_vector(31 downto 0);
  signal DummyCout  : std_logic_vector(31 downto 0);
  signal DummyOut   : std_logic_vector(31 downto 0);
  
  attribute RLOC : string;
  attribute RLOC of CARRY8_SigOut:  label is "X0Y0";
  attribute RLOC of CARRY8_Second:  label is "X0Y1";
  attribute RLOC of CARRY8_Third:   label is "X0Y2";
  attribute RLOC of CARRY8_Forth:   label is "X0Y3";

begin

-- Alignment starting and stopping
  process (Clock,AlignIn, AStart, ADelay)
  begin
    if (ADelay = '1') then
      AReceive <= '0';
    elsif (AlignIn'event and AlignIn = '1') then
      AReceive <= '1';
    end if;
    if (Clock'event and Clock = '1') then
      ADlyRcv <= AReceive;
      ADelay  <= ADlyRcv;
    end if;
  end process;
  DelayAlignStart : SRLC32E
    generic map (INIT => X"00000000",    -- Initial contents of shift register
      IS_CLK_INVERTED => '0' ) -- Optional inversion for CLK
    port map (Q => AStart,     -- 1-bit output: SRL Data
      Q31 => open, -- 1-bit output: SRL Cascade Data
      A => "11111",     -- 5-bit input: Selects SRL depth
      CE => '1',   -- 1-bit input: Clock enable
      CLK => Clock, -- 1-bit input: Clock
      D => ADelay  );    -- 1-bit input: SRL Data
 
  COClkR <= (SCarry(1) and SCarry(2)) or (Scarry(1) and SCarry(3)) or (Scarry(2) and SCarry(3));
  COClkF <= (SCarry(4) and SCarry(5)) or (Scarry(4) and SCarry(6)) or (Scarry(5) and SCarry(6));
  process (Clock)
  begin
    if (Clock'event and Clock = '1') then
      if (AlignRst = '1') then
        ATimer   <= (others => '0');
--        AlignRdy <= '1';
        CntDly(15 downto 0) <= CNTVALUE(15 downto 0);
        Aligning <= '0';
      else
        if (AStart = '1') then
          Aligning <= '1';
          AlignRdy <= '0';
        end if;
        if ((ATimer(14) = '1') and (Increm = '0') ) then
          AlignRdy <= '1';
        end if;
        if (Aligning = '1') then
          ATimer <= ATimer + 1;
        end if;
      end if;
--      Increm <= (COClkR xor COClkF) and ((COCLKR xnor SavedRedge) or (COCLKF xnor SavedFedge));
             -- increment or Decrement to stay at the clock edge (either rising or falling)
             -- If both edges changes, no more increment, the edge is also found
      Increm <= (COCLKR xnor SavedRedge) and (COCLKR xnor Save2REdge);  -- to limit to the rising edge of the clock. (but the signal high/low does not matter)
      DlyTimer <= ATimer(3);
      CEdelay <= (not DlyTimer) and ATimer(3); -- rising edge of ATimer(3), every 16 clock cycles
      AlignRst <= ATimer(15);
      CntDly(18) <= Increm;
      CntDly(19) <= CEdelay;
      SavedRedge <= COCLKR;
      Save2Redge <= SavedRedge;
      SavedFedge <= COCLKF;
      Save2Fedge <= SavedFedge;
    end if;     
  end process;
  SigOut <= SigOutInt;
  process (Clock)
  begin
    if (Clock'event and Clock = '1') then
      if (CEdelay = '1') then
        SigInvert  <= not SigOutInt;
        CntDly(17) <= SigOutInt;
      end if;
--      if (SigInvert = '1') then
--        SigOut <= not SigOutInt;
--      else
--        SigOut <= SigOutInt;
--      end if;
      CntDly(16) <= SigOutInt;
    end if;
  end process;
  
-- Instatiate the Idelay, Odelay and several Carry8
  IDELAYE3_SigIn : IDELAYE3
    generic map (CASCADE => "MASTER",  -- Cascade setting (MASTER, NONE, SLAVE_END, SLAVE_MIDDLE)
      DELAY_FORMAT => "COUNT",         -- Units of the DELAY_VALUE (COUNT, TIME)
      DELAY_SRC => "IDATAIN",          -- Delay input (DATAIN, IDATAIN)
      DELAY_TYPE => "VARIABLE",        -- Set the type of tap delay line (FIXED, VARIABLE, VAR_LOAD)
      DELAY_VALUE => 100,              -- Input delay value setting
      IS_CLK_INVERTED => '0',          -- Optional inversion for CLK
      IS_RST_INVERTED => '0',          -- Optional inversion for RST
      REFCLK_FREQUENCY => 250.0,       -- IDELAYCTRL clock input frequency in MHz (200.0-2667.0)
      SIM_DEVICE => "ULTRASCALE_PLUS", -- Set the device version (ULTRASCALE, ULTRASCALE_PLUS,
                                       -- ULTRASCALE_PLUS_ES1, ULTRASCALE_PLUS_ES2)
      UPDATE_MODE => "ASYNC"     )     -- Determines when updates to the delay will take effect (ASYNC, MANUAL, SYNC)
    port map (
      CASC_OUT => CASC_OUT,      -- 1-bit output: Cascade delay output to ODELAY input cascade
      CNTVALUEOUT => CNTVALUE(8 downto 0), -- 9-bit output: Counter value output
      DATAOUT => DelayOut,       -- 1-bit output: Delayed data output
      CASC_IN => '0',            -- 1-bit input: Cascade delay input from slave ODELAY CASCADE_OUT
      CASC_RETURN => FromODly,   -- 1-bit input: Cascade delay returning from slave ODELAY DATAOUT
      CE => CEdelay,             -- 1-bit input: Active high enable increment/decrement input
      CLK => ClkRef,             -- 1-bit input: Clock input
      CNTVALUEIN => "000000000", -- 9-bit input: Counter value input
      DATAIN => '0',             -- 1-bit input: Data input from the logic
      EN_VTC => '0',             -- 1-bit input: Keep delay constant over VT
      IDATAIN => SigIn,          -- 1-bit input: Data input from the IOBUF
      INC => Increm,             -- 1-bit input: Increment / Decrement tap delay input
      LOAD => '0',               -- 1-bit input: Load DELAY_VALUE input
      RST => '0'        );       -- 1-bit input: Asynchronous Reset to the DELAY_VALUE

  ODELAYE3_SigIn : ODELAYE3
    generic map (CASCADE => "SLAVE_END", -- Cascade setting (MASTER, NONE, SLAVE_END, SLAVE_MIDDLE)
      DELAY_FORMAT => "COUNT",         -- (COUNT, TIME)
      DELAY_TYPE => "VARIABLE",        -- Set the type of tap delay line (FIXED, VARIABLE, VAR_LOAD)
      DELAY_VALUE => 100,              -- Output delay tap setting
      IS_CLK_INVERTED => '0',          -- Optional inversion for CLK
      IS_RST_INVERTED => '0',          -- Optional inversion for RST
      REFCLK_FREQUENCY => 250.0,       -- IDELAYCTRL clock input frequency in MHz (200.0-2667.0).
      SIM_DEVICE => "ULTRASCALE_PLUS", -- Set the device version (ULTRASCALE, ULTRASCALE_PLUS,
                                       -- ULTRASCALE_PLUS_ES1, ULTRASCALE_PLUS_ES2)
      UPDATE_MODE => "ASYNC"  )        -- Determines when updates to the delay will take effect (ASYNC, MANUAL, SYNC)
   port map (
      CASC_OUT    => open,       -- 1-bit output: Cascade delay output to IDELAY input cascade
      CNTVALUEOUT => CNTVALUE(17 downto 9), -- 9-bit output: Counter value output
      DATAOUT     => FromODly,   -- 1-bit output: Delayed data from ODATAIN input port
      CASC_IN     => CASC_OUT,   -- 1-bit input: Cascade delay input from slave IDELAY CASCADE_OUT
      CASC_RETURN => '0',        -- 1-bit input: Cascade delay returning from slave IDELAY DATAOUT
      CE          => CEdelay,    -- 1-bit input: Active high enable increment/decrement input
      CLK         => ClkRef,     -- 1-bit input: Clock input
      CNTVALUEIN  => (others => '0'), -- 9-bit input: Counter value input
      EN_VTC      => '0',        -- 1-bit input: Keep delay constant over VT
      INC         => Increm,     -- 1-bit input: Increment/Decrement tap delay input
      LOAD        => '0',        -- 1-bit input: Load DELAY_VALUE input
      ODATAIN     => '0',        -- 1-bit input: Data input
      RST         => '0'   );    -- 1-bit input: Asynchronous Reset to the DELAY_VALUE

  CARRY8_SigOut : Carry8FD
    generic map(InvertClock => "10" ) -- std_logic_vector(2 downto 1) := "00"
    port map(FFout(0)  => SigOutInt,
      FFout(7 downto 1) => DummyFDout(7 downto 1), --open, -- out std_logic_vector(7 downto 0); -- added FD out
      Clock   => Clock,          -- register clock
      CO(6 downto 0) => DummyCout(6 downto 0), -- open,    -- 8-bit output: Carry-out
      CO(7)  => COFirst,
      O      => DummyOut(7 downto 0), -- open,         -- 8-bit output: Carry chain XOR data out
      CI     => '0',          -- 1-bit input: Lower Carry-In
      CI_TOP => '0',          -- 1-bit input: Upper Carry-In
      DI(0)  => DelayOut,     -- 8-bit input: Carry-MUX data in
      DI(7 downto 1) => "0000000",
      S              => "11111110" ); -- 8-bit input: Carry-mux select
  CARRY8_Second : Carry8FD
    generic map(InvertClock => "10" ) -- std_logic_vector(2 downto 1) := "00"
    port map(
      FFout  => DummyFDout(15 downto 8), --open,          -- out std_logic_vector(7 downto 0); -- added FD out
      Clock  => Clock,         -- register clock
      CO(6 downto 0) => DummyCout(14 downto 8), -- open,  -- 8-bit output: Carry-out
      CO(7)  => COSecond,
      O      => DummyOut(15 downto 8), -- open,          -- 8-bit output: Carry chain XOR data out
      CI     => COFirst,       -- 1-bit input: Lower Carry-In
      CI_TOP => '0',           -- 1-bit input: Upper Carry-In
      DI     => "00000000",    -- 8-bit input: Carry-MUX data in
      S      => "11111111" );  -- 8-bit input: Carry-mux select
  CARRY8_Third : Carry8FD
    generic map(InvertClock => "10" ) -- std_logic_vector(2 downto 1) := "00"
    port map(FFout  => DummyFDout(23 downto 16), -- open,   -- out std_logic_vector(7 downto 0); -- added FD out
      Clock  => Clock,         -- register clock
      CO(6 downto 0) => DummyCout(22 downto 16), -- open,  -- 8-bit output: Carry-out
      CO(7)  => COThird,
      O      => DummyOut(23 downto 16), -- open,          -- 8-bit output: Carry chain XOR data out
      CI     => COSecond,      -- 1-bit input: Lower Carry-In
      CI_TOP => '0',           -- 1-bit input: Upper Carry-In
      DI     => "00000000",    -- 8-bit input: Carry-MUX data in
      S      => "11111111" );  -- 8-bit input: Carry-mux select
  CARRY8_Forth : Carry8FD
    generic map(InvertClock => "10" ) -- std_logic_vector(2 downto 1) := "00"
    port map(FFout  => SCarry,  -- out std_logic_vector(7 downto 0); -- added FD out
      Clock  => Clock,          -- in  std_logic;                    -- register clock
      CO     => DummyCout(31 downto 24), -- open,           -- 8-bit output: Carry-out
      O      => DummyOut(31 downto 24), -- open,           -- 8-bit output: Carry chain XOR data out
      CI     => COThird,        -- 1-bit input: Lower Carry-In
      CI_TOP => '0',            -- 1-bit input: Upper Carry-In
      DI     => "00000000",     -- 8-bit input: Carry-MUX data in
      S      => "11111111" );   -- 8-bit input: Carry-mux select

end Behavioral;
