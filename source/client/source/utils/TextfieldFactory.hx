package utils;

import flash.text.TextFormat;
import flash.text.TextField;
import flash.text.TextFormatAlign;
import flash.text.TextFieldAutoSize;

import flash.filters.GlowFilter;
import flash.filters.BitmapFilterQuality;

class TextfieldFactory
{
	public static inline function getDefault():Dynamic
	{
		var format = new TextFormat("assets/fonts/F", 20, 0x000000);

        var field = new TextField();
		field.defaultTextFormat = format;
        field.autoSize = TextFieldAutoSize.LEFT;
		field.mouseEnabled = false;
        field.embedFonts = true;

		//var outline:GlowFilter=new GlowFilter(0x000000,1,3,3,300);
		//field.filters=[outline];

		return field;
	}

    public static inline function getLog():Dynamic
    {
        var format = new TextFormat("assets/fonts/F", 10, 0x000000);

        var field = new TextField();
        field.defaultTextFormat = format;
        field.autoSize = TextFieldAutoSize.LEFT;
        field.mouseEnabled = false;
        field.embedFonts = true;

        //var outline:GlowFilter=new GlowFilter(0x000000,1,3,3,300);
        //field.filters=[outline];

        return field;
    }

	public static inline function getButtonLabel():Dynamic
	{
		var format = new TextFormat("assets/fonts/F", 20, 0x000000);

        var field = new TextField();
		field.defaultTextFormat = format;
        field.autoSize = TextFieldAutoSize.CENTER;
		field.mouseEnabled = false;
        field.embedFonts = true;

		return field;
	}

	public static inline function getMenuInput():Dynamic
	{
		var format = new TextFormat("assets/fonts/F", 20, 0x000000);

        var field = new TextField();
		field.defaultTextFormat = format;
		field.text = "temp";
        field.background = true;
        field.backgroundColor = 0xFFFFFF;
        field.width = 300;
        field.height = field.textHeight;
        field.text = "";
        field.embedFonts = true;

		//var outline:GlowFilter=new GlowFilter(0x000000,1,3,3,300);
		//field.filters=[outline];

		return field;
	}

	public static inline function getLeftAligned():Dynamic
	{
		var format = new TextFormat("assets/fonts/F", 20, 0x000000);

        var field = new TextField();
		field.defaultTextFormat = format;
        field.autoSize = TextFieldAutoSize.RIGHT;
        field.embedFonts = true;

		return field;
	}

	public static inline function getMenuDefault():Dynamic
	{
		var format = new TextFormat("assets/fonts/F", 20, 0x000000);

        var field = new TextField();
		field.defaultTextFormat = format;
        field.autoSize = TextFieldAutoSize.LEFT;
        field.embedFonts = true;

		return field;
	}

	public static inline function getMenuWarning():Dynamic
	{
		var format = new TextFormat("assets/fonts/F", 20, 0x000000);

        var field = new TextField();
		field.defaultTextFormat = format;
        field.autoSize = TextFieldAutoSize.LEFT;
        field.embedFonts = true;

		return field;
	}
}