
BINDIR=bin/
LIBDIR=lib/
SRCDIR=src/
INCDIR=include/
TESTDIR=test/

APPLICATIONS:=main
MODULES:=
SUBMODULES:=
OBJECTS:=$(foreach mod,$(APPLICATIONS) $(MODULES) $(SUBMODULES),\
	$(mod:%=$(LIBDIR)%.o))
EXES:=$(APPLICATIONS:%=%$(EXE_EXT))

TEST_APPLICATIONS:=$(MODULES)
TEST_OBJECTS:=$(foreach app,$(TEST_APPLICATIONS),\
	$(app:%=$(TESTDIR)$(BINDIR)%.o))
TEST_EXES:=$(TEST_APPLICATIONS:%=$(TESTDIR)$(BINDIR)%$(EXE_EXT))

CXXFLAGS:=$(CXXFLAGS) -std=c++11 -I$(INCDIR)
LDFLAGS:=-L$(LIBDIR)

EXE_EXT?=
EXE?=$(BINDIR)main$(EXE_EXT)

default:$(OBJECTS) $(EXE)
all:default test
test:$(TEST_EXES)

$(EXE):$(OBJECTS)
	$(CXX) -o $@ $(OBJECTS) $(LDFLAGS)
$(LIBDIR)%.o: $(SRCDIR)%.cpp $(INCDIR)%.hpp
	$(CXX) $(CXXFLAGS) -c -o $@ $<

$(TESTDIR)$(BINDIR)%$(EXE_EXT): $(TESTDIR)$(LIBDIR)%.o
	$(CXX) -o $@ $(filter-out $(LIBDIR)main.o,$(OBJECTS)) $(LDFLAGS)
$(TESTDIR)$(LIBDIR)%.o: $(TESTDIR)$(SRCDIR)%.cpp
	$(CXX) $(CXXFLAGS) -c -o $@ $<

clean:;@$(RM) $(OBJECTS) $(EXES) $(TEST_OBJECTS) $(TEST_EXES)

.PHONY: all test clean

