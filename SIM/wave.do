# ==============================================================================
# WAVE.DO - QuestaSim / ModelSim Waveform Configuration
# Project: DATA_ALIGNER_IP
# Grouping Order: CLOCK & RESET -> APB INTERFACE -> MD RX -> MD TX -> DUT
# ==============================================================================

onerror {resume}
quietly WaveActivateNextPane {} 0

# ==============================================================================
# HIERARCHY INSTANCE PATHS (INSIDE TOP MODULE)
# ==============================================================================
set TOP_PATH    "/testbench"
set APB_PATH    "$TOP_PATH/apb_if"
set MD_RX_PATH  "$TOP_PATH/md_rx_if"
set MD_TX_PATH  "$TOP_PATH/md_tx_if"
set DUT_PATH    "$TOP_PATH/dut"

# ==============================================================================
# COLOR PALETTE
# ==============================================================================
set CLK_COLOR   "White"
set APB_COLOR   "Cyan"
set RX_COLOR    "Yellow"
set TX_COLOR    "Orange"
set DUT_COLOR   "Green"

# Enable recursive logging for all signals to allow post-run signal browsing
log -r /*

# ==============================================================================
# 1. CLOCK & RESET SIGNALS
# ==============================================================================
add wave -noupdate -divider -height 25 "CLOCK & RESET"
add wave -noupdate -group "Clocks & Resets" -color $CLK_COLOR           $TOP_PATH/clk
add wave -noupdate -group "Clocks & Resets" -color $CLK_COLOR           $APB_PATH/preset_n
add wave -noupdate -group "Clocks & Resets" -color $CLK_COLOR           $MD_RX_PATH/reset_n
add wave -noupdate -group "Clocks & Resets" -color $CLK_COLOR           $MD_TX_PATH/reset_n

# ==============================================================================
# 2. APB INTERFACE SIGNALS
# ==============================================================================
add wave -noupdate -divider -height 25 "APB INTERFACE SIGNALS"
add wave -noupdate -group "APB Interface" -color $APB_COLOR           $APB_PATH/pclk
add wave -noupdate -group "APB Interface" -color $APB_COLOR           $APB_PATH/preset_n
add wave -noupdate -group "APB Interface" -color $APB_COLOR           $APB_PATH/psel
add wave -noupdate -group "APB Interface" -color $APB_COLOR           $APB_PATH/penable
add wave -noupdate -group "APB Interface" -color $APB_COLOR           $APB_PATH/pwrite
add wave -noupdate -group "APB Interface" -color $APB_COLOR -radix hex $APB_PATH/paddr
add wave -noupdate -group "APB Interface" -color $APB_COLOR -radix hex $APB_PATH/pwdata
add wave -noupdate -group "APB Interface" -color $APB_COLOR -radix hex $APB_PATH/prdata
add wave -noupdate -group "APB Interface" -color $APB_COLOR           $APB_PATH/pready
add wave -noupdate -group "APB Interface" -color $APB_COLOR           $APB_PATH/pslverr

# ==============================================================================
# 3. CFS MD RX INTERFACE SIGNALS
# ==============================================================================
add wave -noupdate -divider -height 25 "CFS MD RX SIGNALS"
add wave -noupdate -group "MD RX Interface" -color $RX_COLOR           $MD_RX_PATH/clk
add wave -noupdate -group "MD RX Interface" -color $RX_COLOR           $MD_RX_PATH/reset_n
add wave -noupdate -group "MD RX Interface" -color $RX_COLOR           $MD_RX_PATH/valid
add wave -noupdate -group "MD RX Interface" -color $RX_COLOR           $MD_RX_PATH/ready
add wave -noupdate -group "MD RX Interface" -color $RX_COLOR -radix hex $MD_RX_PATH/data
add wave -noupdate -group "MD RX Interface" -color $RX_COLOR -radix hex $MD_RX_PATH/offset
add wave -noupdate -group "MD RX Interface" -color $RX_COLOR -radix hex $MD_RX_PATH/size
add wave -noupdate -group "MD RX Interface" -color $RX_COLOR           $MD_RX_PATH/err

# ==============================================================================
# 4. CFS MD TX INTERFACE SIGNALS
# ==============================================================================
add wave -noupdate -divider -height 25 "CFS MD TX SIGNALS"
add wave -noupdate -group "MD TX Interface" -color $TX_COLOR           $MD_TX_PATH/clk
add wave -noupdate -group "MD TX Interface" -color $TX_COLOR           $MD_TX_PATH/reset_n
add wave -noupdate -group "MD TX Interface" -color $TX_COLOR           $MD_TX_PATH/valid
add wave -noupdate -group "MD TX Interface" -color $TX_COLOR           $MD_TX_PATH/ready
add wave -noupdate -group "MD TX Interface" -color $TX_COLOR -radix hex $MD_TX_PATH/data
add wave -noupdate -group "MD TX Interface" -color $TX_COLOR -radix hex $MD_TX_PATH/offset
add wave -noupdate -group "MD TX Interface" -color $TX_COLOR -radix hex $MD_TX_PATH/size
add wave -noupdate -group "MD TX Interface" -color $TX_COLOR           $MD_TX_PATH/err

# ==============================================================================
# 5. DUT TOP & INTERNAL SIGNALS
# ==============================================================================
add wave -noupdate -divider -height 25 "DUT SIGNALS"
add wave -noupdate -group "DUT Top" -color $DUT_COLOR           $DUT_PATH/clk
add wave -noupdate -group "DUT Top" -color $DUT_COLOR           $DUT_PATH/reset_n
add wave -noupdate -group "DUT Top" -color $DUT_COLOR           $DUT_PATH/psel
add wave -noupdate -group "DUT Top" -color $DUT_COLOR           $DUT_PATH/penable
add wave -noupdate -group "DUT Top" -color $DUT_COLOR           $DUT_PATH/pwrite
add wave -noupdate -group "DUT Top" -color $DUT_COLOR -radix hex $DUT_PATH/paddr
add wave -noupdate -group "DUT Top" -color $DUT_COLOR -radix hex $DUT_PATH/pwdata
add wave -noupdate -group "DUT Top" -color $DUT_COLOR -radix hex $DUT_PATH/prdata
add wave -noupdate -group "DUT Top" -color $DUT_COLOR           $DUT_PATH/pready
add wave -noupdate -group "DUT Top" -color $DUT_COLOR           $DUT_PATH/pslverr
add wave -noupdate -group "DUT Top" -color $DUT_COLOR           $DUT_PATH/md_rx_valid
add wave -noupdate -group "DUT Top" -color $DUT_COLOR           $DUT_PATH/md_rx_ready
add wave -noupdate -group "DUT Top" -color $DUT_COLOR -radix hex $DUT_PATH/md_rx_data
add wave -noupdate -group "DUT Top" -color $DUT_COLOR -radix hex $DUT_PATH/md_rx_offset
add wave -noupdate -group "DUT Top" -color $DUT_COLOR -radix hex $DUT_PATH/md_rx_size
add wave -noupdate -group "DUT Top" -color $DUT_COLOR           $DUT_PATH/md_rx_err
add wave -noupdate -group "DUT Top" -color $DUT_COLOR           $DUT_PATH/md_tx_valid
add wave -noupdate -group "DUT Top" -color $DUT_COLOR           $DUT_PATH/md_tx_ready
add wave -noupdate -group "DUT Top" -color $DUT_COLOR -radix hex $DUT_PATH/md_tx_data
add wave -noupdate -group "DUT Top" -color $DUT_COLOR -radix hex $DUT_PATH/md_tx_offset
add wave -noupdate -group "DUT Top" -color $DUT_COLOR -radix hex $DUT_PATH/md_tx_size
add wave -noupdate -group "DUT Top" -color $DUT_COLOR           $DUT_PATH/md_tx_err
add wave -noupdate -group "DUT Top" -color $DUT_COLOR           $DUT_PATH/irq

add wave -noupdate -group "DUT Internal" -radix hex             $DUT_PATH/core/*

# ==============================================================================
# GUI FORMATTING & RUN CONTROL
# ==============================================================================
TreeUpdate [SetDefaultTree]
configure wave -namecolwidth 220        ;# Width of signal names column (pixels)
configure wave -valuecolwidth 100       ;# Width of signal values column (pixels)
configure wave -justifyvalue left       ;# Text justification inside value column
configure wave -signalnamewidth 1       ;# 1 = Show leaf name only, 0 = Full path
configure wave -timelineunits ns        ;# Time unit marker on wave grid

update
run -all
wave zoom full
