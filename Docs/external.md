# External data structure

+0 0x55
+1 0xaa
+2, +3 system name
  'D1' @ 094d
  or start page broadcast @ 0845f
+4 cmd
+5 cmd
+6, +7 16bit word
+8 checksum
 @ 0x898a

# Commands

## B - batch transfer
 @ 0x08c8, 0x851d
 rcv @ 0x8c39

## C _
 rcv @ 0x8c49

### C B
 rcv @ 0x8c5d

### C G
 rcv @ 0x8c50

## E - remote edit
 @ 0x8465
 rcv @ 0x8c32
 4 bytes
 system name -> start page broadcast

## F - fetch
 @ 088e2

### F A
 rcv @ 0x8c6a

### F B - block edit
 @ 0x8472, 0xb8f3
 4 bytes

### F E
 @ 0x889b
 rcv @ 0x8c79
 no payload

### F H - channel region setuop
 @ 0x3d9e, 0x8810
 16 bytes

### F I
 @ 0x206a
 value = current page
 rcv @ 0x8c6e
 44 bytes payload

### F L - line level
 @ 0xb671
 5 bytes

### F O
 @ 0x9063
 241 bytes

### F P
 @ 0x887d
 rcv @ 0x8c66
 no payload

### F Q

### F R
 @ 0x3db1
 24 bytes

### F S - sequence
 @ 0x3bc8

### F T - fetch time
 @b1d7
 12 bytes

### F V
 @ 0x1959

### F W - weather
 @ 0xb3f6
 165 bytes

### F X - external
 @ 0xac2c

## K - keyboard direct
 @ 0x842b
 rcv @ 0x8c2b

## S - send
 @ 0x8942
 rcv @ 0x8d84
 _ = X, P, S, C, M, W, R, H, T, E, L, V, A, Q, O, B, I, D, G

### S A
 1 byte

### S B - block edit
 4 bytes

### S C
 6 bytes

### S D
 5 bytes

### S E - send event
 @ 0x87d0
 value = event number
 32 bytes payload

### S G
 14 bytes

### S H
 @ 0x86d1
 24 bytes

### S I
 @ 0x2061
 44 bytes payload

### S L - line level
 5 bytes

### S M
 460 bytes

### S O
 @ 0x86cc
 241 bytes

### S P - set(send) page ?
 @ 0x2b25, 0x876c
 368 bytes payload
+2/3 -> system name for batch transfer
  @0x2b2b
+6/7 -> 16 bit page number

### S Q
 @ 0x86ae
 234 bytes

### S R
 @ 0x86bd
 12 bytes

### S S - sequence
  39 bytes

### S T - send time
 @ 0x86c2
 12 bytes

### S V - send version
 1 byte

### S W - weather
 @ 0x86b8
 165 bytes

### S X - external
 @ 0x86b3
 200 bytes