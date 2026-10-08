# ==============================================================================
# KRISHNA.P / UVM TESTBENCH MAKEFILE
# Project: DATA_ALIGNER_IP
# Target: QuestaSim / ModelSim 3-Step Flow (vlog -> vopt -> vsim)
# Standard: UVM 1.1d Compliant
# ==============================================================================

# 1. RTL File (add more with backslash continuation if needed)
RTL          ?= ../RTL/design.sv

# 2. Testbench Files in Compilation Order
#    - uvm_ext_pkg   first  (uvm_ext_pkg)
#    - cfs_apb_pkg   second (interface + APB agent classes)
#    - cfs_md_pkg    third  (interface + MD agent classes)
#    - cfs_algn_pkg  fourth (env; depends on agent pkgs)
#    - test_pkg      fifth  (tests; depends on cfs_algn_pkg)
#    - testbench.sv  last   (top module; calls run_test())
TB           ?= ../ENV/UVM_EXT_AGENT/uvm_ext_pkg.sv   \
                ../ENV/APB_AGENT/cfs_apb_pkg.sv       \
                ../ENV/CFS_MD_AGENT/cfs_md_pkg.sv     \
                ../ENV/REG_FILES/cfs_algn_reg_pkg.sv  \
                ../ENV/cfs_algn_pkg.sv                \
                ../TEST/cfs_algn_test_pkg.sv          \
                ../TOP/testbench.sv

# 3. Include Directories (auto-converted to +incdir+ flags)
INCDIRS      ?= ../RTL ../ENV/UVM_EXT_AGENT/ ../ENV/APB_AGENT ../ENV/CFS_MD_AGENT ../ENV/REG_FILES ../ENV ../TEST ../TOP

# 4. Testbench Top Module & vopt Elaboration Names
TB_TOP       ?= testbench
OPT_TOP      ?= $(TB_TOP)_opt
DESIGN_BIN   ?= design.bin

# 5. UVM 1.1d Library Specification in QuestaSim
#    mtiUvm binds explicitly to Questa's precompiled UVM 1.1d package.
UVM_LIB      ?= mtiUvm

# 6. Default Individual Test Name & Seed
TEST         ?= cfs_algn_test_random
SEED         ?= 100

# 7. Comprehensive Regression Test Suite (All 3 tests)
REGRESS_LIST ?= cfs_algn_test_base       \
                cfs_algn_test_reg_access  \
                cfs_algn_test_random

# 8. UVM 1.1d Runtime Controls (overridable on the command line)
#    Examples:
#      make sim TEST=cfs_algn_test_base
#      make sim +UVM_TESTNAME=cfs_algn_test_reg_access
#      make sim +UVM_VERBOSITY=UVM_NONE
#      make sim +UVM_TIMEOUT=10000000
#      make sim +UVM_MAX_QUIT_COUNT=5
#      make sim +SEED=200 +my_custom_flag=1

# Check if +UVM_TESTNAME or UVM_TESTNAME was passed (via Make variable or MAKECMDGOALS)
ifneq ($(origin +UVM_TESTNAME),undefined)
  TEST := $(+UVM_TESTNAME)
else ifdef UVM_TESTNAME
  TEST := $(UVM_TESTNAME)
else
  PLUS_TEST := $(patsubst +UVM_TESTNAME=%,%,$(filter +UVM_TESTNAME=%, $(MAKECMDGOALS)))
  ifneq ($(PLUS_TEST),)
    TEST := $(PLUS_TEST)
  endif
endif

# Check if +UVM_VERBOSITY or UVM_VERBOSITY was passed (via Make variable or MAKECMDGOALS)
ifneq ($(origin +UVM_VERBOSITY),undefined)
  VERBOSITY := $(+UVM_VERBOSITY)
else ifdef UVM_VERBOSITY
  VERBOSITY := $(UVM_VERBOSITY)
else
  PLUS_VERB := $(patsubst +UVM_VERBOSITY=%,%,$(filter +UVM_VERBOSITY=%, $(MAKECMDGOALS)))
  ifneq ($(PLUS_VERB),)
    VERBOSITY := $(PLUS_VERB)
  endif
endif

# Check if +UVM_TIMEOUT was passed (via Make variable or MAKECMDGOALS)
ifneq ($(origin +UVM_TIMEOUT),undefined)
  UVM_TIMEOUT := $(+UVM_TIMEOUT)
else
  PLUS_TIMEOUT := $(patsubst +UVM_TIMEOUT=%,%,$(filter +UVM_TIMEOUT=%, $(MAKECMDGOALS)))
  ifneq ($(PLUS_TIMEOUT),)
    UVM_TIMEOUT := $(PLUS_TIMEOUT)
  endif
endif

# Check if +UVM_MAX_QUIT_COUNT was passed (via Make variable or MAKECMDGOALS)
ifneq ($(origin +UVM_MAX_QUIT_COUNT),undefined)
  UVM_MAX_QUIT := $(+UVM_MAX_QUIT_COUNT)
else
  PLUS_QUIT := $(patsubst +UVM_MAX_QUIT_COUNT=%,%,$(filter +UVM_MAX_QUIT_COUNT=%, $(MAKECMDGOALS)))
  ifneq ($(PLUS_QUIT),)
    UVM_MAX_QUIT := $(PLUS_QUIT)
  endif
endif

# Check if +SEED was passed (via Make variable)
ifneq ($(origin +SEED),undefined)
  SEED := $(+SEED)
endif

VERBOSITY    ?= UVM_MEDIUM
# Note: With timescale 1ns/1ps, UVM evaluates integer timeout in simulator precision units (1ps).
# 1000000000 ps = 1 ms = 100,000 clock cycles (sufficient for long test sequences).
UVM_TIMEOUT  ?= 1000000000
UVM_MAX_QUIT ?= 10

# Capture any additional arbitrary plusargs passed directly on the command line
# Handled from MAKEOVERRIDES (args with =) and MAKECMDGOALS (args without =)
CMD_PLUS_VARS  := $(filter-out +UVM_TESTNAME=% +UVM_VERBOSITY=% +UVM_TIMEOUT=% +UVM_MAX_QUIT_COUNT=% +SEED=%, $(filter +%, $(MAKEOVERRIDES)))
CMD_PLUS_GOALS := $(filter-out +UVM_TESTNAME% +UVM_VERBOSITY% +UVM_TIMEOUT% +UVM_MAX_QUIT_COUNT% +SEED%, $(filter +%, $(MAKECMDGOALS)))
EXTRA_ARGS     ?= $(CMD_PLUS_VARS) $(CMD_PLUS_GOALS)

# 9. Environment & Tool Configuration
BROWSER      ?= firefox
WORK_DIR     ?= work
LOG_DIR      ?= logs
MERGED_UCDB  ?= merged.ucdb
COV_DIR      ?= covhtmlreport

# ==============================================================================
# COMPILER, OPTIMIZER & SIMULATOR FLAGS (UVM 1.1d)
# ==============================================================================
INC_FLAGS  = $(addprefix +incdir+, $(INCDIRS))

# vlog: SystemVerilog compile with explicit timescale, full visibility & coverage instrumentation
VLOG_FLAGS = -sv -work $(WORK_DIR) -timescale 1ns/1ps +acc -coveropt 3 +cover $(INC_FLAGS)

# vopt: Static elaboration with explicit UVM 1.1d binding & coverage (fast, no Visualizer DB overhead)
VOPT_FLAGS     ?= -L $(UVM_LIB) +acc -coveropt 3 $(TB_TOP) -o $(OPT_TOP)

# vopt: Static elaboration with Visualizer design database generation
VOPT_VIS_FLAGS ?= -L $(UVM_LIB) +acc -coveropt 3 -designfile $(DESIGN_BIN) $(TB_TOP) -o $(OPT_TOP)

# vsim base flags: UVM 1.1d binding + assertions + coverage + random seed
VSIM_FLAGS = -L $(UVM_LIB) -assertdebug -coverage -sv_seed $(SEED)

# UVM 1.1d plusargs:
#   -uvmcontrol=none    -> Disable Questa automated UVM transaction tracing overhead
#   +UVM_NO_RELNOTES    -> Suppresses the verbose UVM 1.1d release notes header in logs
#   +UVM_VERBOSITY      -> Global verbosity threshold (UVM_LOW, UVM_MEDIUM, UVM_HIGH, etc.)
#   +UVM_TIMEOUT        -> Simulation timeout in ns with override flag (,YES)
#   +UVM_MAX_QUIT_COUNT -> Max UVM_ERROR count before abort with override flag (,YES)
#   $(EXTRA_ARGS)       -> Pass arbitrary additional plusargs from the command line
UVM_FLAGS  = -uvmcontrol=none \
             +UVM_NO_RELNOTES \
             +UVM_VERBOSITY=$(VERBOSITY) \
             +UVM_TIMEOUT=$(UVM_TIMEOUT),YES \
             +UVM_MAX_QUIT_COUNT=$(UVM_MAX_QUIT),YES \
             $(EXTRA_ARGS)

# ==============================================================================
# PHONY TARGETS DECLARATION
# ==============================================================================
.PHONY: all comp comp_vis sim sim_vis gui vis_live vis regress regress_gui regress_vis \
        merge cov report del help

.DEFAULT_GOAL := help

# Catch-all pattern rule for plusargs passed directly on command line (e.g. +UVM_VERBOSITY=..., +UVM_PHASE_TRACE)
+%:
	@:

all: comp sim

# ==============================================================================
# TARGETS & COMMANDS
# ==============================================================================

## Create working library if it does not already exist
$(WORK_DIR):
	vlib $(WORK_DIR)
	vmap work $(WORK_DIR)

## Create logs directory if it does not already exist
$(LOG_DIR):
	mkdir -p $(LOG_DIR)

## =============================================================================
## 1. Standard Compilation & Static Elaboration (Fast / Non-Visualizer)
## =============================================================================
comp: $(WORK_DIR) $(LOG_DIR)
	@echo "//================== Standard Compilation & Elaboration =====================//"
	vlog $(VLOG_FLAGS) -l $(LOG_DIR)/compile.log $(RTL) $(TB)
	vopt $(VOPT_FLAGS) -l $(LOG_DIR)/elaborate.log
	@echo "//================= Standard Compilation Complete ============================//"

## =============================================================================
## 1b. Dedicated Visualizer Compilation & Static Elaboration
## =============================================================================
comp_vis: $(WORK_DIR) $(LOG_DIR)
	@echo "//================ Visualizer Compilation & Elaboration ======================//"
	vlog $(VLOG_FLAGS) -l $(LOG_DIR)/compile.log $(RTL) $(TB)
	vopt $(VOPT_VIS_FLAGS) -l $(LOG_DIR)/elaborate_vis.log
	@echo "//================ Visualizer Compilation Complete ===========================//"

## =============================================================================
## 2. Single Simulation - Batch Mode (Standalone)
##    Usage: make sim TEST=cfs_algn_test_base VERBOSITY=UVM_HIGH
## =============================================================================
sim:
	@if [ ! -d "$(WORK_DIR)" ]; then \
		echo "Error: $(WORK_DIR) not found. Run 'make comp' first."; \
		exit 1; \
	fi
	@echo "//==================== Simulation Starts: $(TEST) [$(VERBOSITY)] =====================//"
	vsim $(VSIM_FLAGS) $(UVM_FLAGS) $(OPT_TOP) \
		-l $(LOG_DIR)/sim_$(TEST).log \
		-c -do "coverage save -onexit -directive -cvg -codeall $(TEST).ucdb; run -all; exit" \
		+UVM_TESTNAME=$(TEST)
	@echo "//==================== Simulation Ended: $(TEST) =========================//"
	@echo "Log file:    $(LOG_DIR)/sim_$(TEST).log"
	@echo "UCDB file:   $(TEST).ucdb"

## =============================================================================
## 2b. Visualizer Batch Simulation (Generates qwave.db for 'make vis')
##    Usage: make sim_vis TEST=cfs_algn_test_base
## =============================================================================
sim_vis:
	@if [ ! -f "$(DESIGN_BIN)" ]; then \
		echo "Error: $(DESIGN_BIN) not found. Run 'make comp_vis' first."; \
		exit 1; \
	fi
	@echo "//==================== Visualizer Sim Starts: $(TEST) =====================//"
	vsim $(VSIM_FLAGS) $(UVM_FLAGS) $(OPT_TOP) \
		-qwavedb=+assertion+signal+wavefile=$(TEST).qwave.db \
		-l $(LOG_DIR)/sim_vis_$(TEST).log \
		-c -do "coverage save -onexit -directive -cvg -codeall $(TEST).ucdb; run -all; exit" \
		+UVM_TESTNAME=$(TEST)
	@echo "//==================== Visualizer Sim Ended: $(TEST) =======================//"
	@echo "Log file:    $(LOG_DIR)/sim_vis_$(TEST).log"
	@echo "UCDB file:   $(TEST).ucdb"
	@echo "QWAVE DB:    $(TEST).qwave.db -- Run 'make vis TEST=$(TEST)' to view."

## =============================================================================
## 3. Single Simulation - Classic Questa GUI with Auto-Loaded Waves
##    Usage: make gui TEST=cfs_algn_test_base
## =============================================================================
gui:
	@if [ ! -d "$(WORK_DIR)" ]; then \
		echo "Error: $(WORK_DIR) not found. Run 'make comp' first."; \
		exit 1; \
	fi
	@if [ ! -f "wave.do" ] && [ -f "../wave.do" ]; then \
		cp ../wave.do wave.do; \
	fi
	@echo "//==================== GUI Simulation Starts: $(TEST) =====================//"
	vsim -gui $(VSIM_FLAGS) $(UVM_FLAGS) $(OPT_TOP) \
		-do wave.do \
		-l $(LOG_DIR)/sim_gui_$(TEST).log \
		+UVM_TESTNAME=$(TEST) &

## =============================================================================
## 4. Interactive Visualizer Live Simulation
##    Usage: make vis_live TEST=cfs_algn_test_base
## =============================================================================
vis_live: comp_vis
	@echo "//==================== Visualizer Live Starts: $(TEST) =====================//"
	vsim -visualizer $(VSIM_FLAGS) $(UVM_FLAGS) $(OPT_TOP) \
		-qwavedb=+assertion+signal+wavefile=$(TEST).qwave.db \
		-l $(LOG_DIR)/sim_vis_$(TEST).log \
		+UVM_TESTNAME=$(TEST) &

## =============================================================================
## 5. Post-Simulation Visualizer Waveform Viewer
##    Usage: make vis TEST=cfs_algn_test_base
## =============================================================================
vis:
	@if [ ! -e "$(TEST).qwave.db" ]; then \
		echo "Error: $(TEST).qwave.db not found. Run 'make sim_vis TEST=$(TEST)' first."; \
		exit 1; \
	fi
	@if [ ! -f "$(DESIGN_BIN)" ]; then \
		echo "Error: $(DESIGN_BIN) not found. Run 'make comp_vis' first."; \
		exit 1; \
	fi
	@echo "//================ Opening Visualizer: $(TEST).qwave.db =================//"
	visualizer -designfile $(DESIGN_BIN) $(TEST).qwave.db &

## =============================================================================
## 6. Streamlined Regression Suite (Sequential execution of all tests)
##    Usage: make regress [VERBOSITY=UVM_LOW]
## =============================================================================
regress: comp
	@echo "//==================== Regression Starts =====================//"
	@rm -f *.ucdb $(MERGED_UCDB)
	@set -e; for t in $(REGRESS_LIST); do \
		echo "--> Running Test: $$t  [Verbosity: $(VERBOSITY)]"; \
		vsim $(VSIM_FLAGS) $(UVM_FLAGS) $(OPT_TOP) \
			-qwavedb=+assertion+signal+wavefile=$$t.qwave.db \
			-l $(LOG_DIR)/sim_$$t.log -c \
			-do "coverage save -onexit -directive -cvg -codeall $$t.ucdb; run -all; exit" \
			+UVM_TESTNAME=$$t; \
	done
	@echo "//==================== Regression Ended ======================//"
	@echo "Regression finished successfully. Run 'make report' to merge UCDBs and generate reports."

## =============================================================================
## 7. Coverage Operations
## =============================================================================
## Merge coverage files
merge:
	@echo "//================ Merging Coverage Files =================//"
	vcover merge $(MERGED_UCDB) *.ucdb

## Generate HTML & Text coverage reports
cov: merge
	@echo "//================ Generating Coverage Reports =================//"
	vcover report -details -html -htmldir $(COV_DIR) $(MERGED_UCDB)
	vcover report -output my_coverage_log.txt -details $(MERGED_UCDB)
	@echo "Coverage reports: HTML -> '$(COV_DIR)/index.html'  Text -> 'my_coverage_log.txt'"

## Single consolidated coverage target (Merge + Reports + Browser)
report: merge
	@echo "//================ Generating Coverage Reports =================//"
	vcover report -details -html -htmldir $(COV_DIR) $(MERGED_UCDB)
	vcover report -output my_coverage_log.txt -details $(MERGED_UCDB)
	@echo "Coverage reports: HTML -> '$(COV_DIR)/index.html'  Text -> 'my_coverage_log.txt'"
	@echo "//================ Opening Coverage Report =================//"
	$(BROWSER) $(COV_DIR)/index.html &

## Open merged UCDB in Questa Classic GUI
regress_gui:
	@if [ ! -f "$(MERGED_UCDB)" ]; then \
		echo "$(MERGED_UCDB) not found -> merging *.ucdb first..."; \
		vcover merge $(MERGED_UCDB) *.ucdb; \
	fi
	@echo "//================ Opening Coverage in Questa GUI =================//"
	vsim -gui -viewcov $(MERGED_UCDB) &

## Open merged UCDB in Siemens Visualizer
regress_vis:
	@if [ ! -f "$(MERGED_UCDB)" ]; then \
		echo "$(MERGED_UCDB) not found -> merging *.ucdb first..."; \
		vcover merge $(MERGED_UCDB) *.ucdb; \
	fi
	@echo "//================ Opening Coverage in Visualizer =================//"
	visualizer -viewcov $(MERGED_UCDB) &

## =============================================================================
## 8. Cleanup (Preserves wave.do)
## =============================================================================
del:
	@echo "//================ Cleaning Project Directory =================//"
	rm -rf $(WORK_DIR) qrun.out/ vsim.wlf qrun.log *.ucdb $(MERGED_UCDB) $(COV_DIR) \
	       transcript $(LOG_DIR)/*.log my_coverage_log.txt *.wlf *.qwave.db \
	       visualizer.log $(DESIGN_BIN) certe_dump.xml s.log
	@echo "Cleanup complete."

## =============================================================================
## 9. Quick Command Reference
## =============================================================================
help:
	@echo ""
	@echo "+-----------------------------------------------------------------------------+"
	@echo "|                 DATA_ALIGNER_IP -- UVM Simulation Makefile                  |"
	@echo "+==================+==========================================================+"
	@echo "|  make comp       | Standard compile RTL+TB and elaborate with vopt (fast)   |"
	@echo "|  make comp_vis   | Compile and elaborate with Visualizer DB (design.bin)    |"
	@echo "|  make sim        | Standalone batch sim (no recompile) TEST=<name>          |"
	@echo "|  make sim_vis    | Batch sim with Visualizer waveform dump (qwave.db)       |"
	@echo "|  make gui        | Questa Classic GUI sim with wave.do                      |"
	@echo "|  make vis_live   | Visualizer interactive live sim                          |"
	@echo "|  make vis        | Open post-sim waveform in Visualizer                     |"
	@echo "|  make regress    | Run regression suite (all 3 tests)                       |"
	@echo "|  make merge      | Merge all *.ucdb files into $(MERGED_UCDB)                  |"
	@echo "|  make cov        | Generate HTML + Text coverage reports                    |"
	@echo "|  make report     | Merge UCDBs, generate HTML/Text reports & open in browser|"
	@echo "|  make regress_gui| View merged coverage in Questa Classic GUI               |"
	@echo "|  make regress_vis| View merged coverage in Siemens Visualizer               |"
	@echo "|  make del        | Remove all generated build artifacts (preserves wave.do) |"
	@echo "+==================+==========================================================+"
	@echo "|  UVM 1.1d Controls (all overridable on command line):                       |"
	@echo "|    TEST         default=cfs_algn_test_random                                |"
	@echo "|    SEED         default=100         [random or numeric seed]                |"
	@echo "|    VERBOSITY    default=UVM_MEDIUM  [UVM_NONE|LOW|MEDIUM|HIGH|FULL|DEBUG]   |"
	@echo "|    UVM_TIMEOUT  default=1000000000  [sim timeout in 1ps precision units]    |"
	@echo "|    UVM_MAX_QUIT default=10          [UVM_ERRORs before abort]               |"
	@echo "+-----------------------------------------------------------------------------+"
	@echo ""
