## Updating Moller Registers

1. Update register in AirHDL
1. Open up Vivado GUI (this allows it to notice the change immediately)
1. Update files in hdl/src/moller_regmap_1.0/src from AirHDL downloads (SystemVerilog package+module)
    - moller_regs_pkg.sv
    - moller_regs.sv
1. Update address width in Block Design if necessary (AXI address is in bytes, AirHDL displays byte length)
1. Inside Vivado, open Block Design in IP Package Editor and update
1. Update external pin assignments as required
1. Updates file in sw/linux/project-spec/meta-user/recipes-apps/moller/files/moller_regs.h from AirHDL download


## Setting Module ID in EEPROM

The first address (0x0) is the least significant byte (LSB). As less than 256 modules will be made, only that location will contain a number, the rest of the address bytes (1-7) should be written with zeroes so the deviceID is read out correctly.

```
> i2cset -y -f 0 0x51 0x0 <module id in decimal>
> i2cset -y -f 0 0x51 0x1 0
> i2cset -y -f 0 0x51 0x2 0
> i2cset -y -f 0 0x51 0x3 0
> i2cset -y -f 0 0x51 0x4 0
> i2cset -y -f 0 0x51 0x5 0
> i2cset -y -f 0 0x51 0x6 0
> i2cset -y -f 0 0x51 0x7 0
```


## Clock Cleaner

The clock cleaner is the LMK04816 Three Input Low-Noise Clock Jitter Cleaner With Dual Loop PLL

Input Oscillator:
- Crystek CVHD-950X-100, VCXO (100 MHz)

Input Clocks:
- IN0: LVDS Reference Clock (??62.5 MHz??)
- IN1: TI Reference Clock (250 MHz)
- IN2: Silicon Labs 511BBA125M000BAG, Oscillator (125 MHz)

Output Clocks:

- 250MHz clock to the TI interface (CLK_OUT11) and FPGA (CLK_OUT10)
- CLN_CLKB (CLK_OUT9) and CLN_CLKA (CLK_OUT8) sent to A and B ADC groups (likely 125MHz)
- CLK_REP (CLK_OUT7) and MGT_B228_REFCLK1 (CLK_OUT6), likely 156.25 MHz
- MGT_B229_REFCLK1 (CLK_OUT5) and MGT_B230_REFCLK0 (CLK_OUT4), likely 156.25 MHz
- CLN_CNVA (CLK_OUT3) and CLN_CNVB (CLK_OUT2), likely 15MHz
- SOM_IN_CLK0 and (CLK_OUT1) and SOM_IN_CLK1 (CLK_OUT0), should match CLN_CLKA/B
- CLNR_OSC clock at 100MHz

ClKin0 (62.5) - PLL1_R = 15
ClKin1 (250) - PLL1_R = 60
ClKin2 (125) - PLL1_R = 30

PLL1_N = 24

PLL1 PDF = 4166 +2/3 kHz (CP = 1.6mA)

PLL2_R = 1
PLL2_N_PRE = 5
PLL2_N = 5

VCO = 2500 MHz
PLL2 PDF = 10,000 kHZ (10 MHz)

DIV0_1 20 (125 MHz)
DIV2_3 200 (12.5 MHz)
DIV4_5 16 (156.25 MHz) (40 for 62.5 MHz)
DIV6_7 16 (156.25 MHz)
DIV8_9 20 (125 Mhz)
DIV10_11 10 (250 MHz)

SYNC (Sync pin)
Status_Holdover (switch to READBACK?)
Status_LD (use for lockdetect PLL1+PLL2) -> forward to LED for status
Status_CLKin0 (clock select pin)
Status_CLKin1 (clock select pin)