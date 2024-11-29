# https://www.gnu.org/software/make/manual/make.html
target [target...] : [dependent ....]
	[ command ...]


foo.o : foo.c defs.h
        cc -c -g foo.c

- How to decide whether foo.o is out of date:
	it is out of date if it does not exist,
	or if either foo.c or defs.h is more recent than it.
- How to update the file foo.o:
	by running cc as stated.
	The recipe does not explicitly mention defs.h,
	but we presume that foo.c includes it,
	and that is why defs.h was added to the prerequisites.

