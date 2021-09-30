open List;;

(* Problem 1 - 
  If each element in a exists in b, then
  a is a subset of b
  Filters elements of a that do not exist in b
  If there are elements in this list, 
  then a is not a subset of b
 *)
let subset a b =
  match filter (fun x -> not(exists (fun y -> x = y) b)) a with
  | [] -> true
  | _ -> false

(* Problem 2 - 
  If a is a subset of b and b is a subset of a, 
  then a and b are equal
 *)
let equal_sets a b =
  (subset a b) && (subset b a)

(* Problem 3 - 
  Concatenates a and b using @ (list concatentation)
  (returned list may contain duplicates)
 *)
let set_union a b = a @ b

(* Problem 4 - 
  Returns the union of all sets in a
  by taking the set union set by set
  (returned list may contain duplicates)
 *)
let rec set_all_union a =
  fold_left (set_union) [] a

(* Problem 5 - 
  self_member s
  It is not possible to write a function that checks whether
  a set s is a member of itself because in OCaml, lists must be the
  same type (unlike a tuple). A list cannot be both a' and a' list type
  (which must happen in order for a set, which is a list of a',
  to be a member of itself among other elements of a' type).
 *)

(* Problem 6 - 
  Returns the computed fixed point for f with respect to x
  eq is the equality predicate for f's domain
 *)
let rec computed_fixed_point eq f x =
  if eq (f x) x then x 
  else computed_fixed_point eq f (f x)

(* Problem 7 - 
  Filters unreachable rules; finds reachable rules
  by recursively finding reachable nonterminals starting
  from the start symbol
 *)
type ('nonterminal, 'terminal) symbol =
  | N of 'nonterminal
  | T of 'terminal

let get_reachables_from_symbol symbol rules = 
  let rec get_nonterminals_rhs rules = 
    let rec parse_rhs rhs = 
      match rhs with 
      | [] -> []
      | head::tail -> match head with 
        | N symbol -> symbol::parse_rhs tail
        | _ -> parse_rhs tail
    in
      match rules with
      | [] -> []
      | head::tail -> match head with
        | (lhs, rhs) -> set_union (parse_rhs rhs) (get_nonterminals_rhs tail)
  in
  symbol::get_nonterminals_rhs (filter (fun rule -> if (fst rule) = symbol then true else false) rules)

let rec get_reachables_from_nonterminal_list nonterminals rules = 
  match nonterminals with
  | [] -> []
  | symbol::nonterminals_list -> set_union (get_reachables_from_symbol symbol rules) (get_reachables_from_nonterminal_list nonterminals_list rules)

let rec get_all_reachables reached next_level rules =
  let unchecked_nonterminals = filter (fun x -> not(exists (fun y -> x = y) reached)) next_level in
  match unchecked_nonterminals with
  | [] -> next_level
  | _ -> get_all_reachables next_level (set_union (get_reachables_from_nonterminal_list unchecked_nonterminals rules) next_level) rules

let filter_reachable g = 
  let rec find_reachable_rules start_symbol rules reachable_rules = 
    match rules with
    | [] -> []
    | head::tail -> match head with
      | (symbol, rule) -> 
        if (subset [symbol] reachable_rules) then (symbol, rule)::find_reachable_rules start_symbol tail reachable_rules
        else find_reachable_rules start_symbol tail reachable_rules
  in
  let start_symbol = fst g in
  let rules = snd g in
  (start_symbol, find_reachable_rules start_symbol rules (get_all_reachables [start_symbol] (get_reachables_from_symbol start_symbol rules) rules))
