

dir_1 := src
final = ./exe/plague ./corpus_files/catchmeifyoucan.txt ./corpus_files

.PHONY: all $(dir_1) 
all: $(dir_1) $(final) RUN

$(dir_1):
	$(MAKE) --directory=$@ $(TARGET)



.PHONY: RUN clean no_stats last_modified install
# specific commands
RUN: 
	@echo ".............\nRunning final exectuables\n............." 
	$(final)
	


clean:
	@echo "All exe and obj cleared" 
	@rm -f ./exe/*
	@#@ is used to silence the make command/comment
