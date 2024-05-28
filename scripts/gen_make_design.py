import sys,os,csv

# first test vector index to use in stimuli file; normally 0
if 'FOLDER' in os.environ:
    FOLDER      = os.environ['FOLDER']
else:
    sys.exit("Missing FOLDER definition in Makefile")

if 'TB' in os.environ:
    TB          = os.environ['TB']
else:
    sys.exit("Missing TB definition in Makefile")
    
if 'TBEXTRA' in os.environ:
    TBEXTRA          = os.environ['TBEXTRA']
else:
    TBEXTRA          = ''
    
if 'TOP' in os.environ:
    TOP         = os.environ['TOP']
else:
    sys.exit("Missing TOP definition in Makefile")

if 'CHIPTOP' in os.environ:
    CHIPTOP     = os.environ['CHIPTOP']
else:
    sys.exit("Missing CHIPTOP definition in Makefile")

if 'LIB' in os.environ:
    LIB         = os.environ['LIB']
else:
    sys.exit("Missing LIB definition in Makefile")

if 'CELLS' in os.environ:
    CELLS       = os.environ['CELLS']
else:
    sys.exit("Missing CELLS definition in Makefile")

CLOCK       = os.environ['CLOCK']
if 'CLOCKNAME' in os.environ:
    CLOCKNAME   = os.environ['CLOCKNAME']
    clocknetpresent = 1
else:
    clocknetpresent = 0

if 'INPUTDELAY' in os.environ:
    INPUTDELAY  = os.environ['INPUTDELAY']
else:
    sys.exit("Missing INPUTDELAY definition in Makefile")

if 'OUTPUTDELAY' in os.environ:
    OUTPUTDELAY = os.environ['OUTPUTDELAY']
else:
    sys.exit("Missing OUTPUTDELAY definition in Makefile")

if 'ABC' in os.environ:
    ABC         = os.environ['ABC']
    abcpresent  = 1
else:
    abcpresent  = 0

if 'CHIPCONFIG' in os.environ:
    CHIPCONFIG  = os.environ['CHIPCONFIG']
else:
    sys.exit("Missing CHIPCONFIG definition in Makefile")
    
def create_makefile():
    makefile_name = FOLDER + '/work/makefile';
    with open(makefile_name, 'w') as makefile:
        makefile.write('SHELL := /bin/bash\n')
        makefile.write('\n')
        
        makefile.write('all: \n')
        makefile.write('\techo \"Targets are: rtlsim, synthesis, glschematic, gltiming, glsim, clean\"\n')
        makefile.write('\n')

        makefile.write('rtlsim:\n')
        makefile.write('\tiverilog -y ../rtl ../sim/' + TB + '\n')
        makefile.write('\t./a.out && mv trace.vcd rtl.vcd && rm -f a.out\n')
        makefile.write('\n')

        makefile.write('netlist.v: synth.ys\n')
        makefile.write('\tyosys -s synth.ys\n');
        makefile.write('\n')

        makefile.write('synthesis: netlist.v\n')
        makefile.write('\n')

        makefile.write('netlist.json: synthesis\n')
        makefile.write('\n')

        makefile.write('glschematic: netlist.svg\n')
        makefile.write('\n')
        

        makefile.write('netlist.svg: netlist.json\n')
        makefile.write('\tnetlistsvg netlist.json -o netlist.svg\n')
        makefile.write('\n')

        makefile.write('gltiming: netlist.v\n')
        makefile.write('\tsta <sta.cmd\n')
        makefile.write('\n')

        makefile.write('lib.cmd:\n')
        makefile.write('\tfind ' + CELLS + ' -name \'*_0.v\'    >lib.cmd\n')
        makefile.write('\tfind ' + CELLS + ' -name \'*_1.v\'   >>lib.cmd\n')
        makefile.write('\tfind ' + CELLS + ' -name \'*_2.v\'   >>lib.cmd\n')
        makefile.write('\tfind ' + CELLS + ' -name \'*_4.v\'   >>lib.cmd\n')
        makefile.write('\tfind ' + CELLS + ' -name \'*_6.v\'   >>lib.cmd\n')
        makefile.write('\tfind ' + CELLS + ' -name \'*_8.v\'   >>lib.cmd\n')
        makefile.write('\tfind ' + CELLS + ' -name \'*_12.v\'  >>lib.cmd\n')
        makefile.write('\tfind ' + CELLS + ' -name \'*_16.v\'  >>lib.cmd\n')
        makefile.write('\tls ' + CELLS + ' | awk \'{print \"+incdir+' + CELLS + '/\" $$0;}\' >>lib.cmd\n')
        makefile.write('\tgrep -v bleeder lib.cmd >tmp000 && mv tmp000 lib.cmd\n')
        makefile.write('\n')

        makefile.write('glsim: lib.cmd netlist.v\n')
        makefile.write('\tiverilog -DFUNCTIONAL -c lib.cmd netlist.v ' + TBEXTRA + ' ../sim/' + TB + '\n')
        makefile.write('\t./a.out && mv trace.vcd netlist.vcd && rm -f a.out\n')
        makefile.write('\n')

        makefile.write('openroad: \n')
        makefile.write('\txhost +; docker run --rm -it \\\n')
        makefile.write('\t--network=host \\\n')
        makefile.write('\t--env DISPLAY=${DISPLAY} \\\n')
        makefile.write('\t-v /tmp/.X11-unix:/tmp/.X11-unix \\\n')
        makefile.write('\t--privileged \\\n')
        makefile.write('\t--workdir=/OpenROAD-flow-scripts/flow/vodice24-asic-opt \\\n')
        makefile.write('\t-v ${HOME}/.Xauthority:/root/.Xauthority:rw \\\n')
        makefile.write('\t-v /usr/share/X11/xkb:/usr/share/X11/xkb \\\n')
        makefile.write('\t-v ${HOME}/vodice24-asic-opt:/OpenROAD-flow-scripts/flow/vodice24-asic-opt \\\n')
        makefile.write('\tcrypto-asic-opt bash --rcfile ./scripts/ps1.prompt\n')
        makefile.write('\n')


        makefile.write('chip: \n')
        makefile.write('\t(source ../../../../env.sh && cd ../../.. && make DESIGN_CONFIG=vodice24-asic-opt/' + FOLDER + '/chip/' + CHIPCONFIG + ')\n')
        makefile.write('\n')

        makefile.write('chipgui: chip\n')
        makefile.write('\t(source ../../../../env.sh && cd ../../.. && make DESIGN_CONFIG=vodice24-asic-opt/' + FOLDER + '/chip/' + CHIPCONFIG + ' gui_final)\n')
        makefile.write('\n')

        makefile.write('chipdata: chip\n')
        makefile.write('\t(cp -r ../../../logs/sky130hd/' + CHIPTOP + ' logs && cp -r ../../../results/sky130hd/' + CHIPTOP + ' results && cp -r ../../../reports/sky130hd/' + CHIPTOP + ' reports) \n')
        makefile.write('\n')

        makefile.write('chipclean: \n')
        makefile.write('\t(source ../../../../env.sh && cd ../../.. && make DESIGN_CONFIG=vodice24-asic-opt/' + FOLDER + '/chip/' + CHIPCONFIG + ' clean_all)\n')
        makefile.write('\n')

def create_synthys():
    yosys_name = FOLDER + '/work/synth.ys'
    with open(yosys_name, 'w') as yosys:
        yosys.write('read_liberty -lib ' + LIB + '\n')
        dir = FOLDER + '/rtl'
        vfiles = [f for f in os.listdir(dir) if os.path.isfile(os.path.join(dir, f)) and f.endswith('.v')]
        rtl_vfiles = ['../rtl/' + s for s in vfiles]
        rtl = " ".join(rtl_vfiles)
        yosys.write('read_verilog ' + rtl + '\n')
        yosys.write('\n')
        yosys.write('synth -top ' + TOP + '\n')
        yosys.write('\n')
        yosys.write('flatten \n')
        yosys.write('\n')
        yosys.write('opt -purge\n')
        yosys.write('\n')
        yosys.write('dfflibmap -liberty ' + LIB + '\n')
        if (abcpresent == 1):
            yosys.write('abc -D ' + str(float(CLOCK) * 1000) + ' -constr ../../scripts/abc.constr -script ../../scripts/' + ABC + ' -liberty ' + LIB + '\n')
        else:
            yosys.write('abc -D ' + str(float(CLOCK) * 1000) + ' -constr ../../scripts/abc.constr -liberty ' + LIB + '\n')
        yosys.write('\n')
        yosys.write('setundef -zero\n')
        yosys.write('opt_clean -purge\n')
        yosys.write('\n')
        yosys.write('stat -liberty ' + LIB + '\n')
        yosys.write('\n')
        yosys.write('write_verilog netlist.v\n')
        yosys.write('write_json netlist.json\n')

def create_sta():
    sta_name = FOLDER + '/work/sta.cmd'
    with open(sta_name, 'w') as sta:
        sta.write('read_liberty ' + LIB + '\n')
        sta.write('read_verilog netlist.v\n')
        sta.write('link_design ' + TOP + '\n')
        sta.write('\n')
        if (clocknetpresent == 1):
            sta.write('create_clock -name clk -period ' + CLOCK + ' {' + CLOCKNAME + '}\n')
            sta.write('set non_clock_inputs [lsearch -inline -all -not -exact [all_inputs] ' + CLOCKNAME + ']\n')
            sta.write('set_input_delay ' + INPUTDELAY + ' -clock clk $non_clock_inputs\n')
        else:
            sta.write('create_clock -name clk -period ' + CLOCK + '\n')
            sta.write('set_input_delay ' + INPUTDELAY + ' -clock clk [all_inputs]\n')
        sta.write('set_output_delay ' + OUTPUTDELAY + ' -clock clk [all_outputs]\n')
        sta.write('\n')
        sta.write('report_checks\n')
        sta.write('report_power\n')
        sta.write('\n')
        sta.write('exit')

def create_chipsdc():
    sdc_name = FOLDER + '/work/constraint.sdc'
    with open(sdc_name, 'w') as sdc:
        sdc.write('current_design ' + TOP + '\n')
        sdc.write('set clk_period ' + CLOCK + '\n')
        sdc.write('\n')
        if (clocknetpresent == 1):
            sdc.write('create_clock -name clk -period $clk_period {' + CLOCKNAME + '}\n')
            sdc.write('set non_clock_inputs [lsearch -inline -all -not -exact [all_inputs] ' + CLOCKNAME + ']\n')
            sdc.write('set_input_delay ' + INPUTDELAY + ' -clock clk $non_clock_inputs\n')
        else:
            sdc.write('create_clock -name clk -period $clk_period\n')
            sdc.write('set_input_delay ' + INPUTDELAY + ' -clock clk [all_inputs]\n')
        sdc.write('set_output_delay ' + OUTPUTDELAY + ' -clock clk [all_outputs]\n')
        sdc.write('\n')
    

if __name__ == '__main__':
        create_makefile()
        create_synthys()
        create_sta()
        create_chipsdc()
