#Presentado por: Daniel Alejandro Muñoz, David García Velasco
#! /bin/sh
#Configurar pines:
#Leds
        echo out > /sys/class/gpio/gpio39/direction
        echo out > /sys/class/gpio/gpio38/direction
        echo out > /sys/class/gpio/gpio25/direction
        echo out > /sys/class/gpio/gpio16/direction
        echo out > /sys/class/gpio/gpio19/direction
        echo out > /sys/class/gpio/gpio26/direction
        echo out > /sys/class/gpio/gpio27/direction
        echo out > /sys/class/gpio/gpio41/direction
        echo out > /sys/class/gpio/gpio40/direction

#Pulsadores
        #TODO: implementar pwm para los pines gpio28 y gpio18

        echo in > /sys/class/gpio/gpio24/direction #pulsador izquierdo
        echo in > /sys/class/gpio/gpio17/direction #pulsador derecho
        echo in > /sys/class/gpio/gpio28/direction #reset
		
#-----------------------------------------------------------#
#Funcion que inicia y reinicia el juego, hace un juego de leds en barrida
reset(){
	iterador=0
    	onOff 0
	while [ $iterador -lt 3 ]
	do
    	echo 1 > /sys/class/gpio/gpio39/value
    	usleep 25000
    	echo 0 > /sys/class/gpio/gpio39/value
    	usleep 25000
    	echo 1 > /sys/class/gpio/gpio38/value
    	usleep 25000
    	echo 0 > /sys/class/gpio/gpio38/value
    	usleep 25000
    	echo 1 > /sys/class/gpio/gpio25/value
    	usleep 25000
    	echo 0 > /sys/class/gpio/gpio25/value
    	usleep 25000
    	echo 1 > /sys/class/gpio/gpio16/value
    	usleep 25000
    	echo 0 > /sys/class/gpio/gpio16/value
    	usleep 25000
    	echo 1 > /sys/class/gpio/gpio19/value
    	usleep 25000
    	echo 0 > /sys/class/gpio/gpio19/value
    	usleep 25000
    	echo 1 > /sys/class/gpio/gpio26/value
    	usleep 25000
    	echo 0 > /sys/class/gpio/gpio26/value
    	usleep 25000
	echo 1 > /sys/class/gpio/gpio27/value
    	usleep 25000
    	echo 0 > /sys/class/gpio/gpio27/value
    	usleep 25000
    	echo 0 > /sys/class/gpio/gpio41/value
    	usleep 25000
    	echo 1 > /sys/class/gpio/gpio41/value
    	usleep 25000
    	echo 0 > /sys/class/gpio/gpio40/value
    	usleep 25000
    	echo 1 > /sys/class/gpio/gpio40/value
    	usleep 25000
	iterador=$(($iterador + 1))
	done
	contGato=0
	echo 1 > /sys/class/gpio/gpio39/value

}
#-------------------------------------------------------
#Enciende o apaga todos los leds segun el parámetro especificado
onOff(){
    echo $1 > /sys/class/gpio/gpio39/value
    echo $1 > /sys/class/gpio/gpio38/value
    echo $1 > /sys/class/gpio/gpio25/value
    echo $1 > /sys/class/gpio/gpio16/value
    echo $1 > /sys/class/gpio/gpio19/value
    echo $1 > /sys/class/gpio/gpio26/value
    echo $1 > /sys/class/gpio/gpio27/value
    if [ $1 == 1 ]; then
          echo 0 > /sys/class/gpio/gpio41/value
          echo 0 > /sys/class/gpio/gpio40/value
    else
          echo 1 > /sys/class/gpio/gpio41/value
          echo 1 > /sys/class/gpio/gpio40/value
    fi


}
#-------------------------------------------------------
#MOVIMIENTO DEL GATO IZQ-DER EN LOS LEDS

#Variables Globales, ledRaton representa el led donde se encuentra el ratón y contador gato el led donde se encuentra el gato
estActual=0
estAnterior=0
contGato=0
idx=0
ledRaton=0
gameover=0
 echo 1 > /sys/class/gpio/gpio39/value

#------------------------------------------------------



gameOver(){
if [ $(($contGato + 1 )) -eq $ledRaton ]; then
						echo 0 > /sys/class/gpio/gpio40/value
						sleep 2
						echo 1 > /sys/class/gpio/gpio40/value
						gameover=1

						fi

}
#-----------------------------------------------------------------





#Funcion Pulsador Derecha: mueve el gato en una posición a la derecha, llama a la función moverGatoDer().
pulsadorDer(){
 cont=0
    while [ $cont -lt 20 ]
    do
    estActual=`cat /sys/class/gpio/gpio17/value`

        if [ $estActual != $estAnterior ]; then
                if [ $estActual == 0 ]; then
                    contGato=$(($contGato + 1))
                    moverGatoDer
                        echo $contGato
                    break
                fi
        fi
    estAnterior=$estActual
        cont=$(($cont + 1 ))
    done

}
#Funcion pulsador izquierda: Mueve el gato en una posicion a la izquierda, llama a la funcion moverGatoIzq().
pulsadorIzq(){
cont=0
while [ $cont -lt 20 ]
do
estActual=`cat /sys/class/gpio/gpio24/value`

        if [ $estActual != $estAnterior ]; then
                if [ $estActual == 0 ]; then
                    contGato=$(($contGato - 1))
                    moverGatoIzq
        echo $contGato
                    break
                fi
        fi

cont=$(($cont + 1 ))
 estAnterior=$estActual
done
}


#-----------------------------------------------------------------------------------------------------------------------
# Función moverGatoDer: con la variable de tipo global contGato(led donde está el gato), hace el caso para cada una de las posiciones, apaga y enciende el led
# respectivo para generar ilusión de movimiento hacia la derecha

moverGatoDer(){
   case $contGato in
               1)      echo 0 > /sys/class/gpio/gpio39/value
                        echo 1 > /sys/class/gpio/gpio38/value
						gameOver
						
						;;

                2)      echo 0 > /sys/class/gpio/gpio38/value
                        echo 1 > /sys/class/gpio/gpio25/value
						gameOver;;

                3)      echo 0 > /sys/class/gpio/gpio25/value
                        echo 1 > /sys/class/gpio/gpio16/value
						gameOver;;

                4)      echo 0 > /sys/class/gpio/gpio16/value
                        echo 1 > /sys/class/gpio/gpio19/value
						gameOver;;

                5)      echo 0 > /sys/class/gpio/gpio19/value
                        echo 1 > /sys/class/gpio/gpio26/value
						gameOver;;

                6)      echo 0 > /sys/class/gpio/gpio26/value
                        echo 1 > /sys/class/gpio/gpio27/value
						gameOver;;

                7)      echo 0 > /sys/class/gpio/gpio27/value
                        echo 0 > /sys/class/gpio/gpio41/value
						gameOver;;
		#Desbordamiento por la derecha, pasa al otro lado de los leds

                *)      echo 1 > /sys/class/gpio/gpio41/value
                        echo 1 > /sys/class/gpio/gpio39/value
						gameOver
                   contGato=0;;
                    esac

}

# Función moverGatoIzq: con la variable de tipo global contGato(led donde está el gato), hace el caso para cada una de las posiciones, apaga y enciende el led
# respectivo para generar ilusión de movimiento hacia la izquierda

moverGatoIzq(){
   case $contGato in
                0)      echo 1 > /sys/class/gpio/gpio39/value
                        echo 0 > /sys/class/gpio/gpio38/value
						gameOver;;

                1)      echo 1 > /sys/class/gpio/gpio38/value
                        echo 0 > /sys/class/gpio/gpio25/value
						gameOver;;

                2)      echo 1 > /sys/class/gpio/gpio25/value
                        echo 0 > /sys/class/gpio/gpio16/value
						gameOver;;

                3)      echo 1 > /sys/class/gpio/gpio16/value
                        echo 0 > /sys/class/gpio/gpio19/value
						gameOver;;

                4)      echo 1 > /sys/class/gpio/gpio19/value
                        echo 0 > /sys/class/gpio/gpio26/value
						gameOver;;

                5)      echo 1 > /sys/class/gpio/gpio26/value
                        echo 0 > /sys/class/gpio/gpio27/value
						gameOver;;

                6)      echo 1 > /sys/class/gpio/gpio27/value
                        echo 1 > /sys/class/gpio/gpio41/value
						gameOver
						;;
		#Desbordamiento por la izquierda, pasa al otro lado de los leds

                *)      echo 0 > /sys/class/gpio/gpio41/value
                        echo 0 > /sys/class/gpio/gpio39/value
                        contGato=7
						gameOver;;
                    esac

}
#--------------------------------------------------------------------
#MOVIMIENTO DEL RATON
#-------------------------------------------------------------------------
#Genera un numero pseudoaleatorio que nos indicara la posicion de el raton en los leds, el pseudoAleatorio usa una lista y un recorrido para asignar
random (){
	cont=0
	seudoAleatorio="3 5 1 7 5 3 2 8 1 6 3 2 6 4 5 7 5 3 2 1 7 4 1 3 6 4 5 4 2 8 6 1"
	if [ $idx -eq 32 ]; then
    	idx=0
	fi
  	  for i in $seudoAleatorio
    		do
        		if [ $cont -eq $idx ]; then
               			idx=$(($idx + 1))
               			ledRaton=$i
                		break
        		fi
        		cont=$(($cont + 1 ))
    		done
}
#-----------------------Bucle principal de juego-----------------------------------------------
# Se genera un número pseudo aleatorio donde representa el led del ratón, dicho led se pone a titilar. Dentro de cada caso se permite el movimiento del gato
# y dependiendo del pulsador presionado se llama al respectivo movimiento del gato (moverGatoIzq, moverGatoDere)
 
while (true)
	gameover=0
	do
	pul=`cat /sys/class/gpio/gpio28/value`
	if [ $pul -eq 1 ]; then
   		reset
	fi
	random
	#de ser la posicion del gato igual a la del raton vuelve a generar, no tiene sentido que el raton caiga encima del gato
	if [ $(($contGato + 1 )) -eq $ledRaton ]; then
        	random
	else
        dx="1 2 3 4 5"


case $ledRaton in
        1) for i in $dx
                do
                        usleep 25000
                        echo 1 > /sys/class/gpio/gpio39/value
                        usleep 25000
                        echo 0 > /sys/class/gpio/gpio39/value

			pul1=`cat /sys/class/gpio/gpio24/value`
			pul2=`cat /sys/class/gpio/gpio17/value`
			if [ $pul1 -eq 1 ]; then
        		  	pulsadorIzq
			fi
			if [ $pul2 -eq 1 ]; then
       				pulsadorDer
			fi
			if [ $gameover -eq 1 ]; then
				echo 1 > /sys/class/gpio/gpio39/value
			break
			fi
	   done
		;;
 2) for i in $dx
                do
                     usleep 25000
                     echo 1 > /sys/class/gpio/gpio38/value
                     usleep 25000
                     echo 0 > /sys/class/gpio/gpio38/value

		pul1=`cat /sys/class/gpio/gpio24/value`
		pul2=`cat /sys/class/gpio/gpio17/value`
		if [ $pul1 -eq 1 ]; then
        		pulsadorIzq
		fi
		if [ $pul2 -eq 1 ]; then
       			pulsadorDer
		fi
		if [ $gameover -eq 1 ]; then
			echo 1 > /sys/class/gpio/gpio38/value
			break
		fi
		done
		;;

 3) for i in $dx
                do
                        usleep 25000
                        echo 1 > /sys/class/gpio/gpio25/value
                        usleep 25000
                        echo 0 > /sys/class/gpio/gpio25/value

			pul1=`cat /sys/class/gpio/gpio24/value`
			pul2=`cat /sys/class/gpio/gpio17/value`
			if [ $pul1 -eq 1 ]; then
			        pulsadorIzq
			fi
			if [ $pul2 -eq 1 ]; then
 			      pulsadorDer
			fi
			if [ $gameover -eq 1 ]; then
				echo 1 > /sys/class/gpio/gpio25/value
				break	
			fi
		done
		;;
 4) for i in $dx
                do
                        usleep 25000
                        echo 1 > /sys/class/gpio/gpio16/value
						
                        usleep 25000
                        echo 0 > /sys/class/gpio/gpio16/value

			pul1=`cat /sys/class/gpio/gpio24/value`
			pul2=`cat /sys/class/gpio/gpio17/value`
			if [ $pul1 -eq 1 ]; then
 			       pulsadorIzq
			fi
			if [ $pul2 -eq 1 ]; then
 			      pulsadorDer
			fi
			if [ $gameover -eq 1 ]; then
				echo 1 > /sys/class/gpio/gpio16/value
			break
			fi
		done
		;;

 5) for i in $dx
                do
                        usleep 25000
                        echo 1 > /sys/class/gpio/gpio19/value
                        usleep 25000
                        echo 0 > /sys/class/gpio/gpio19/value

			pul1=`cat /sys/class/gpio/gpio24/value`
			pul2=`cat /sys/class/gpio/gpio17/value`
			if [ $pul1 -eq 1 ]; then
     			   pulsadorIzq
			fi
			if [ $pul2 -eq 1 ]; then
  			     pulsadorDer
			fi
			if [ $gameover -eq 1 ]; then
				echo 1 > /sys/class/gpio/gpio19/value
			break
			fi
		done
		;;
6) for i in $dx
                do
                        usleep 25000
                        echo 1 > /sys/class/gpio/gpio26/value
                        usleep 25000
                        echo 0 > /sys/class/gpio/gpio26/value

			pul1=`cat /sys/class/gpio/gpio24/value`
			pul2=`cat /sys/class/gpio/gpio17/value`
			if [ $pul1 -eq 1 ]; then
      			  pulsadorIzq
			fi
			if [ $pul2 -eq 1 ]; then
  			     pulsadorDer
			fi
			if [ $gameover -eq 1 ]; then
				echo 1 > /sys/class/gpio/gpio26/value
			break
			fi
		done
		;;

 7) for i in $dx
                do
                        usleep 25000
                        echo 1 > /sys/class/gpio/gpio27/value
                        usleep 25000
                        echo 0 > /sys/class/gpio/gpio27/value

			pul1=`cat /sys/class/gpio/gpio24/value`
			pul2=`cat /sys/class/gpio/gpio17/value`
			if [ $pul1 -eq 1 ]; then
			        pulsadorIzq
			fi
			if [ $pul2 -eq 1 ]; then
			       pulsadorDer
			fi
			if [ $gameover -eq 1 ]; then
				echo 1 > /sys/class/gpio/gpio27/value
			break
			fi
		done
			;;
8) for i in $dx
                do
                        usleep 25000
                        echo 0 > /sys/class/gpio/gpio41/value
                        usleep 25000
                        echo 1 > /sys/class/gpio/gpio41/value

			pul1=`cat /sys/class/gpio/gpio24/value`
			pul2=`cat /sys/class/gpio/gpio17/value`
			if [ $pul1 -eq 1 ]; then
 			       pulsadorIzq
			fi
			if [ $pul2 -eq 1 ]; then
			       pulsadorDer
			fi
			if [ $gameover -eq 1 ]; then
				echo 0 > /sys/class/gpio/gpio41/value
			break
			fi
		done
		;;

#Excepcion, si hay algún desbordamiento del raton el caso caería acá
*) echo "Excepcion"
	;;
	esac
	fi
done