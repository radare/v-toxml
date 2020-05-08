module toxml

struct Toxml {
mut:
	s string
	stack []string
}

pub fn new() &Toxml {
	x := &Toxml{}
	x.s = ''
	x.stack = []
	return x
}

fn escape_key(s string) string {
	// TODO : Throw an error if the key is not valid
	s = s.replace('=', '')
	s = s.replace('"', '')
	s = s.replace('<', '')
	s = s.replace('>', '')
	return s
}

fn escape_string(s string) string {
	s = s.replace('"', '\\"')
	s = s.replace('<', '&lt;')
	s = s.replace('>', '&gt;')
	// TODO : Do proper char escaping
	return s
}

fn attributes(kvs map[string]string) string {
	mut a := ''
	for k,v in kvs {
		ek := escape_key(k)
		ev := escape_string(v)
		a += ' $ek="$ev"'
	}
	return a
}

fn (x &Toxml)indent() string {
	return '  '.repeat(x.stack.len)
}

fn xmlstr(s string) string {
	return ''
}

pub fn (x &Toxml)body(msg string) {
	x.s += '$msg\n'
}

pub fn (x &Toxml)openclose(tag string, kvs map[string]string) {
	x.llopen(tag, kvs, '/')
}

pub fn (x &Toxml)prolog(tag string, kvs map[string]string) {
	x.llopen('?' + tag, kvs, '?')
}

pub fn (x &Toxml)comment(tag string) {
	nokv := map[string]string{}
	x.llopen('!--', nokv, '--')
}

pub fn (x &Toxml)open(tag string, kvs map[string]string) {
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

pub fn (x &Toxml)close() {
	tag := x.pop()
	instr := x.indent()
	x.s += '$instr</$tag>\n'
}

fn (x &Toxml)finish() {
	for x.stack.len > 0 {
		x.close()
	}
}

pub fn (x &Toxml)str() string {
	x.finish()
	return x.s
}
