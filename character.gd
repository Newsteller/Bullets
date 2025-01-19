extends Node2D

# Parametry elipsy
var promien_poziomy: float = 50   # Promień poziomy (oś X)
var promien_pionowy: float = 25   # Promień pionowy (oś Y)
var speed: float = 1.0  # Prędkość obrotu punktu (w radianach na sekundę)

# Kąty do obliczania pozycji punktu
var first_angle: float = 0.0
var second_angle: float = 3.0

# Punkty poruszające się po elipsie
var moving_first_point: Vector2 = Vector2.ZERO
var moving_second_point: Vector2 = Vector2.ZERO


func _process(delta: float):
	# Zwiększ kąt w czasie, aby punkt się poruszał
	first_angle += speed * delta
	second_angle += speed * delta
	
	# Zresetuj kąt po pełnym obrocie (2π radianów)
	if first_angle > TAU:  # TAU = 2 * PI
		first_angle -= TAU
	
	if second_angle > TAU:  # TAU = 2 * PI
		second_angle -= TAU
	
	# Oblicz nową pozycję punktów na elipsie
	moving_first_point.x = promien_poziomy * cos(first_angle)
	moving_first_point.y = promien_pionowy * sin(first_angle)
	
	moving_second_point.x = promien_poziomy * cos(second_angle)
	moving_second_point.y = promien_pionowy * sin(second_angle)
	
	# Przesuń środki do środka markera
	moving_first_point += %SrodekElipsy.global_position
	moving_second_point += %SrodekElipsy.global_position
	
	queue_redraw()


func _draw():
	# Rysowanie elipsy i punktu na niej
	draw_custom_ellipse(%SrodekElipsy.global_position, %PromienPoziomySlider.value, %PromienPionowySlider.value, 64)  # Rysujemy elipsę (64 punkty)
	draw_circle(moving_first_point, 5, Color.RED)  # Czerwony punkt
	draw_circle(moving_second_point, 5, Color.GREEN)  # Zielony punkt

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
	
	draw_polyline(vertices, Color.WHITE, 2)  # Biała elipsa


func _on_promien_poziomy_slider_value_changed(value: float) -> void:
	%PromienPoziomyLabel.text = "Promień poziomy (oś Y): " + str(value)
	promien_poziomy = %PromienPoziomySlider.value
	queue_redraw()


func _on_promien_pionowy_slider_value_changed(value: float) -> void:
	%PromienPionowyLabel.text = "Promień poziomy (oś X): " + str(value)
	promien_pionowy = %PromienPionowySlider.value
	queue_redraw()


func _on_predkosc_slider_value_changed(value: float) -> void:
	%PredkoscLabel.text = "Prędkość: " + str(value)
	speed = value
	queue_redraw()


func _on_przesun_do_gory_button_pressed() -> void:
	zaaktualizuj_srodek_elipsy()
	%SrodekElipsy.global_position.y -= 1


func _on_przesun_w_prawo_button_pressed() -> void:
	zaaktualizuj_srodek_elipsy()
	%SrodekElipsy.global_position.x += 1


func _on_przesun_do_dolu_button_pressed() -> void:
	zaaktualizuj_srodek_elipsy()
	%SrodekElipsy.global_position.y += 1


func _on_przesun_w_lewo_button_pressed() -> void:
	zaaktualizuj_srodek_elipsy()
	%SrodekElipsy.global_position.x -= 1


func zaaktualizuj_srodek_elipsy():
	%PrzesunSrodekLabel.text = "Środek elipsy: " + str(%SrodekElipsy.global_position)
