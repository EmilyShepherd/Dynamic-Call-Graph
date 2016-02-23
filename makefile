
# Location of AspectJ Compiler script
AJC         = ajc

# Location of Java and Jar commands
JAVA        = java
JAR         = "C:/Program Files/Java/jdk1.8.0_73/bin/jar"

# Location of AspectJ library directory and runtime JAR
ASPECT_HOME = C:/aspectj1.8/lib/
ASPECTJRT   = $(ASPECT_HOME)aspectjrt.jar

# The username and archive names
USER        = ams2g11
ARCHIVE     = COMP6209_$(USER)


################################################################

# By default, compile everything
all: q1.jar q2.jar q3.jar

# To compile each JAR, compile the java files in its directory,
# including the user's subdirectory, along with all AspectJ files
# found
%.jar: %/$(USER)/*
	$(AJC) $^ -outjar $@

# Make the archive file for submission
archive: $(ARCHIVE).zip
$(ARCHIVE).zip: q*/$(USER)/*
	$(JAR) cMf $@ $^

####

# Runs all tests
runtests: test1 test2 test3

# Runs a specific test
test%: q%.jar
	$(JAVA) -cp "$(ASPECTJRT);$<" $(basename $<).ams2g11.Main


####

# Deletes everything
cleanall: clean
	rm -f *.jar
	rm -f ajcore.*.txt
	rm -f $(ARCHIVE).zip

# Deletes the output of running the code
clean:
	rm -f *.csv


####

.PHONY: all clean cleanall archive

