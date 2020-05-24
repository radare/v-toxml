all:
	v test .
	cd examples && for a in *.v ; do v run $$a ; done
