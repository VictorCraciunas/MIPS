# VHDL-Based Processor Design

## Overview
This project is a **VHDL-based processor design**, implementing key components such as **instruction fetching, memory management, execution unit, register file, and control unit**. The system simulates a simplified **processor pipeline** using VHDL, enabling basic instruction execution and memory operations.

## Features
- **Instruction Fetch Unit**: Fetches instructions from memory
- **Memory Module**: Handles data storage and retrieval
- **Control Unit**: Decodes and manages execution flow
- **Execution Unit**: Performs arithmetic and logical operations
- **Register File**: Stores general-purpose registers
- **RAM Module**: Manages data memory operations
- **Multipurpose General Unit (MPG)**: Handles various system functions
- **Test Environment**: Provides a simulation setup to validate functionality

## File Structure
```
VHDLProcessor/
│── src/
│   ├── instruction_fetch.vhd  # Instruction Fetch Unit
│   ├── mem.vhd                # Memory Module
│   ├── mpg.vhd                # Multipurpose General Unit
│   ├── ramm.vhd               # RAM Module
│   ├── reg_file.vhd           # Register File
│   ├── ssd.vhd                # SSD Control Logic
│   ├── test_env.vhd           # Test Environment
│   ├── control_unit.vhd       # Control Unit
│   ├── decode.vhd             # Instruction Decoder
│   ├── execution_unit.vhd     # Execution Unit
```

## Simulation & Testing
### 1. Setup VHDL Environment
- Use **ModelSim**, **Vivado**, or **GHDL** for simulation.
- Ensure all `.vhd` files are compiled before simulation.

### 2. Running the Simulation
- Load the test environment (`test_env.vhd`).
- Run the simulation and observe the instruction execution.
- Verify register updates and memory operations.



