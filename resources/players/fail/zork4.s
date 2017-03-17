.comment "I'M
	ALIIIIVE"
.name "zo
	rk"

l1:
l2:     sti r1, %:live, %1
aff r12
	and r1, %0, r1

 live:	live %1
		zjmp %:live
