all:	poster.tex
	python compile_refs.py
	open poster.pdf
