.data
    ang: .asciiz "Ingresar el ángulo: " 
    msg: .asciiz "1)Seno\n2)Coseno\nEscoger operación: "
    res: .asciiz "\nElresultado es: "
    uno: .double 1.0
    pdec: .double 0.1
    sdec: .double 0.01
    tdec: .double 0.001
    cdec: .double 0.0001
    qdec: .double 0.00001
.text
main:

    # Se imprime el string que pide ingresar un ángulo
    li $v0, 4
    la $a0, ang
    syscall
    # Se guarda el valor del angulo ingresado
    li $v0, 5
    syscall
    # Se mueve el valor al registro t0
    move $t0, $v0
    # Se copia el valor del angulo en el registro t1 y t2
    add $t1, $t0, $zero
    add $t2, $t0, $zero
    # Se imprime el string con el menú para pedir calculaar seno o coseno del angulo
    li $v0, 4
    la $a0, msg
    syscall
    # Se guarda el valor ingresado
    li $v0, 5
    syscall
    # Se resetea el contenido del registro a0
    add $a0, $zero, $zero
    # De pendiendo del valor ingresado se salta a la operación correspondiente
    beq $v0, 1, seno
    beq $v0, 2, coseno
    
seno:

    # Si el angulo es negativo se salta a signo_sen
    bltz $t0, signo_sen
    # Se copia en s1 el contenido de t0
    add $s1, $t0, $zero
    # Se carga el double uno en f2
    l.d $f2, uno
    # Se salta a guardar el angulo en flotante(primer termino de la serie de Taylor)
    jal gdec
    # Se mueve el resultado de gdec a f4
    mov.d $f4, $f0
    # Se resetea f0
    mov.d $f0, $f30
    # Se salta a calcular el cuadrado del angulo ingresado
    jal cuadrado
    # Se mueve el cuadrado de a0 a t0
    move $t0, $a0
    # Se resetea a0
    add $a0, $zero, $zero
    # Se copia el cuadrado en t2
    add $t2, $t0, $zero
    # Se salta a la multiplicación para calcular x^3
    jal multiplicacion
    # Se mueve el resultado de x^3 a s5
    move $s5, $a0
    # Se carga un 6(3!) en s6
    li $s6, 6
    # Se salta a la división para calcular el segundo termino de la serie de Taylor
    jal control_division
    # Se mueve el resultado de la división a f6 (segundo termino del seno en serie de Taylor)
    mov.d $f6, $f0
    # Se resetea f0
    mov.d $f0, $f30
    # Se mueve  x^3 a t1
    move $t1, $a0
    # Se resetea a0
    add $a0, $zero, $zero
    # Se copia el contenido de t0 (el cuadrado del angulo) en t2
    add $t2, $t0, $zero
    # Se salta a calcular x^5, multiplicando x^3 * x^2
    jal multiplicacion
    # Se mueve el resultado de x^5 a s5
    move $s5, $a0
    # Se carga un 120(5!) en s6
    li $s6, 120
    # Se salta a la división para calcular el tercer termino de la serie de Taylor
    jal control_division
    # Se mueve el resultado de la división a f8 (tercer termino de la serie de Taylor)
    mov.d $f8, $f0
    # Se resetea f0
    mov.d $f0, $f30
    # Se mueve  x^5 a t1
    move $t1, $a0
    # Se resetea a0
    add $a0, $zero, $zero
    # Se copia el contenido de t0 (el cuadrado del angulo) en t2
    add $t2, $t0, $zero
    # Se salta a calcular x^7, multiplicando x^5 * x^2
    jal multiplicacion
    # Se mueve el resultado de x^7 a s5
    move $s5, $a0
    # Se carga un 5040(7!) en s6
    li $s6, 5040
    # Se salta a la división para calcular el cuarto termino de la serie de Taylor
    jal control_division
    mov.d $f10, $f0
    # Se mueve el resultado de la división a f10 (cuarto termino de la serie de Taylor)
    mov.d $f0, $f30
    # Se guarda en f12 el resultado de el primer termino - el segundo termino 
    sub.d $f12, $f4, $f6
    # Se guarda en f12 el resultado de la primera operacion + el tercer termino
    add.d $f12, $f12, $f8
    # Se guarda en f12 el resultado de la segunda operacion - el cuarto termino
    sub.d $f12, $f12, $f10
    # Si en a3 hay un 1 se salta a res_sen
    beq $a3, 1, res_sen
    # Sino se salta a fin
    j fin

coseno:

    # Si el angulo es negativo se salta a signo_sen
    bltz $t0, signo_cos
    # Se copia en s1 el contenido de t0
    add $s1, $t0, $zero   
    # Se resetea a0
    add $a0, $zero, $zero
    # Se copia el angulo en t2
    add $t2, $t0, $zero
    # Se calcula el cuadrado del angulos
    jal cuadrado
    # Se copia el cuadrado del angulo en a0
    add $t0, $a0, $zero
    # Se mueve el cuadrado del angulo a s5
    move $s5, $a0
    # Se carga un 2(2!) en s6
    li $s6, 2
    # Se salta a la división para calcular el segundo termino de la serie de Taylor
    jal control_division
    # Se mueve el segundo termino a f4
    mov.d $f4, $f0
    # Se resetea f0
    mov.d $f0, $f30
    # Se mueve  x^2 a t1
    move $t1, $a0
    # Se resetea a0
    add $a0, $zero, $zero
    # Se copia  x^2 en t2
    add $t2, $t0, $zero
    # Se salta a calcular x^4
    jal multiplicacion
    # Se mueve x^4 a s5
    move $s5, $a0
    # Se carga un 24(4!) en s6
    li $s6, 24
    # Se salta a la división para calcular el tercer termino de la serie de Taylor
    jal control_division
    # Se mueve el tercer termino a f4
    mov.d $f6, $f0
    # Se resetea f0
    mov.d $f0, $f30
    # Se mueve  x^4 a t1
    move $t1, $a0
    # Se resetea a0
    add $a0, $zero, $zero
    # Se copia  x^4 en t2
    add $t2, $t0, $zero
    # Se salta a calcular x^6
    jal multiplicacion
    # Se mueve x^6 a s5
    move $s5, $a0
    # Se carga un 720(6!) en s6
    li $s6, 720
    # Se salta a la división para calcular el cuarto termino de la serie de Taylor
    jal control_division
    # Se mueve el cuarto termino a f4
    mov.d $f8, $f0
    # Se resetea f0
    mov.d $f0, $f30
    # Se mueve  x^6 a t1
    move $t1, $a0
    # Se resetea a0
    add $a0, $zero, $zero
    # Se copia  x^6 en t2
    add $t2, $t0, $zero
    # Se salta a calcular x^8
    jal multiplicacion
    # Se mueve x^8 a s5
    move $s5, $a0
    # Se carga un 40320(8!) en s6
    li $s6, 40320
    # Se salta a la división para calcular el quinto termino de la serie de Taylor
    jal control_division
    # Se mueve el quinto termino a f4
    mov.d $f10, $f0
    # Se resetea f0
    mov.d $f0, $f30
    # Se carga un 1.o en f2 que es el primer termino de la serie de Taylor
    l.d $f2, uno
    # Se calcla el primer termino - el segundo
    sub.d $f12, $f2, $f4
    # Al resultado se le suma el tercer termino
    add.d $f12, $f12, $f6
    # Al resultado se le reste el cuarto termino
    sub.d $f12, $f12, $f8
    # Al resultado se le suma el quinto termino
    add.d $f12, $f12, $f10
    # Se salta a fin
    j fin
    
signo_sen:

    # Si el angulo ingresado es negativo y la operacion escogida es seno se guarda un 1 en a3
    slt $a3, $t0, $zero
    # Se hace positivo el angulo
    sub $t0, $zero, $t0
    # Se copia el valor del angulo positivo en t1 y t2
    add $t1, $t0, $zero
    add $t2, $t0, $zero
    # Se vuelve a seno
    j seno
    
signo_cos:

    # Se hace positivo el angulo, al ser coseno una funcion par cos(-x)=cos(x)
    sub $t0, $zero, $t0
    # Se copia el valor del angulo positivo en t1 y t2
    add $t1, $t0, $zero
    add $t2, $t0, $zero
    # Se vuelve a coseno
    j coseno
    
res_sen:

    # Si el angulo era originalmente negativo, se cambia de signo el resultado, ya que al ser una funcion impar el seno, sen(-x)= -sen(x)
    sub.d $f12, $f30, $f12
    # Se salta a fin
    j fin
    
gdec:

    # Si en s1 hay un 0 se salta a volver
    beqz $s1, volver
    # Se suma un 1.0 a f0 y se guarda en f0
    add.d $f0, $f0, $f2
    # Se resta un 1 a s1 y se guarda en 1
    subi $s1, $s1, 1
    # Se vuelve al inicio del loop
    j gdec

cuadrado:

    #Si en t2 hay un 0 se salta a volver
    beq $t2, 0, volver 
    # Se añade en a0 el contenido de a0 + el contenido de t1
    add $a0, $t1, $a0
    # Se resta 1 al primer numero que está en $t3
    subi $t2, $t2, 1 
    # Se vuelve al inicio de cuadrado en loop
    j cuadrado

multiplicacion:

    #Si en t3 hay un 0 se salta a volver
    beq $t2, 0, volver 
    # Se añade en a0 el contenido de a0 + el contenido de t1
    add $a0, $t1, $a0
    # Se resta 1 al primer numero que está en $t3
    subi $t2, $t2, 1 
    # Se vuelve al inicio de cuadrado en loop
    j multiplicacion

control_division:

    # Se copia el contenido de ra en t9 (para no perder la referencia para volver)
    add $t9, $ra, $zero
    # Se carga un 1.0 en f2
    l.d $f2, uno
    # Se salta a division para calcular la parte entera del resultado
    jal division
    # Se carga un 9 en t8 para multiplicar el resto de la division por 10
    li  $t8, 9
    # Se copia el resto en s7
    add $s7, $zero, $s5
    # Se salta a multiplicar por 10 el resto de la primera division
    jal multi10
    # Se carga un 0.1 en f2
    l.d $f2, pdec
    # Se salta a division para calcular el primer decimal del resultado
    jal division
    # Se carga un 9 en t8 para multiplicar el resto de la division por 10
    li  $t8, 9
    # Se copia el resto en s7
    add $s7, $zero, $s5
    # Se salta a multiplicar por 10 el resto de la segunda division
    jal multi10
    # Se carga un 0.01 en f2
    l.d $f2, sdec
    # Se salta a division para calcular el segundo decimal del resultado
    jal division
    # Se carga un 9 en t8 para multiplicar el resto de la division por 10
    li  $t8, 9
    # Se copia el resto en s7
    add $s7, $zero, $s5
    #  Se salta a multiplicar por 10 el resto de la tercera division
    jal multi10
    # Se carga un 0.001 en f2
    l.d $f2, tdec
    # Se salta a division para calcular el tercer decimal del resultado
    jal division
    # Se carga un 9 en t8 para multiplicar el resto de la division por 10
    li  $t8, 9
    # Se copia el resto en s7
    add $s7, $zero, $s5
    #  Se salta a multiplicar por 10 el resto de la tercera division
    jal multi10
     # Se carga un 0.0001 en f2
    l.d $f2, cdec
    # Se salta a division para calcular el cuarto decimal del resultado
    jal division
    # Se carga un 9 en t8 para multiplicar el resto de la division por 10
    li  $t8, 9
    # Se copia el resto en s7
    add $s7, $zero, $s5
    #  Se salta a multiplicar por 10 el resto de la tercera division
    jal multi10
     # Se carga un 0.00001 en f2
    l.d $f2, qdec
    # Se salta a division para calcular el quinto decimal del resultado
    jal division
    # Se vuelve a donde indica t9
    jr $t9
    
division:

    # Se resta al angulo en su potencia dependiendo el termino el factorial correspondiente y se guarda en $s4
    sub $s4, $s5, $s6
    # Si el resultado de la resta es negativo de salta a volver
    bltz  $s4, volver
    # Se realiza la resta de nuevo y se guarda en s5
    sub $s5, $s5, $s6
    # Se suma el decimal o parte entera segun corresponda en f0
    add.d $f0, $f0,$f2 
    # Si la resta es 0 se salta a fin_div
    beq $s5, 0, fin_div
    # Sino se vuelve a division entera como loop
    j division

multi10:

    # Si t8 es 0 se salta a volver
    beqz $t8, volver
    # Si no se suma el resto de la division en s5, luego se va actualizando el valor
    add  $s5, $s5, $s7
    # Se resta uno a t8
    subi $t8, $t8, 1
    # Se vuelve al inicio del loop
    j multi10
       
volver:

    # Se vuelve a donde indica ra
    jr $ra
    
fin_div:
    
    # Se vuelve a donde indica t9
    jr $t9
    
fin:

    # Se imprime el string indicando cual es el resultado
    li $v0, 4
    la $a0, res
    syscall
    # Se imprime el resultado
    li $v0, 3
    syscall
    # Se finaliza el programa
    li $v0,10
    syscall
