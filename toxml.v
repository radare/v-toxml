module toxml

import strings

struct Toxml {
mut:
	sb strings.Builder
	stack []string
}

pub fn new() &Toxml {
	return &Toxml{
		sb: strings.Builder{}
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

fn escape_string(s string) string {
	mut r := s.replace('"', '\\"')
	r = r.replace('<', '&lt;')
	r = r.replace('>', '&gt;')
	r = r.replace('\\', '&bsol;')
	r = r.replace('"', '&quot;')
	r = r.replace('\n', '')
	// TODO : Do proper char escaping
	return r
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

pub fn (x &Toxml)body(msg string) bool {
	if x.stack.len > 0 {
		x.sb.write('$msg\n')
		return true
	}
	return false
}

pub fn (x &Toxml)openclose(tag string, kvs map[string]string) bool {
	return x.llopen(tag, kvs, '/', '')
}

pub fn (x &Toxml)prolog(tag string, kvs map[string]string) bool {
	return x.llopen('?' + tag, kvs, '?', '')
}

pub fn (x &Toxml)comment(tag string) {
	x.llopen('!-- ', map[string]string{}, ' --', tag)
}

fn valid(s string) bool {
	return s != ''
}

pub fn (x &Toxml)open(tag string, kvs map[string]string) bool {
	if !valid(tag) {
		return false
	}
	r := x.llopen(tag, kvs, '', '')
	x.stack << tag
	return r
}

fn (x &Toxml)llopen(tag string, kvs map[string]string, ch string, str string) bool {
	if !valid(tag) {
		return false
	}
	attrs := attributes(kvs)
	instr := x.indent()
	x.sb.write('$instr<$tag$str$attrs$ch>\n')
	return true
}

fn (x &Toxml)pop() string {
	// return *&string(x.stack.pop())
	if x.stack.len == 0 {
		return ''
	}
	tag := x.stack.last()
	x.stack.delete(x.stack.len - 1)
	return tag
}

pub fn (x &Toxml)close() bool {
	tag := x.pop()
	if !valid(tag) {
		return false
	}
	instr := x.indent()
	x.sb.write('$instr</$tag>\n')
	return true
}

pub fn (x &Toxml)finish() {
	for x.stack.len > 0 {
		x.close()
	}
}

pub fn (x &Toxml)str() string {
	x.finish()
	return x.sb.str()
}
