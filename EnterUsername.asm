.data
	tb1: 	.asciiz	"Xin moi nhap username: "
	tb2: 	.asciiz "username vua nhap khong hop le. Vui long nhap lai. \n"
	tb3: 	.asciiz "Xin chao "
	tb4:	.asciiz "\n"
	str:	.space 30
	kq:	.space 10

	
.text
	.globl main
main:
	jal _EnterUsername
	
	#xuat tb1
	li $v0, 4
	la $a0,tb3
	syscall
	
	#xuat username
	li $v0,4
	la $a0,kq
	syscall 
	
	#ketthuc
	li $v0,10
	syscall

#===================Ham nhap username=====================
#Dau thu tuc
_EnterUsername:
	addi $sp,$sp,-52
	sw $ra,($sp)
	sw $s0,4($sp)	
	sw $s1,8($sp)
	sw $s2,12($sp)	
	sw $s3,16($sp)
	sw $s4,20($sp)	
	sw $s5,24($sp)
	sw $s6,28($sp)	
	sw $s7,32($sp)
	sw $t0,36($sp)	
	sw $t1,40($sp)
	sw $t2,44($sp)	
	sw $t3,48($sp)
	sw $t4,52($sp)	
	
#than thu tuc

	#xuat tb1
	li $v0, 4
	la $a0,tb1
	syscall 
	
	#nhap chuoi username
	li $v0,8
	la $a0,str
	la $a1,30
	syscall 
	
	
	li $t4,0	#khoi tao t4=0
	la $s0,str	#Khoi tao chuoi ban dau
	la $s1,kq	#khoi tao chuoi ket qua
	li $s2,'0'
	li $s3,'9'
	li $s4,'a'
	li $s5,'z'
	li $s6,'A'
	li $s7,'Z'

_EnterUsername.Loop:
	#kiem tra xem so ki tu chuoi co bang 10 khong
	beq $t4,10,_EnterUsername.End_loop
	
	#doc 1 ki tu
	lb $t0,($s0)
	#xem ki tu do co thuoc 0->9 hay khong
	sle $t1,$s2,$t0
	sle $t2,$t0,$s3
	and $t3,$t1,$t2
	
	#neu bang add ki tu vao chuoi ket qua
	bne $t3,0,_EnterUsername.Loop.AddStr
	
	#xem ki tu co thuoc chuoi tu a->z khong
	sle $t1,$s4,$t0
	sle $t2,$t0,$s5
	and $t3,$t1,$t2
	
	#neu bang add ki tu vao chuoi ket qua
	bne $t3,0,_EnterUsername.Loop.AddStr
	
	#xem ki tu co thuoc tu A-> Z khong
	sle $t1,$s6,$t0
	sle $t2,$t0,$s7
	and $t3,$t1,$t2
	
	#neu bang thi add ki tu vao chuoi ket qua
	beq $t3,1,_EnterUsername.Loop.AddStr
	
	#neu ki tu la \n thi ket thuc vong lap
	beq $t0,'\n',_EnterUsername.End_loop
		
	j _EnterUsername.NotPermit

	
_EnterUsername.Loop.AddStr:
	#lay 1 ki tu cua s1 luu vao t0
	sb $t0,($s1)
	
	#tang chuoi $s0
	addi $s0,$s0,1
	
	#tang chuoi $s1
	addi $s1,$s1,1
	
	#tang dem len 1
	addi $t4,$t4,1
	
	j _EnterUsername.Loop
	
_EnterUsername.NotPermit:

	#xuat thong bao chuoi nhap khong hop le
	li $v0,4
	la $a0,tb2
	syscall
	#nhap lai tu dau
	j _EnterUsername
	 
_EnterUsername.End_loop:	
	sb $0,($s1)	
#cuoi thu tuc
	#restore thanh ghi
	lw $ra,($sp)
	lw $s0,4($sp)	
	lw $s1,8($sp)
	lw $s2,12($sp)	
	lw $s3,16($sp)
	lw $s4,20($sp)	
	lw $s5,24($sp)
	lw $s6,28($sp)	
	lw $s7,32($sp)
	lw $t0,36($sp)	
	lw $t1,40($sp)
	lw $t2,44($sp)	
	lw $t3,48($sp)
	lw $t4,52($sp)	
	
	#xoa stack
	addi $sp,$sp,52
	
	#quay ve ham main
	jr $ra
	
