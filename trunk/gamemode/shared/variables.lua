if GMF then return end

GMF = {
	startRound = "preround",
	teams =
	{
		{
			name = "Blue",
			color =
			{
				brighter   = Color( 80, 150, 255, 255),
				darker     = Color( 80, 150, 255, 255),
				neutral    = Color( 70, 120, 220, 255),
				player     = Color(100, 140, 255, 255),
				scoreboard = Color( 35,  60, 255, 100),
			},
		},
		{
			name = "Yellow",
			color =
			{
				brighter   = Color(245, 245,   0, 255),
				darker     = Color(245, 245,   0, 255),
				neutral    = Color(200, 200,   0, 255),
				player     = Color(255, 255, 150, 255),
				scoreboard = Color(120, 120,   0, 100),
			},
		},
		{
			name = "Green",
			color =
			{
				brighter   = Color(  0, 235,   0, 255),
				darker     = Color(  0, 235,   0, 255),
				neutral    = Color(  0, 200,   0, 255),
				player     = Color(150, 255, 150, 255),
				scoreboard = Color(  0, 120,   0, 100),
			},
		},
		{
			name = "Red",
			color =
			{
				brighter   = Color(255,  40,  40, 255),
				darker     = Color(255,  40,  40, 255),
				neutral    = Color(200,  50,  40, 255),
				player     = Color(255, 150, 150, 255),
				scoreboard = Color(100,  25,  20, 100),
			},
		},
	},
}