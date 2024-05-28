export DESIGN_NAME = poly1305
export PLATFORM    = sky130hd

export VERILOG_FILES = ./vodice24-asic-opt/poly1305_ws/rtl/processblock.v \
			./vodice24-asic-opt/poly1305_ws/rtl/poly1305.v

export SDC_FILE      = ./vodice24-asic-opt/poly1305_ws/work/constraint.sdc

export DIE_AREA    =   0   0   800   800
export CORE_AREA   =   5   5   795   795
