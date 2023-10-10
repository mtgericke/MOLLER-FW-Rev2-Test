-------------------------------------------------------------
-- MSS copyright 2020
--	Filename:  TBCOM5501IPG.VHD
-- Author: Alain Zarembowitch / MSS
--	Version: 0
--	Date last modified: 11/24/20
-- Inheritance: 	TBCOM5501.VHD 2/2/18
--
-- description:  testbench for a 10G Ethernet MAC.
-- The application sends frames in rapid succession on the MAC transmit path
-- The tb loops back the component XGMII output (XGMII_TX) to the XGMII input (XGMII_RX)
-- The ethernet frame is thus checked on the MAC receive path, including CRC32 check etc.

  LIBRARY ieee;
  USE ieee.std_logic_1164.ALL;
  USE ieee.numeric_std.ALL;

  ENTITY tbcom5501ipg IS
  END ENTITY;

  ARCHITECTURE behavior OF tbcom5501ipg IS

--------------------------------------------------------
--      COMPONENTS
--------------------------------------------------------
	COMPONENT COM5501
	GENERIC (
		EXT_PHY_MDIO_ADDR: std_logic_vector(4 downto 0);
		RX_MTU: integer;
		RX_BUFFER: std_logic;
		RX_BUFFER_ADDR_NBITS: integer;
		TX_MTU: integer;
		TX_BUFFER: std_logic;
		TX_BUFFER_ADDR_NBITS: integer;
		MAC_CONTROL_PAUSE_ENABLE: std_logic;
		SIMULATION: std_logic
    );
	PORT(
		CLK : IN std_logic;
		SYNC_RESET : IN std_logic;
		CLK156g : IN std_logic;
		MAC_TX_CONFIG : IN std_logic_vector(7 downto 0);
		MAC_RX_CONFIG : IN std_logic_vector(7 downto 0);
		MAC_ADDR : IN std_logic_vector(47 downto 0);
		MAC_TX_DATA : IN std_logic_vector(63 downto 0);
		MAC_TX_DATA_VALID : IN std_logic_vector(7 downto 0);
		MAC_TX_EOF : IN std_logic;
		MAC_RX_CTS : IN std_logic;
		XGMII_RXD : IN std_logic_vector(63 downto 0);
		XGMII_RXC : IN std_logic_vector(7 downto 0);
		MDIO_IN : IN std_logic;
		MDIO_DIR : out std_logic;
		MAC_TX_CTS : OUT std_logic;
		MAC_RX_DATA : OUT std_logic_vector(63 downto 0);
		MAC_RX_DATA_VALID : OUT std_logic_vector(7 downto 0);
		MAC_RX_SOF : OUT std_logic;
		MAC_RX_EOF : OUT std_logic;
		MAC_RX_FRAME_VALID: out std_logic;
		XGMII_TXD : OUT std_logic_vector(63 downto 0);
		XGMII_TXC : OUT std_logic_vector(7 downto 0);
		RESET_N : OUT std_logic;
		MDC : OUT std_logic;
		MDIO_OUT : OUT std_logic;
		PHY_CONFIG_CHANGE : IN std_logic;
		PHY_RESET: in std_logic;
		TEST_MODE: in std_logic_vector(1 downto 0);
		POWER_DOWN: in std_logic;
		PHY_STATUS: out std_logic_vector(7 downto 0);
		PHY_STATUS2: out std_logic_vector(7 downto 0);
		PHY_ID : OUT std_logic_vector(15 downto 0);
		N_RX_FRAMES : OUT std_logic_vector(15 downto 0);
		N_RX_BAD_CRCS : OUT std_logic_vector(15 downto 0);
		N_RX_FRAMES_TOO_SHORT : OUT std_logic_vector(15 downto 0);
		N_RX_FRAMES_TOO_LONG : OUT std_logic_vector(15 downto 0);
		N_RX_WRONG_ADDR : OUT std_logic_vector(15 downto 0);
		N_RX_LENGTH_ERRORS : OUT std_logic_vector(15 downto 0);
		RX_IPG: out std_logic_vector(7 downto 0);
		DEBUG1 : OUT std_logic_vector(63 downto 0);
		DEBUG2 : OUT std_logic_vector(63 downto 0);
		DEBUG3 : OUT std_logic_vector(63 downto 0);
		TP : OUT std_logic_vector(10 downto 1)
		);
	END COMPONENT;
--------------------------------------------------------
--     SIGNALS
--------------------------------------------------------
signal  CLK156g: std_logic := '0';
signal SYNC_RESET_CLK156: std_logic := '0';
constant TX_START1: integer range 0 to 65535 := 100;
constant TX_START2: integer range 0 to 65535 := 112;
constant TX_START3: integer range 0 to 65535 := 122;
constant TX_START4: integer range 0 to 65535 := 250;
signal TX_SEQ: unsigned(15 downto 0) := (others => '0');
signal TX_WORD_CNTR: unsigned(15 downto 0) := (others => '0');

signal LAN1_MAC_ADDR: std_logic_vector(47 downto 0) := (others => '0');
signal LAN1_MDIO_IN: std_logic := '0';
signal LAN1_MDC: std_logic := '0';
signal LAN1_MDIO_OUT: std_logic := '0';
signal LAN1_MDIO_DIR: std_logic := '0';
signal LAN1_PHY_RESET: std_logic := '0';
signal LAN1_TEST_MODE: std_logic_vector(1 downto 0) := (others => '0');
signal LAN1_POWER_DOWN: std_logic := '0';
signal LAN1_PHY_ID: std_logic_vector(15 downto 0) := (others => '0');
signal LAN1_PHY_STATUS: std_logic_vector(7 downto 0) := (others => '0');
signal LAN1_PHY_STATUS2: std_logic_vector(7 downto 0) := (others => '0');
signal LAN1_MAC_TX_DATA: std_logic_vector(63 downto 0) := (others => '0');
signal LAN1_MAC_TX_DATA_VALID: std_logic_vector(7 downto 0) := (others => '0');
signal LAN1_MAC_TX_EOF: std_logic:= '0';
signal LAN1_MAC_TX_CTS: std_logic:= '0';
signal LAN1_MAC_RX_DATA: std_logic_vector(63 downto 0) := (others => '0');
signal LAN1_MAC_RX_DATA_VALID: std_logic_vector(7 downto 0) := (others => '0');
signal LAN1_MAC_RX_SOF: std_logic:= '0';
signal LAN1_MAC_RX_EOF: std_logic:= '0';
signal LAN1_MAC_RX_FRAME_VALID: std_logic:= '0';
signal LAN1_N_RX_FRAMES:  std_logic_vector(15 downto 0) := (others => '0');
signal LAN1_N_RX_BAD_CRCS:  std_logic_vector(15 downto 0) := (others => '0');
signal LAN1_N_RX_FRAMES_TOO_SHORT:  std_logic_vector(15 downto 0) := (others => '0');
signal LAN1_N_RX_FRAMES_TOO_LONG:  std_logic_vector(15 downto 0) := (others => '0');
signal LAN1_N_RX_WRONG_ADDR:  std_logic_vector(15 downto 0) := (others => '0');
signal LAN1_N_RX_LENGTH_ERRORS:  std_logic_vector(15 downto 0) := (others => '0');
signal LAN1_RX_IPG: std_logic_vector(7 downto 0) := (others => '0');

signal XGMII_TXD: std_logic_vector(63 downto 0) := (others => '0');
signal XGMII_TXC: std_logic_vector(7 downto 0) := (others => '0');
signal XGMII_RXD: std_logic_vector(63 downto 0) := (others => '0');
signal XGMII_RXC: std_logic_vector(7 downto 0) := (others => '0');

--------------------------------------------------------
--      IMPLEMENTATION
--------------------------------------------------------
begin

CLK156g_GEN: process
begin
	CLK156g <= '1';
	wait for 3.2ns;
	CLK156g <= '0';
	wait for 3.2ns;
end process;

-- testbench sequencer
TX_SEQ_001: process(CLK156g)
begin
	if rising_edge(CLK156g) then
		TX_SEQ <= TX_SEQ + 1;
	end if;
end process;

-- sync reset
SYNC_RESET_CLK156_GEN: process(CLK156g)
begin
	if rising_edge(CLK156g) then
		if(TX_SEQ = 10) then
			SYNC_RESET_CLK156 <= '1';
		else
			SYNC_RESET_CLK156 <= '0';
		end if;
	end if;
end process;

-- generate tx frame
TX_FRAME_GEN: process(CLK156g)
begin
	if rising_edge(CLK156g) then
		if(SYNC_RESET_CLK156 = '1') or (TX_SEQ = TX_START1) or (TX_SEQ = TX_START2) or (TX_SEQ = TX_START3) then
			TX_WORD_CNTR <= (others => '0');
		elsif(TX_SEQ > TX_START1) and (TX_SEQ < TX_START2) and (LAN1_MAC_TX_CTS = '1') then
			TX_WORD_CNTR <= TX_WORD_CNTR + 1;

-- to test various frame lengths and short frame padding
			if(TX_WORD_CNTR = 0) then
				LAN1_MAC_TX_DATA <= x"f1f2060504030201";
				LAN1_MAC_TX_DATA_VALID <= x"FF";
				LAN1_MAC_TX_EOF <= '0';
			elsif(TX_WORD_CNTR = 1) then
				LAN1_MAC_TX_DATA <= x"1112131415161718";
				LAN1_MAC_TX_DATA_VALID <= x"FF";
			elsif(TX_WORD_CNTR = 2) then
				LAN1_MAC_TX_DATA <= x"2122233425262728";
				LAN1_MAC_TX_DATA_VALID <= x"FF";
			elsif(TX_WORD_CNTR = 3) then
				LAN1_MAC_TX_DATA <= x"3132333435363738";
				LAN1_MAC_TX_DATA_VALID <= x"FF";
			elsif(TX_WORD_CNTR = 4) then
				LAN1_MAC_TX_DATA <= x"4142434445464748";
				LAN1_MAC_TX_DATA_VALID <= x"FF";
			elsif(TX_WORD_CNTR = 5) then
				LAN1_MAC_TX_DATA <= x"5152535455565758";
				LAN1_MAC_TX_DATA_VALID <= x"FF";
			elsif(TX_WORD_CNTR = 6) then
				LAN1_MAC_TX_DATA <= x"6162636465666768";
				LAN1_MAC_TX_DATA_VALID <= x"ff";
			elsif(TX_WORD_CNTR = 7) then
				LAN1_MAC_TX_DATA <= x"7172737475767778";
				LAN1_MAC_TX_DATA_VALID <= x"ff";
			elsif(TX_WORD_CNTR = 8) then
				LAN1_MAC_TX_DATA <= x"8182838485868788";
				LAN1_MAC_TX_DATA_VALID <= x"FF";
			elsif(TX_WORD_CNTR = 9) then
				LAN1_MAC_TX_DATA <= x"9192939495969798";
				LAN1_MAC_TX_DATA_VALID <= x"FF";
				LAN1_MAC_TX_EOF <= '1';
			else
				LAN1_MAC_TX_DATA_VALID <= x"00";
				LAN1_MAC_TX_EOF <= '0';
			end if;

		elsif(TX_SEQ > TX_START2) and (TX_SEQ < TX_START3) and (LAN1_MAC_TX_CTS = '1') then
			TX_WORD_CNTR <= TX_WORD_CNTR + 1;

-- Other frame with a known CRC (to check the CRC = D3C41B13)
			if(TX_WORD_CNTR = 0) then
				LAN1_MAC_TX_DATA <= x"0E00FFFFFFFFFFFF";
				LAN1_MAC_TX_DATA_VALID <= x"FF";
				LAN1_MAC_TX_EOF <= '0';
			elsif(TX_WORD_CNTR = 1) then
				LAN1_MAC_TX_DATA <= x"01000608A3BBCA08";
				LAN1_MAC_TX_DATA_VALID <= x"FF";
			elsif(TX_WORD_CNTR = 2) then
				LAN1_MAC_TX_DATA <= x"0E00010004060008";
				LAN1_MAC_TX_DATA_VALID <= x"FF";
			elsif(TX_WORD_CNTR = 3) then
				LAN1_MAC_TX_DATA <= x"7E0110ACA3BBCA08";
				LAN1_MAC_TX_DATA_VALID <= x"FF";
			elsif(TX_WORD_CNTR = 4) then
				LAN1_MAC_TX_DATA <= x"10AC000000000000";
				LAN1_MAC_TX_DATA_VALID <= x"FF";
			elsif(TX_WORD_CNTR = 5) then
				LAN1_MAC_TX_DATA <= x"0000000000001F01";
				LAN1_MAC_TX_DATA_VALID <= x"03";
				LAN1_MAC_TX_EOF <= '1';
			else
				LAN1_MAC_TX_DATA_VALID <= x"00";
				LAN1_MAC_TX_EOF <= '0';
			end if;

		elsif(TX_SEQ > TX_START3) and (TX_SEQ < TX_START4) and (LAN1_MAC_TX_CTS = '1') then
			TX_WORD_CNTR <= TX_WORD_CNTR + 1;
-- to test various frame lengths and short frame padding
			if(TX_WORD_CNTR = 0) then
				LAN1_MAC_TX_DATA <= x"0200ffffffffffff";
				LAN1_MAC_TX_DATA_VALID <= x"FF";
				LAN1_MAC_TX_EOF <= '0';
			elsif(TX_WORD_CNTR = 1) then
				LAN1_MAC_TX_DATA <= x"00450008e22e29c9";
				LAN1_MAC_TX_DATA_VALID <= x"FF";
			elsif(TX_WORD_CNTR = 2) then
				LAN1_MAC_TX_DATA <= x"1180000071744801";
				LAN1_MAC_TX_DATA_VALID <= x"FF";
			elsif(TX_WORD_CNTR = 3) then
				LAN1_MAC_TX_DATA <= x"ffff0000000034c5";
				LAN1_MAC_TX_DATA_VALID <= x"FF";
			elsif(TX_WORD_CNTR = 4) then
				LAN1_MAC_TX_DATA <= x"340143004400ffff";
				LAN1_MAC_TX_DATA_VALID <= x"FF";
			elsif(TX_WORD_CNTR = 5) then
				LAN1_MAC_TX_DATA <= x"128300060101d627";
				LAN1_MAC_TX_DATA_VALID <= x"FF";
			elsif(TX_WORD_CNTR = 6) then
				LAN1_MAC_TX_DATA <= x"000000000000a812";
				LAN1_MAC_TX_DATA_VALID <= x"ff";
			elsif(TX_WORD_CNTR = 8) then
				LAN1_MAC_TX_DATA <= x"0200000000000000";
				LAN1_MAC_TX_DATA_VALID <= x"ff";
			elsif(TX_WORD_CNTR = 9) then
				LAN1_MAC_TX_DATA <= x"00000000e22e29c9";
				LAN1_MAC_TX_DATA_VALID <= x"FF";
			elsif(TX_WORD_CNTR = 34) then
				LAN1_MAC_TX_DATA <= x"8263000000000000";
				LAN1_MAC_TX_DATA_VALID <= x"FF";
			elsif(TX_WORD_CNTR = 35) then
				LAN1_MAC_TX_DATA <= x"01073d0101356353";
				LAN1_MAC_TX_DATA_VALID <= x"FF";
			elsif(TX_WORD_CNTR = 36) then
				LAN1_MAC_TX_DATA <= x"8263000000000000";
				LAN1_MAC_TX_DATA_VALID <= x"FF";
			elsif(TX_WORD_CNTR = 44) then
				LAN1_MAC_TX_DATA <= x"0000000000112233";
				LAN1_MAC_TX_DATA_VALID <= x"07";
				LAN1_MAC_TX_EOF <= '1';
			elsif(TX_WORD_CNTR < 44) then
				LAN1_MAC_TX_DATA <= x"0000000000000000";
				LAN1_MAC_TX_DATA_VALID <= x"FF";
			else
				LAN1_MAC_TX_DATA_VALID <= x"00";
				LAN1_MAC_TX_EOF <= '0';
			end if;

		else
			LAN1_MAC_TX_DATA_VALID <= x"00";
			LAN1_MAC_TX_EOF <= '0';
		end if;


	end if;
end process;


LAN1_MAC_ADDR <= x"010203040506";

COM5501_001: COM5501
GENERIC MAP(
	EXT_PHY_MDIO_ADDR => "00000",	-- on COM-5401 adapter, the external PHY MDIO address is 0
	RX_MTU => 1500,	-- bytes in standard frame
	RX_BUFFER => '1',	-- minimize latency. No rx output buffer, use same clock for CLK and CLK156g.
	RX_BUFFER_ADDR_NBITS => 10,	-- n/a
	TX_MTU => 1500,	-- bytes in standard frame
	TX_BUFFER => '1',	-- minimize latency. No tx input buffer, use same clock for CLK and CLK156g.
	TX_BUFFER_ADDR_NBITS => 10,	-- n/a
	MAC_CONTROL_PAUSE_ENABLE => '1',
	SIMULATION => '1'
)
PORT MAP(
	CLK => CLK156g,
	SYNC_RESET => SYNC_RESET_CLK156,
	CLK156g => CLK156g,
	MAC_TX_CONFIG => x"03",
	MAC_RX_CONFIG => x"0F",
	MAC_ADDR => LAN1_MAC_ADDR,
	MAC_TX_DATA => LAN1_MAC_TX_DATA,
	MAC_TX_DATA_VALID => LAN1_MAC_TX_DATA_VALID,
	MAC_TX_EOF => LAN1_MAC_TX_EOF,
	MAC_TX_CTS => LAN1_MAC_TX_CTS,
	MAC_RX_DATA => LAN1_MAC_RX_DATA,
	MAC_RX_DATA_VALID => LAN1_MAC_RX_DATA_VALID,
	MAC_RX_SOF => LAN1_MAC_RX_SOF,
	MAC_RX_EOF => LAN1_MAC_RX_EOF,
	MAC_RX_FRAME_VALID => LAN1_MAC_RX_FRAME_VALID,
	MAC_RX_CTS => '1',
	-- XGMII interface
	XGMII_TXD => XGMII_TXD,
	XGMII_TXC => XGMII_TXC,
	XGMII_RXD => XGMII_TXD,		-- loopback
	XGMII_RXC => XGMII_TXC,
	-- MDIO interface with external PHY
	RESET_N => open,	-- N/A no MDIO here
	MDC => open,
	MDIO_OUT => open,
	MDIO_IN => '0',
	MDIO_DIR => open,
	PHY_CONFIG_CHANGE => '0',
	PHY_RESET => LAN1_PHY_RESET,
	TEST_MODE => LAN1_TEST_MODE,
	POWER_DOWN => LAN1_POWER_DOWN,
	PHY_STATUS => LAN1_PHY_STATUS,
	PHY_STATUS2 => LAN1_PHY_STATUS2,
	PHY_ID => LAN1_PHY_ID,
	N_RX_FRAMES => LAN1_N_RX_FRAMES,
	N_RX_BAD_CRCS => LAN1_N_RX_BAD_CRCS,
	N_RX_FRAMES_TOO_SHORT => LAN1_N_RX_FRAMES_TOO_SHORT,
	N_RX_FRAMES_TOO_LONG => LAN1_N_RX_FRAMES_TOO_LONG,
	N_RX_WRONG_ADDR => LAN1_N_RX_WRONG_ADDR,
	N_RX_LENGTH_ERRORS => LAN1_N_RX_LENGTH_ERRORS,
	RX_IPG => LAN1_RX_IPG,
	DEBUG1 => open,
	DEBUG2 => open,
	DEBUG3 => open,
	TP => open
);
  END;
