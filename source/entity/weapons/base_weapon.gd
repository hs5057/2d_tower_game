extends Area2D
class_name BaseWeapon

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var hitbox_component: HitboxComponent = $HitboxComponent
@onready var random_audio_component: RandomAudioComponent = $RandomAudioComponent



func _ready() -> void:
	hitbox_component.area_entered.connect(_on_hitbox_component_area_entered)


func anim_play(anim_name: String) -> void:
	animation_player.play(anim_name)


func _on_hitbox_component_area_entered(area: Area2D) -> void:
	print("%s -> %s" % [self.name , area.owner.name])
	random_audio_component.play_random()
