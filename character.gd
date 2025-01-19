extends CharacterBody2D

# Parametry elipsy
var a: float = 50  # Promień poziomy (oś X)
var b: float = 25   # Promień pionowy (oś Y)
var speed: float = 1.0  # Prędkość obrotu punktu (w radianach na sekundę)

# Kąt do obliczania pozycji punktu
var angle: float = 0.0

# Punkt poruszający się po elipsie
var moving_point: Vector2 = Vector2.ZERO

func _process(delta: float):
	# Zwiększ kąt w czasie, aby punkt się poruszał
	angle += speed * delta
	
	# Zresetuj kąt po pełnym obrocie (2π radianów)
	if angle > TAU:  # TAU = 2 * PI
		angle -= TAU
	
	# Oblicz nową pozycję punktu na elipsie
	moving_point.x = a * cos(angle)
	moving_point.y = b * sin(angle)
	
	# Debug: Rysowanie elipsy i punktu w edytorze
	

func _draw():
	# Rysowanie elipsy i punktu na niej
	draw_custom_ellipse(%Marker2D.global_position, a, b, 64)  # Rysujemy elipsę (64 punkty)
	draw_circle(moving_point, 5, Color(1, 0, 0))  # Czerwony punkt

func draw_custom_ellipse(center: Vector2, rx: float, ry: float, points: int):
	"""
	Rysuje elipsę jako przybliżenie wielokąta o podanej liczbie punktów.
	"""
	var vertices = []
	for i in range(points):
		var theta = float(i) / points * TAU
		var x = center.x + rx * cos(theta)
		var y = center.y + ry * sin(theta)
		vertices.append(Vector2(x, y))
	vertices.append(vertices[0])  # Zamykamy elipsę
	
	draw_polyline(vertices, Color(1, 1, 1), 2)  # Biała elipsa
