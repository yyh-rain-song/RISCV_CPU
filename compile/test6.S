jal x2, _flag1      #1
_flag1:
jal x3, _flag2      #2
ori x1, x0, 0x001   #3
_flag2:
jal x4, _flag3      #4
ori x1, x0, 0x001   #5
ori x1, x0, 0x002   #6
ori x1, x0, 0x003   #7
_flag3:
ori x2, x0, 0x002   #8