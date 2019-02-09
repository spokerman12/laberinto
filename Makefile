makeLaberinto: Main.hs Laberinto.hs Herramientas.hs Sabio.hs
	ghc -o El_Sabio_del_Laberinto Main.hs
	mkdir Documentacion
	haddock Main.hs -o Documentacion -h
