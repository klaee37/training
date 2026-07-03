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
- Enter directory lab_001_spi (assume you are in directory training/)
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
  - On the Open Database window, Display files of type: -> "VCD Files (*.vcd)".
  - Click to select file "sim.vcd".
  - Click "Open & Dismiss"- On the File Translation window, click "OK".
  - Click signals on the Design Browser window, the signals will show on the waveform window.
- Modify the spi.v with VScode or any text editor in lab_001_spi/ to get test bench result pass.
- You can see the passing waveform from file "sim_pass.vcd".
