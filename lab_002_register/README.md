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
