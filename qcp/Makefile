CURRENT_DIR=.
SLL_DIR=../sll

-include CONFIGURE

echo_dir : 
	@echo "COQBIN=$(COQBIN)" > SUB_CONFIGURE
	@echo "SUF=$(SUF)" >> SUB_CONFIGURE
	@echo "SLL_DIR=$(SLL_DIR)" >> SUB_CONFIGURE
	@echo "SL_DIR=$(SL_DIR)" >> SUB_CONFIGURE
	@echo "COMMON_STRATEGY_DIR=$(COMMON_STRATEGY_DIR)" >> SUB_CONFIGURE

SLL_MAKE : 
	cp SUB_CONFIGURE $(CURRENT_DIR)/sll/CONFIGURE
	cp SUB_CONFIGURE $(CURRENT_DIR)/sll-hw/CONFIGURE
	cd sll && $(MAKE) depend && $(MAKE) all -j5

DLL_MAKE : 
	cp SUB_CONFIGURE $(CURRENT_DIR)/dll/CONFIGURE
	cp SUB_CONFIGURE $(CURRENT_DIR)/dll-hw/CONFIGURE
	cd dll && $(MAKE) depend && $(MAKE) all -j5

ARITH_MAKE : 
	cp SUB_CONFIGURE $(CURRENT_DIR)/arith/CONFIGURE
	cp SUB_CONFIGURE $(CURRENT_DIR)/arith-hw/CONFIGURE
	cd arith && $(MAKE) depend && $(MAKE) all -j5

TREE_MAKE : 
	cp SUB_CONFIGURE $(CURRENT_DIR)/tree/CONFIGURE
	cp SUB_CONFIGURE $(CURRENT_DIR)/tree-hw/CONFIGURE
	cd tree && $(MAKE) depend && $(MAKE) all -j5

ALGO_MAKE : 
	cp SUB_CONFIGURE $(CURRENT_DIR)/algorithm/CONFIGURE
	cd algorithm && $(MAKE) depend && $(MAKE) all -j5

all : echo_dir SLL_MAKE DLL_MAKE ARITH_MAKE TREE_MAKE ALGO_MAKE
	@echo "All subdirectories have been built."


clean:
	cd sll && $(MAKE) clean
	cd dll && $(MAKE) clean
	cd arith && $(MAKE) clean
	cd tree && $(MAKE) clean
	cd algorithm && $(MAKE) clean
	

.PHONY: clean depend
.DEFAULT_GOAL := all

-include .depend

-include $(DEPS)