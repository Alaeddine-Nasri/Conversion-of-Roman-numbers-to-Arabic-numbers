
include 'emu8086.inc'

data segment


     entete  DB 9,9,201,55 dup (205),187,13,10

            DB 9,9,186,"                TP1 D'ASSEMBLEUR                       ",186,13,10
            DB 9,9,186,"  REALISE PAR: BERRAOUI DJIHANE -  DRACENI AMINA       ",186,13,10
            DB 9,9,186,"         SECTION: A           GROUPE: 03               ",186,13,10
            DB 9,9,186,"          ANNEE UNIVERSITAIRE: 2018/2019               ",186,13,10
            DB 9,9,200,55 dup (205),188,13,10,13,10,'$'







    entree db "Bienvenue dans notre programme",10,13,"$"
    entree2 db 10,13,"Le principe de ce programme est:  $"
    entree3 db 10,13,"-Faire une conversion des nombres arabes en romain$"
    entree4 db 10,13,"-Faire une conversion des nombres romains en arabe",10,13,"$"


    
    touche db 10,13,10,13,"Appuyez sur une touche pour continuer...$"

    msg db 10,13,"Entrez votre reponse: $"   
    choix db 10,13,"Choisissez la conversion qui vous convient en entrant 1 ou 2 ou 3",10,13,"$"
    choix1 db 10,13,"1-Conversion Arabe-->Romain$"
    choix2 db 10,13,"2-Conversion Romain-->Arabe$"
     choix3 db 10,13,"3-Quitter le programme",10,13,"$"
   
     saisie_choix  db 10,13,"Veuillez entrer votre choix <1, 2, 3>$"
    msg3 db 10,13,"Voulez vous reessayer avec un autre nombre ? (y^n) $"


     ;messages d'erreurs procedure validation chiffre romain
    N_vld1 db 10,13,"Un meme caractere ne peut pas se repeter plus de trois fois $"
    N_vld2 db 10,13,"'I' ne peut etre suivi que par 'X', 'V', 'I' $"
    N_vld3 db 10,13,"'V' ne peut etre suivi que par 'I' $"
    N_vld4 db 10,13,"'X' ne peut pas etre suivi par 'D' ou 'M' $";une erreur: XV est juste 
    N_vld5 db 10,13,"'L' ne peut etre suivi que par 'X', 'V' ou 'I'$"
    N_vld7 db 10,13,"'D' ne peut etre suivi que par 'C', 'L', 'X', 'V' ou 'I' $"
    n_existe db 10,13, " ce caractere n existe pas dans les nombres romains $"
    N_vld8 db 10,13," 'C' ne peut etre suivi que par 'I', 'V', ou 'L' $"
    
    saisie_nbr db 10,13,"Veuillez entrer un nombre   $"
    after_conversion db 10,13,"Le resultat de la conversion est  $"
    
    test_valide db 10,13,"Pour pouvoir convertir un nombre on s'assure qu'il est valide $"
    v_valide db 10,13,"Votre nombre est valide Veuillez le reinserer pour le convertir $"
    N_valide db 10,13,"votre nombre est non valide, la conversion est donc impossible  $"


    ;variable des procedures
    caspe db "0000$"
    ;erreur1 db 10,13,"N'inserez que des chiffres entre 0 et 9 $"
    erreur2 db 10,13,"Le nombre doit etre compris entre 1 et 3999 $"
    multip dw 1
    lecture db 5,?,9 dup(?)
    lecture2 db 10,?,9 dup(?)
    sauv dw ?
    bool dw 0 ;bool est un booleen qui est a 0 si la lecture a bien ete effectuee
     nombre Dw 16 dup(?),'$' 
     msg_err2 DB 13,10,'/!\ ERREUR ! le nombre entre est invalide.',13,10,'Veuillez entrer un autre nombre  :  ','$'
    ;test
    valeur dw 0

    ;variable de la validation romain
    romain db "I","V","X","L","C","D","M" ;tableau des nombres romains
    arabe dw 1h,5h,10d,50d,100d,500d,1000d
    nb_arb db 10  dup("$")
    nb_rom db 10,?,10 dup("$")
    affiche db 10 dup("$")
                                       
    valide dw 1d   ;initialise a vrai(1)
    cpt dw 0d
      
    ;variables de la conversion romaine arabe 
    msg1 db "saisir le cara$"
    msgE db "Le nombre est faux$"
    msg2 db 10,13,,10,13,"Votre nombre est : $"
    pkey db "press any key...$" 
    lect db 10,?,10 dup(0) 
     
    tabromain db "I","V","X","L","C","D","M" ;tableau des nombres romains
    tabarab dw 1h,5d,10d,50d,100d,500d,1000d
    nb_arab dw 0h,0h,0h,0h,0h

    taille dw 0     
    tmp dw 0
    e dw 0
    now dw 0
    res dw 0
    i dw 0 
    
    



ends

stack segment
    dw   128  dup(0)
ends

code segment
                                                                                                   
                                                                                                   
;************************************************************************************************
                                                                                                   
                                                                                                   
                                                                                                   
    

;*******************PROCEDURE LECTURE***********************************

lire proc

    ; SI contient l'adresse du mot memoire ou la valeur doit etre rangee

    mov multip,1
    mov bool,0


    ;lecture du nombre
    MOV AH,10
    LEA DX,lecture
    INT 33

    mov ax,[si]
    mov sauv,ax
    mov [si],0
    mov [si+1],0

    ;conversion en decimal


    mov al,[lecture+1]  ; lecture+1 continet la longeur de la chaine
    cbw        ;convert byte to word
  ;  sub cx,1      //ask mehdi
    mov cx,ax
    mov si,0
    convert:

    mov di,cx  ;//pour parcourir la chaine
    mov Al,[lecture+di+1]  ;commencer par le poids faible  //loop dec le cx car on commence cx = la longeur
    cbw
    mov nb_arb[si],al
    inc si
    cmp ax,32   ;si le caract�re est un espace
    je espace    ;verifier que le caractere est entre 0 et 9

    sub ax,30h



    cmp ax,0
    jl errorneg
    cmp ax,10
    jge error
    mov dx,0

    mov bx,multip        ;multip contient les puissances de 10
    mul bx

    cmp dx,0       ;la fin de la chaine
    jne depas
    cmp ax,0
    jl depas

    add ax,[si]

    cmp ax,0000h        ;verifier que le nombre n'est pas 0000
    je casspe

    cmp ax,0F9Fh        ;verifier que le nombre ne depasse pas 3999
    jg casspe



    mov [si],ax       ;remplacer valeur  //ask mehdi

    mov ax,10
    mul bx                ;multiplier multip par 10
    mov multip,ax

    ; on les stock dans un tableau //li tekhdem bih amina

    loop convert ;reconstruire le nombre

    jmp fin

    espace:

    cmp cl,[lecture+1]
    jne espdebut         ;ignorer les espaces a la fin
    dec cx
    dec [lecture+1]
    jmp convert
espdebut:

    dec cx
    mov di,cx
    cmp cx,0                 ;ignorer les espaces au debut
    je fin
    mov Al,[lecture+di+1]
    cbw

    cmp ax,32
    je espdebut
    sub ax,30h
    jmp errorneg





    errorneg:
    add ax,30h

    cmp cx,1
    jne error

    cmp al,43             ;verifier si premier caractere est '+'
    je fin

    cmp al,45              ;verifier si le premier caractere est '-'
    jne error

    mov ax,0
    mov bx,[si]
    sub ax,bx
    mov [si],ax          ; si oui prendre -result
    jmp fin

    error:

   
    mov ax,sauv             ;erreur caractere non ascii
    mov [si],ax

    mov bool,1

    jmp fin

    casspe:
    cmp di,2
    jne depas
    mov dx,ax
    mov Al,[lecture+di]
    cmp al,45
    jne depas
    mov ax,0
    sub ax,dx
    mov [si],ax
    jmp fin




    depas:

    lea dx,erreur2          ;cas d'overflow
    mov ah, 9
    int 21h
    mov ax,sauv
    mov [si],ax

    mov bool,1


 fin:

    mov multip,1
    RET

    lire endp                                                                                                   
                                                                                                   
                                                                                                   
 ;**************************************VALIDATION*************************************
 validation proc 
    
    ;affichag saisie_nbr
    lea dx, saisie_nbr
    mov ah, 9
    int 21h
    
    
        MOV DI,offset nombre


;lect1:
          MOV AH,10
          LEA DX,lecture2
          INT 33


    mov ax,[si]
    mov sauv,ax
    mov [si],0
    mov [si+1],0

            MOV ax,0

           mov al,[lecture2+1]
           mov cx,ax
           mov si,0
           mov di,1
         convert2:
          ; mov di,cx
           mov al,[lecture2+di+1]
           cbw
           mov nb_rom[si],al
           inc si
           inc di
           loop convert2



           MOV SI,offset nombre
    mov si,0
    mov di,1
    MOV CPT,0
    TANTQUE:
    ;test

        cmp nb_rom[si],"$"
        je FINBOUCLE
        cmp valide,0d
        je FINBOUCLE

        ;test1
        ;Un nombre ne se repete pas plus de 4 fois
        mov bl,nb_rom[di]
        mov al,nb_rom[si]
        cmp al,bl
        jne SINON1
        inc cpt ;cpt:= cpt+1
        cmp cpt,3d
        jl SI2
        ;si cpt >3
        mov valide,0d ;valide := Faux
        ; Affichage message d'erreur
        lea dx,N_vld1
        mov ah,9
        int 21h
        jmp FINTQ

    SINON1: MOV cpt,0d ;reinitialiser cpt
            jmp SI2
    SI2:
      cmp al,49h ; comparer caractere courant a 'I'
      jne SI4
      cmp bl,58h ;comaprer le suivant de 'I' a 'X'
      je SI4
      cmp bl,56h ;comaprer le suivant de 'I' a 'V'
      je SI4
      cmp bl,49h ;comaprer le suivant de 'I' a 'I'
      je SI4
      cmp bl,24H ;comparer le suivant a '$'
      je FINTQ
      mov valide,0d
      ;Affichage du message d'erreur
      lea dx,N_vld2
      mov ah,9
      int 21h
      jmp FINTQ

    SI4:
      cmp al,56h ;comaprer le charactere de 'V'
      jne SI5
      cmp bl,49h ;comaprer le suivant de 'V' a 'I'
      je SI5
      cmp bl,24H ;comparer le suivant a '$'
      je FINTQ
      mov valide,0h
      lea dx,N_vld3
      mov ah,9
      int 21h
      jmp FINTQ

    SI5:
      cmp al,58h ;comparer le caractere courant a "X"
      JNE SI6
      cmp bl,4dh ;comaprer le suivant de 'X' a 'M'
      je ERREUR
      cmp bx,44h ;comaprer le suivant de 'X' a 'D'
      je ERREUR
      cmp bl,24H ;comparer le suivant a '$'
      je FINTQ
      JMP  FINTQ
ERREUR:
      mov valide,0
      lea dx,N_vld4
      mov ah,9
      int 21h
      jmp FINTQ

    SI6:
      cmp al,4ch  ;comparer le caractere courant a "L"
      jne Si7
      cmp bl,58h ;comaprer le suivant de 'L' a 'X'
      Je FINTQ
      cmp bl,56h ;comaprer le suivant de 'L' a 'v'
      JE FINTQ
      cmp bl,49h
      je FINTQ
      cmp bl,24H ;comparer le suivant a '$'
      je FINTQ
      mov valide,0d
      lea dx,N_vld5
      mov ah,9
      int 21h
      jmp FINTQ

    SI7:
      cmp al,44h ;comparer le caractere courant a "D"
      jne SI8
      cmp bl,4dh ;comaprer le suivant de 'D' a 'M'
      jne FINTQ
      mov valide,0
      lea dx,N_vld7
      mov ah,9
      int 21h
      jmp FINTQ
      ;test7
  si8:cmp al,43h  ;comparer le caractere courant a "c"
      jne FINTQ
      cmp bl,49h ;comaprer le suivant de 'C' a 'I'
      je FINTQ
      cmp bl,56h ;comaprer le suivant de 'C' a 'v'
      je FINTQ
      cmp bl,4ch ;comaprer le suivant de 'C' a 'L'
      je FINTQ
      cmp bl,58h ;comaprer le suivant de 'C' a 'x'
      je FINTQ
      cmp bl,24H ;comparer le suivant a '$'
      je FINTQ
      mov valide,0
      lea dx,N_vld8
      mov ah,9
      int 21h
      jmp FINTQ
    FINTQ:
      inc si
      inc di
      jmp TANTQUE
;existepas:
;      lea dx,n_existe
 ;     mov ah,9
  ;    int 21h
   ;   jmp FINBOUCLE
    FINBOUCLE:
      ;MOV valide,1d
      mov ax,0h
      mov bx,0h
      RET
      validation endp
;****************************************************************************************** 




;**************************conversion arabe romaine***************************            
      conv_arb_rom proc 
        
        ;affichag saisie_nbr
        lea dx, saisie_nbr
        mov ah, 9
        int 21h
        
        
        
        
        
        call lire
        mov ax,0d 
        mov cx,0d
        mov si,0d 
        mov di,0d 
        mov bx,0d 
        
        bcl: 
        
        mov al,nb_arb[bx]
        sub al,30h
        cmp al,0h     ;si le chiffre est egale a 0
        je suite
        cmp al,5d    ;on comparre le chiffre avec 5
        je egale
        jl petit
        jg grand
        egale:             ;si le chiffre est egale a 5
        mov al,romain[si+1]
        mov nb_rom[di],al
        inc di
        jmp suite
        petit:         ;si l chiffre est inferieure a 5
        cmp al,4d
        je four 
        mov cx,ax
        mov al,romain[si]
        bcl2:
        mov nb_rom[di],al
        inc di
        loop bcl2
        jmp suite
        four:             ;si le chiffre est egale a 4 (cas special)
        mov al,romain[si+1]
        mov nb_rom[di],al
        inc di
        mov al,romain[si]
        mov nb_rom[di],al
        inc di
        jmp suite
        grand:      ;si le chiffre est superieure a 5
        cmp al,9d
        je nine
        mov al,romain[si]
        mov nb_rom[di],al
        inc di
        sub nb_arb[bx],35h
        mov cx,ax
        mov al,romain[si]
        bcl3:
        mov nb_rom[di],al
        inc di
        loop bcl3 
        nine:             ;si le chiffre est egale a 9 (cas special)
        mov al,romain[si+2]
        mov nb_rom[di],al
        inc di
        mov al,romain[si]
        mov nb_rom[di],al
        inc di
        suite:
        inc bx 
        mov ax,bx
        mov dx,2d
        mul dx
        mov si,ax
        cmp si,6d      ;cas special (1000/2000/3000) 
        jne suite2:
        mov al,nb_arb[bx]
        sub al,30h
        cmp al,0h
        je fin1 
 
        mov cx,ax
        mov al,romain[si]
        bcl4:
        mov nb_rom[di],al
        inc di
        loop bcl4
        jmp fin
suite2:
        cmp bx,3d
        jle bcl
        fin1:
         
        ret
        conv_arb_rom endp     
            
;*********************************************************************************** 
conv_rom_arb proc 
    
    ;affichag saisie_nbr
    lea dx, saisie_nbr
    mov ah, 9
    int 21h
    
    
    
    
    
        mov ax,0d 
        mov cx,0d
        mov si,0d 
        mov di,0d 
        mov bx,0d 
      
Romain_Arab:
    
    mov bx,0 ; initialisation     
    
    reading:                  ;reading cara
    mov ah,01h
    int 21h
    
    cmp al,13         ; sortir dans le cas de entrer  
    mov dx,bx
    JE CBN
     
    mov romain  [bx],al   ; remplir la chaine
    inc bx  
    
    JMP reading 
       
CBN:
     ;remplir le tableau des entiers   
                 
     mov taille,dx            
     mov di,0 
     mov i,0
     mov ax,0 
     add dx,dx
     chaine:   
         mov bx,0  
         mov si,0
         mov bl,romain[di]  ; pour la comparaison
     indice:
         cmp bl,tabromain[si]     ;recuperer l'equivalent
         JE found
         INC si  
         cmp si,7d
         JE ERROR1  ;cas Boucle infinie  
         JMP indice
     found:
         mov bx,i
         add si,si 
         mov ax,tabarab[si]    ; remplir tabarab
         mov nb_arab[bx],ax  
         inc di 
         INC bx   
         INC bx
         mov i,bx
         cmp dx,i 
         JE pret  
         JL ERROR1 ;cas Boucle infinie 
         JMP chaine   
         
pret: 
    mov res,0
    mov di,0
    etiq:  
        mov cx,0
        mov bx,taille
        add bx,bx  
        cmp di,bx
        JE print
        mov ax,nb_arab[di]
        mov tmp,ax
        INC di
        INC di
        mov ax,nb_arab[di]
        cmp tmp,ax  
        JG greater
        JE equal
        JL less
        
        equal:  
            cmp E,0
            JE deux
            troix:  
                add ax,tmp
                add E,ax 
                mov ax,E
                SUB ax,tmp
                mov E,ax
                JMP etiq 
            deux:
            add ax,tmp
            add E,ax 
            JMP etiq  
        greater:
            add cx,tmp 
            add cx,E
            add res,cx 
            cmp E,0
            JE etiq
            SUB cx,E
            SUB res,cx
            mov E,0 
            JMP etiq
        less: 
            INC di
            INC di
            mov cx,ax   
            SUB cx,E
            SUB cx,tmp
            add res,cx
            cmp E,0
            JE etiq
            mov cx,tmp 
            add res,cx
            mov E,0
            JMP etiq
            
        mov bx,E
        add res,bx
         
         ;affichag after_conversion
    lea dx, after_conversion
    mov ah, 9
    int 21h
                           
print:

    mov dx,offset msg2
    mov ah,09h
    int 21h  
      
    mov ax,res  
    CALL   print_num      ; print number in AX.
                           
            
            
    ;;lea dx, pkey
    ;;mov ah, 9
    ;int 21h        ; output string at ds:dx
    
    ; wait for any key....    
    ;;mov ah, 1
    ;;int 21h      
ERROR1:   
    ;mov dx,offset msgE
    ;mov ah,09h
    ;int 21h           
                
EXIT:            
            

 conv_rom_arb endp









;*******************************************************************************************
start:
; set segment registers:
    mov ax, data
    mov ds, ax
    mov es, ax
    
;***********************INTRODUCTION***************************
    lea dx, entete
    mov ah, 9
    int 21h


    lea dx, entree
    mov ah, 9               ; message d'entree
    int 21h
    lea dx, entree2
    mov ah, 9               ; message d'entree
    int 21h
    lea dx, entree3
    mov ah, 9               ; message d'entree
    int 21h
    lea dx, entree4
    mov ah, 9               ; message d'entree
    int 21h


   

    lea dx, touche      ;appuyez sur une touche pour continuer
    mov ah, 9
    int 21h
    mov     ax,0c01h
    int     21h



    call CLEAR_SCREEN
    
    lea dx, choix
    mov ah, 9
    int 21h      
    lea dx, choix1
    mov ah, 9
    int 21h
    lea dx, choix2
    mov ah, 9
    int 21h  
    lea dx, choix3
    mov ah, 9
    int 21h      
    
    ;affichag saisie_choix
    lea dx, saisie_choix
    mov ah, 9
    int 21h
    
    
    
    
    ;pour entrez la reponse
    mov ah,1
    int 21h 
    
       
    cmp aL,31h
    je conversion_arb_rom
    cmp aL,32h
    je conversion_rom_arb
    cmp aL,33h
    je endfins 
      
      
      
      
      
    conversion_arb_rom:
    call conv_arb_rom
    
    ;affichag after_conversion
    lea dx, after_conversion
    mov ah, 9
    int 21h
    
     
    mov si,0 
    mov bx,0
    bcl8:
     cmp nb_rom[si],"$"
     je finbcl8
     inc bx
     inc si
     jmp bcl8
     finbcl8:
    
    mov si,0 
    mov al,0
    mov di,bx
    bcl9:
    mov al,nb_rom[di-1]
    mov affiche[si],al 
    inc si
    dec di
    cmp di,1
    jge bcl9
    
    lea dx,affiche
    mov ah,9
    int 21h
     
    jmp endfins  
    conversion_rom_arb:
    
    ;affichag test_valide
    lea dx, test_valide
    mov ah, 9
    int 21h 
    
    
    
    call validation
    
    cmp valide,0 
    je faux
    
    ;affichag v_valide
    lea dx, v_valide
    mov ah, 9
    int 21h 
    
    call conv_rom_arb
    jmp endfins
    
    
    faux:
    
     ;affichag N_valide
    lea dx, N_valide
    mov ah, 9
    int 21h
    
    
    
    
    
    
    
    
    
    endfins:
    
    ends
            
DEFINE_PRINT_STRING

DEFINE_CLEAR_SCREEN 
DEFINE_PRINT_NUM
DEFINE_PRINT_NUM_UNS

end start ; set entry point and stop the assembler.
            