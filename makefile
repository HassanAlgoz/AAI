watch:
	# How it breaks down:
	# fzf: Recursively lists all files in your current directory and opens an interactive, searchable interface.
	# Just start typing any part of the filename or path.
	# xargs -o: Takes the file path you selected and appends it to the next command.
	# The -o flag is crucial here—it ensures typst watch can still safely take control of your terminal input.
	fzf | xargs -o typst watch --root .

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

preview:
	quarto preview ./content

publish:
	quarto publish gh-pages ./content --no-render

# restore:
# 	git restore --staged --worktree content/ old/
# 	git clean -fd content/ old/
