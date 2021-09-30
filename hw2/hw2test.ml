let accept_all string = Some string

type sentence_nonterminals =
  | S | NP | VP | No | V | D | Adj | Adv

let sentence_grammar = (S, 
    [S, [N NP; N VP];
    NP, [N No];
    NP, [N Adj; N No];
    NP, [N D; N Adj; N No];
    NP, [N D; N No];
    VP, [N V];
    VP, [N V; N Adv];
    No, [T"dog"];
    No, [T"horse"];
    No, [T"girl"];
    V, [T"eats"];
    V, [T"runs"];
    V, [T"pops off"];
    D, [T"The"];
    D, [T"A"];
    Adj, [T"swifty"];
    Adj, [T"strong"];
    Adv, [T"slowly"];
    Adv, [T"lazily"]])

let the_grammar = convert_grammar sentence_grammar

(* While the full fragment can be matched, the matcher
matches the first possible prefix, which is "The swifty dog runs" 
*)
let the_frag = ["The"; "swifty"; "dog"; "runs"; "lazily"]

let make_matcher_test = 
    make_matcher the_grammar accept_all the_frag = Some ["lazily"]

let new_frag = ["The"; "swifty"; "dog"; "runs"]

let parse_tree = make_parser the_grammar new_frag 

let make_parser_test = parse_tree = 
    Some (Node (S,
                [Node (NP,
                        [Node (D,
                            [Leaf "The"]);
                         Node (Adj, 
                            [Leaf "swifty"]);
                         Node (No,
                            [Leaf "dog"])]);
                 Node (VP,
                        [Node (V,
                            [Leaf "runs"])])]))

let parse_leaves_test = match parse_tree with
    | Some tree -> parse_tree_leaves tree = new_frag
    | _ -> false

