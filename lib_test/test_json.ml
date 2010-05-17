TYPE_CONV_PATH "Json"
open Printf

type i1 = int32
and  i2 = int
and  i3 = int64
and  i4 = ( int32 * int * int64 )
and  p =
  | One of string * int array
  | Two of t
  | Three of x option list
  | Four

and pp = [ `Poly1 | `Poly2 | `Poly3 of int ]

and t = {
  t1: int;
  mutable t2: string;
  t3: x
} and x = {
  x1: t array;
  x2: int64
} and f = {
  mutable f1: int;
  mutable f2: string list;
  f3: string;
  f4: int64;
  f5: char array;
} and tu = ( int  * f * pp )

with json

type o =
  < x: f; y: x; z: (int -> string) > 
  with json

let i1 = 5l
let i2 = 6
let i3 = 7L
let i4 = ( 100l, 101, 102L)
let p = One ("foo", [|1;2;3|])
let p' = Four
let pp = `Poly2
let rec t = { t1=1000; t2="t"; t3=x }
and t' = {t1=1001; t2="t'"; t3=x }
and x = { x1=[| t; t' |]; x2=9L }
let f = { f1=1; f2=["f";"f'"]; f3="f3x"; f4=99L; f5=[|'a';'b';'c'|] }
let tu = ( 3, f, pp )
let o = object method x=f method y=x method z i = string_of_int i end

open OUnit

let (<=>) n (f,t,v) =
  let json = f v in
  printf "%s: json1= %s\n%!" n json;
  try
    let v' = t json in
    let json' = f v' in
    printf "%s: json2= %s\n%!" n json';
    ("EQ " ^ n) @? ( json = json' )
  with
    e -> printf "ERR: %s\n%!" (Printexc.to_string e); raise e

let test_t ()  = "t"  <=> (json_of_t, t_of_json, t)
let test_x ()  = "x"  <=> (json_of_x, x_of_json, x)
let test_f ()  = "f"  <=> (json_of_f, f_of_json, f)
let test_tu () = "tu" <=> (json_of_tu, tu_of_json, tu)

let suite = [
  "test_t" >::  test_t;
  "test_x" >::  test_x
(*
  "test_f" >::  test_f;
  "test_tu" >::  test_tu;
*)
]
