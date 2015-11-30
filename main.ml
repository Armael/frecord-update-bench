let min = ref 2
let max = ref 1
let output_file = ref None

let opts = [
  "-out", Arg.String (fun s -> output_file := Some s), "output graph to png file";
]

let parse_args =
  let i = ref 0 in
  fun s ->
    begin
      if !i = 0 then min := int_of_string s
      else if !i = 1 then max := int_of_string s
      else ()
    end; incr i

let _ =
  Arg.parse opts parse_args (Printf.sprintf "Usage: %s <min record size> <max record size>" Sys.argv.(0));
  Compare.(draw_graphs ?out:!output_file (do_benchs !min !max))
