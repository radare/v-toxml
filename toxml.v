module toxml

struct Toxml {
mut:
	s string
	stack []string
}

fn toxml_new() &Toxml {
	x := &Toxml{}
	x.s = ''
	x.stack = []
	return x
}

fn attributes(kvs map[string]string) string {
	mut a := ''
	for k,v in kvs {
		a += ' $k="$v"'
	}
	return a
}

fn (x &Toxml)indent() string {
	return '  '.repeat(x.stack.len)
}

fn xmlstr(s string) string {
	return ''
}

fn (x &Toxml)body(msg string) {
	x.s += '$msg\n'
}

fn (x &Toxml)openclose(tag string, kvs map[string]string) {
	x.llopen(tag, kvs, '/')
}

fn (x &Toxml)prolog(tag string, kvs map[string]string) {
	x.llopen('?' + tag, kvs, '?')
}

fn (x &Toxml)comment(tag string) {
	nokv := map[string]string{}
	x.llopen('!--', nokv, '--')
}

fn (x &Toxml)open(tag string, kvs map[string]string) {
	x.llopen(tag, kvs, '')
	x.stack.push(tag)
}

fn (x &Toxml)llopen(tag string, kvs map[string]string, ch string) {
	attrs := attributes(kvs)
	instr := x.indent()
	x.s += '$instr<$tag$attrs$ch>\n'
}

fn (x &Toxml)pop() string {
	// return *&string(x.stack.pop())
	tag := x.stack.last()
 	x.stack.delete(x.stack.len - 1)
	return tag
}

fn (x &Toxml)close() {
	tag := x.pop()
	instr := x.indent()
	x.s += '$instr</$tag>\n'
}

fn (x &Toxml)finish() {
	for x.stack.len > 0 {
		x.close()
	}
}

fn (x &Toxml)str() string {
	x.finish()
	return x.s
}
