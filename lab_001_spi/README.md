## 1. Lab_001_SPI
### 1.1 Lab_001_SPI : Fix spi.v
Modify the combination logics (in start-end comment blocks) in lab_001_spi/spi.v with VScode or any text editor to get test bench result pass.
- Enter directory lab_001_spi (assume you are in directory training/)
```
cd lab_001_spi
```
- Run elaboration to check error and warning message. Make sure that the error is zero. The warning message should be zero.
```
make elab
```
- Run simulation. You propably get fail result.
```
make
```
- Open simvision to view to waveform from simulation result.
```
simvision &
```
- On the simvision window,
  - On the menu -> File -> Open Database...
  - On the Open Database window, Display files of type: -> "VCD Files (*.vcd)".
  - Click to select file "sim.vcd".
  - Click "Open & Dismiss"- On the File Translation window, click "OK".
  - Click signals on the Design Browser window, the signals will show on the waveform window.
- You can see the passing waveform from file "sim_pass.vcd".
### 1.2 Lab_001_SPI : Synthesis
Check that there is not inferred latch in your design.
- Run synthesize.
```
make syn
```
You should get a message "Synthesis Done". If there is any inferred latch, an error message "Inferred latch" is showns and informs the inferred latch signal.
- Run simulation with the gate netlist file spi_netlist.v.
```
make sim_syn
```
