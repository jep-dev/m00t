# Directories in root
BINDIR=bin/
LIBDIR=lib/
SRCDIR=src/
INCDIR=include/

# Directory shadowing root
TESTDIR=test/

# File extension of an executable; empty for Linux, .exe for Windows
EXE_EXT?=

# Root module implementing main function
APPLICATIONS:=main
# Root modules not implementing main
MODULES:=
# Root submodules to modules above
SUBMODULES:=
# Object files produced by compiling the above
OBJECTS:=$(foreach mod,$(APPLICATIONS) $(MODULES) $(SUBMODULES),\
	$(mod:%=$(LIBDIR)%.o))
# Executable(s) produced by linking the object files
EXES:=$(APPLICATIONS:%=%$(EXE_EXT))

# Each test application implements main to test a module
TEST_APPLICATIONS:=$(MODULES)
# Single object files to link into test applications
TEST_OBJECTS:=$(foreach app,$(TEST_APPLICATIONS),\
	$(app:%=$(TESTDIR)$(BINDIR)%.o))
# Executables produced by linking the test object files
TEST_EXES:=$(TEST_APPLICATIONS:%=$(TESTDIR)$(BINDIR)%$(EXE_EXT))

# Compiler arguments
CXXFLAGS:=$(CXXFLAGS) -std=c++11 -I$(INCDIR)
# Linker arguments
LDFLAGS:=-L$(LIBDIR)

# Targets selected by default (no make arguments)
default:$(OBJECTS) $(EXES)
# Targets selected by executing 'make test'
test:$(TEST_OBJECTS) $(TEST_EXES)
# Targets selected by executing 'make all'
all:default test

# Root executable target, dependent on root objects
$(BINDIR)%$(EXE_EXT):$(OBJECTS)
	$(CXX) -o $@ $(OBJECTS) $(LDFLAGS)
# Root object file target, dependent on corresponding source & header
$(LIBDIR)%.o: $(SRCDIR)%.cpp $(INCDIR)%.hpp
	$(CXX) $(CXXFLAGS) -c -o $@ $<

# Test executable target, dependent on corresponding test module
$(TESTDIR)$(BINDIR)%$(EXE_EXT): $(TESTDIR)$(LIBDIR)%.o
	$(CXX) -o $@ $(filter-out $(LIBDIR)main.o,$(OBJECTS)) $(LDFLAGS)
# Test object file target, dependent on corresponding module source
$(TESTDIR)$(LIBDIR)%.o: $(TESTDIR)$(SRCDIR)%.cpp
	$(CXX) $(CXXFLAGS) -c -o $@ $<

# Remove all output files by executing 'make clean'
clean:;@$(RM) $(OBJECTS) $(EXES) $(TEST_OBJECTS) $(TEST_EXES)

# Targets that aren't supposed to produce output of the same name
.PHONY: all test clean

