module toxml

fn test_toxml_special() {
	mut x := toxml.new()
	assert(x.open('node',{
		'fo<o"b>ar':'fo<o"b>ar'})
	)
	assert(x.body('fo<o"b>ar'))
	assert(x.close())
	x.finish()
	expect := '<node foobar="fo&amp;lt;o&amp;bsol;&quot;b&amp;gt;ar">\nfo&amp;lt;o&amp;bsol;&quot;b&amp;gt;ar\n</node>\n'
	s := x.str()
	assert(s == expect)
}

fn test_toxml_stack() {
	mut x := toxml.new()
	assert(!x.open('',{'':''}))
	assert(!x.body('body'))
	assert(!x.close())
	x.finish()
	assert(x.str() == '')
}

fn test_toxml_comment() {
	mut x := toxml.new()
	x.comment('hello world')
	x.finish()
	expect := '<!-- hello world -->'
	assert(x.str().trim_space() == expect)
}

fn test_toxml_nest() {
	mut x := toxml.new()
	x.prolog('xml', {
		'version': '1.0'
		'encoding': 'UTF-8'
	})
	x.open('users', {
		'total': '2'
	})

	x.open('user', {
		'name': 'pancake'
		'password': '1234'
	})
	x.body('/home/pancake')
	x.close()

	x.open('user', {
		'name': 'root'
		'password': 'toor'
	})
	x.body('/root')
	x.close()

	x.comment('hello world')
	x.finish()

	expect := '<?xml version="1.0" encoding="UTF-8"?>
<users total="2">
  <user name="pancake" password="1234">
/home/pancake
  </user>
  <user name="root" password="toor">
/root
  </user>
  <!-- hello world -->
</users>
'
	assert(x.str() == expect)
}
