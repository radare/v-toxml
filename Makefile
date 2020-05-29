all:
	v test .
	cd examples && for a in *.v ; do v run $$a ; done

README.md:
	cd examples && v run readme.v > ../README.md
