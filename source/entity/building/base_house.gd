extends StaticBody2D

@onready var floating_text_marker: Marker2D = %FloatingTextMarker
@onready var can_attack_range: Area2D = %CanAttackRange
@onready var can_attack_range_collision_shape: CollisionShape2D = %CollisionShape2D
@onready var final_position: Marker2D = %FinalPosition
