
# Location of AspectJ Compiler script
AJC          = ajc

# Location of Java and Jar commands
JAVA         = java
JAR          = jar
JAVAC        = javac

# Location of AspectJ library directory and runtime JAR
ASPECT_HOME  = /aspectj1.8/lib/
ASPECTJRT    = $(ASPECT_HOME)aspectjrt.jar

# The username and archive names
USER         = ams2g11
ARCHIVE      = COMP6209_$(USER)
TEST_ARCHIVE = COMP6209_harness


################################################################

# By default, compile everything
all: q1.jar q2.jar q3.jar

# To compile each JAR, compile the java files in its directory,
# including the user's subdirectory, along with all AspectJ files
# found
%.jar:
	$(AJC) -inpath bin/ -aspectpath bin/$(basename $@)/$(USER) -outjar $@

# Build Native Java class files
bin/%.class: %.java bin/.keep
	$(JAVAC) -cp "./;$(ASPECTJRT);test.jar" -implicit:none -d bin $<

# Build AspectJ class files
bin/%.class: %.aj bin/.keep
	$(AJC) -d bin -cp "bin;$(ASPECTJRT)" $<

# Makes the bin folder, required by JavaC
%/.keep:
	@if ! [ -d $(dir $@) ]; then mkdir $(dir $@); fi
	touch $@

# Build the test JAR
test.jar: $(addprefix bin/,$(addsuffix .class,$(basename $(wildcard test/*.java))))
	cd bin && $(JAR) cf ../$@ $(addprefix $(basename $@)/,$(notdir $^))


####

# Make the archive file for submission
archive: $(ARCHIVE).zip
$(ARCHIVE).zip: q*/$(USER)/*

# Make the archive file for sharing the test harness
harness: $(TEST_ARCHIVE).zip
$(TEST_ARCHIVE).zip: test/*.java makefile readme.md q*/*.java

# Actually make the zip files
%.zip:
	$(JAR) cMf $@ $^


####

# Runs all tests
runtests: test1 test2 test3

# Runs a specific test
test%: q%.jar test.jar
	$(JAVA) -cp "$(ASPECTJRT);$<;test.jar" test.TestHarness $(basename $<)


####

# Deletes everything
cleanall:
	rm -rf bin *.csv *.jar ajcore.*.txt $(ARCHIVE).zip $(TEST_ARCHIVE).zip

# Deletes the output of running the code
clean:
	rm -f *.csv


####

.PHONY: all clean cleanall archive harness

# JAR dependencies
q1.jar: $(addsuffix .class,$(basename $(addprefix bin/,$(wildcard q1/*.java q1/$(USER)/*.java q1/$(USER)/*.aj))))
q2.jar: $(addsuffix .class,$(basename $(addprefix bin/,$(wildcard q2/*.java q2/$(USER)/*.java q2/$(USER)/*.aj))))
q3.jar: $(addsuffix .class,$(basename $(addprefix bin/,$(wildcard q3/*.java q3/$(USER)/*.java q3/$(USER)/*.aj))))

# Add test.jar as a dependancy of the specific question package files
$(addsuffix .class,$(basename $(addprefix bin/,$(wildcard q*/*.java)))): test.jar