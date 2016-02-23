AJC = ajc
JAVAC = "C:\Program Files\Java\jdk1.8.0_73\bin\javac"
JAVA = java
ASPECT_HOME = C:/aspectj1.8/lib/
ASPECTJRT = $(ASPECT_HOME)aspectjrt.jar


.PHONY: all clean cleanall

all: q1.jar q2.jar q3.jar

%.jar: %/A.java %/B.java %/ams2g11/Graph.aj %/ams2g11/Main.java
	$(AJC) $^ -outjar $@

q3.jar: q3/A.java q3/B.java q3/ams2g11/Graph.aj q3/ams2g11/Main.java q3/ams2g11/MethodDetails.java
	$(AJC) $^ -outjar $@

runtests: test1 test2 test3

test%: q%.jar
	$(JAVA) -cp "$(ASPECTJRT);$<" $(basename $<).ams2g11.Main

cleanall: clean
	rm -f *.jar

clean:
	rm -f *.csv