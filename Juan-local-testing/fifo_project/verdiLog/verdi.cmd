verdiSetActWin -dock widgetDock_<Message>
simSetSimulator "-vcssv" -exec "simv" -args
debImport "-dbdir" "simv.daidir"
wvCreateWindow
wvOpenFile -win $_nWave2 \
           {/nfs/site/disks/juanpsal_disk_002/iscp-fst/Intel_Makeathon/Juan-local-testing/fifo_project/results/test_write_to_full/novas.fsdb}
verdiSetActWin -dock widgetDock_MTB_SOURCE_TAdebExit
BSelect "tb_top.dut" -win $_nTrace1
verdiSetActWin -dock widgetDock_<Inst._Tree>
srcHBSelect "tb_top.dut_if" -win $_nTrace1
srcHBSelect "tb_top.dut_if" -win $_nTrace1
