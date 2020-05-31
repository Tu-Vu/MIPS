.data
	
	arr_score: .space 1000 
	arr_player: .space 1000 #100 phan tu 10 byte
	str: .space 1000 # 250 phan tu 4 bytes
	str_player: .space 1000	
	number_of_highscore: .word 0
	tb1 : .asciiz "Top 10 Player and score :"
	fin: .asciiz "nguoichoi.txt"      
	xuongdong : .asciiz"\n" 
	daucach: .asciiz "-"
	dausao: .asciiz "*"	
	
.text
  
	  	
  	#====================Ham doc score tu file ================#
  	# Mo file doc
  	li   $v0, 13      
  	la   $a0, fin     
  	li   $a1, 0        	# 0: read, 1: write, 9: write-only with create and append
  	li   $a2, 0        	# mode is ignored
  	syscall           	# v0 <- file descriptor 
  	move $s6, $v0     	# luu vao s6
 
	# Doc file 
	li   $v0, 14       
	move $a0, $s6      	
	la   $a1, str   	
	li   $a2, 1000       	# do dai chuoi doc
	syscall         
	#truyen vao string_file , arr_score
	#tra ve number of highscore
	# truyen tham so
	la $a0,arr_score
	la $a1,str
	# goi ham
	jal _TachChuoilayScore
	# lay kq tra ve so luong highscore
	
	sw $v0, number_of_highscore
	
	
	# Close file 
 	li   $v0, 16       
  	move $a0, $s6      # file descriptor to close
  	syscall            # close file
  	#====================Ham doc score tu file ================#
  	
  	#====================Ham doc player tu file ================#
  	# Mo file doc
  	li   $v0, 13      
  	la   $a0, fin     
  	li   $a1, 0        	# 0: read, 1: write, 9: write-only with create and append
  	li   $a2, 0        	# mode is ignored
  	syscall           	# v0 <- file descriptor 
  	move $s6, $v0     	# luu vao s6
 
	# Doc file 
	li   $v0, 14       
	move $a0, $s6      	
	la   $a1, str   	
	li   $a2, 1000       	# do dai chuoi doc
	syscall      
	   
	#truyen vao string_file , arr_score
	#tra ve number of highscore
	# truyen tham so
	la $a0,arr_player
	la $a1,str
	# goi ham
	jal _TachChuoilayPlayer
	
	# Close file 
 	li   $v0, 16       
  	move $a0, $s6      # file descriptor to close
  	syscall            # close file				
  	#====================Ham doc player tu file ================#
  	
  	
  	#====================Ham xuat arr_Player===============#
	#truyen vao arr_score , n
	
	# truyen tham so
	lw $a0,number_of_highscore
	la $a1,arr_player
	
	#debug
	
	# goi ham
	#jal _XuatMangPlayer
  	#==================== Ham xuat arr_Player ================#
  	
  	#====================Ham xuat arr_score ================#
	#truyen vao arr_score , n
	
	# truyen tham so
	lw $a0,number_of_highscore
	la $a1,arr_score
	#debug
	#lw $a0,($a1)
	#li $v0,1
	#syscall
	# goi ham
	#jal _XuatMangInt
  	#==================== Ham xuat arr_score ================#
  	
  	#==================== Ham Sort arr_score and player================#
	#truyen vao arr_score , n
	
	# truyen tham so
	lw $a0,number_of_highscore
	la $a1,arr_score
	#deubg
	#lw $a0,($a1)
	#li $v0,1
	#syscall
	# goi ham
	jal _Sort
	  #truyen tham so
    	lw $a0,number_of_highscore
	la $a1,arr_score
    
    	#goi ham xuat mang
    	#jal _XuatMangInt
  	#====================Ham Sort arr_score and player================#
  	
  	
  	
	
	#====================Ham xuat arr_Player===============#
	#truyen vao arr_score , n
	
	# truyen tham so
	lw $a0,number_of_highscore
	la $a1,arr_player
	
	#debug
	
	# goi ham
	#jal _XuatMangPlayer
  	#==================== Ham xuat arr_Player ================#
  	
  	#====================Ham xuat arr_score ================#
	#truyen vao arr_score , n
	
	# truyen tham so
	lw $a0,number_of_highscore
	la $a1,arr_score
	
	#lw $a0,($a1)
	#li $v0,1
	#syscall
	# goi ham
	#jal _XuatMangInt
  	#==================== Ham xuat arr_score ================#
  	
  	#====================Top 10 player and score =================#
  	#xuat thong bao
  	la $a0,tb1
  	li $v0,4
  	syscall
  	# truyen tham so
	lw $a0,number_of_highscore
	#goi ham
	jal _XuatTop10
  	#====================Top 10 player and score =================#
	li $v0,10
	syscall
	
	
	
# truyen vo a0 <- $arr, a1 <- $str
# tra ve: khong co
############## Ham _TachChuoi lay Score ######################
_TachChuoilayScore:
	# khai bao kich thuoc stack
	add $sp,$sp,-36
	
	sw $ra,($sp)
	sw $s0,4($sp)		 # arr_number	
	sw $s1,8($sp)		 # str	
	sw $t0,12($sp)		 # character "-"
	sw $t1,16($sp)		 # character "*"
	sw $t2,20 ($sp)		 # the lengh of string of scores
	sw $t3,24 ($sp)         # string of score get from file
	sw $t4 ,28 ($sp)	#number of high score
	sw $t5, 32($sp)
	
	
	move $s0,$a0			# s0 <- $arr
	#la $s0,arr
	move $s1,$a1			# s1 <- $str
	move $t3, $a1			#khoi tao $t3 - not important
	
	#khoi tao
	la $t0,daucach				
	lb $t0,($t0)			# t0 <- "-"
	la $t1,dausao
	lb $t1,($t1)			# t1 <- "*"
	la $t2,0			# length of socre = 0
	la $t4,0			#khoi tao number_of_hight_score = 0
	#-------------lap toi ki tu "-" dau tien--------------------------
TachChuoilayScore.LapToiKiTu:			
	# lay gia tri str[i], i = 0
	lb $a0,($s1)
	# tang $str
	addi $s1,$s1,1
	# str[i] != "-" thi lap
	bne $a0,$t0,TachChuoilayScore.LapToiKiTu
	
	#-----------lap toi ki tu "-" tiep theo de lay diem---------------
TachChuoilayScore.LapLayDiem:		
	# lay gia tri str[i]
	lb $a0,($s1)
	# str[i] != "-" thi lap
	bne $a0,$t0,TachChuoilayScore.LapLayDiem.TangDem
	beq $a0,$t0,TachChuoilayScore.ThoatLap.LayScore	# thoat lap sau khi da doc diem 1 nguoi choi
TachChuoilayScore.ThoatLap.LayScore:
	#khi lay duoc 1 score thi gan ki tu ket thuc chuoi
	sb $0,($t3) 
	#tru di $t3
	sub $t3,$t3,$t2
	la $t2,0 # length of socre = 0
	
	#debug
	#move $a0,$t3
	#li $v0,4 #4 is print string
	#syscall
	#goi ham String_to_Int de doi qua int roi luu vao arr
	
	#truyen tham so
	la $a0,($t3)
	
	#debug
	#goi ham String_to_int
	jal _StringToInt
	#lay gia tri tra ve
	sw $v0,($s0)
	addi $s0,$s0,4
	#debug
	#lw $a0,($s0)
	#li $v0,1
	#syscall
	
	
	
	#debug
	#move $a0,$s0
	#li $v0,1
	#syscall	
	
	#(tang dem $s0)
	
	addi $t4,$t4,1 #tang number of high score len 1
	j TachChuoilayScore.ThoatLap.Lap		
TachChuoilayScore.LapLayDiem.TangDem:							
	# in ra man hinh =>> DOI THANH INT => PUSH VAO ARR
	sb $a0,($t3) # load ki tu cua score vao $t3
	
	addi $t3,$t3,1 # tang dia chi $t3
	addi $t2,$t2,1 # tang length of score +=1

	
	#debug
	#li $v0,11
	#syscall
	
	# tang $str
	addi $s1,$s1,1												
	j TachChuoilayScore.LapLayDiem	
	
	#-------------------lap toi ki tu "*"-------------------------		 	
TachChuoilayScore.ThoatLap.Lap:	
	addi $s1,$s1,1
	lb $a0,($s1)
	bne $a0,$t1,TachChuoilayScore.ThoatLap.Lap	# chua gap "*" thi lap

	# kiem tra "*" la ki tu cuoi cung
	addi $s1,$s1,1
	lb $a0,($s1)
	beqz $a0,TachChuoilayScore.Thoat		# end of string thi thoat
	j TachChuoilayScore.LapToiKiTu	# quay lai tu dau lay diem nguoi choi tiep theo
	
TachChuoilayScore.Thoat:	  
	move $v0,$t4
	
	# restore thanh ghi
	lw $ra,($sp)
	lw $s0,4($sp)			
	lw $s1,8($sp)			
	lw $t0,12($sp)		
	lw $t1,16($sp)	
	sw $t2,20 ($sp)		 # the lengh of string of scores
	sw $t3,24 ($sp)         # string of score get from file
	sw $t4 ,28 ($sp)	#number of high score
	sw $t5, 32($sp)
	# xoa stack
	add $sp,$sp,36
	# quay ve 
  	jr $ra
####################################

# truyen vo $a0 <- $str
# tra ve $v0 = gia tri str
################## Ham _StringToInt #################################	
_StringToInt:	
	addi $sp,$sp,-32
	sw $ra,($sp)
	sw $t0,4($sp)
	sw $s0,8($sp)
	sw $t1,12($sp)
	sw $t2,16($sp)
	sw $t3,20($sp)
	sw $t4,24($sp)
	sw $s1,28($sp)
	
	move $s0,$a0 			# s0 <- &str
	
	#------------dem chuoi vua nhap co n ky tu-------------------
	# khoi tao
	li $t0,0 			# n = 0
SoKiTu.Lap:
	# doc 1 ki tu
	lb $a0,($s0)
	# kiem tra neu != 0 thi tang dem
	bnez $a0,SoKiTu.TangDem
	j SoKiTu.Thoat 
SoKiTu.TangDem:
	addi $t0,$t0,1 		# n ++	
	addi $s0,$s0,1 		# tang dia chi
	j SoKiTu.Lap
SoKiTu.Thoat:
	addi $s0,$s0,-1 		# giam s0 (vi [s0] dang la 0)

	#----------------------tinh ket qua-----------------------------
	
	#khoi tao
	li $t1,1			# i = 1
	li $t2,10			# 10
	li $t3,0			# dem = 0
	li $s1,0			# kq = 0
Value.Lap:
	slt $t4,$t3,$t0		# dem < n
	bne $t4,$0,Value.TangDem	
	beq $t4,$0,Value.Thoat	
	
Value.TangDem:
	# doc 1 ki tu ($s0 dang o vi tri cuoi cung)
	move $a0,$s0
	# lay gia tri ki tu (dung ham SimpleNum)
	jal _SimpleNum
	# lay kq tra ve
	move $a0,$v0
	
	mult $a0,$t1			# [str] * i
	mflo $a0
	add $s1,$s1,$a0		# kq += [str] * i
	# tang dem
	mult $t1,$t2			# i * 10
	mflo $t1
	addi $t3,$t3,1		# dem ++
	addi $s0,$s0,-1 		# giam dia chi
	j Value.Lap
			
Value.Thoat:						
	move $v0,$s1
	
	#debug
	#la $a0,($v0)								
	#li $v0,1 #4 is print string
	#syscall	
	
	lw $ra,($sp)
	lw $t0,4($sp)
	lw $s0,8($sp)
	lw $t1,12($sp)
	lw $t2,16($sp)
	lw $t3,20($sp)
	lw $t4,24($sp)
	lw $s1,28($sp)
	addi $sp,$sp,32
	jr $ra
########################################
	
								
# truyen vao a0 <- $str (0-9)
# tra ve $v0 = gia tri str	
################## Ham _SimpleNum ############################
_SimpleNum:
	addi $sp,$sp,-8
	sw $ra, ($sp)
	sw $s0,4($sp)
	
	lb $s0,($a0)
	
	beq $s0,48,Zero
	beq $s0,49,One
	beq $s0,50,Two
	beq $s0,51,Three
	beq $s0,52,Four
	beq $s0,53,Five
	beq $s0,54,Six
	beq $s0,55,Seven
	beq $s0,56,Eight
	beq $s0,57,Nine
Zero:
	li $v0,0
	j Exit
One:
	li $v0,1
	j Exit
Two:
	li $v0,2
	j Exit
Three:
	li $v0,3
	j Exit
Four:
	li $v0,4
	j Exit
Five:
	li $v0,5
	j Exit
Six:
	li $v0,6
	j Exit
Seven:
	li $v0,7
	j Exit
Eight:
	li $v0,8
	j Exit
Nine:
	li $v0,9
	j Exit
Exit:	
	lw $ra, ($sp)
	lw $s0,4($sp)
	addi $sp,$sp,8
	jr $ra
######################################
#=============== Xuat mang Int=================#
_XuatMangInt:
	addi $sp,$sp,-32
	sw $ra,($sp)
	sw $s0,4($sp) #n
	sw $s1,8($sp) #arr
	sw $t0,12($sp)
	sw $t1,16($sp)	
		
	#Lay tham so luu vao thanh ghi
	move $s0,$a0
	move $s1,$a1
#THan thu tuc
	#Khoi tao vong lap
	li $t0,0 #i=0
_XuatMangInt.Lap:
	#xuat arr[i]
	lw $a0,($s1)
	li $v0,1
	syscall
	
	#xuat khoang trang
	li $v0,11
	li $a0,' '
	syscall
	
	#tang dia chi mang
	addi $s1,$s1,4
	addi $t0,$t0,1
	
	#kiem tra i<n thi lap
	slt $t1,$t0,$s0
	beq $t1,1,_XuatMangInt.Lap

	#Cuoi thu tuc
		#restore
		lw $ra,($sp)
		lw $s0,4($sp) #n
		lw $s1,8($sp) #arr
		lw $t0,12($sp)
		lw $t1,16($sp)	
		
		#xoa stack
		addi $sp,$sp,32
		
		#tra ve 
		jr $ra
#=============== Xuat mang Int =================#  
#=============== Buble Sort ==============#
_Sort:
    addi $sp,$sp,-44
    sw $ra,($sp)
    sw $s0,4($sp) #n
    sw $s1,8($sp) #arr_score_i
    sw $s2,12($sp) #arr_score_j
    sw $s3,16($sp) #arr_player_tenp
    sw $s4,20($sp) #arr_player_tenp
    sw $t0,24($sp) #i
    sw $t1,28($sp)  #j
    sw $t3,32($sp)  #compare
    sw $t4,36($sp)  #Arr[i]
    sw $t5,40($sp)  #Arr[j]
    sw $t6,44($sp)  #gia tri bang 4
    #Lay tham so luu vao thanh ghi
    move $s0,$a0
    #load arr_score and arr_player
    la $a0,arr_player
    move $s1,$a1 #s1 arr_score
    move $s3,$a0 #s1 arr_score
#THan thu tuc
    #Khoi tao vong lap
    li $t0,0 #i=0
    li $t1,0 #j=0
_Sort.Lap_i:

    #xuat a[i]
    li $t1,0 #j=0   
    move $s2,$a1
    move $s4,$a0
    _Sort.Lap_j:
        #kiem tra de swap 
        lw $t4,($s1) #lay arr[i]
        lw $t5,($s2) #lay arr[j]
        slt $t3, $t4, $t5
        beq $t3,1,_Sort.continue
       
        #swap _ score
        sw  $t5, ($s1)  #gan a[i] bang a[j]
        li $t6,4 	#gan t6 = 4
        
        mult $t6,$t0   #lay 4*$t0(i*4)
        mflo $t3	#gan vao $t3
        
        sub $s1,$s1,$t3 #lui a[i] di $t3 vi tri
        
        mult $t6,$t1	#lay 4*$t0(j*4)
        mflo $t3	#gan vao $t3
        
        add $s1,$s1,$t3	#tien toi a[j] bang cach them a[0] j*4 vi tri
        sw  $t4, ($s1) #gan a[j] = a[i]
        
        sub $s1,$s1,$t3#tra lai ve a[0]
        
        mult $t6,$t0#i*4
        mflo $t3	#luu vao $t3
        
        add $s1,$s1,$t3#tra lai ve a[i]
        
        lw $t4,($s3) #lay arr[i]
        lw $t5,($s4) #lay arr[j]
         #swap _ player
        sw  $t5, ($s3)  #gan a[i] bang a[j]
        li $t6,4 	#gan t6 = 4
        
        mult $t6,$t0   #lay 4*$t0(i*4)
        mflo $t3	#gan vao $t3
        
        sub $s3,$s3,$t3 #lui a[i] di $t3 vi tri
        
        mult $t6,$t1	#lay 4*$t0(j*4)
        mflo $t3	#gan vao $t3
        
        add $s3,$s3,$t3	#tien toi a[j] bang cach them a[0] j*4 vi tri
        sw  $t4, ($s3) #gan a[j] = a[i]
        
        sub $s3,$s3,$t3#tra lai ve a[0]
        
        mult $t6,$t0#i*4
        mflo $t3	#luu vao $t3
        
        add $s3,$s3,$t3#tra lai ve a[i]
         
         
        _Sort.continue:
        #tang dia chi mang
        addi $s2,$s2,4  #arr_score[j++]
        addi $s4,$s4,4  #arr_player[j++]
        addi $t1,$t1,1 #tang j++
        
        #kiem tra i<n thi lap
        slt $t2,$t1,$s0
        beq $t2,1,_Sort.Lap_j
    
        
    #tang dia chi mang
    addi $s1,$s1,4  #arr_score[i++]
    addi $s3,$s3,4  #arr_player[i++]
    addi $t0,$t0,1 #tang i++
    #kiem tra i<n thi lap
    slt $t1,$t0,$s0
    beq $t1,1,_Sort.Lap_i
    
    #Cuoi thu tuc
        #restore
	lw $ra,($sp)
    	lw $s0,4($sp) #n
    	lw $s1,8($sp) #arr_score_i
    	lw $s2,12($sp) #arr_score_j
    	lw $s3,16($sp) #arr_player_tenp
    	lw $s4,20($sp) #arr_player_tenp
   	lw $t0,24($sp) #i
   	lw $t1,28($sp)  #j
   	lw $t3,32($sp)  #compare
    	lw $t4,36($sp)  #Arr[i]
    	lw $t5,40($sp)  #Arr[j]
    	lw $t6,44($sp)  #gia tri bang 4
        
        #xoa stack
        addi $sp,$sp,44
        
        #tra ve 
        jr $ra
#=============== Buble Sort ==============#
############## Ham _TachChuoi lay Player ######################
_TachChuoilayPlayer:
	# khai bao kich thuoc stack
	add $sp,$sp,-28
	
	sw $ra,($sp)
	sw $s0,4($sp)		 # arr_player	
	sw $s1,8($sp)		 # str	
	sw $t0,12($sp)		 # character "-"
	sw $t1,16($sp)		 # character "*"
	sw $t2,20 ($sp)		 # the lengh of string of player
	sw $t3,24 ($sp)         # string of score get from file
	move $s0,$a0			# s0 <- $arr_player
	move $s1,$a1			# s1 <- $str
	la $t3,str_player			#khoi tao $t3 - not important
	
	#khoi tao
	la $t0,daucach				
	lb $t0,($t0)			# t0 <- "-"
	la $t1,dausao
	lb $t1,($t1)			# t1 <- "*"
	la $t2,0			# length of socre = 0
	la $t4,0			# length of socre = 0
	#-------------doc ten dau tien --------------------------
TachChuoilayPlayer.GetPlayer_1st:			
	
	lbu $a0,($s1)
	
	beq $a0,$t0,TachChuoilayPlayer.StorePlayertoArr
	#ghi player 1st
	sb $a0,($t3)
	addi $t3,$t3,1 # increase pointer
	addi $t2,$t2,1 # length of str_player +=1
	addi $s1,$s1,1
	#
	j TachChuoilayPlayer.GetPlayer_1st 	
TachChuoilayPlayer.Lap:
	lb $a0,($s1)
	beq $a0,$t1,TachChuoilayPlayer.GetPlayer
	addi $s1,$s1,1
	j TachChuoilayPlayer.Lap
	
TachChuoilayPlayer.GetPlayer:	
	addi $s1,$s1,1
	lbu $a0,($s1)
	beqz $a0,TachChuoilayPlayer.Thoat
	beq $a0,$t0,TachChuoilayPlayer.StorePlayertoArr
	#lay player luu vao $t3
	sb $a0,($t3)
	addi $t3,$t3,1
	addi $t2,$t2,1 # length of str_player +=1
	j TachChuoilayPlayer.GetPlayer
TachChuoilayPlayer.StorePlayertoArr:
	sb $0,($t3)
	sub  $t3,$t3,$t2 #tra con tro ve ban dau
	#luu $t3 vao arr_player
	sw $t3,($s0)
	addi $t2,$t2,1
	add $t3,$t3,$t2
	add $t2,$0,$0 # length of str_player = 0
	addi $s0,$s0,4
	j TachChuoilayPlayer.Lap
TachChuoilayPlayer.Thoat:	  
	
	# restore thanh ghi
	lw $ra,($sp)
	lw $s0,4($sp)		 # arr_player	
	lw $s1,8($sp)		 # str	
	lw $t0,12($sp)		 # character "-"
	lw $t1,16($sp)		 # character "*"
	lw $t2,20 ($sp)		 # the lengh of string of scores
	lw $t3,24 ($sp)         # string of score get from file
	# xoa stack
	add $sp,$sp,28
	# quay ve 
  	jr $ra
####################################
# truyen vo $a0 <- $player_arr
# tra ve 
#=============== Xuat mang Player =================#
_XuatMangPlayer:
	addi $sp,$sp,-20
	sw $ra,($sp)
	sw $s0,4($sp) #n
	sw $s1,8($sp) #arr
	sw $t0,12($sp)
	sw $t1,16($sp)	
	
	#Lay tham so luu vao thanh ghi
	move $s0,$a0 #n
	move $s1,$a1 #arr_player
	
	
#THan thu tuc
	#Khoi tao vong lap
	li $t0,0 #i=0
	
_XuatMangPlayer.Lap:
	#xuat arr[i]
	lw $a0,($s1)
	li $v0, 4 #4 is print string
	syscall
	#xuat khoang trang
	li $v0, 11
	li $a0,' '
	syscall
	
	#tang dia chi mang
	addi $s1,$s1,4
	addi $t0,$t0,1
	#kiem tra i<n thi lap
	slt $t1,$t0,$s0
	beq $t1,1,_XuatMangPlayer.Lap

	#Cuoi thu tuc
	#restore
	lw $ra,($sp)
	lw $s0,4($sp) #n
	lw $s1,8($sp) #arr
	lw $t0,12($sp)
	lw $t1,16($sp)	
		
	#xoa stack
	addi $sp,$sp,20
		
	#tra ve 
	jr $ra
#=============== Xuat mang Player =================#  
#=============== Xuat Top 10 Player and score =================#
_XuatTop10:
	addi $sp,$sp,-20
	sw $ra,($sp)
	sw $s0,4($sp) #n
	sw $s1,8($sp) #arr_player
	sw $s2,12($sp) #arr_score
	sw $t0,16($sp)
	sw $t1,20($sp)	
	
	
	#Lay tham so luu vao thanh ghi
	move $s0,$a0 #n
	la $s1,arr_player
	la $s2,arr_score
	
	
	
#THan thu tuc
	#Khoi tao vong lap
	li $t0,0 #$t0 = 0
	li $t1,10
blt  $s0,10,_XuatTop10.Lap	
#kiem tra xem #n co lon hon 10 khong
bgt  $s0,10,_XuatTop10.setNto10
_XuatTop10.setNto10:
	add $s0,$zero,10
	j _XuatTop10.Lap
	
_XuatTop10.Lap:
	#xuat ki tu xuong don
	li $v0, 11
	li $a0,'\n'
	syscall
	#xuat arr[i]
	lw $a0,($s1)
	li $v0, 4 #4 is print string
	syscall
	#xuat khoang trang
	li $v0, 11
	li $a0,' '
	syscall
	
	lw $a0,($s2)
	li $v0, 1 #4 is print string
	syscall
	
	
	#tang dia chi mang
	addi $s1,$s1,4
	addi $s2,$s2,4
	addi $t0,$t0,1
	#kiem tra i<n thi lap
	slt $t1,$t0,$s0
	beq $t1,1,_XuatTop10.Lap

	#Cuoi thu tuc
	#restore
	lw $ra,($sp)
	lw $s0,4($sp) #n
	lw $s1,8($sp) #arr
	lw $t0,12($sp)
	lw $t1,16($sp)	
		
	#xoa stack
	addi $sp,$sp,20
		
	#tra ve 
	jr $ra
#=============== Xuat mang Player =================#  