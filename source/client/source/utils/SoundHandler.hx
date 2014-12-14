package utils;

import openfl.Assets;

import flash.media.*;
import flash.events.Event;
import flash.net.SharedObject;

class SoundHandler
{
	static public var muteEffects:Bool	= false;
	static public var muteMusic:Bool	= false;
	static public var effectsSoundTransform:SoundTransform;
	static public var musicSoundTransform:SoundTransform;
	static public var so:SharedObject;

	static public var music:Sound;
	static public var repeatMusic:Bool;
	static public var musicChannel:SoundChannel;
	static public var musicPosition:Float;

	public function new()
	{
		effectsSoundTransform = new SoundTransform(1);
		musicSoundTransform = new SoundTransform(1);
		so = SharedObject.getLocal("settings");

		musicPosition = 0;

		if(so.data.muteEffects != null)
		{
			muteEffects = so.data.muteEffects;
		}
		else
		{
			so.data.muteEffects = false;
			so.flush();
		}

		if(so.data.muteMusic != null)
		{
			muteMusic = so.data.muteMusic;
		}
		else
		{
			so.data.muteMusic = false;
			so.flush();
		}

		if(so.data.effectsVolume != null)
		{
			setEffectsVolume(so.data.effectsVolume);
		}
		else
		{
			so.data.effectsVolume = 1;
			so.flush();
		}

		if(so.data.musicVolume != null)
		{
			setMusicVolume(so.data.musicVolume);
		}
		else
		{
			so.data.musicVolume = 1;
			so.flush();
		}
	}

	public static function playEffect(name:String, ?range:Int):Void
	{
		if(muteEffects == true)
		{
			return;
		}

		var sound:Sound = Assets.getSound("assets/audio/"+name+".wav");
		sound.play(0,0,effectsSoundTransform);
	}

	public static function playMusic(name:String, ?repeat:Bool):Void
	{
		if(muteMusic == true)
		{
			return;
		}

		musicPosition = 0;
		music = Assets.getSound("assets/audio/"+name+".mp3");
		musicChannel = music.play(0, 0, musicSoundTransform);

		if(repeat != null && repeat)
		{
			repeatMusic = repeat;
			musicChannel.addEventListener(Event.SOUND_COMPLETE, musicComplete);
		}
	}

	private static function musicComplete(e:Event):Void
	{
		musicPosition = 0;
		musicChannel = music.play(0, 0, musicSoundTransform);
		musicChannel.addEventListener(Event.SOUND_COMPLETE, musicComplete);
	}

	public static function stopMusic():Void
	{
		if(musicChannel != null)
		{
			musicChannel.removeEventListener(Event.COMPLETE, musicComplete);
			musicChannel.stop();
			musicChannel = null;
		}
	}

	public static function setMuteEffects(muteEffects:Bool):Void
	{
		SoundHandler.muteEffects = muteEffects;
		so.data.muteEffects = muteEffects;
		so.flush();
	}

	public static function setMuteMusic(muteMusic:Bool):Void
	{
		SoundHandler.muteMusic = muteMusic;
		so.data.muteMusic = muteMusic;
		so.flush();

		if(muteMusic)
		{
			if(musicChannel != null)
			{
				musicPosition = musicChannel.position;
				musicChannel.stop();
			}
		}
		else
		{
			if(music != null)
			{
				musicChannel = music.play(musicPosition, 0, musicSoundTransform);

				if(repeatMusic)
				{
					musicChannel.addEventListener(Event.SOUND_COMPLETE, musicComplete);
				}
			}
		}
	}

	public static function setEffectsVolume(effectsVolume:Float):Void
	{
		effectsSoundTransform.volume = effectsVolume;
		so.data.effectsVolume = effectsVolume;
		so.flush();
	}

	public static function setMusicVolume(musicVolume:Float):Void
	{
		musicSoundTransform.volume = musicVolume;
		so.data.musicVolume = musicVolume;
		so.flush();

		if(musicChannel != null)
		{
			musicChannel.soundTransform = musicSoundTransform;
		}
	}
}