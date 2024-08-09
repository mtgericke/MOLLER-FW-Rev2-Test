- block
    - sum
    - sum of squares
    - min
    - max
    - count?

- option number of blocks
- number samples per block
- 30Hz to 1920hz operational
- maximum

- trigger, with a delay

- 'streaming' mode
    - indication in integration window
    - indication in a block (even/odd)


if number of blocks * samples > integration start interval, then count a dropped trigger counter

- while integration, have a busy bit


- output TCSOUT(13)=SyncReset, GENOUT(2): TI_Trigger_out


- add to document: how timestamps work (and get reset), how ADC convert works (based off 250Mhz clock)


