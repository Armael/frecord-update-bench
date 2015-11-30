let record_def sz cout =
  Printf.fprintf cout "(**** Type & dummy value for [r%d] *)\n\n" sz;
  Printf.fprintf cout "type r%d = {\n" sz;
  for i = 1 to sz do
    Printf.fprintf cout "  r%d_%d : int option;\n" sz i
  done;
  Printf.fprintf cout "}\n\n";
  Printf.fprintf cout "let r%d = { " sz;
  for i = 1 to sz do
    Printf.fprintf cout "r%d_%d = Some 0; " sz i
  done;
  Printf.fprintf cout "}\n"

let record_setn rec_sz n cout =
  Printf.fprintf cout "let set%d_r%d r = {\n" n rec_sz;
  Printf.fprintf cout "  r with\n";
  for i = 1 to n do
    Printf.fprintf cout "  r%d_%d = Some 0;\n" rec_sz i
  done;
  Printf.fprintf cout "}\n"

let record_all_setn rec_sz cout =
  Printf.fprintf cout "(**** [r%d]: Functional update functions *)\n\n" rec_sz;
  for i = 1 to rec_sz - 1 do
    if i > 1 then output_string cout "\n";
    record_setn rec_sz i cout;
  done

let bench_all_setn rec_sz cout =
  Printf.fprintf cout "(**** Benchs for [r%d] *)\n\n" rec_sz;
  Printf.fprintf cout "let _ =\n benchs := [\n";
  for i = 1 to rec_sz - 1 do
    Printf.fprintf cout "  (\"set%d_r%d\", fun () -> ignore (set%d_r%d r%d));\n"
      i rec_sz i rec_sz rec_sz;
  done;
  Printf.fprintf cout "] :: !benchs\n"

let () =
  let max_rec_sz =
    match Sys.argv |> Array.to_list |> List.tl with
    | [sz] -> int_of_string sz
    | _ ->
      Printf.printf
        "Usage: %s max_size, where max_size is the maximum number of fields\n"
        Sys.argv.(0);
      exit 1
  in
  let cout = stdout in

  Printf.fprintf cout "let benchs = ref []\n\n";
  
  for sz = 2 to max_rec_sz do
    record_def sz cout;
    output_string cout "\n";
    record_all_setn sz cout;
    output_string cout "\n";
    bench_all_setn sz cout;
    output_string cout "\n";
  done;

  Printf.fprintf cout "let benchs = List.rev !benchs\n"
