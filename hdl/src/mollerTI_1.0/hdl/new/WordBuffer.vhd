----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/03/2020 01:05:19 PM
-- Design Name: 
-- Module Name: WordBuffer - Behavioral
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
--library UNISIM;
--use UNISIM.VComponents.all;

entity WordBuffer is
  Port ( Clock : in STD_LOGIC;
    Data     : in    std_logic_vector (71 downto 0); 
    FifoREn  : in    std_logic; 
    Reset    : in    std_logic; 
    Write_En : in    std_logic; 
    FnEmpty  : out   std_logic; 
    FnFull   : out   std_logic; 
    Status   : out   std_logic_vector(31 downto 0);
    MedOut   : out   std_logic_vector (35 downto 0));
end WordBuffer;

architecture Behavioral of WordBuffer is

  COMPONENT buf72to36
  PORT (clk : IN STD_LOGIC;
    srst : IN STD_LOGIC;
    din : IN STD_LOGIC_VECTOR(71 DOWNTO 0);
    wr_en : IN STD_LOGIC;
    rd_en : IN STD_LOGIC;
    dout : OUT STD_LOGIC_VECTOR(35 DOWNTO 0);
    full : OUT STD_LOGIC;
    empty : OUT STD_LOGIC;
    prog_full : OUT STD_LOGIC;
    wr_rst_busy : OUT STD_LOGIC;
    rd_rst_busy : OUT STD_LOGIC  );
  END COMPONENT;

--  component buf72to36
--    port ( wr_clk    : in    std_logic; 
--      din       : in    std_logic_vector (71 downto 0); 
--      wr_en     : in    std_logic; 
--      rd_clk    : in    std_logic; 
--      rd_en     : in    std_logic; 
--      rst       : in    std_logic; 
--      dout      : out   std_logic_vector (35 downto 0); 
--      full      : out   std_logic; 
--      prog_full : out   std_logic; 
--      empty     : out   std_logic);
--  end component;
  signal FnEmptyInt : std_logic;
  signal FnFullInt  : std_logic;
  signal ReadEnInt  : std_logic;
  signal SyncReset  : std_logic;
  signal CountW     : std_logic_vector(7 downto 0):="00000000";
  signal CountR     : std_logic_vector(7 downto 0):="00000000";
  signal CountFR    : std_logic_vector(7 downto 0):="00000000";

begin

  process (Clock)
  begin
    if (Clock'event and Clock = '1') then
      SyncReset <= Reset;
      if (SyncReset = '1') then
        CountW <= (others => '0');
        CountR <= (others => '0');
        CountFR <= (others => '0');
      else
        if (Write_En = '1') then
          CountW <= CountW + 1;
        end if;
        if (FifoREn = '1') then
          CountR <= CountR + 1;
        end if;
        if (ReadEnInt = '1') then
          CountFR <= CountFR + 1;
        end if;
      end if;
    end if;
  end process;
  Status(31 downto 8) <= CountW(7 downto 0) & CountR(7 downto 0) & CountFR(7 downto 0);
  ReadEnInt <= FifoREn and (not FnEmptyInt);
  DataStorage : buf72to36
  PORT MAP(clk => Clock, --  IN STD_LOGIC;
    srst => SyncReset, -- IN STD_LOGIC;
    din(71 downto 36) => Data(35 downto 0), -- IN STD_LOGIC_VECTOR(71 DOWNTO 0);
    din(35 downto 0) => Data(71 downto 36), -- IN STD_LOGIC_VECTOR(71 DOWNTO 0);
    wr_en => Write_En, -- IN STD_LOGIC;
    rd_en => ReadEnInt, -- IN STD_LOGIC;
    dout => MedOut(35 downto 0), -- OUT STD_LOGIC_VECTOR(35 DOWNTO 0);
    full => Status(7), -- OUT STD_LOGIC;
    empty => FnEmptyInt, -- OUT STD_LOGIC;
    prog_full => FnFullInt, -- OUT STD_LOGIC;
    wr_rst_busy => Status(2), -- OUT STD_LOGIC;
    rd_rst_busy => Status(3) ); -- OUT STD_LOGIC  );
  Status(0) <= FnFullInt;
  Status(1) <= FnEmptyInt;
  Status(4) <= SyncReset;
  Status(5) <= Write_En;
  Status(6) <= ReadEnInt;
--  Status(7) <= Write_En or FifoRen;
  FnFull <= FnFullInt;
  FnEmpty <= FnEmptyInt;
--  DataStorage : buf72to36
--    port map (din(71 downto 36) => Data(35 downto 0),
--      din(35 downto 0) => Data(71 downto 36),
--      rd_clk => Clock,
--      rd_en  => ReadEnInt,
--      rst    => SyncReset,
--      wr_clk => Clock,
--      wr_en  => Write_En,
--      dout(35 downto 0) => MedOut(35 downto 0),
--      empty  => FnEmptyInt,
--      full   => open,
--      prog_full => FnFull );

end Behavioral;
