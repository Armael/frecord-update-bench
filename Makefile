genbench: genbench.ml
	ocamlopt -o genbench genbench.ml

gen:
	./genbench 50 > mybench.ml

mybench_case1.cmx:
	ocamlopt -c -w -23 -frecord-update-switch fieldwise -o mybench_case1.cmx mybench.ml

mybench_case1.cmo: 
	ocamlc -c -w -23 -frecord-update-switch fieldwise -o mybench_case1.cmx mybench.ml

mybench_case2.cmx:
	ocamlopt -c -w -23 -frecord-update-switch fieldwise -o mybench_case2.cmx mybench.ml

mybench_case2.cmo: 
	ocamlc -c -w -23 -frecord-update-switch fieldwise -o mybench_case2.cmx mybench.ml

cases: mybench.ml mybench_case1.cmx mybench_case2.cmx

compare: compare.ml mybench_case1.cmx mybench_case2.cmx
	ocamlfind ocamlopt -o compare -thread -linkpkg -package unix -package bench -package gnuplot mybench_case1.cmx mybench_case2.cmx compare.ml

top: mybench_case1.cmo mybench_case2.cmo
	rlwrap ocaml -init top.ml

clean:
	rm -f *.cmx *.cmi *.cmo *.o
	rm -f genbench
