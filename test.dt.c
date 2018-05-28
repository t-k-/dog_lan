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

void foo(); // automatic forward-declaration

dict_t foo()
{
	list_t li = #list();

	list_len(li)
	list_reverse(li)
	list_iter(li, -1);
	list_push_front(li, );
	list_push_back(li, );
	list_detach(li, );

	#sort(list, li, iter1, iter2) {
		return iter1 > iter2;
	}

	#foreach (iter, list, li) {
		list_detach();
		free(item);
	}


	dict_t d = #dict(
		"*age" = strdup(12),
		"ex" = list("ammy", "bob", "tim")
	);

	free(d#["age"]);

//	void *k = a.key("age");
//	*k = malloc(sizeof(int));
//	*(*k) = 12;

	d#["age"] = #new(int, 12);
	d#["ex"] = #list("ammy", "bob", "tim");
	return d;
}

int main()
{
	int age;
	list ex;
	char *err;
	#catch (age, ex) { foo() } {
		ABORT_ON_ERROR;
	}

	// or ...
	#catch { bar() } {
		ABORT_ON_ERROR; // if non-zero returned.
	}

	return 0;
}
