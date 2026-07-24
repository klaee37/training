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
code . &
```
- Install VSCode Extension (First-time only),
  - On the VSCode window,
  - Go to Extensions (click Extensions tab, or menu -> View -> Extensions or Ctrl+Shift+X).
  - Search "SystemVerilog - Languauge Support" and click "Install".
- Open project folder,
  - On the menu -> File -> Open Folder...
  - On the Open Folder window, browse into "training" folder and click "Select"
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
## 2. Lab_002_register
- Modify register.v to get pass simulation result.
- SDO is zero for undefined bit reading.

### Register Table
- Address 0x00

<table>
  <thead>
    <tr>
      <th>BIT</th>
      <th>7</th>
      <th>6</th>
      <th>5</th>
      <th>4</th>
      <th>3</th>
      <th>2</th>
      <th>1</th>
      <th>0</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>Name</td>
      <td colspan="8">CONFIG_0[7:0]</td>
    </tr>
    <tr>
      <td>Access Type</td>
      <td colspan="8">R/W</td>
    </tr>
    <tr>
      <td>Reset Value</td>
      <td colspan="8">b0000_0000</td>
    </tr>
  </tbody>
</table>

- Address 0x01

<table>
  <thead>
    <tr>
      <th>BIT</th>
      <th>7</th>
      <th>6</th>
      <th>5</th>
      <th>4</th>
      <th>3</th>
      <th>2</th>
      <th>1</th>
      <th>0</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>Name</td>
      <td></td>
      <td colspan="3">CONFIG_1[2:0]</td>
      <td colspan="3"></td>
      <td>EN_0</td>
    </tr>
    <tr>
      <td>Access Type</td>
      <td></td>
      <td colspan="3">R/W</td>
      <td colspan="3"></td>
      <td>R/W</td>
    </tr>
    <tr>
      <td>Reset Value</td>
      <td></td>
      <td colspan="3">b101</td>
      <td colspan="3"></td>
      <td>b1</td>
    </tr>
  </tbody>
</table>

- Address 0x02

<table>
  <thead>
    <tr>
      <th>BIT</th>
      <th>7</th>
      <th>6</th>
      <th>5</th>
      <th>4</th>
      <th>3</th>
      <th>2</th>
      <th>1</th>
      <th>0</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>Name</td>
      <td colspan="8">STATUS_0[7:0]</td>
    </tr>
    <tr>
      <td>Access Type</td>
      <td colspan="8">R</td>
    </tr>
    <tr>
      <td>Reset Value</td>
      <td colspan="8">bXXXX_XXXX</td>
    </tr>
  </tbody>
</table>

- Address 0x03

<table>
  <thead>
    <tr>
      <th>BIT</th>
      <th>7</th>
      <th>6</th>
      <th>5</th>
      <th>4</th>
      <th>3</th>
      <th>2</th>
      <th>1</th>
      <th>0</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>Name</td>
      <td>EN_1</td>
      <td></td>
      <td colspan="3">STATUS_2[2:0]</td>
      <td colspan="2"></td>
      <td>STATUS_1</td>
    </tr>
    <tr>
      <td>Access Type</td>
      <td>R/W</td>
      <td></td>
      <td colspan="3">R</td>
      <td colspan="2"></td>
      <td>R</td>
    </tr>
    <tr>
      <td>Reset Value</td>
      <td>b1</td>
      <td></td>
      <td colspan="3">bXXX</td>
      <td colspan="2"></td>
      <td>bX</td>
    </tr>
  </tbody>
</table>
