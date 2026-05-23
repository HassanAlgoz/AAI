watch:
	# How it breaks down:
	# fzf: Recursively lists all files in your current directory and opens an interactive, searchable interface.
	# Just start typing any part of the filename or path.
	# xargs -o: Takes the file path you selected and appends it to the next command.
	# The -o flag is crucial here—it ensures typst watch can still safely take control of your terminal input.
	fzf | xargs -o typst watch --root .


compress:
	@echo "Compressing PNG assets..."
	@find assets/ -type f -name '*.png' -print0 | xargs -0 -I{} oxipng -o 4 --strip safe --alpha {}

# Find all .typ files recursively
SRC_FILES := $(shell find courses/ -name "*.typ")

# Define the target to compile everything
compile:
	@for file in $(SRC_FILES); do \
			filename=$$(basename $$file .typ); \
			target="pdf/$$filename.pdf"; \
			if [ -f "$$target" ] && [ "$(FORCE)" != "1" ]; then \
				echo "Skipping $$filename.pdf (already exists)"; \
			else \
				echo "Compiling $$file -> $$target"; \
				typst compile $$file $$target --root .; \
			fi; \
		done

# recompile: Forces compilation of all files
recompile:
	@$(MAKE) compile FORCE=1

check:
	@echo "Running all scripts in scripts/check/..."
	@for script in scripts/check/*; do \
		if [ -x "$$script" ]; then \
			echo "Running $$script..."; \
			"$$script" || exit 1; \
		else \
			echo "Skipping $$script (not executable)"; \
		fi \
	done