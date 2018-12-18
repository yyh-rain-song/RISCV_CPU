ori x1, x0, 0x000
ori x2, x0, 0x000

_flag1:
addi x1, x1, 0x001
addi x2, x2, 0x001
beq x1, x2, _flag1
addi x1, x1, 0x001