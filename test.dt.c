#header "foo-module.h" {

#require "dict.h"
dict_t foo();

#require "common.h"
#require "dict.h" // will be lifted and set-union
struct foo {
	int a;
	i32 b;
	dict_t d;
};

} // ============ //

#header "common.h" {

#require <stdio.h>
#require <stdlib.h>
#require <string.h>
#require <stdtype.h>

typedef int32_t i32;

#define cat3macro(_a, _b, _c) \
	_a ## _b ## _c

} // ============ //

#require "hello.h"

struct bar {
	i32 abd;
}

void foo(struct bar b); // automatic forward-declaration
// #(put just above the first function.)

dict_t foo(struct bar b)
{
	list_t li = #list();

	list_len(li)
	list_reverse(li)
	list_iter(li, -1);
	list_push_front(li, );
	list_push_back(li, );
	list_detach(li, );
	list_t sorted_li = list_sort(li, callbk);

	#foreach (iter, list, li) {
		list_detach();
		free(item);
	}

	dict_t d = #box {
		"name" = 12;
		"-age" = strdup(12);
		"ex" = list("ammy", "bob", "tim");
	};

	free(d#["age"]);

	d#["age"] = #malloc(int);
	d#["ex"] = #list("ammy", "bob", "tim");
	return d;
}

int main()
{
	int age;
	list ex;
	char *err;
	#unbox (age, ex, err) {
		foo()
	}
	
	if (err) { printf("ERR: %s\n", err); abort() }
	return 0;
}
