# car_01_data.gd

extends Resource

var vehicle_name = "Placeholder Car"
var move_speed: float = 4200
var start_max_speed: float = 8000
var rotate_speed: float = .75
var linear_drag: float = 2.5
var move_drag: float = .25
var xy_slerp_factor: float = 0.09
var boost_factor: float = 1.001
var braking_power: float = 9
var max_health: float = 105
var damage_per_hit = 7

