li		x1,  0x11	# x2 = 100
li		x2,  0x22		# x1 = 50 
li		x3,  0x33		# x3 = 159 
li      x4,  0x44
lui     x5,  0x01       # x5 = 1000
sh		x1, 0x000(x5)

sb      x3, 0x002(x5)
sb      x4, 0x003(x5)

lw		x6, 0x000(x5)		