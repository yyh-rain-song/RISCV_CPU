ori x1, x0, 0x200 
sll x1, x1, 20
ori x1, x1, 0x010 #x1=20000010

ori x2, x0, 0x200 
sll x2, x2, 20
ori x2, x2, 0x001 #x2=20000001

ori x3, x0, 0x000
add x3, x2, x1 #x3=x1+x2=40000011
addi x3, x3, 0x001
sub x4, x2, x1 #x4=x2-x1=fffffff1

slt x5, x4, x3 #x5=1
sltu x6, x4, x3 #x6=0

slti x7, x5, 0xf #x7=1
sltiu x8, x5, 0xf #x8=1