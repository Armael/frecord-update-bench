open Gnuplot

module type S = sig
  val benchs : (string * (unit -> unit)) list list
end

module M1 : S = Mybench_case1
module M2 : S = Mybench_case2

let benchs1 = M1.benchs |> Array.of_list
let benchs2 = M2.benchs |> Array.of_list

let do_benchs min_rec_sz max_rec_sz =
  let mkbenchs benchs =
    Array.init (max_rec_sz - min_rec_sz + 1) (fun i ->
      Bench.bench_funs benchs.(min_rec_sz + i - 2) ()
    ) in
  (mkbenchs benchs1, mkbenchs benchs2)

let graph ?out results1 results2 rec_sz =
  let gp = Gp.create () in
  begin match out with
    | None -> ()
    | Some path -> Gp.set ~output:(Output.create (`Png path)) gp
  end;
  let series title results = 
    Series.lines_xy ~title (List.mapi (fun i res ->
      (float_of_int @@ i+1,
       res.Bench.mean.Bench.Bootstrap.point)
    ) results.(rec_sz - 1)) in

  Gp.plot_many gp [
    series "Case 1" results1;
    series "Case 2" results2;
  ];
  Gp.close gp

let draw_graphs ?out (res1, res2) =
  for i = 1 to Array.length res1 do
    graph ?out res1 res2 i
  done

