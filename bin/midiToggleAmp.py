#!/usr/bin/python

import socket
import struct
import time

s = socket.socket( socket.AF_INET, socket.SOCK_DGRAM )

s.connect( ("localhost", 5006 ) )

# Control Change
bytes = struct.pack( "BBBB", 0xaa, 0xB0, 0x16, 0x7f )
s.send( bytes )
bytes = struct.pack( "BBBB", 0xaa, 0xB0, 0x17, 0x7f )
s.send( bytes )

s.close()
