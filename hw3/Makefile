default: clean
	javac Pigzj.java

check: default
	@chmod +x test.sh
	@./test.sh

clean: 
	@rm -f *.class *.gz em gzip_strace.txt pigz_strace.txt Pigzj_strace.txt
	