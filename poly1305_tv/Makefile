polygen: polygen.c poly1305.c
	gcc polygen.c poly1305.c -o polygen
	./polygen >vectors.txt

example: main.c poly1305.c
	gcc main.c poly1305.c -o example

clean:
	rm -f *.o *~ polygen example vectors.txt
