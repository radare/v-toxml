import toxml
import os

const (
header = '
XML Serialization library for V
===============================

![CI](https://github.com/radare/v-toxml/workflows/CI/badge.svg)

Usage example: 

```go
import toxml
'

footer = '
```
The output for this code is the following:

```xml
'
)

fn main_code() string {
	contents := os.read_file(@FILE) or { panic(err) }
	fn_main_index := contents.index('fn main' + '() {') or { panic(err) }
	fn_main := contents[fn_main_index..]
	lines := fn_main.split('\n')
	mut res := []string{}
	for line in lines {
		if line.contains('println') && !line.contains('(x)') {
			continue
		}
		res << line
	}
	return res.join('\n')
}

fn main() {
	mc := main_code()
	println(header)
	println(mc)
	x := toxml.new()
	x.prolog('xml', {
		'version': '1.0'
		'encoding': 'UTF-8'
	})
	x.open('testsuites', {
		'id': '20150612_170402'
		'name': 'new-config'
		'tests': '1234'
		'failures': '1234'
		'time': '1234'
	})
	x.open('testsuite', {
		'id': '20150612_170402'
		'name': 'new-config'
		'time': '1234'
	})
	x.open('testcase', {
		'id': '20150612_170402'
		'name': 'new-config'
		'time': '1234'
	})
	x.open('failure', {
		'message': 'Warning message here'
		'type': 'WARNING'
	})
	x.body('Warning')
	x.close()
	x.finish()

	println(footer)
	println(x)
	println('``' + '`\n')
}
