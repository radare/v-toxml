import toxml // serialize
import zenith391.vwxml.xml // deserialize

fn walk_into(mut toxml toxml.Toxml, node &xml.Node) {
        for t in node.childrens {
		mut attrs := map[string]string{}
                for a in t.attributes {
			attrs[a.name] = a.value
                }
		toxml.open(t.name, attrs)
		toxml.body(t.text)
		walk_into(mut toxml, &t)
		toxml.close()
        }
}

fn main() {
        node := xml.parse('<thing abc="test"><test>Hello</test><test uid="123">World</test></thing>')
	mut out := toxml.new()
	walk_into(mut out, node)
	res := out.str()
	println('$res')
}
