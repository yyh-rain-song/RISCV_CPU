.global _start

jal x2, _flag1 #pc+4存入x2 （pc=4)
ori x1, x0, 0x00a
ori x1, x0, 0x00b
ori x1, x0, 0x00c
_flag1:
ori x1, x0, 0x01b #应该跳到这里
jalr x3, x1, 0x01 #pc+4存入x3 (pc=24)
ori x1, x0, 0x00d
_flag2:
ori x1, x0, 0x003 #应该跳到这里