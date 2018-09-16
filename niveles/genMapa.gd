extends Node2D

#Variables modificables...
var origenCamino = Vector2(0,0) #multiplico por 4 porque es el escalado de Camera2D
var direccionRandom = Vector2(0,1) #Indicamos que la direccion inicial es hacia abajo
var distanciaPasillo = randi()%6+6
var cantidadPasillo = 18
var camaraMargen = Vector2(60,30)
var velCamara = 1000 #Velocidad de camara moviendo con Flechas

#Variables para el generador, no cambiar!
var esqIzqMapa = Vector2(0,0) #Punto esquina izquierda del mapa
var esqDerMapa = Vector2(0,0) #Punto esquina derecha del mapa
var x = -1
var y = -1
var x2 = 0
var y2 = 0
var x3 = 0
var y3 = 0
var x4 = 0
var y4 = 0
var puntoEscan = Vector2()
var dirAnterior = Vector2()
var dirActual = direccionRandom
var direccion = {
	arriba = Vector2(0,-1),
	abajo = Vector2(0,1),
	derecha = Vector2(1,0),
	izquierda = Vector2(-1,0)
}

func _ready():
	randomize()
	generarMapa()
	generarMuros()

func generarMapa():
	for pasilloNo in range(cantidadPasillo):
		for pasillo in range(distanciaPasillo):
			if !escanTerreno():
				$tilemap.set_cell(origenCamino.x,origenCamino.y,1)
				origenCamino += direccionRandom
		if esqIzqMapa.x > origenCamino.x: esqIzqMapa.x = origenCamino.x
		if esqIzqMapa.y > origenCamino.y: esqIzqMapa.y = origenCamino.y
		if esqDerMapa.x < origenCamino.x: esqDerMapa.x = origenCamino.x
		if esqDerMapa.y < origenCamino.y: esqDerMapa.y = origenCamino.y
		distanciaPasillo = randi()%3+4
		match direccionRandom:
			direccion.arriba:
					dirActual = dirAnterior
			direccion.abajo:
				dirAnterior = dirActual
				if randi()%2 == 0:
					dirActual = direccion.derecha
				else:
					dirActual = direccion.izquierda
			direccion.derecha:
				dirAnterior = dirActual
				if randi()%2 == 0:
					dirActual = direccion.arriba
				else:
					dirActual = direccion.abajo
			direccion.izquierda:
				dirAnterior = dirActual
				if randi()%2 == 0:
					dirActual = direccion.arriba
					distanciaPasillo -= 2
				else:
					dirActual = direccion.abajo
		direccionRandom = Vector2(dirActual.x,dirActual.y)

func escanTerreno():
	var terreno = false
	x = -1
	y = -1
	puntoEscan = origenCamino + direccionRandom * 3
	for i in range(9):
		if $tilemap.get_cell(puntoEscan.x + x , puntoEscan.y + y) == 1:
			terreno = true
		if x >= 1:
			x = -1
			y += 1
		else:
			x += 1
	return terreno

func generarMuros():
	print(esqIzqMapa , "--" , esqDerMapa)
	x = esqDerMapa.x - esqIzqMapa.x + camaraMargen.x
	y = esqDerMapa.y - esqIzqMapa.y + camaraMargen.x
	
	x2 = esqIzqMapa.x - round(camaraMargen.x/2)
	y2 = esqIzqMapa.y - round(camaraMargen.y/2)
	
	x3 = esqDerMapa.x - esqIzqMapa.x 
	y3 = esqDerMapa.y - esqIzqMapa.y
	
	x4 = esqIzqMapa.x
	y4 = esqIzqMapa.y
	
	$pos.marginBottom = (y3 + y4) * 64
	$pos.marginTop = y4 * 64
	$pos.marginLeft = x4 * 64
	$pos.marginRight = (x3 + x4)*64
	$pos.global_position = Vector2(round(x),round(y))
	for i in range(x*y):
		if $tilemap.get_cell(x2,y2) != 1: $tilemap.set_cell(x2,y2,0)
		if x2 > esqDerMapa.x + round(camaraMargen.x/2):
			x2 = esqIzqMapa.x - round(camaraMargen.x/2)
			y2 +=1
		else:
			x2 += 1