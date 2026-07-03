# Training
- Clone the project.
```
git clone https://github.com/klaee37/training.git
```
- Open vscode in directory training/.
```
cd training
code &
```
## Lab_001_SPI
- Enter directory lab1_spi (assume you are in directory training/)
```
cd lab_001_spi
```
- Run elaboration to check error and warning message.
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
  - On the Open Database window, Display files of type: -> "VCD Files (*.vcd)"
  - Click to select file "sim.vcd"
  - Click "Open & Dismiss"- On the File Translation window, click "OK"
- Modify the spi.v with VScode or any text editor in lab1_spi/ to get test bench result pass.
- You can see the passing waveform from file "sim_pass.vcd".
