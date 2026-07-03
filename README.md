# Training
- Clone the project.
```
git clone https://github.com/klaee37/training.git
```
- Enter directory training.
```
cd training
```
- Open VSCode.
```
code &
```
- Install VSCode Extension (First-time only),
  - On the VSCode window,
  - Go to Extensions (click Extensions tab, or menu -> View -> Extensions or Ctrl+Shift+X).
  - Search "SystemVerilog - Languauge Support" and click "Install".
- Open project folder,
  - On the menu -> File -> Open Folder...
  - On the Open Folder window, browse into "training" folder and click "Select"
## Lab_001_SPI
### Lab_001_SPI : Fix spi.v
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
### Lab_001_SPI : Synthesis
Check that there is not inferred latch in your design.
- Run synthesize.
```
make syn
```
You should get a message "Synthesis Done". If there is any inferred latch, an error message "CDFG2G-622 Inferred latch" is showns and informs the inferred latch signal.
- Run simulation with the gate netlist file spi_netlist.v.
```
make sim_syn
```
