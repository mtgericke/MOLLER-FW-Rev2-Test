----------------------------------------------------------------------------------
-- Company:  Thomas Jefferson National Accelarator Facility
-- Engineer:  GU
-- 
-- Create Date:    13:54:38 07/23/2013 
-- Design Name: 
-- Module Name:    TrgBitFifo - Behavioral 
-- Project Name:  TSFPGA
-- Target Devices:  Virtrx-5
-- Tool versions: 
-- Description:   This module delays the GTP trigger bits, EXT trigger bits
--       and FP trigger bits for bit pattern readout
--       The original module, TrgSrcRead, uses CLB delay and works mainly
--       on the Clk625.  This module uses BRAM36 and works on Clk250.
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
library UNISIM;
use UNISIM.VComponents.all;

entity TrgBitFifo is
  Port ( GtpTrgIn : in  STD_LOGIC_VECTOR (31 downto 0);  -- They are all 4 ns wide pulses
    ExtTrgIn : in  STD_LOGIC_VECTOR (31 downto 0);
    FpTrgIn  : in  STD_LOGIC_VECTOR (31 downto 0);
    GtpTrgInEn : in std_logic;
    ExtTrgInEn : in std_logic;
    FpTrgInEN  : in std_logic;  -- These three channels work simultanousely
    SyncDly : in  STD_LOGIC_VECTOR (7 downto 0);
    SerialDly : in std_logic_vector(7 downto 0);
    QuadTime : in  STD_LOGIC_VECTOR (1 downto 0);
    Clk250 : in  STD_LOGIC;
    Reset : in  STD_LOGIC;
    WindowDly : in std_logic_vector(4 downto 0);
    TestPt  : out  std_logic_vector(10 downto 1);
    TrgInput : inout  STD_LOGIC_VECTOR (95 downto 0));
end TrgBitFifo;

architecture Behavioral of TrgBitFifo is

-- signals for FIFO control
  signal FifoWEn : std_logic;
  signal DelayOut : std_logic_vector (30 downto 1);
  signal DlyedWEn : std_logic;
  signal FifoREn : std_logic;
  signal GtpValid : std_logic_vector(3 downto 0);
  signal FifoOutput : std_logic_vector(95 downto 0);
  signal DFifoREn : std_logic;
  signal MFifoREn : std_logic;

  component BRAM36
    port (din: IN std_logic_VECTOR(35 downto 0);
      rd_clk : IN std_logic;
      rd_en  : IN std_logic;
      rst    : IN std_logic;
      wr_clk : IN std_logic;
      wr_en  : IN std_logic;
      almost_full: OUT std_logic;
      dout   : OUT std_logic_VECTOR(35 downto 0);
      empty  : OUT std_logic;
      full   : OUT std_logic);
   end component;
-- Synplicity black box declaration
   attribute syn_black_box : boolean;
   attribute syn_black_box of BRAM36: component is true;

begin
  process (Clk250, Reset)
  begin
    if (Clk250'event and Clk250 = '1') then  -- Three FIFOs work simultanously
      if (Reset = '1') then
        FifoWEn <= '0';
        FifoREn <= '0';
      else
        FifoWEn <= (GtpTrgInEn or FpTrgInEn or ExtTrgInEn);
        FifoREn <= DlyedWEn;
      end if;
    end if;
  end process;
  
  process (Clk250, Reset)
  begin
    if (Clk250'event and Clk250 = '1') then
      if (Reset = '1') then
        GtpValid <= (others => '0');
      else
        if (FifoREn = '1' and DFifoREn = '0') then
           GtpValid <= GtpValid + 1;
        elsif (FifoREn = '0' and DFifoREn = '1' and GtpValid > "0000") then
           Gtpvalid <= GtpValid - 1;
        end if;
      end if;
    end if;
  end process;
  
  process (Clk250)
  begin
    if (Clk250'event and Clk250 = '1') then
      if (GtpValid > "0000") then
        TrgInput (31 downto 0)  <= FifoOutput(31 downto 0);
        TrgInput (63 downto 32) <= FifoOutput(63 downto 32);
        TrgInput (95 downto 64) <= FifoOutput(95 downto 64);
      else
        TrgInput (95 downto 0) <= (others => '0');
      end if;
    end if;
  end process;
  
  REnWindow : SRLC32E
    port map (Q => DFifoREn,
      Q31  => open,
      A    => WindowDly(4 downto 0),
      CE   => '1',
      Clk  => Clk250,
      D    => FifoREn  );
  
  GtpTriggerBits : BRAM36
    port map (
      din(31 downto 0) => GtpTrgIn(31 downto 0),
      din(35 downto 32) => "0000",
      rd_clk => Clk250,
      rd_en => FifoREn,
      rst => Reset,
      wr_clk => Clk250,
      wr_en => FifoWEn,
      almost_full => TestPt(1),
      dout(31 downto 0) => FifoOutput (31 downto 0),
      dout(35 downto 32) => open,
      empty => TestPt(2),
      full => TestPt(3) );
      
  ExtTriggerBits : BRAM36
    port map (
      din(31 downto 0) => ExtTrgIn(31 downto 0),
      din(35 downto 32) => "0000",
      rd_clk => Clk250,
      rd_en => FifoREn,
      rst => Reset,
      wr_clk => Clk250,
      wr_en => FifoWEn,
      almost_full => TestPt(4),
      dout(31 downto 0) => FifoOutput (63 downto 32),
      dout(35 downto 32) => open,
      empty => open,
      full => open );
      
  FpTriggerBits : BRAM36
    port map (
      din(31 downto 0) => FpTrgIn(31 downto 0),
      din(35 downto 32) => "0000",
      rd_clk => Clk250,
      rd_en  => FifoREn,
      rst    => Reset,
      wr_clk => Clk250,
      wr_en  => FifoWEn,
      almost_full => TestPt(5),
      dout(31 downto 0) => FifoOutput (95 downto 64),
      dout(35 downto 32) => open,
      empty => open,
      full  => open );
      
  SRLC32ESerial1 : SRLC32E
    port map ( Q => DelayOut(2),
      Q31 => DelayOut(1),
      A   => SerialDly(4 downto 0),
      CE  => '1',
      Clk => Clk250,
      D   => FifoWEn  );
  SRLC32ESerial2 : SRLC32E
    port map ( Q => DelayOut(4),
      Q31 => DelayOut(3),
      A   => SerialDly(4 downto 0),
      CE  => '1',
      Clk => Clk250,
      D   => DelayOut(1)  );
  SRLC32ESerial3 : SRLC32E
    port map ( Q => DelayOut(6),
      Q31 => DelayOut(5),
      A   => SerialDly(4 downto 0),
      CE  => '1',
      Clk => Clk250,
      D   => DelayOut(3)  );
  SRLC32ESerial4 : SRLC32E
    port map (Q => DelayOut(8),
      Q31 => DelayOut(7),
      A   => SerialDly(4 downto 0),
      CE  => '1',
      Clk => Clk250,
      D   => DelayOut(5)  );
  process (Clk250)
  begin
    if (Clk250'event and Clk250 = '1') then
      case SerialDly(6 downto 5) is
        when "00" =>  DelayOut(10) <= DelayOut(2);
        when "01" =>  DelayOut(10) <= DelayOut(4);
        when "10" =>  DelayOut(10) <= DelayOut(6);
        when "11" =>  DelayOut(10) <= DelayOut(8);
        when others =>   NULL;
      end case;
    end if;
  end process;

  SRLC32ESync1 : SRLC32E
    port map (Q => DelayOut(12),
      Q31 => DelayOut(11),
      A   => SyncDly(4 downto 0),
      CE  => '1',
      Clk => Clk250,
      D   => DelayOut(10)  );
  SRLC32ESync2 : SRLC32E
    port map (Q => DelayOut(14),
      Q31 => DelayOut(13),
      A   => SyncDly(4 downto 0),
      CE  => '1',
      Clk => Clk250,
      D   => DelayOut(11)  );
  SRLC32ESync3 : SRLC32E
    port map (Q   => DelayOut(16),
      Q31 => DelayOut(15),
      A   => SyncDly(4 downto 0),
      CE  => '1',
      Clk => Clk250,
      D   => DelayOut(13)  );
  SRLC32ESync4 : SRLC32E
    port map (Q => DelayOut(18),
      Q31 => DelayOut(17),
      A   => SyncDly(4 downto 0),
      CE  => '1',
      Clk => Clk250,
      D   => DelayOut(15)  );
  SRLC32ESync5 : SRLC32E
    port map (Q => DelayOut(20),
      Q31 => DelayOut(19),
      A   => SyncDly(4 downto 0),
      CE  => '1',
      Clk => Clk250,
      D   => DelayOut(17)  );
  SRLC32ESync6 : SRLC32E
    port map (Q => DelayOut(22),
      Q31 => DelayOut(21),
      A   => SyncDly(4 downto 0),
      CE  => '1',
      Clk => Clk250,
      D   => DelayOut(19)  );
  SRLC32ESync7 : SRLC32E
    port map (Q => DelayOut(24),
      Q31 => DelayOut(23),
      A   => SyncDly(4 downto 0),
      CE  => '1',
      Clk => Clk250,
      D   => DelayOut(21)  );
  SRLC32ESync8 : SRLC32E
    port map (Q => DelayOut(26),
      Q31 => DelayOut(25),
      A   => SyncDly(4 downto 0),
      CE  => '1',
      Clk => Clk250,
      D   => DelayOut(23)  );
  process (Clk250)
  begin
    if (Clk250'event and Clk250 = '1') then
      case SyncDly(7 downto 5) is
        when "000" =>   DelayOut(30) <= DelayOut(12);
        when "001" =>   DelayOut(30) <= DelayOut(14);
        when "010" =>   DelayOut(30) <= DelayOut(16);
        when "011" =>   DelayOut(30) <= DelayOut(18);
        when "100" =>   DelayOut(30) <= DelayOut(20);
        when "101" =>   DelayOut(30) <= DelayOut(22);
        when "110" =>   DelayOut(30) <= DelayOut(24);
        when "111" =>   DelayOut(30) <= DelayOut(26);
        when others =>  NULL;
      end case;
    end if;
  end process;
  ESRLC32EWindow : SRLC32E
    port map (Q => open,
      Q31 => MFifoREn,
      A   => "11111",   -- a fixed delay to compensate for the trigger path delay
      CE  => '1',
      Clk => Clk250,
      D   => DelayOut(30)  );
  ESRLC32EWindowB : SRLC32E
    port map (Q => DlyedWEn,
      Q31 => open,
      A   => "01001",   -- a fixed delay to compensate for the trigger path delay
      CE  => '1',
      Clk => Clk250,
      D   => MFifoREn  );
  TestPt(6) <= FifoOutput(35);
  TestPt(7) <= ExtTrgIn(3);
  TestPt(8) <= TrgInput(35);
  TestPt(9) <= FifoWEn;
  TestPt(10) <= FifoREn;
  
end Behavioral;
