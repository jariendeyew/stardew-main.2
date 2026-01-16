extends Node
## Autoload

## 音频资源的总线类型
enum Bus{
	MASTER,
	MUSIC,
	SFX,
}

## 对应总线的名称
const MUSIC_BUS = "Music"
const SFX_BUS = "SFX"

##音乐播放器的个数,默认是2，两个播放器可以实现渐变的效果
var music_player_count:int = 2
## 当前音乐播放器的下标，默认是0
var current_music_player_index:int = 0
##音乐播放器存放的数组
var music_players:Array[AudioStreamPlayer]
##音乐渐变时长
var music_fade_duration:float = 1.0
##音效播放器的个数，随便的6个，意味着同时最多可以播放6个音效
var sfx_player_count:int = 6
##音效播放器存放的数组
var sfx_players:Array[AudioStreamPlayer]

# 新增：音量保存配置
var config: ConfigFile = ConfigFile.new()
const CONFIG_PATH = "user://audio.cfg"
var volumes: Dictionary = {
	Bus.MASTER: 0.3,  # 默认30%（降低太大声音）
	Bus.MUSIC: 0.3,
	Bus.SFX: 0.3
}

func _ready() -> void:
	initial_music_player()
	initial_sfx_player()
	load_volumes()  # 新增：加载保存音量
	set_all_volumes()  # 新增：应用默认/加载音量

## 新增：从文件加载音量
func load_volumes() -> void:
	if config.load(CONFIG_PATH) == OK:
		for bus in volumes:
			volumes[bus] = config.get_value("audio", "bus_%d" % bus, volumes[bus])

## 新增：应用所有音量
func set_all_volumes() -> void:
	for bus in volumes:
		set_volume(bus, volumes[bus])

## 初始化音乐播放器
func initial_music_player() -> void:
	for i in music_player_count:
		var audio_player := AudioStreamPlayer.new()
		audio_player.process_mode = Node.PROCESS_MODE_ALWAYS
		audio_player.bus = MUSIC_BUS
		add_child(audio_player)
		music_players.append(audio_player)
	
## 初始化音效播放器
func initial_sfx_player() -> void:
	for i in sfx_player_count:
		var sfx_player := AudioStreamPlayer.new()
		sfx_player.bus = SFX_BUS
		add_child(sfx_player)
		sfx_players.append(sfx_player)
		
## 播放音乐函数,音乐同一时间只能播放一首
func play_music(audio:AudioStream) -> void:
	var current_audio_player := music_players[current_music_player_index]
	if current_audio_player.stream == audio:
		return##避免相同的音乐重复播放
	var empty_audio_player_index = 0 if current_music_player_index == 1 else 1
	var empty_audio_player = music_players[empty_audio_player_index] 
	empty_audio_player.stream = audio
	play_fade_in(empty_audio_player)
	play_fade_out(current_audio_player)
	current_music_player_index = empty_audio_player_index
	
## 渐入
func play_fade_in(audio_player:AudioStreamPlayer) -> void:
	audio_player.play()
	var tween = create_tween()
	tween.tween_property(audio_player,"volume_db",0,music_fade_duration)
	
## 渐出
func play_fade_out(audio_player:AudioStreamPlayer) -> void:
	var tween = create_tween()
	tween.tween_property(audio_player,"volume_db",-40,music_fade_duration)
	await tween.finished
	audio_player.stop()
	audio_player.stream = null
	
## 播放音效函数，音效可以同时播放多个
func play_sfx(audio:AudioStream) -> void:
	for i in sfx_player_count:
		var sfx_player = sfx_players[i]
		if not sfx_player.playing:
			sfx_player.stream = audio
			sfx_player.play()
			break

##设置音量大小，第一个参数是枚举类型Bus{Master,Music,sfx}
func set_volume(bus_index:Bus,v:float) -> void:
	var db = linear_to_db(v) #这里的
	AudioServer.set_bus_volume_db(bus_index,db)
	volumes[bus_index] = v  # 新增：记录
	config.set_value("audio", "bus_%d" % bus_index, v)  # 新增：保存
	config.save(CONFIG_PATH)
