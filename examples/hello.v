module main

import toxml

fn main() {
        mut x := toxml.new()
        x.comment('hello world')
        x.finish()
        println(x.str())
}
