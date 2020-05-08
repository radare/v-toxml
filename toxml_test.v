module toxml

fn toxml_test() {
	x := toxml.new()
	x.comment('hello world')
	x.finish()
	println(x.str())
}
