G50 class at edX
Keith R. Bergerstock
(krbergerstock@e4kountdown.com)

because I am using LOVE2D version 11.1 some necessary changes where needed:
	push version 0.3  , push version 0.2 causes an internal error in the engine 
	that throws an exception and halts
	
	the set color commands in the love api require colors to be between 0 and 1
	(r/255, g/255, b/255) is the proper conversion )
	

	

