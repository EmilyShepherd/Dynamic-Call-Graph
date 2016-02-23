AJC = ajc
JAVAC = "C:\Program Files\Java\jdk1.8.0_73\bin\javac"
JAVA = java
ASPECT_HOME = C:/aspectj1.8/lib/
ASPECTJRT = $(ASPECT_HOME)aspectjrt.jar
USER      = ams2g11


.PHONY: all clean cleanall

all: q1.jar q2.jar q3.jar

%.jar: %/$(USER)/*.aj %/*.java %/$(USER)/*.java
	$(AJC) $^ -outjar $@

runtests: test1 test2 test3

test%: q%.jar
	$(JAVA) -cp "$(ASPECTJRT);$<" $(basename $<).ams2g11.Main

cleanall: clean
	rm -f *.jar
	rm -f ajcore.*.txt

clean:
	rm -f *.csv