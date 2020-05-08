XML Serialization library for V
===============================

Usage example: 

```go
import toxml

fn main() {
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
	println(x)
}
```
