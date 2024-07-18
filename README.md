# :rocket: HDL - Design of Experiment
Github repository for Verilog HDL source codes of Design of Experiment for the course CPE114L-4.

Group Members:

1. CANDA, Ice Marcux
2. CAPOQUIAN, Reji
3. CLAROS, Angelica
4. DE GUZMAN, Rance Jacob
5. DE PEÑA, Vince Samuel

## ✅ Requirements

1. This project aims to solve the need for advanced security measures by introducing an 8-digit digital passcode lock with attempts, an alarm, and 7-segment displays that can be used on a variety of applications (doorlock, safe/vault lock, etc.).
2. _Refer to the documentation for the truth table_
3. An encoder circuit is used for keypad inputs, ranging from zero (0) to nine (9).
4. Other combinational circuits were added such as decoders for BCD-to-7-segment conversion and demultiplexers for mode selection.
5. Universal shift registers were used for storing the data with a total of sixteen shift registers (64 bit memory storage) and a 4-bit synchronous counter circuit was used for counting attempts (up to five attempts only until alarm rings).