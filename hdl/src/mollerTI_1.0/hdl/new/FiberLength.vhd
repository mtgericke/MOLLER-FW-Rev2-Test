----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/27/2020 01:44:58 PM
-- Design Name: 
-- Module Name: FiberLength - Behavioral
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
use IEEE.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity FiberLength is
  Port ( Clock : in STD_LOGIC;
    MReturn : in STD_LOGIC;
    MasterMode : in STD_LOGIC;
    VmeRst : in STD_LOGIC_VECTOR (15 downto 0);
    DSMout : out STD_LOGIC;
    ReadData : out STD_LOGIC_VECTOR (31 downto 0);
    TestPt : out STD_LOGIC_VECTOR (8 downto 1));
end FiberLength;

architecture Behavioral of FiberLength is

  component ClkEdgeAvoid is
    Port (
      ClkRef   : in STD_LOGIC;  -- Reference clock to the Delay elements
      Clock    : in STD_LOGIC;  -- clock to sync the SigIn
      SigIn    : in STD_LOGIC;  -- signal to be captured (to avoid the clock edge)
      AlignIn  : in STD_LOGIC;  -- alignment initiate signal
      SigOut   : out STD_LOGIC;  -- registered signal (clock edge avoided)
      SigInvert : out std_logic := '0';
      AlignRdy : out std_logic;  -- alignment ready
      CntDly   : out STD_LOGIC_VECTOR (19 downto 0) );  -- (8:0): Idelay count value  (17:9): Odelay value
  end component ClkEdgeAvoid;                           -- (18) : Increament   (19): Inc/Decrement enable
  
  signal Aligned  : std_logic;                                                    
  signal AlignCnt : std_logic_vector(39 downto 0);
  signal AlignedSig : std_logic;
  signal AHigh    : std_logic := '0';
  signal MOut     : std_logic := '0';
  signal PreMOut1 : std_logic := '0';
  signal PreMOut2 : std_logic := '0';
  signal PostMOut : std_logic := '0';
  signal FillLpbk : std_logic;
  signal PreStop  : std_logic := '0';
  signal DlyStop  : std_logic_vector(7 downto 0):=(others => '0'); -- (0) is the Stop in schematics
  signal Latency  : std_logic_vector(15 downto 0) := (others =>'0');
  signal LatCntEn : std_logic := '0';
  signal FillIn   : std_logic;
  signal PulseDet : std_logic;
  signal NoSigCnt : std_logic_vector(7 downto 0):=(others =>'0');
  
begin

  ReturnSignalAlign : ClkEdgeAvoid
    Port map(ClkRef => Clock, -- in STD_LOGIC;  -- Reference clock to the Delay elements
      Clock    => Clock,      -- in STD_LOGIC;  -- clock to sync the SigIn
      SigIn    => MReturn,    -- in STD_LOGIC;  -- signal to be captured (to avoid the clock edge)
      AlignIn  => VmeRst(13), -- in STD_LOGIC;  -- alignment initiate signal
      SigOut   => Aligned,    -- out STD_LOGIC;  -- registered signal (clock edge avoided)
      SigInvert => TestPt(5), -- out_logic := '0';
      AlignRdy => TestPt(6),       -- out std_logic;  -- alignment ready
      CntDly   => AlignCnt(19 downto 0) ); -- out STD_LOGIC_VECTOR (19 downto 0) );  -- (8:0): Idelay count value
                                           --  (17:9): Odelay value (18): Increament (19): Inc/Decrement enable
  process (Clock, VmeRst, MOut)
  begin

 -- Measurement of the Fiber Latency VmeRst(15) --> MOut   
    if (MOut = '1') then
      PreMOut1 <= '0';
    else
      if (VmeRst(15)'event and VmeRst(15) = '1') then
        PreMOut1 <= '1';
      end if;
    end if;

-- Clocked signals (FFs)
    if (Clock'event and Clock = '1') then
      AHigh <= not AHigh;
      if (AHigh = '1') then
        PreMOut2 <= PreMOut1;
      end if;
      MOut <= PreMOut2;
      PostMOut <= MOut or AHigh;
      PreStop <= Aligned;
      if (DlyStop(0) = '1') then
        DlyStop(0) <= '0';
      else
        DlyStop(0) <= PreStop and Aligned;
      end if;
      DlyStop(1) <= DlyStop(0);
      DlyStop(2) <= DlyStop(1);
      DlyStop(3) <= DlyStop(2);
      if (DlyStop(0) = '1' or VmeRst(13) = '1') then
        LatCntEn <= '0';
      else
        LatCntEn <= MOut and AHigh;
      end if;
      if (MOut = '1' and AHigh = '1') then
        Latency <= (others => '0');
      elsif (LatCntEn = '1') then
        Latency <= Latency + 1;
      end if;
      ReadData(31 downto 23) <= Latency(8 downto 0);
      ReadData(22 downto 20) <= Latency(11 downto 9);
      ReadData(19 downto 0) <= AlignCnt(19 downto 0);
    end if;
  end process;

-- Fillin logic, if the master
  process (Clock)
  begin
    if (Clock'event and Clock = '1') then
      FillIn <= not FillIn;
      PulseDet <= Aligned;
      if (Aligned /= PulseDet) then  -- either rising edge or falling edge
        NoSigCnt <= (others => '0');
      else
        NoSigCnt <= NoSigCnt + 1;
      end if;
    end if;
  end process;
  FillLpbk <= Aligned xor (NoSigCnt(7) and FillIn);
  DSMout <= PostMOut when (MasterMode = '0') else FillLpbk;
  TestPt(4 downto 1) <= FillLpbk & Aligned & DlyStop(1) & MOut;
  TestPt(8 downto 7) <= LatCntEn & VmeRst(15);

end Behavioral;
