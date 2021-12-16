extends Node
const DEFAULT_MASS =1.5
const DEFAULT_SLOW_RADIUS = 200.0
const DEFAULT_MAX_SPEED = 800.0

func arrive_to(velocity: Vector2,
	position: Vector2,
	target_position: Vector2,
	slow_radius=DEFAULT_SLOW_RADIUS,
	max_speed=DEFAULT_MAX_SPEED,
	mass=DEFAULT_MASS)->Vector2:
	var distance_to_target = position.distance_to(target_position)
	var desired_velocity = (target_position - position).normalized() * max_speed
	if distance_to_target < slow_radius:
		desired_velocity *= (distance_to_target / slow_radius) * .75 + .25
	var steering = (desired_velocity - velocity) / mass
	return velocity + steering
func follow(velocity,
	position,
	target_position,
	max_speed,
	mass=DEFAULT_MASS):
		
	var desired_velocity = (target_position - position).normalized() * max_speed
	# var push = calculate_avoid_force(desired_velocity)
	# var steering = (desired_velocity - velocity + push) / mass
	var steering = (desired_velocity - velocity) / mass
	return velocity + steering

