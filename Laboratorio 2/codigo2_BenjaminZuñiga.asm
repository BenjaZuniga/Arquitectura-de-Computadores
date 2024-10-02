.data
    # Coordenadas del primer vector
    v1: .asciiz "Coordenada X del primer vector: "
    v2: .asciiz "\nCoordenada Y del primer vector: "
    v3: .asciiz "\nCoordenada Z del primer vector: "
    # Coordenadas del segundo vector
    u1: .asciiz "\nCoordenada X del segundo vector: "
    u2: .asciiz "\nCoordenada Y del segundo vector: "
    u3: .asciiz "\nCoordenada Z del segundo vector: "
    # Resultado
    res: .asciiz "\nLa distancia entre los dos vectores es: "

.text
     # Imprimir string de la coordenada X del primer vector
     li $v0, 4
     la $a0, v1
     syscall
     # Guardar la primera coordenada del primer vector
     li $v0, 7
     syscall
     # Mover la coordenada ingresada a f8
     mov.d $f8, $f0
     # Imprimir string de la coordenada Y del primer vector
     li $v0, 4
     la $a0, v2
     syscall
     # Guardar la segunda coordenada del primer vector
     li $v0, 7
     syscall
     # Mover la coordenada ingresada a f10
     mov.d $f10, $f0
     # Imprimir string de la coordenada Z del primer vector
     li $v0, 4
     la $a0, v3
     syscall
     # Guardar la tercera coordenada del primer vector
     li $v0, 7
     syscall
     # Mover la coordenada ingresada a f12
     mov.d $f12, $f0
     # Imprimir string de la coordenada X del segundo vector
     li $v0, 4
     la $a0, u1
     syscall
     # Guardar la primera coordenada del segundo vector
     li $v0, 7
     syscall
     # Mover la coordenada ingresada a f2
     mov.d $f2, $f0
     # Imprimir string de la coordenada Y del segundo vector
     li $v0, 4
     la $a0, u2
     syscall
     # Guardar la segunda coordenada del segundo vector
     li $v0, 7
     syscall
     # Mover la coordenada ingresada a f4
     mov.d $f4, $f0
     # Imprimir string de la coordenada Z del segundo vector
     li $v0, 4
     la $a0, u3
     syscall
     # Guardar la tercera coordenada del segundo vector
     li $v0, 7
     syscall
     # Mover la coordenada ingresada a f6
     mov.d $f6, $f0
     # Saltar a main
     j main
     
main:
    # Calcular (Ax-Bx)
    sub.d $f2, $f8, $f2
    # Calcular (Ax-Bx) elevado 2
    mul.d $f2, $f2, $f2
    # Calcular (Ay-By)
    sub.d $f4, $f10, $f4
    # Calcular (Ay-By) elevado 2
    mul.d $f4, $f4, $f4
    # Calcular (Az-Bz)
    sub.d $f6, $f12, $f6
    # Calcular (Az-Bz) elevado 2
    mul.d $f6, $f6, $f6
    # Sumar los tres resultados
    add.d $f2, $f2, $f4
    add.d $f2, $f2, $f6
    # Guardar un 1.0 en f0
    div.d $f0, $f2, $f2
    # Resetear f10
    add.d $f10, $f0, $f0
    # Guardar un 20 (número de iteraciones)en s0
    addi $s0, $zero, 20
    # Cambiar el puntero de la pila para guardar punto flotante doble
    addi $sp, $sp, -4
    # Saltar a calcular Newton-Raphson
    j nr
    
nr:
   # Si el numero de iteraciones es 0 saltar a final
   beq $s0, 0, final
   # Cambiar el puntero de la pila para guardar punto flotante doble 
   addi $sp, $sp, -8
   # Guardar punto flotante doble de la iteracion anterior de Newton-Raphson en la pila
   s.d $f0, ($sp)
   # Dividir el valor de la raiz cuadrada entre el punto inicial
   div.d $f4, $f2, $f0
   # Al resultado anterior sumarle el punto inicial
   add.d $f4, $f4, $f0
   # Al resultado anterior dividirlo entre 2
   div.d $f0, $f4, $f10
   # Restarle 1 a las iteraciones restantes
   subi $s0, $s0, 1
   # Cargar el punto flotante doble de la iteracion anterior de Newton-Raphson en f14
   l.d $f14, ($sp)
   # Si f14 y f0 (resultado de la iteracion anterior y actual) son iguales poner una bandera en el coprocesador 1
   c.eq.d $f14, $f0
   # Si hay una bandera en el coprocesador 1 saltar a final
   bc1t final
   # Sino volver al principio
   j nr
   
final:
    # Imprimir el string indicando el resultado
    li $v0, 4
    la $a0, res
    syscall
    # Mover el resultado a f12
    mov.d $f12, $f0
    # Imprimir el resultado
    li $v0,3
    syscall
    # Se finaliza el programa
    li $v0,10
    syscall

   
     
