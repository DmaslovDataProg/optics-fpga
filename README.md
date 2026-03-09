# Optic signals processing using FPGA 
Project for FPGA with the unfiltered light processing. 

 
## Simulation stage

**Python environment** The 1 kHz sine wave with the white noise contamination is simulated, filtered and the FIR coefficients are delivered. It serves for 4 purposes:
- Returns the .txt file with the ADC offset for the Verilog environment.
- Computes the 29 bins FIR coefficients for Verilog.
- Applies the FFT on the sine + noise signal to extract the main frequency.
- Compares the noise + sine signal, generated sine and the Verilog output.

The **Verilog** code simulates the FPGA behavior, where on the input of the circuit a noisy signal is incoming and the on-chip DSP is performing. It seves for the following:
- Establish the basic 4 - element average prcessing for the code functioning
- Integrate the FIR coefficients on the simulated FPGA.
- Apply DSP on the Python-simulated noise + sine signal and returns the .txt file with the filtered signal for later Python post processing.
- Returns the .vcd file for visualisation in GtkWave.

## How to launch this code:
For the simulation part two languages are used: Python and Visual studio code. Below further information is provided on how to adopt each. 

### For Python code:
Make sure that you run in a clean environement (some already installed libraries may conflict with each other) your Python script in Anaconda environment, some libraries may conflict with each other, for this run in bash/Powershell:
`conda create -n signalGen python=3.10`

### For Verilog code:
Visual studio for the Verilog files, with the Verilog extension installed. Compilation of the final testbench is performed as follow:
`iverilog -o fir_sim FirFilter.v movingAverageTb.v`  

## Hardware list: 
Coming soon..

# Demo of the functionality: 
Coming soon..

- Limitations on the hardware: 
Coming soon..


- Future implementations: 
1) Use the low level hardware to apply the optical-RF-ultrasound test
2) Employ IR, registers and advanced hardware complete the project.
