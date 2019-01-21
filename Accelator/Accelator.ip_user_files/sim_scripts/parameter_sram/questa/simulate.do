onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib parameter_sram_opt

do {wave.do}

view wave
view structure
view signals

do {parameter_sram.udo}

run -all

quit -force
