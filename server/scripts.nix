let
	perimeter = {a, ... }@args: 2 * (a + args.b + args.c);
in
	perimeter { a = 2; b = 4; c = 4; }
