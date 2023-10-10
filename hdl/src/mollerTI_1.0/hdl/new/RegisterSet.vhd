----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:43:04 10/16/2014 
-- Design Name: 
-- Module Name:    RegisterSet - Behavioral 
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
--library UNISIM;
--use UNISIM.VComponents.all;

entity RegisterSet is
  Port ( Address : in  STD_LOGIC_VECTOR (8 downto 0);
    DataIn : in std_logic_vector (31 downto 0);
    Clock : in  STD_LOGIC;
    Reset : in  STD_LOGIC;
    BAR : in  STD_LOGIC_VECTOR (2 downto 0);
    Enable : in  STD_LOGIC;
    CrateID : out std_logic_vector (7 downto 0);
    CrateIDEn : out std_logic;
    FiberEn : out  STD_LOGIC_VECTOR (7 downto 0);
    TrgSyncOutEn : out  STD_LOGIC;
    IntrptID : out  STD_LOGIC_VECTOR (7 downto 0);
    IntrptLevel : out  STD_LOGIC_VECTOR (2 downto 0);
    IntrptEn : out std_logic;
    TrigDelayWidth : out  STD_LOGIC_VECTOR (31 downto 0);
    VmeAddress : out  STD_LOGIC_VECTOR (31 downto 0);
    BlockSize : out  STD_LOGIC_VECTOR (7 downto 0);
    TIDataFormat : out  STD_LOGIC_VECTOR (7 downto 0);
    VMESetting : out  STD_LOGIC_VECTOR (31 downto 0);
    I2CAdd : out  STD_LOGIC;
--  EnableCntl : out  STD_LOGIC_VECTOR (15 downto 0);
    TrgSrcEn : out  STD_LOGIC_VECTOR (15 downto 0);
    TrgSrcSet : out std_logic;
    SyncSrcEn : out  STD_LOGIC_VECTOR (15 downto 0);
    BusySrcEn : out  STD_LOGIC_VECTOR (15 downto 0);
    ClkSrcSet : out std_logic;
    ClockSrc : out  STD_LOGIC_VECTOR (31 downto 0);
    TrigPreScale : out  STD_LOGIC_VECTOR (15 downto 0);
    BlockTh : out  STD_LOGIC_VECTOR (7 downto 0);
    TrigRule : out  STD_LOGIC_VECTOR (31 downto 0);
    TrigWindow : out  STD_LOGIC_VECTOR (31 downto 0);
    GtpTrgEn : out  STD_LOGIC_VECTOR (31 downto 0);
    ExtTrgEn : out  STD_LOGIC_VECTOR (31 downto 0);
    FPTrgEn : out  STD_LOGIC_VECTOR (31 downto 0);
    FPOutput : out  STD_LOGIC_VECTOR (15 downto 0);
    SyncDelay : out  STD_LOGIC_VECTOR (31 downto 0);
    GtpPreScaleA : out  STD_LOGIC_VECTOR (31 downto 0);
    GtpPreScaleB : out  STD_LOGIC_VECTOR (31 downto 0);
    GtpPreScaleC : out  STD_LOGIC_VECTOR (31 downto 0);
    GtpPreScaleD : out  STD_LOGIC_VECTOR (31 downto 0);
    ExtPreScaleA : out  STD_LOGIC_VECTOR (31 downto 0);
    ExtPreScaleB : out  STD_LOGIC_VECTOR (31 downto 0);
    ExtPreScaleC : out  STD_LOGIC_VECTOR (31 downto 0);
    ExtPreScaleD : out  STD_LOGIC_VECTOR (31 downto 0);
    LTTableLoad : out std_logic;
    VmeEvtType : out  STD_LOGIC_VECTOR (31 downto 0);
    SyncGenDelay : out  STD_LOGIC_VECTOR (7 downto 0);
    SyncWidth : out  STD_LOGIC_VECTOR (7 downto 0);
    TrigCommandEn : out  STD_LOGIC;
    TrigCommand : out  STD_LOGIC_VECTOR (15 downto 0);
    RandomTrgEn : out  STD_LOGIC;
    RandomTrg : out  STD_LOGIC_VECTOR (15 downto 0);
    SoftTrg1En : out  STD_LOGIC;
    SoftTrg1 : out  STD_LOGIC_VECTOR (31 downto 0);
    SoftTrg2En : out  STD_LOGIC;
    SoftTrg2 : out  STD_LOGIC_VECTOR (31 downto 0);
    SyncCodeEn : out  STD_LOGIC;
    SyncCode : out  STD_LOGIC_VECTOR (7 downto 0);
    RunCode  : out  STD_LOGIC_VECTOR (31 downto 0);
    SyncEvtGen : out  STD_LOGIC_VECTOR (31 downto 0);
    PromptTrgW : out std_logic_vector (7 downto 0);
    ROCEn : out std_logic_vector (31 downto 0);
    EndOfRunBlk : out  STD_LOGIC_VECTOR (31 downto 0);
    TrgTblData : out std_logic_vector(31 downto 0);
    TrgTblAdr : out std_logic_vector(3 downto 0);
    TrgTblWEN : out std_logic;
    ForceTrgSrcSet : out std_logic;
    RunGo : out std_logic;
    RegE4Data : out std_logic_vector(15 downto 0);
    RegE4En   : out std_logic;
    Reg104D : out std_logic_vector(31 downto 0);
    Reg108D : out std_logic_vector(31 downto 0);
    Reg10cD : out std_logic_vector(31 downto 0);
    Reg110D : out std_logic_vector(31 downto 0);
    Reg114D : out std_logic_vector(31 downto 0);
    Reg118D : out std_logic_vector(31 downto 0);
    Reg11cD : out std_logic_vector(31 downto 0);
    Reg120D : out std_logic_vector(31 downto 0);
    Reg124D : out std_logic_vector(31 downto 0);
    Reg128D : out std_logic_vector(31 downto 0);
    Reg12cD : out std_logic_vector(31 downto 0);
    Reg130D : out std_logic_vector(31 downto 0);
    MinRuleWidth : out std_logic_vector(31 downto 0);
    I2CAddData : out std_logic_vector(31 downto 0);
    VmeReset : out std_logic_vector (31 downto 0)  );
end RegisterSet;

architecture Behavioral of RegisterSet is

  signal RegEn: std_logic;
  signal VmeResetInt : std_logic_vector(31 downto 0);
  
begin

  RegEn <= Enable and BAR(1) and BAR(2) and (not BAR(0)) and (not Address(0)) and (not Address(1));

  process (Clock, Reset, RegEn)
  begin
    If (Clock'event and Clock = '1') then
      VmeReset <= VmeResetInt;
      if ((Reset = '0') or (VmeResetInt(4) = '1') ) then  -- RESET is negative logic
        FiberEn <= (others => '1');
        CrateID(7 downto 0) <= x"59";
        TrgSyncOutEn <= '1';
        IntrptID <= "11010000";
        IntrptLevel <= "101";
        TrigDelayWidth <= "00001111000000000000111100000000";  -- default 0x07000700, delay is 0, width 32ns
        VmeAddress <= "100000000" & "000000000" & "111111111" & "00000";
        BlockSize <= "00000001";
        TIDataFormat <= "00000011";
        VMESetting <= "00000000000000000000000000010001";
        I2CAdd <= '0';
--      EnableCntl <= (others => '0');
        TrgSrcEn(15 downto 0)  <= (others => '0');
        SyncSrcEn(15 downto 0) <= x"0010"; -- "0000000000000010"; from HFBR#1 to Loopback
        BusySrcEn <= (others => '0');
        ClockSrc <= x"00000000";
        TrigPreScale <= (others => '0');
        BlockTh <= "00000001";  -- trigger block threshold
        TrigRule <= "00000001000000010000000100000001";
        TrigWindow <= "00000000100000000000000000000001";
        GtpTrgEn <= (others => '0');
        ExtTrgEn <= (others => '0');
        FPTrgEn <= "00000000000010100000000000000000"; -- default the trigger input pattern window to 0x0A, enable to 0x0
        FPOutput <= (others => '0');
        SyncDelay <= x"5f1f5f5f";
        GtpPreScaleA <= (others => '0');
        GtpPreScaleB <= (others => '0');
        GtpPreScaleC <= (others => '0');
        GtpPreScaleD <= (others => '0');
        ExtPreScaleA <= (others => '0');
        ExtPreScaleB <= (others => '0');
        ExtPreScaleC <= (others => '0');
        ExtPreScaleD <= (others => '0');
        VmeEvtType <= "11111110111111011111101111111010"; -- 0xFE(254) 0xFD(253) 0xFB(251) 0xFA(250);
        SyncGenDelay <= "01010100";
        SyncWidth <= "00100000";
        RunCode <= (others => '0');
        SyncEvtGen <= (others => '0');
        PromptTrgW <= "00110011";
        ROCEn(7 downto 0) <= "00000001";
        EndOfRunBlk <= (others => '0');
        VmeResetInt <= (others => '0');
        Reg104D <= (others => '0');
        Reg108D <= (others => '0');
        Reg10cD <= (others => '0');
        Reg110D <= (others => '0');
        Reg114D <= (others => '0');
        Reg118D <= (others => '0');
        Reg11cD <= (others => '0');
        Reg120D <= (others => '0');
        Reg124D <= (others => '0');
        Reg128D <= (others => '0');
        Reg12cD <= (others => '0');
        Reg130D <= (others => '0');
        MinRuleWidth <= (others => '0');
        TrgSrcSet <= '0';
		CrateIDEn <= '0';
		ClkSrcSet <= '0';
 		LTTableLoad <= '0';
		TrigCommandEn <= '0';
		RandomTrgEn <= '0';
		SoftTrg1En <= '0';
		SoftTrg2En <= '0';
        RunGo <= '0';
        RegE4En   <= '0'; -- out std_logic;
        ForceTrgSrcSet <= '0';
        TrgTblWEN <= '0';
      elsif (RegEn = '1') then
        case (Address(8 downto 6)) is
          when "000" =>
            case (Address(5 downto 2)) is 
              when "0000" => CrateID(7 downto 0) <= DataIn(7 downto 0);
                             CrateIDEn <= '1';
              when "0001" => FiberEn(7 downto 0) <= DataIn(7 downto 0);
                             TrgSyncOutEn <= DataIn(8);
              when "0010" => IntrptID(7 downto 0) <= DataIn(7 downto 0);
                             IntrptLevel(2 downto 1) <= DataIn(10 downto 9);
                             IntrptLevel(0) <= DataIn(8) or (not (DataIn(9) or DataIn(10)));
                             IntrptEn <= DataIn(16);
              when "0011" => TrigDelayWidth <= DataIn;
              when "0100" => VMEAddress <= DataIn; --   A32Max <= DataIn(13 downto 5); A32Min <= DataIn(22 downto 14); A32Base <= DataIn(31 downto 23);
              when "0101" => BlockSize <= DataIn(7 downto 0);
              when "0110" => TIDataFormat <= DataIn(7 downto 0);
              when "0111" => VMESetting <= DataIn(31 downto 0);
                             I2CAdd <= DataIn(8);
--            EnableCntl <= DataIn(31 downto 16);
              when "1000" => TrgSrcEn(15 downto 0) <= DataIn(15 downto 0);
                             TrgSrcSet <= '1';
                             if (DataIn(23 downto 16) = "11111100") then
                               ForceTrgSrcSet <= '1';
                             end if;
                             RunGo <= DataIn(31) and DataIn(28) and (not DataIn(30))
                                 and (not DataIn(29)) and (not DataIn(27)) and (not DataIn(26))
                                 and (not DataIn(25)) and (not DataIn(24));
              when "1001" => SyncSrcEn(15 downto 0) <= DataIn(15 downto 0);
              when "1010" => BusySrcEn(15 downto 0) <= DataIn(15 downto 0);
              when "1011" => ClockSrc <= DataIn(31 downto 0);
                             ClkSrcSet <= '1';
              when "1100" => TrigPreScale <= DataIn(15 downto 0);
              when "1101" => BlockTh <= DataIn(7 downto 0);
              when "1110" => TrigRule <= DataIn(31 downto 0);
              when "1111" => TrigWindow <= DataIn(31 downto 0);
              when others =>  null;
            end case;
          when "001" =>
            case (Address(5 downto 2)) is
              when "0000" =>  GTPTrgEn <= DataIn(31 downto 0);
              when "0001" =>  ExtTrgEn <= DataIn(31 downto 0);
 
              when "0010" =>  FPTrgEn <= DataIn(31 downto 0);
              when "0011" =>  FPOutput <= DataIn(15 downto 0);
              when "0100" =>  SyncDelay <= DataIn;
              when "0101" =>  GtpPreScaleA <= DataIn; 
              when "0110" =>  GtpPreScaleB <= DataIn;
              when "0111" =>  GtpPreScaleC <= DataIn;
              when "1000" =>  GtpPreScaleD <= DataIn;
              when "1001" =>  ExtPreScaleA <= DataIn;
              when "1010" =>  ExtPreScaleB <= DataIn;
              when "1011" =>  ExtPreScaleC <= DataIn;
                              LTTableLoad <= '1';
              when "1100" =>  ExtPreScaleD <= DataIn;
              when "1101" =>  VmeEvtType <= DataIn;
              when "1110" =>  SyncCode <= DataIn(7 downto 0);
                              SyncCodeEn <= '1';
              when "1111" =>  SyncGenDelay <= DataIn(7 downto 0);
              when others =>  null;
            end case;
          when "010" =>
            case (Address(5 downto 2)) is 
              when "0000" =>  SyncWidth <= DataIn(7 downto 0);
              when "0001" =>  TrigCommand <= DataIn(15 downto 0);
                              TrigCommandEn <= '1';
              when "0010" =>  RandomTrg <= DataIn(15 downto 0);
                              RandomTrgEn <= '1';
              when "0011" =>  SoftTrg1 <= DataIn;
                              SoftTrg1En <= '1';
              when "0100" =>  SoftTrg2 <= DataIn;
                              SoftTrg2En <= '1';
              when "0111" =>  RunCode <= DataIn(31 downto 0);
              when others =>  null;
            end case;
          when "011" => 
            case (Address(5 downto 2)) is 
              when "0101" =>  SyncEvtGen <= DataIn(31 downto 0);
              when "0110" =>  PromptTrgW <= DataIn(7 downto 0);
              when "1001" =>  RegE4Data(15 downto 0) <= DataIn(15 downto 0); -- out std_logic_vector(15 downto 0);
                              RegE4En   <= '1'; -- out std_logic;
              when "1011" =>  ROCEn(31 downto 0) <= DataIn(31 downto 0);

--            TDSyncRst(23 downto 0) <= DataIn(31 downto 8);  -- Bit(31:16): TD enable, Bit(15:8): SyncRst control
              when "1111" =>  EndOfRunBlk <= DataIn;
              when others =>  null;
            end case;
          when "100" =>
            if (Address(5 downto 2) = "0000" ) then
              VmeResetInt <= DataIn;
            elsif (Address(5 downto 2) = "0001" ) then
              Reg104D <= DataIn;
            elsif (Address(5 downto 2) = "0010" ) then
              Reg108D <= DataIn;
            elsif (Address(5 downto 2) = "0011" ) then
              Reg10cD <= DataIn;
            elsif (Address(5 downto 2) = "0100" ) then
              Reg110D <= DataIn;
            elsif (Address(5 downto 2) = "0101" ) then
              Reg114D <= DataIn;
            elsif (Address(5 downto 2) = "0110" ) then
              Reg118D <= DataIn;
            elsif (Address(5 downto 2) = "0111" ) then
              Reg11cD <= DataIn;
            elsif (Address(5 downto 2) = "1000" ) then
              Reg120D <= DataIn;
            elsif (Address(5 downto 2) = "1001" ) then
              Reg124D <= DataIn;
            elsif (Address(5 downto 2) = "1010" ) then
              Reg128D <= DataIn;
            elsif (Address(5 downto 2) = "1011" ) then
              Reg12cD <= DataIn;
            elsif (Address(5 downto 2) = "1100" ) then
              Reg130D <= DataIn;
            elsif (Address(5 downto 2) = "1110" ) then
              MinRuleWidth <= DataIn;
            end if;
          when "101" =>
            TrgTblAdr(3 downto 0) <= Address(5 downto 2);
            TrgTblData <= DataIn;
            TrgTblWEN <= '1';        
          when "111" =>
            if (Address(5 downto 2) = "0000" ) then
              I2CAddData <= DataIn;
            end if;
          when others =>  null;
        end case;
      else
        TrgTblWEN <= '0';
        CrateIDEn <= '0';
        TrgSrcSet <= '0';
        RandomTrgEn <= '0';
        SoftTrg1En <= '0';
        SoftTrg2En <= '0';
        SyncCodeEn <= '0';
        TrigCommandEn <= '0';
        ClkSrcSet <= '0';
        VmeResetInt <= (others => '0');
        LTTableLoad <= '0';
        VmeSetting(24) <= '0';
        ForceTrgSrcSet <= '0';
        RegE4En   <= '0'; -- out std_logic;
      end if; --the reset/enable
    end if; -- clock end
  end process; 

end Behavioral;

