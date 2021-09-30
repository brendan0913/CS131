open List

type ('nonterminal, 'terminal) symbol =
  | N of 'nonterminal
  | T of 'terminal

(* 
 * Problem 1 - Converts the HW1 grammar to HW2 grammar
 * Returns a start symbol-production function pair, where
 * the production function takes a nonterminal as an argument
 *)
let convert_grammar gram1 =
  let rec concat_rules rules nt = 
    match rules with
      | [] -> []
      | head::tail -> if nt = fst head then snd head::concat_rules tail nt 
                      else concat_rules tail nt
  in fst gram1, concat_rules (snd gram1)

(* 
 * Problem 2 - Parses tree from left to right and yields a
 * list of terminal symbols / fragment / leaves
 *)
type ('nonterminal, 'terminal) parse_tree =
  | Node of 'nonterminal * ('nonterminal, 'terminal) parse_tree list
  | Leaf of 'terminal

let parse_tree_leaves tree =
  let rec helper = function
    | [] -> []
    | Leaf l::tail -> l::helper tail
    | Node (_, children)::tail -> (helper children) @ (helper tail)
  in helper [tree]

(* 
 * Problem 3 - Makes a matcher for the grammar gram.
 * A match is acceptable if the acceptor succeeds when given the
 * suffix fragment that immediately follows the matching prefix
 *    The matcher returns what the acceptor returns. 
 *    If no acceptable match is found, the matcher returns None.
 * parse_rules - Goes through rules, checking if the fragment can be
 * represented by the current rule
 *    If not, moves on to next rule
 *    If no more remaining rules to check, there is no match
 * match_fragment - Goes through current rule of parse_rules
 *    If terminal symbol in rule matches the current fragment's
 *    terminal, attempts to the match the rest of the fragment. 
 *    If nonterminal symbol, parses the reachable rules from the
 *    nonterminal using match_fragment on the tail of the rule as
 *    the acceptor.
 *)
let rec make_matcher gram = 
  let rec parse_rules accept frag func_rules = function
    | [] -> None
    | head_rule::tail_rules -> match match_fragment func_rules head_rule accept frag with (* check all possible matches from head_rule *)
      | Some suffix -> Some suffix
      | None -> parse_rules accept frag func_rules tail_rules (* if no match for current rule, continue with next rule in tail_rules *)
  and match_fragment func_rules rule accept frag =
    match rule with
      | [] -> accept frag
      | T t::tail -> (match frag with
        | [] -> None
        | head_frag::tail_frag -> 
            if t = head_frag then let new_accept = match_fragment func_rules tail accept in new_accept tail_frag
            else None)
      | N nt::tail -> match frag with
        | [] -> (match rule with 
          | [] -> accept frag
          | _ -> None)
        | _ -> let new_accept = match_fragment func_rules tail accept in parse_rules new_accept frag func_rules (func_rules nt)
  in match gram with
    | (start, func_rules) -> fun accept frag -> parse_rules accept frag func_rules (func_rules start)

(* 
 * Problem 4
 * parse_fragment - Very similar to the matcher from #3, but returns the full derivation in
 * addition to the accepted suffix, using an acceptor that accepts all derivation-string pairs
 * make_parser - Finds the full derivation for the given grammar and fragment,
 * and makes subtrees from the top nonterminal symbol of the derivation to form the full tree
 *    The only case from the modified matcher where there is a parse tree is if there is a nonempty
 *    set of dervied_rules from the start_symbol to the fragment and if the suffix from the accept_all
 *    acceptor (accepts every derivation-suffix pair) is empty (meaning the matched prefix is the entire 
 *    fragment). If the suffix is not empty, then the entire fragment cannot be parsed as a tree.
 *)
let parse_fragment gram =
  let accept_all_ds_pair derivation string = Some (derivation, string) in
  let rec parse_rules accept derivation frag start func_rules = function
    | [] -> None
    | head_rule::tail_rules -> match match_fragment func_rules head_rule accept (derivation @ [start, head_rule]) frag with
      | Some rules_suffix_pair -> Some rules_suffix_pair 
      | None -> parse_rules accept derivation frag start func_rules tail_rules
  and match_fragment func_rules rule accept derivation frag = 
    match rule with
      | [] -> accept derivation frag
      | T t::tail -> (match frag with
        | [] -> None
        | head_frag::tail_frag -> 
            if t = head_frag then let new_accept = match_fragment func_rules tail accept derivation in new_accept tail_frag
            else None)
      | N nt::tail -> match frag with
        | [] -> (match rule with 
          | [] -> accept derivation frag
          | _ -> None)
        | _ -> let new_accept = match_fragment func_rules tail accept in parse_rules new_accept derivation frag nt func_rules (func_rules nt)  
  in match gram with 
    | (start, func_rules) -> fun frag -> parse_rules accept_all_ds_pair [] frag start func_rules (func_rules start)

let make_parser gram = 
  (* make_subtree returns (rules for subtree, subtree) pair 
     make_tree returns (derived_rules, tree) pair by concatenating subtrees 
     derived_rules will be empty by the end *)
  let rec make_subtree derived_rules = function
    | T t -> derived_rules, Leaf t
    | N nt -> match derived_rules with
      | [] -> [], Node (nt, [])
      | head::tail -> let st = make_tree tail (snd head) in
                      fst st, Node (nt, snd st) (* roots subtree at Node of tree *)
  and make_tree derived_rules = function
    | [] -> derived_rules, []
    | head::tail -> let subtree = make_subtree derived_rules head in (* (rule, subtree) *)
                    let tree = make_tree (fst subtree) tail in       (* (rules for subtree, rest_of_subtrees) *)
                    fst tree, snd subtree::snd tree                  (* (rules for subtree, subtree::rest_of_subtrees) --> (rules, tree) *)
  in fun frag -> match parse_fragment gram frag with
    | None -> None                       (* no match *)
    | Some ([], _) -> None               (* no derived rules to fragment *)
    | Some (derived_rules, []) ->        (* AVAILABLE PARSE TREE: derived rules to entire fragment (no suffix) *)
        let print_tree t = hd (snd t) in (* t is represented as a pair (derived_rules, tree) *)
        let get_first_nt d_rules = [N (fst (hd d_rules))] in (* derived_rules starts with nonterminal start symbol *)
        Some (print_tree (make_tree derived_rules (get_first_nt derived_rules)))
    | Some (derived_rules, _) -> None    (* derived rules to only part of the fragment, as a nonempty suffix is
                                            returned by matcher that uses accept_all acceptor *)
