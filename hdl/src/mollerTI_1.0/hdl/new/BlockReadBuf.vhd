----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/03/2020 01:33:13 PM
-- Design Name: 
-- Module Name: BlockReadBuf - Behavioral
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
use ieee.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity BlockReadBuf is
  Port ( ClkRead      : in    std_logic; 
    ClkWrite     : in    std_logic; 
    DataIn       : in    std_logic_vector (71 downto 0); 
    ReadEnIn     : in    std_logic; 
    Reset        : in    std_logic; 
    WriteEn      : in    std_logic; 
    BufferBusy   : out   std_logic; 
    DataOut      : out   std_logic_vector (71 downto 0); 
    DataValid    : out   std_logic; 
    DWAvailable  : out   std_logic_vector (15 downto 0); 
    FifoPFull    : out   std_logic; 
    ReadyForRead : out   std_logic; 
    Status       : out   std_logic_vector (15 downto 0); 
    WordCount    : out   std_logic_vector (15 downto 0) );
end BlockReadBuf;

architecture Behavioral of BlockReadBuf is

  component fifo8k72
    port (wr_clk  : in    std_logic; 
      prog_full : out   std_logic; 
      din       : in    std_logic_vector (71 downto 0); 
      wr_en     : in    std_logic; 
      rd_clk    : in    std_logic; 
      rd_en     : in    std_logic; 
      rst       : in    std_logic; 
      full      : out   std_logic; 
      empty     : out   std_logic; 
      valid     : out   std_logic; 
      dout      : out   std_logic_vector (71 downto 0);
      wr_rst_busy : OUT STD_LOGIC;
      rd_rst_busy : OUT STD_LOGIC  );
  end component;

  signal WriteBusy  : std_logic;
  signal BlockEnd   : std_logic;
  signal WordCntInt : std_logic_vector(15 downto 0):=(others=>'0');
  signal DWAvCnt    : std_logic_vector(15 downto 0):=(others=>'0');
  signal CountLoad  : std_logic;
  signal DCountLoad : std_logic;
  signal ReadEn     : std_logic;
  signal RdyReadInt : std_logic;
  signal FifoFull   : std_logic;
  signal DataValidInt : std_logic;
  signal D1WriteBusy  : std_logic;
  signal D2WriteBusy  : std_logic;
  
begin

  BlockEnd <= (WriteEn and DataIn(71) and (not DataIn(70))) or
              (WriteEn and DataIn(35) and (not DataIn(34)));
  process (ClkWrite, Reset, DCountLoad)
  begin
    if (Reset = '1' or DCountLoad = '1') then
      WriteBusy <= '0';
      WordCntInt <= (others => '0');
    else
      if (ClkWrite'event and ClkWrite = '1') then
        if (BlockEnd = '1') then
          WriteBusy <= '1';
        end if;
        if (WriteEn = '1') then
          WordCntInt <= WordCntInt + 1;
        end if;
      end if;
    end if;
  end process;

  process (ClkRead, Reset)
  begin
    if (ClkRead'event and ClkRead = '1') then
      if (Reset = '1') then
        DWAvCnt <= (others => '0');
      elsif (CountLoad = '1') then
        DWAvCnt <= WordCntInt;
      elsif (ReadEn = '1' and RdyReadInt = '1') then
        DWAvCnt <= DWAvCnt - 1;
      end if;
      if (CountLoad = '1') then
        CountLoad <= '0';
      elsif (RdyReadInt = '0') then
        CountLoad <= D2WriteBusy;
      end if;
      DCountLoad <= CountLoad;
    end if;
    if (Reset = '1') then
      D1WriteBusy <= '0';
      D2WriteBusy <= '0';
    else
      if (ClkRead'event and ClkRead = '1') then
        D1WriteBusy <= WriteBusy;
        D2WriteBusy <= D1WriteBusy;
      end if;
    end if;
  end process;
  RdyReadInt <= DWAvCnt(11) or DWAvCnt(10) or DWAvCnt(9) or DWAvCnt(8)
             or DWAvCnt(7) or DWAvCnt(6) or DWAvCnt(5) or DWAvCnt(4)
             or DWAvCnt(3) or DWAvCnt(2) or DWAvCnt(1) or DWAvCnt(0);
  DWAvailable(15 downto 0) <= DWAvCnt(15 downto 0);
  WordCount <= WordCntInt(15 downto 0);
  ReadEn <= ReadEnIn and RdyReadInt;
  ReadyForRead <= RdyReadInt;

  DataStorage : fifo8k72
    port map ( wr_clk => ClkWrite,
      din(71 downto 0) => DataIn(71 downto 0),
      rd_clk  => ClkRead,
      rd_en   => ReadEn,
      rst     => Reset,
      wr_en   => WriteEn,
      dout(71 downto 0) => DataOut(71 downto 0),
      empty   => Status(9),
      full    => FifoFull,
      prog_full => FifoPFull,
      wr_rst_busy => open,
      rd_rst_busy => open,
      valid   => DataValidInt );
  BufferBusy <= D2WriteBusy or WriteBusy or BlockEnd or FifoFull;
  DataValid <= DataValidInt;
  Status(11) <= DataValidInt;
  Status(15 downto 12) <= "1010";
  Status(10) <= ReadEnIn;
  Status(8) <= FifoFull;
  Status(7 downto 4) <= DataIn(34) & DataIn(35) & DataIn(70) & DataIn(71);
  Status(3 downto 0) <= WriteEn & CountLoad & RdyReadInt & WriteBusy;
end Behavioral;
