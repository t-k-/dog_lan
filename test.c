#import moduleA
// list_len, list_sort, list_generator ...

	/* generic for */
	{
		struct list_iterator g = list_generator(li);
		do {
			struct T *t = MEMBER_2_STRUCT(g.cur.now, struct T, ln);
			printf("item %d \n", t->i);
		} while (list_next(li, &g));
	}

	list_len(li)
	list_sort(li, cmp_foo)

	for_each(iter, list, li) {
		ele -> element(iter, struct T);
		printf("%d\n", ele->i);
		list_tail(iter)
		list_head(iter)
		continue;
		break;
	}

	hashmap {a: b, c: d}
	a, b, c <- foo(bar)
