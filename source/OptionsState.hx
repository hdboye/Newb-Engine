package;

import flixel.FlxG;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxColor;

// my code is shit so beware lolz

class OptionsState extends MusicBeatState
{
	var textMenuItems:Array<String> = ['Multipliers', 'Gamechangers'];
	var multiplierItems:Array<String> = ['Health Multiplier', 'Score Multiplier'];
	var gameChangers:Array<String> = ['Full Energy', 'Antispam', 'Bot Mode'];
	var optionsMenus:Array< Array<String> > = [[],[],[],[]];
	var menuItems:FlxTypedGroup<Alphabet>;
	var curSelected:Int = 0;
	var curMenu:Int = 0;

	// startup values might make a saving system later????? 
	public static var healthMultiplier:Int = 1;
	public static var scoreMultiplier:Int = 1;
	public static var fullEnergy:Bool = true;
	public static var antiSpam:Bool = false;
	public static var botMode:Bool = false;

	private var optionText:FlxText;

    override public function create():Void
    {
		optionsMenus[0] = textMenuItems;
		optionsMenus[1] = multiplierItems;
		optionsMenus[2] = gameChangers;
		var bg:FlxSprite = new FlxSprite().loadGraphic('assets/images/menuBGBlue.png');
		add(bg);
		optionText = new FlxText(1130, 10, 128, "", 100);
		optionText.setFormat("assets/fonts/vcr.ttf", 64, FlxColor.WHITE, RIGHT, OUTLINE, FlxColor.BLACK);
		add(optionText);

		menuItems = new FlxTypedGroup<Alphabet>();
		add(menuItems);

		for (i in 0...textMenuItems.length)
		{
			var menuText:Alphabet = new Alphabet(0, (70 * i) + 30, textMenuItems[i], true, false);
			menuText.isMenuItem = true;
			menuText.targetY = i;
			menuItems.add(menuText);
		}
        super.create();
    }

    override function update(elapsed:Float)
		{
			if(curMenu == 0){
				optionText.text = "";
			}else if (curMenu == 1){
				switch(curSelected){
					case 0:
						optionText.text = FlxG.save.data.healthMultiplier + "x";
					case 1:
						optionText.text = FlxG.save.data.scoreMultiplier + "x";
				}
			}else if (curMenu == 2){
				switch(curSelected){
					case 0:
						optionText.text = boolToOnOff(FlxG.save.data.fullEnergy);
					case 1:
						optionText.text = boolToOnOff(FlxG.save.data.antiSpam);
					case 2:
						optionText.text = boolToOnOff(FlxG.save.data.botMode);	
				}
			}
			var upP = controls.UP_P;
			var downP = controls.DOWN_P;
			var accepted = controls.ACCEPT;
			var back = controls.BACK;

			if (upP)
			{
				changeSelection(-1);
			}
			if (downP)
			{
				changeSelection(1);
			}
			// this code can probably be improved but i suck at coding so whatevz
			if (controls.LEFT_P)
			{
				if(curMenu == 1)
				{
					switch(curSelected)
					{
						case 0:
							if (FlxG.save.data.healthMultiplier >= 2)
								FlxG.save.data.healthMultiplier -= 1;
						case 1:
							if (FlxG.save.data.scoreMultiplier >= 2)
								FlxG.save.data.scoreMultiplier -= 1;
					}
				}
				else if (curMenu == 2)
				{
					switch(curSelected)
					{
						case 0:
							FlxG.save.data.fullEnergy = false;
						case 1:
							FlxG.save.data.antiSpam = false;
						case 2:
							FlxG.save.data.botMode = false;
					}
				}
			}
			if (controls.RIGHT_P)
			{
				if(curMenu == 1)
				{
					switch(curSelected)
					{
						case 0:
							if (FlxG.save.data.healthMultiplier <= 4)
								FlxG.save.data.healthMultiplier += 1;
						case 1:
							if (FlxG.save.data.scoreMultiplier <= 4)
								FlxG.save.data.scoreMultiplier += 1;
					}
				}
				else if(curMenu == 2)
				{
					switch(curSelected)
					{
						case 0:
							FlxG.save.data.fullEnergy = true;
						case 1:
							FlxG.save.data.antiSpam = true;
						case 2:
							FlxG.save.data.botMode= true;
					}
				}
			}
			if (controls.ACCEPT)
			{
				curMenu = curSelected + 1;
				refreshList(optionsMenus[curSelected + 1]);
			}
			if (back)
			{
				if (curMenu == 0){
					FlxG.switchState(new MainMenuState());
				}
				else{
					curMenu = 0;
					refreshList(optionsMenus[0]);
				}

			}	
			super.update(elapsed);
		}	
	function changeSelection(change:Int = 0)
	{
		// NGio.logEvent('Fresh');
		FlxG.sound.play('assets/sounds/scrollMenu' + TitleState.soundExt, 0.4);

		curSelected += change;
		var thingie:Array<String> = optionsMenus[curMenu];
		
		if (curSelected < 0)
			curSelected = thingie.length - 1;
		if (curSelected >= thingie.length)
			curSelected = 0;

		// selector.y = (70 * curSelected) + 30;

		var bullShit:Int = 0;

		for (item in menuItems.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			// item.setGraphicSize(Std.int(item.width * 0.8));

			if (item.targetY == 0)
			{
				item.alpha = 1;
				// item.setGraphicSize(Std.int(item.width));
			}
		}
	}
	function boolToOnOff(variable:Bool = true)
	{
		// funny bool to on-off function bc its used ez
		if (variable)
			return "ON";
		else
			return "OFF";
	}
	function refreshList(thething:Array<String>)
	{
		// funny refresh list.. give it array and it kewl
		curSelected = 0;
		menuItems.clear();
		for (i in 0...thething.length)
			{
				var menuText:Alphabet = new Alphabet(0, (70 * i) + 30, thething[i], true, false);
				menuText.isMenuItem = true;
				menuText.targetY = i;
				menuItems.add(menuText);
			}
	}
}