
.data
	randNumber : .word 0 #random_Number
	#file_data_name: .asciiz "C:/Users/Admin/Desktop/do_KTMT_MIPS/data.txt"
	file_data_name: .asciiz "dethi.txt"
	String_in_File : .space 100
	word : .space 10
	number_of_word: .word 0 
	
.text
	#=====================Generate Random number===================#
	 #truyen tham so
	 # goi ham Random number	
	 jal _RandomNumber
	 # lay ket qua tra ve
	 sw $v0,randNumber
	 
	 #in ra RandNumber - FOR DEBUGING
	 move  $a0,$v0
   	 li $v0, 1   #1 print integer
   	 #lw $a0, randNumber
   	 syscall
	#=====================Generate Random number===================#
	
	#===================== Read From File ===================#
	 #truyen tham so
	 
	 # goi ham Random number	
	 jal _ReadDataFromFile
	 
	 # lay ket qua tra ve
	
	 
	 #in ra noi dung FILE - FOR DEBUGING
	 
   	 #li $v0, 4   #1 print integer
   	 #la $a0, String_in_File
   	 #syscall
	#=====================Read From File ===================#
	
	#==================Get word from POS I  ==================#
	 #truyen tham so
	 la $a0, String_in_File
	 lw $a1, randNumber
	 # goi ham Random number	
	 jal _GetWordFromPositionI
	 
	 # lay ket qua tra ve
	 #sw $v0,word
	 
	 #in ra noi dung FILE - FOR DEBUGING
 	
   	li $v0 4  #4 print string
   	la $a0,word
   	syscall
	#==================Get word from POS I  ==================#			
	 j _exit


##=============================	Ham Random number======================##
_RandomNumber:
    #dau thu tuc
    
    
    sw $s0,4($sp) #random number
    
    li $a1, 7 #Here you set $a1 to the max bound.
    li $v0, 42  #generates the random number.
    syscall
    move $v0,$a0 # random luu trong $a0 -- chuyen $a0 ve $v0 de tra ve
   #Cuoi thu tuc
   jr $ra
##=============================	Ham Random number======================## 
##==========================Ham Read Data From FILE===================##
_ReadDataFromFile:
    #dau thu tuc 
    addi $sp,$sp, -32
    sw $ra,($sp)
#openfile
	#openfile
	li $v0,13
	la $a0,file_data_name
	li $a1,0
	li $a2,0
	syscall

	#Luu dia chi file vao $s0
	move $s0,$v0

	#Doc file
	li $v0,14
	move $a0,$s0
	la $a1,String_in_File
	li $a2,50
	syscall		
   #Cuoi thu tuc
	#restore
	lw $ra,($sp)
	#xoa stack
	addi $sp,$sp,32
	jr $ra
##==========================Ham Read Data From FILE===================##   
##==================== Ham Get Word From Position I ==================##
_GetWordFromPositionI:
    #dau thu tuc 
    addi $sp,$sp,-32
    sw $ra,($sp)
    sw $s0,4($sp) #String in File
    sw $s1,8($sp) #Random Number
    sw $s2,12($sp) #result
    sw $t0,16($sp) #bien dem
    sb $t1,20($sp) #character
    sw $t2,24($sp) #compare
   
    #Lay tham so luu vao thanh ghi
    move $s0,$a0 #$s0 ->string in file
    move $s1,$a1 #$s1 ->Random Number
   
    #la $s2,word
    la $s2,word
    #move $s2,$s2
    #than thu tuc
     li $t0,0#bien dem
     
    #li $v0, 1   #11 print charater
    #la $a0, ($t0)
    #syscall 	
    
_GetWordFromPositionI.Loop:
	#doc 1 ki tu
	lb $t1,($s0)
     	
     	#li $v0, 1   #1 print int
    	#la $a0, ($t0)
    	#syscall 
     
	beq  $t1,'-',_GetWordFromPositionI.TangDem
	
	#kiem tra xem toi tu thu random_number chua
	sgt  $t2,$t0,$s1
	beq $t2,1,_GetWordFromPositionI.GetWord	
	
	addi $s0,$s0,1
	j _GetWordFromPositionI.Loop

_GetWordFromPositionI.TangDem:
	addi $t0,$t0,1 #Tang dem
	addi $s0,$s0,1
	j _GetWordFromPositionI.Loop
	
	
_GetWordFromPositionI.GetWord:	
	
	 lb $t1,($s0)
	 beq  $t1,'-',_GetWordFromPositionI.Ketthuc
	 #debug
	 
	 #li $v0, 11   #11 print charater
   	 #la $a0, ($t1)
   	 #syscall
   	 
   	 sb $t1,($s2)
	 addi $s0,$s0,1
	 addi $s2,$s2,1
	 
	 
    	j _GetWordFromPositionI.GetWord
    	
 _GetWordFromPositionI.Ketthuc:    
 	#gan ki tu ket thuc chuoi cho word
 	addi $s2,$s2,1
 	sb $0,($s2) 
 	#addi $t3,$t3,-3
 	#move  $v0,$t3
 	#debug
 	
 	#subi $t3,$t3,-3
     	#li $v0, 4  #1 print integer
   	#la $a0, ($t3)
   	#syscall
   	#debug
#Cuoi thu tuc
		#restore
	lw $ra,($sp)
	lw $s0,4($sp) #String in File
    	lw $s1,8($sp) #Random Number
    	lw $s2,12($sp) #Random Number
    	lw $t0,16($sp) #bien dem
   	lb $t1,20($sp) #character
   	lw $t2,24($sp) #compare
		
		#xoa stack
		addi $sp,$sp,32
		#tra ve 
		jr $ra	
   	

##==================== Ham Get Word From Position I ==================##

_exit:   
