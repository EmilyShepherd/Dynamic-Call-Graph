
# Location of AspectJ Compiler script
AJC          = ajc

# Location of Java and Jar commands
JAVA         = java
JAR          = "C:/Program Files/Java/jdk1.8.0_73/bin/jar"
JAVAC        = "C:/Program Files/Java/jdk1.8.0_73/bin/javac"

# Location of AspectJ library directory and runtime JAR
ASPECT_HOME  = C:/aspectj1.8/lib/
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
	$(AJC) $^ -outjar $@


####

TestHarness.class: TestHarness.java
	$(JAVAC) TestHarness.java

# Make the archive file for submission
archive: $(ARCHIVE).zip
$(ARCHIVE).zip: q*/$(USER)/*

# Make the archive file for sharing the test harness
harness: $(TEST_ARCHIVE).zip
$(TEST_ARCHIVE).zip: TestHarness.java makefile readme.md q*/*.java

# Actually make the zip files
%.zip:
	$(JAR) cMf $@ $^

####

# Runs all tests
runtests: test1 test2 test3

# Runs a specific test
test%: q%.jar TestHarness.class
	$(JAVA) -cp "./;$(ASPECTJRT);$<" TestHarness $(basename $<)


####

# Deletes everything
cleanall:
	rm -f *.class *.csv *.jar ajcore.*.txt $(ARCHIVE).zip $(TEST_ARCHIVE).zip

# Deletes the output of running the code
clean:
	rm -f *.csv


####

.PHONY: all clean cleanall archive harness

# JAR dependencies
q1.jar: q1/$(USER)/*.aj q1/*.java $(wildcard q1/$(USER)/*.java)
q2.jar: q2/$(USER)/*.aj q2/*.java $(wildcard q2/$(USER)/*.java)
q3.jar: q3/$(USER)/*.aj q3/*.java $(wildcard q3/$(USER)/*.java)