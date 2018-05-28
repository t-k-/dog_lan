#import "string" @ list.h
@list_len
@struct a

typedef int aint;
struct foo;
struct foo {
	int a;
	aint b;
};

const int max_doc_id = UINT_MAX

#define macro(_a, _b, _c) \
	_a ## _b ## _c

void foo();

dict_t foo()
{
	list_len(li)
	list_sort(li, cmp_foo)
	list_tail(iter);
	list_head(iter);

	#foreach (i, b, a) {
		list_detach();
		free(item);
	}

	hashmap {a: b, c: d}
	a, b, c <- foo(bar)

	dict_t d = #new(dict_t, #dict(
		"*age": strdup(12),
		"ex": list("ammy", "bob", "tim")
	));

	d = #dict(
		"*age": strdup(12),
		"ex": list("ammy", "bob", "tim")
	);

	free(d#["age"]);

	void *k = a.key("age");
	*k = malloc(sizeof(int));
	*(*k) = 12;

	d#["age"] = #new(int, 12);

	d#["ex"] = #list("ammy", "bob", "tim");

	return d;
}

int main()
{
	dict_t d = foo();

	int age = d#["age"];
	return 0;
}
