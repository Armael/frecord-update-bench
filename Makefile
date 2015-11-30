genbench: genbench.ml
	ocamlopt -o genbench genbench.ml

mybench.ml: genbench
	./genbench 50 > mybench.ml

mybench_case1.cmx: mybench.ml
	ocamlopt -c -w -23 -frecord-update-switch fieldwise -o mybench_case1.cmx mybench.ml

mybench_case1.cmo: mybench.ml
	ocamlc -c -w -23 -frecord-update-switch fieldwise -o mybench_case1.cmx mybench.ml

mybench_case2.cmx: mybench.ml
	ocamlopt -c -w -23 -frecord-update-switch fieldwise -o mybench_case2.cmx mybench.ml

mybench_case2.cmo: mybench.ml
	ocamlc -c -w -23 -frecord-update-switch fieldwise -o mybench_case2.cmx mybench.ml

cases: mybench.ml mybench_case1.cmx mybench_case2.cmx

compare.cmx: compare.ml mybench_case1.cmx mybench_case2.cmx
	ocamlfind ocamlopt -c -thread -linkpkg -package unix -package bench -package gnuplot mybench_case1.cmx mybench_case2.cmx compare.ml

compare.cmo: compare.ml mybench_case1.cmo mybench_case2.cmo
	ocamlfind ocamlc -c -thread -linkpkg -package unix -package bench -package gnuplot mybench_case1.cmo mybench_case2.cmo compare.ml

top: mybench_case1.cmo mybench_case2.cmo
	rlwrap ocaml -init top.ml

main.native: main.ml compare.cmx
	ocamlfind ocamlopt -o main.native -thread -linkpkg -package unix -package bench -package gnuplot mybench_case1.cmx mybench_case2.cmx compare.cmx main.ml

main.byte: main.ml compare.cmo
	ocamlfind ocamlc -o main.byte -thread -linkpkg -package unix -package bench -package gnuplot mybench_case1.cmo mybench_case2.cmo compare.cmo main.ml

clean:
	rm -f *.cmx *.cmi *.cmo *.o
	rm -f mybench.ml
	rm -f genbench
	rm -f main.byte main.native
