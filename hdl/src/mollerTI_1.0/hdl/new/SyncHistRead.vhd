----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/25/2020 02:40:34 PM
-- Design Name: 
-- Module Name: SyncHistRead - Behavioral
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
Library xpm;
use xpm.vcomponents.all;

entity SyncHistRead is
  Port ( Clock  : in STD_LOGIC;
    ClkSlow     : in STD_LOGIC;
    SyncMonitor : in STD_LOGIC_VECTOR (15 downto 0);
    ValidTSTD   : in STD_LOGIC;
    ValidSub    : in STD_LOGIC;
    ValidTS     : in STD_LOGIC;
    SCValid     : in STD_LOGIC;
    ResetMem    : in STD_LOGIC;
    ReadEn      : in STD_LOGIC;
    ClkRead     : in STD_LOGIC;
    DataCode    : out STD_LOGIC_VECTOR (39 downto 0));
end SyncHistRead;

architecture Behavioral of SyncHistRead is
  signal FifoDataIn  : std_logic_vector(35 downto 0);
  signal FifoDataOut : std_logic_vector(39 downto 0);
  signal SyncSaveEn  : std_logic_vector(7 downto 0) := (others => '0');
  signal rd_en       : std_logic;
  signal wr_en       : std_logic;
  signal ClearBuf    : std_logic;
  signal ClearOver   : std_logic;
  signal SyncTimer   : std_logic_vector(24 downto 0):=(others => '0');
begin

  -- xpm_fifo_async: Asynchronous FIFO, Xilinx Parameterized Macro, version 2019.1
  SyncCodeFifo : xpm_fifo_async
    generic map (CDC_SYNC_STAGES => 2,  -- DECIMAL
      DOUT_RESET_VALUE => "0",    -- String
      ECC_MODE => "no_ecc",       -- String
      FIFO_MEMORY_TYPE => "auto", -- String
      FIFO_READ_LATENCY => 1,     -- DECIMAL
      FIFO_WRITE_DEPTH => 2048,   -- DECIMAL
      FULL_RESET_VALUE => 0,      -- DECIMAL
      PROG_EMPTY_THRESH => 5,    -- DECIMAL
      PROG_FULL_THRESH => 5,     -- DECIMAL
      RD_DATA_COUNT_WIDTH => 1,   -- DECIMAL
      READ_DATA_WIDTH => 36,      -- DECIMAL
      READ_MODE => "std",         -- String
      RELATED_CLOCKS => 0,        -- DECIMAL
   -- SIM_ASSERT_CHK => 0,        -- DECIMAL; 0=disable simulation messages, 1=enable simulation messages
      USE_ADV_FEATURES => "0707", -- String
      WAKEUP_TIME => 0,           -- DECIMAL
      WRITE_DATA_WIDTH => 36,     -- DECIMAL
      WR_DATA_COUNT_WIDTH => 1 )   -- DECIMAL
    port map (almost_empty => open,   -- 1-bit output: Almost Empty : When asserted, this signal indicates that
                                      -- only one more read can be performed before the FIFO goes to empty.
      almost_full => open,     -- 1-bit output: Almost Full: When asserted, this signal indicates that
                                      -- only one more write can be performed before the FIFO is full.
      data_valid => open,       -- 1-bit output: Read Data Valid: When asserted, this signal indicates
                                      -- that valid data is available on the output bus (dout).
      dbiterr => open,             -- 1-bit output: Double Bit Error: Indicates that the ECC decoder
                                      -- detected a double-bit error and data in the FIFO core is corrupted.
      dout => FifoDataOut(35 downto 0),      -- READ_DATA_WIDTH-bit output: Read Data: The output data bus is driven
                                      -- when reading the FIFO.
      empty => FifoDataOut(37),                 -- 1-bit output: Empty Flag: When asserted, this signal indicates that
                                      -- the FIFO is empty. Read requests are ignored when the FIFO is empty,
                                      -- initiating a read while empty is not destructive to the FIFO.
      full => FifoDataOut(39),        -- 1-bit output: Full Flag: When asserted, this signal indicates that the
                                      -- FIFO is full. Write requests are ignored when the FIFO is full,
                                      -- initiating a write when the FIFO is full is not destructive to the
                                      -- contents of the FIFO.
      overflow => open,           -- 1-bit output: Overflow: This signal indicates that a write request
                                      -- (wren) during the prior clock cycle was rejected, because the FIFO is
                                      -- full. Overflowing the FIFO is not destructive to the contents of the
                                      -- FIFO.
      prog_empty => open,       -- 1-bit output: Programmable Empty: This signal is asserted when the
                                      -- number of words in the FIFO is less than or equal to the programmable
                                      -- empty threshold value. It is de-asserted when the number of words in
                                      -- the FIFO exceeds the programmable empty threshold value.
      prog_full => FifoDataOut(38),     -- 1-bit output: Programmable Full: This signal is asserted when the
                                      -- number of words in the FIFO is greater than or equal to the
                                      -- programmable full threshold value. It is de-asserted when the number
                                      -- of words in the FIFO is less than the programmable full threshold
                                      -- value.
      rd_data_count => open, -- RD_DATA_COUNT_WIDTH-bit output: Read Data Count: This bus indicates
                                      -- the number of words read from the FIFO.
      rd_rst_busy => open,     -- 1-bit output: Read Reset Busy: Active-High indicator that the FIFO
                                      -- read domain is currently in a reset state.
      sbiterr => open,             -- 1-bit output: Single Bit Error: Indicates that the ECC decoder
                                      -- detected and fixed a single-bit error.
      underflow => open,         -- 1-bit output: Underflow: Indicates that the read request (rd_en)
                                      -- during the previous clock cycle was rejected because the FIFO is
                                      -- empty. Under flowing the FIFO is not destructive to the FIFO.
      wr_ack => open,               -- 1-bit output: Write Acknowledge: This signal indicates that a write
                                      -- request (wr_en) during the prior clock cycle is succeeded.
      wr_data_count => open, -- WR_DATA_COUNT_WIDTH-bit output: Write Data Count: This bus indicates
                                      -- the number of words written into the FIFO.
      wr_rst_busy => open,     -- 1-bit output: Write Reset Busy: Active-High indicator that the FIFO
                                      -- write domain is currently in a reset state.
      din => FifoDataIn(35 downto 0),   -- WRITE_DATA_WIDTH-bit input: Write Data: The input data bus used when
                                      -- writing the FIFO.
      injectdbiterr => '0',    -- 1-bit input: Double Bit Error Injection: Injects a double bit error if
                                      -- the ECC feature is used on block RAMs or UltraRAM macros.
      injectsbiterr => '0',  -- 1-bit input: Single Bit Error Injection: Injects a single bit error if
                                      -- the ECC feature is used on block RAMs or UltraRAM macros.
      rd_clk => ClkRead,           -- 1-bit input: Read clock: Used for read operation. rd_clk must be a
                                      -- free running clock.
      rd_en => rd_en,                 -- 1-bit input: Read Enable: If the FIFO is not empty, asserting this
                                      -- signal causes data (on dout) to be read from the FIFO. Must be held
                                      -- active-low when rd_rst_busy is active high.
      rst => ResetMem,                     -- 1-bit input: Reset: Must be synchronous to wr_clk. The clock(s) can be
                                      -- unstable at the time of applying reset, but reset must be released
                                      -- only after the clock(s) is/are stable.
      sleep => '0',                 -- 1-bit input: Dynamic power saving: If sleep is High, the memory/fifo
                                      -- block is in power saving mode.
      wr_clk => ClkSlow,               -- 1-bit input: Write clock: Used for write operation. wr_clk must be a
                                      -- free running clock.
      wr_en => ClearOver   );      -- 1-bit input: Write Enable: If the FIFO is not full, asserting this
                                      -- signal causes data (on din) to be written to the FIFO. Must be held
                                      -- active-low when rst or wr_rst_busy is active high.
  process (Clock)
  begin
    if (Clock'event and Clock = '1') then
      if (ClearBuf = '1') then
        SyncSaveEn(3 downto 0) <= (others => '0');
      else
        if (ValidTSTD = '1') then
          SyncSaveEn(0) <= '1';
        end if;
        if (ValidSub = '1') then
          SyncSaveEn(1) <= '1';
        end if;
        if (ValidTS = '1') then
          SyncSaveEn(2) <= '1';
        end if;
        if (SCValid = '1') then
          SyncSaveEn(3) <= '1';
        end if;
      end if;
    end if;
  end process;
  
  process (ClkSlow)
  begin
    if (ClkSlow'event and ClkSlow = '1') then
      if (ClearOver = '1') then
        ClearOver <= '0';
        FifoDataIn(20) <= '0';
      else
        CLearOver <= SyncSaveEn(0) or SyncSaveEn(1) or SyncSaveEn(2) or SyncSaveEn(3);
        if (SyncTimer(23) = '1') then
          FifoDataIn(20) <= '1';
        end if;
      end if;
      ClearBuf <= ClearOver;
      SyncTimer <= SyncTimer + 1;
    end if;
  end process;
  FifoDataIn(35 downto 21) <= SyncTimer(22 downto 8);
  -- assign the FifiDataIn
  FifoDataIn(19) <= SyncSaveEn(3);
  FifoDataIn(18 downto 15) <= SyncMonitor(15 downto 12);
  FifoDataIn(14) <= SyncSaveEn(2);
  FifoDataIn(13 downto 10) <= SyncMonitor(11 downto 8);
  FifoDataIn(9) <= SyncSaveEn(1);
  FifoDataIn(8 downto 5) <= SyncMonitor(7 downto 4);
  FifoDataIn(4) <= SyncSaveEn(0);
  FifoDataIn(3 downto 0) <= SyncMonitor(3 downto 0);
  DataCode(39 downto 0) <= FifoDataOut(39 downto 0);
  process (ClkRead)
  begin
    if (ClkRead'event and ClkRead = '1') then
      FifoDataOut(36) <= FifoDataOut(37);
    end if;
  end process;
  rd_en <= ReadEn and (not FifoDataOut(36));

end Behavioral;
