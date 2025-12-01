# 📡 SPI Master State Machine

[cite_start]This repository contains the Verilog HDL implementation of a simple state-machine-driven **SPI (Serial Peripheral Interface) Master** module, designed as `SPI_state.v`[cite: 1]. [cite_start]The design is intended to demonstrate the fundamental sequential control logic required to drive the SPI clock (`spi_sclk`) and Chip Select (`spi_cs`) signals for transmitting 16-bit data[cite: 1, 13].

## ⚙️ Module Details: `SPI_state.v`

[cite_start]The module operates synchronously with the clock signal and uses a state machine to manage the transmission protocol[cite: 5].

### State Definitions

[cite_start]The state machine uses three states to control the clock and data flow[cite: 2, 3]:

| State | Value | Description |
| :--- | :--- | :--- |
| **IDLE** | `2'b00` | Initial state. [cite_start]Resets control signals and prepares for transmission[cite: 6, 7]. |
| **TRANSFER** | `2'b01` | [cite_start]Sets `spi_cs` low (Active) and initiates the data transfer of one bit[cite: 8, 9]. |
| **DONE** | `2'b10` | [cite_start]Temporarily asserts `spi_sclk` high to complete the clock cycle for the current bit[cite: 10]. |

### Port Definitions

| Port Name | Direction | Width | Function |
| :--- | :--- | :--- | :--- |
| `clk` | Input | 1 | [cite_start]System clock[cite: 1]. |
| `rst` | Input | 1 | [cite_start]Asynchronous Active-Low Reset[cite: 1, 5]. |
| `data_in` | Input | 16 | [cite_start]16-bit data to be transmitted[cite: 1]. |
| **`spi_cs`** | Output | 1 | [cite_start]SPI Chip Select (Active Low)[cite: 1, 4]. |
| **`spi_sclk`** | Output | 1 | [cite_start]SPI Serial Clock[cite: 1, 4]. |
| **`spi_data`** | Output | 1 | [cite_start]SPI Master Out Slave In (MOSI) data line[cite: 1, 3]. |
| **`counter`** | Output | 5 | [cite_start]Tracks the number of bits remaining to be sent[cite: 1, 3, 14]. |

### 🔑 Key Implementation Logic

* [cite_start]**Reset Condition:** On reset (`~rst`), the `cs` signal is set high (`1'b1`), `sclk` is set low (`1'b0`), and the `count` is initialized to $16$ (`05'd16`)[cite: 6]. [cite_start]The `state` is set to `IDLE`[cite: 6].
* [cite_start]**IDLE State:** Sets `sclk` low (`1'b0`) and `cs` high (`1'b1`) [cite: 7, 8][cite_start], then moves to the `TRANSFER` state[cite: 8].
* [cite_start]**TRANSFER State:** Sets `cs` low (`1'b0`) [cite: 9][cite_start], loads the current bit of `data_in` into `MOSI` [cite: 9][cite_start], decrements the `count` [cite: 9][cite_start], and transitions to the `DONE` state[cite: 10].
* [cite_start]**DONE State:** Sets `sclk` high (`1'b1`)[cite: 11]. [cite_start]If the `count` is greater than 0, it returns to `IDLE` [cite: 11][cite_start]; otherwise, it resets the `count` to 16 [cite: 12] [cite_start]and returns to `IDLE`[cite: 12].

---

## 🧪 Testbench (`spi_state_tb.v`)

[cite_start]The testbench (`spi_state_tb.v`) is included to verify the module's sequential behavior and state transitions[cite: 15, 6].

* [cite_start]**Clock:** Generated with an `always #5 clk = ~clk;` block[cite: 20].
* [cite_start]**Reset Sequence:** `rst` is asserted high after a $10\text{ns}$ delay[cite: 21].
* [cite_start]**Stimulus:** The testbench drives new 16-bit data values into `data_in` sequentially [cite: 22][cite_start], with a $480\text{ns}$ delay between each word[cite: 22].

```verilog
initial begin
    #10 rst=1;
    
         data_in = 16'hA569; // First 16-bit word
    #480 data_in = 16'h2563; // Second word
    // ... further data words follow
    #480 data_in = 16'h7564;
    $finish;
end
