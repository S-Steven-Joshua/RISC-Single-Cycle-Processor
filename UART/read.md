# UART 32-bit Serializer and Deserializer

## Overview

This project implements a simple UART-based data transmission system capable of transferring 32-bit data over a standard 8-bit UART interface.

The design consists of two major blocks:

1. **Serializer (Transmitter Side)**
   - Accepts a 32-bit parallel input.
   - Splits the 32-bit word into four 8-bit bytes.
   - Sequentially transmits each byte through the UART transmitter.

2. **Deserializer (Receiver Side)**
   - Receives four 8-bit UART packets.
   - Reconstructs the original 32-bit data word.
   - Generates a valid signal once all four bytes are received.

---

## Features

- 32-bit parallel data transmission over UART
- Automatic serialization into 8-bit packets
- Automatic reconstruction of original 32-bit data
- UART transmitter and receiver modules
- Byte counter for packet tracking
- Data valid indication after complete reception
- Fully synthesizable RTL design
- FPGA and ASIC compatible

---
## Output for the Serializer  
<img width="1920" height="1021" alt="Image" src="https://github.com/user-attachments/assets/652020eb-ac72-422d-872b-807a8825092e" />

---
## Output for the UART


## System Architecture
