module toxml

import strings

struct Toxml {
mut:
	sb strings.Builder
	stack []string
}

pub fn new() Toxml {
	return Toxml {
		sb: strings.new_builder(0)
		stack: []
	}
}

fn escape_key(s string) string {
	// TODO : Throw an error if the key is not valid
	mut r := s.replace('=', '')
	r = r.replace('"', '')
	r = r.replace('<', '')
	r = r.replace('>', '')
	return r
}

fn escape_value(s string) string {
	return escape_html(s)
}

fn escape_html(s string) string {
	mut r := s.replace('"', '\\"')
	r = r.replace('<', '&lt;')
	r = r.replace('>', '&gt;')
	r = r.replace('\\', '&bsol;')
	// r = r.replace('\n', '')
	r = r.replace('&', '&amp;')
        r = r.replace('"', '&quot;')
        r = r.replace("'", '&apos;')
	return r
}

fn attributes(kvs map[string]string) string {
	mut a := ''
	for k,v in kvs {
		ek := escape_key(k)
		ev := escape_value(v)
		a += ' $ek="$ev"'
	}
	return a
}

fn (x &Toxml)indent() string {
	return '  '.repeat(x.stack.len)
}

pub fn (mut x Toxml)body(msg string) bool {
	if x.stack.len > 0 {
		e := escape_html(msg)
		x.sb.write_string('$e\n')
		return true
	}
	return false
}

pub fn (mut x Toxml)openclose(tag string, kvs map[string]string) bool {
	return x.llopen(tag, kvs, '/', '')
}

pub fn (mut x Toxml)prolog(tag string, kvs map[string]string) bool {
	return x.llopen('?' + tag, kvs, '?', '')
}

pub fn (mut x Toxml)comment(tag string) {
	x.llopen('!-- ', map[string]string{}, ' --', tag)
}

fn valid(s string) bool {
	return s != ''
}

pub fn (mut x Toxml)open(tag string, kvs map[string]string) bool {
	if !valid(tag) {
		return false
	}
	r := x.llopen(tag, kvs, '', '')
	x.stack << tag
	return r
}

fn (mut x Toxml)llopen(tag string, kvs map[string]string, ch string, str string) bool {
	if !valid(tag) {
		return false
	}
	attrs := attributes(kvs)
	instr := x.indent()
	x.sb.write_string('$instr<$tag$str$attrs$ch>\n')
	return true
}

fn (mut x Toxml)pop() string {
	// return *&string(x.stack.pop())
	if x.stack.len == 0 {
		return ''
	}
	tag := x.stack.last()
	x.stack.delete(x.stack.len - 1)
	return tag
}

pub fn (mut x Toxml)close() bool {
	tag := x.pop()
	if !valid(tag) {
		return false
	}
	instr := x.indent()
	x.sb.write_string('$instr</$tag>\n')
	return true
}

pub fn (mut x Toxml)finish() {
	for x.stack.len > 0 {
		x.close()
	}
}

pub fn (mut x Toxml)str() string {
	x.finish()
	return x.sb.str()
}
