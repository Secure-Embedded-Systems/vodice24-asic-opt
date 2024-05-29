# Cryptographic Hardware Optimization for ASIC

## About

Cryptographic hardware are specialized computation structures dedicated to the 
execution of a single or a few cryptographic algorithms. Through specialization, 
hardware achieves higher performance, lower power consumption, and lower silicon 
cost compared to equivalent cryptographic software implementations. The difference 
in efficiency can be orders of magnitude. Yet, while the performance benefits of 
hardware are well understood, the cryptographic engineering community is generally 
unfamiliar with the process of mapping algorithms to hardware structures. 
For example, reference implementations of new cryptographic standards are more 
commonly found in software than in hardware. With the advent of open source hardware 
design tools, and especially open-source ASIC design tools, a great opportunity 
exists for a culture of hardware engineering in the cryptographic community. The 
potential gains of cryptographic implementations in efficiency, in scope, and in 
innovation are simply too big to ignore the hardware design domain.

The objective of this tutorial is to introduce a standard open-source ASIC design 
flow using cryptographic hardware design examples. Tutorial attendees will learn 
specifically about techniques for high performance, and techniques for low area. 
In each case, attendees will target the OpenROAD ASIC design flow for Google 
Skywater 130nm standard cells.

In this design process, the attendees will learn how to analyze the tool output, 
and how to make meaningful design decisions towards high performance or low area 
in hardware.

1. Transform a C reference implementation to RTL hardware, without the magic of a compiler or a high-level synthesis tool.
2. Understand common RTL design transformations for high performance in hardware: pipelining, unfolding, and retiming
3. Understand common RTL design transformations for low area in hardware: multiplexing and bitserial design.

## Slide Material

[PDF slides](https://schaumont.dyn.wpi.edu/schaum/summerschool-crypto-asic-opt-prs.pdf)

## Schedule

| Time  |  Topic                 |  Transformations                |
|-------|------------------------|---------------------------------|
| 9:00  | OpenROAD Design Flow   | Pipelining, bitserial design    |
| 10:00 | Hands-on               |                                 |
| 10:30 | Break                  |                                 |
| 11:00 | Poly1305 in Hardware   | Multiplexing, microcoding       |
| 11:30 | Hands-on               |                                 |

## Design Index

| Design     | Purpose                                                |
|------------|--------------------------------------------------------|
| lfsr       | 4-bit LFSR to demonstrate basic flow steps             |
| modmul_bp  | Bit-parallel mod-29 multiplier                         |
| modmul_bp_pipe | Bit-parallel mod-29 pipelined multiplier           |
| modmul_bs  | Bit-serial mod-29 multiplier                           |
| poly1305_bp | Bit-parallel Poly1305 MAC                             |
| poly1305_ws | Word-serial Poly1305 MAC                              |
| poly1305_ws_w32 | Word-serial Poly1305 MAC with mux'ed multiplier   |
| poly1305_tv | Poly1305 test vector generator                        |

## Useful Commands (using LFSR as design target)

- RTL code: ``lfsr/rtl/lfsr.v``


## Design Server IPs

| Server | IP              |
|--------|-----------------|
| asic01 | 123.123.123.123 |
| asic02 | 123.123.123.123 |
| asic03 | 123.123.123.123 |
| asic04 | 123.123.123.123 |
| asic05 | 123.123.123.123 |
| asic06 | 123.123.123.123 |
| asic07 | 123.123.123.123 |
| asic08 | 123.123.123.123 |
| asic09 | 123.123.123.123 |
| asic10 | 123.123.123.123 |
| asic11 | 123.123.123.123 |
| asic12 | 123.123.123.123 |
| asic13 | 123.123.123.123 |
| asic14 | 123.123.123.123 |
| asic15 | 123.123.123.123 |
| asic16 | 123.123.123.123 |
| asic17 | 123.123.123.123 |
| asic18 | 123.123.123.123 |
| asic19 | 123.123.123.123 |
| asic20 | 123.123.123.123 |
