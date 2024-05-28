export DESIGN_NAME = poly1305
export PLATFORM    = sky130hd

export VERILOG_FILES = ./vodice24-asic-opt/poly1305_ws_w32/rtl/processblock.v \
			./vodice24-asic-opt/poly1305_ws_w32/rtl/poly1305.v

export SDC_FILE      = ./vodice24-asic-opt/poly1305_ws_w32/work/constraint.sdc

export DIE_AREA    =   0   0   500   500
export CORE_AREA   =   5   5   495   495
