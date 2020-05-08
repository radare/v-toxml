module toxml

fn toxml_test() {
	x := toxml_new()
	x.comment('hello world')
	x.finish()
	println(x.str())
}
