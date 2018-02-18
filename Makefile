# minimalist makefile
.SUFFIXES:
#
.SUFFIXES: .cpp .o .c .h
ifeq ($(DEBUG),1)
CFLAGS = -fPIC  -std=c99 -ggdb -msse4.2 -mpclmul -march=native -mmacosx-version-min=10.11 -funroll-loops -Wstrict-overflow -Wstrict-aliasing -Wall -Wextra -pedantic -Wshadow -fsanitize=undefined  -fno-omit-frame-pointer -fsanitize=address
CXXFLAGS = -fPIC  -std=c++11 -ggdb -msse4.2 -mpclmul -march=native -funroll-loops -Wstrict-overflow -Wstrict-aliasing -Wall -Wextra -pedantic -Wshadow -fsanitize=undefined  -fno-omit-frame-pointer -fsanitize=address
else
CFLAGS = -fPIC -std=c99 -O3 -msse4.2 -mpclmul -march=native -mmacosx-version-min=10.11 -funroll-loops -Wstrict-overflow -Wstrict-aliasing -Wall -Wextra -pedantic -Wshadow
CXXFLAGS = -fPIC -std=c++11 -O3 -msse4.2 -mpclmul -march=native -funroll-loops -Wstrict-overflow -Wstrict-aliasing -Wall -Wextra -pedantic -Wshadow
endif # debug

HEADERS=include/clhash.h

OBJECTS= clhash.o

LIBDYN=libclhash.dylib
LIBSTAT=libclhash.a

all: $(OBJECTS) $(LIBDYN) $(LIBSTAT) unit cppunit benchmark example cppexample

unit : ./tests/unit.c  $(HEADERS) $(OBJECTS)
	$(CC) $(CFLAGS) -o unit ./tests/unit.c -Iinclude  $(OBJECTS)

cppunit : ./tests/cppunit.cpp  $(HEADERS) $(OBJECTS)
	$(CXX) $(CXXFLAGS) -o cppunit ./tests/cppunit.cpp -Iinclude  $(OBJECTS)


example : ./example.c $(HEADERS) $(OBJECTS)
	$(CC) $(CFLAGS) -o example example.c -Iinclude  $(OBJECTS)

cppexample : ./cppexample.cpp $(HEADERS) $(OBJECTS)
	$(CXX) $(CXXFLAGS) -o cppexample cppexample.cpp -Iinclude  $(OBJECTS)


benchmark :./benchmarks/benchmark.c $(HEADERS) $(OBJECTS)
	$(CC) $(CFLAGS) -o benchmark ./benchmarks/benchmark.c -Iinclude  $(OBJECTS)

$(LIBDYN) : $(OBJECTS)
	libtool -macosx_version_min 10.11 -dynamic -o $(LIBDYN) $(OBJECTS) -lSystem

$(LIBSTAT) : $(OBJECTS)
	libtool -static -o $(LIBSTAT) $(OBJECTS)

clhash.o: ./src/clhash.c $(HEADERS)
	$(CC) $(CFLAGS) -c ./src/clhash.c -Iinclude

clean:
	rm -f $(OBJECTS) $(LIBDYN) $(LIBSTAT) unit cppunit example cppexample benchmark
