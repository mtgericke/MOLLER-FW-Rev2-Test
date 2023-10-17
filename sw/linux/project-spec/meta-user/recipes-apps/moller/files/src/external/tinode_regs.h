#ifndef TINODE_REGS_H
#define TINODE_REGS_H

#ifdef __cplusplus
extern "C" {
#endif

/* Revision number of the 'tinode' register map */
#define TINODE_REVISION 1

/* Default base address of the 'tinode' register map */
#define TINODE_DEFAULT_BASEADDR 0x80010000

/* Size of the 'tinode' register map, in bytes */
#define TINODE_RANGE_BYTES (2 << 13)

#define TINODE_REG_CRATE_ID 0x00
#define TINODE_REG_CRATE_ID_MASK 0x000000FF

#define TINODE_REG_FIBER_EN 0x01
#define TINODE_REG_FIBER_EN_MASK                    0x000000FF
#define TINODE_REG_FIBER_EN_TRIG_SYNC_OUT_EN_MASK   0x00000100

#define TINODE_REG_INTERRUPT 0x02
#define TINODE_REG_INTERRUPT_ID_MASK 0x000000FF
#define TINODE_REG_INTERRUPT_LEVEL_MASK 0x00000700
#define TINODE_REG_INTERRUPT_EN_MASK 0x00010000

#define TINODE_REG_TRIG_DELAY_WIDTH     0x03

#define TINODE_REG_VME_ADDRESS          0x04

#define TINODE_REG_BLOCK_SIZE           0x05
#define TINODE_REG_BLOCK_SIZE_MASK      0x000000FF

#define TINODE_REG_TI_DATA_FORMAT       0x06
#define TINODE_REG_VME_SETTING          0x07
//#define TINODE_REG_I2C_ADD              0x07

#define TINODE_REG_TRIG_SRC_EN          0x08
#define TINODE_REG_SYNC_SRC_EN          0x09
#define TINODE_REG_BUSY_SRC_EN          0x0A
#define TINODE_REG_CLOCK_SRC            0x0B
#define TINODE_REG_TRIG_PRESCALE        0x0C
#define TINODE_REG_BLOCK_TH             0x0D
#define TINODE_REG_TRIG_RULE            0x0E
#define TINODE_REG_TRIG_WINDOW          0x0F

#define TINODE_REG_GTP_TRG_EN           0x10
#define TINODE_REG_EXT_TRG_EN           0x11
#define TINODE_REG_FP_TRG_EN            0x12
#define TINODE_REG_FP_OUTPUT            0x13
#define TINODE_REG_SYNC_DELAY           0x14

#define TINODE_REG_GTP_PRESCALE_A       0x15
#define TINODE_REG_GTP_PRESCALE_B       0x16
#define TINODE_REG_GTP_PRESCALE_C       0x17
#define TINODE_REG_GTP_PRESCALE_D       0x18

#define TINODE_REG_EXT_PRESCALE_A       0x19
#define TINODE_REG_EXT_PRESCALE_B       0x1A
#define TINODE_REG_EXT_PRESCALE_C       0x1B
#define TINODE_REG_EXT_PRESCALE_D       0x1C

#define TINODE_REG_VME_EVT_TYPE         0x1D
#define TINODE_REG_SYNC_CODE            0x1E
#define TINODE_REG_SYNC_GEN_DELAY       0x1F

#define TINODE_REG_SYNC_WIDTH           0x20
#define TINODE_REG_TRIG_CMD             0x21
#define TINODE_REG_RANDOM_TRG           0x22
#define TINODE_REG_SOFT_TRG1            0x23
#define TINODE_REG_SOFT_TRG2            0x24
#define TINODE_REG_RUN_CODE             0x25

#define TINODE_REG_SYNC_EVT_GEN         0x35
#define TINODE_REG_PROMPT_TRG_W         0x36
#define TINODE_REG_E4_DATA              0x39
#define TINODE_REG_ROC_EN               0x3C
#define TINODE_REG_END_OF_RUN_BLK       0x3F


#define TINODE_REG_VME_RESET_INT        0x40
#define TINODE_REG_104D                 0x41
#define TINODE_REG_108D                 0x42
#define TINODE_REG_10CD                 0x43
#define TINODE_REG_110D                 0x44
#define TINODE_REG_114D                 0x45
#define TINODE_REG_118D                 0x46
#define TINODE_REG_11CD                 0x47
#define TINODE_REG_120D                 0x48
#define TINODE_REG_124D                 0x49
#define TINODE_REG_128D                 0x4A
#define TINODE_REG_12CD                 0x4B
#define TINODE_REG_130D                 0x4C

#define TINODE_REG_MIN_RULE_WIDTH       0x4E

#define TINODE_REG_TRG_TBL_ADDR         0x50 // lower 4 bits here indicate table address to load

#define TINODE_REG_I2C_ADD_DATA         0x60



#define TINODE_REG_READ_ID              0x00
#define TINODE_REG_READ_FIBER           0x01
#define TINODE_REG_READ_INTERRUPT       0x02
#define TINODE_REG_READ_TRIG_DELAY_WIDTH 0x03
#define TINODE_REG_READ_VME_ADDR        0x04

#ifdef __cplusplus
}
#endif

#endif  /* TINODE_REGS_H */