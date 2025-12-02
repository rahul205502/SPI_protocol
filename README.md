# 📡 SPI Master State Machine

This repository contains the Verilog HDL implementation of a simple state-machine-driven **SPI (Serial Peripheral Interface) Master** module, designed as `SPI_state.v`. The design is intended to demonstrate the fundamental sequential control logic required to drive the SPI clock (`spi_sclk`) and Chip Select (`spi_cs`) signals for transmitting 16-bit data.

## ⚙️ Module Details: `SPI_state.v`

The module operates synchronously with the clock signal and uses a state machine to manage the transmission protocol.

### State Definitions

The state machine uses three states to control the clock and data flow:

| State | Value | Description |
| :--- | :--- | :--- |
| **IDLE** | `2'b00` | Initial state. Resets control signals and prepares for transmission. |
| **TRANSFER** | `2'b01` | Sets `spi_cs` low (Active) and initiates the data transfer of one bit. |
| **DONE** | `2'b10` | Temporarily asserts `spi_sclk` high to complete the clock cycle for the current bit. |

### Port Definitions

| Port Name | Direction | Width | Function |
| :--- | :--- | :--- | :--- |
| `clk` | Input | 1 | System clock. |
| `rst` | Input | 1 | Asynchronous Active-Low Reset. |
| `data_in` | Input | 16 | 16-bit data to be transmitted. |
| **`spi_cs`** | Output | 1 | SPI Chip Select (Active Low). |
| **`spi_sclk`** | Output | 1 | SPI Serial Clock. |
| **`spi_data`** | Output | 1 | SPI Master Out Slave In (MOSI) data line. |
| **`counter`** | Output | 5 | Tracks the number of bits remaining to be sent. |

### 🔑 Key Implementation Logic

* **Reset Condition:** On reset (`~rst`), the `cs` signal is set high (`1'b1`), `sclk` is set low (`1'b0`), and the `count` is initialized to $16$ (`05'd16`). The `state` is set to `IDLE`.
* **IDLE State:** Sets `sclk` low (`1'b0`) and `cs` high (`1'b1`) [cite: 7, 8][cite_start], then moves to the `TRANSFER` state.
* **TRANSFER State:** Sets `cs` low (`1'b0`), loads the current bit of `data_in` into `MOSI`, decrements the `count` [cite_start], and transitions to the `DONE` state.
* **DONE State:** Sets `sclk` high (`1'b1`). If the `count` is greater than 0, it returns to `IDLE`; otherwise, it resets the `count` to 16 and returns to `IDLE`.

---

## 🧪 Testbench (`spi_state_tb.v`)

The testbench (`spi_state_tb.v`) is included to verify the module's sequential behavior and state transitions.

* **Clock:** Generated with an `always #5 clk = ~clk;` block.
* **Reset Sequence:** `rst` is asserted high after a $10\text{ns}$ delay.
* **Stimulus:** The testbench drives new 16-bit data values into `data_in` sequentially, with a $480\text{ns}$ delay between each word.

```verilog
initial begin
    #10 rst=1;
    
         data_in = 16'hA569; // First 16-bit word
    #480 data_in = 16'h2563; // Second word
    // ... further data words follow
    #480 data_in = 16'h7564;
    $finish;
end
