let subset_test0 = subset [] []
let subset_test1 = subset [] [1;2;3]
let subset_test2 = not (subset [1;2;3] [])
let subset_test3 = subset [1;2] [1;2;3;4]
let subset_test4 = subset [2;1] [1;2;3;4]
let subset_test5 = subset [1;1] [1;2;3;4]
let subset_test6 = subset [1;1;1;1;1;1] [1;2;3;4]
let subset_test7 = subset [1;1;1;3] [1;2;3;4]
let subset_test8 = subset [1;2;3;4] [1;2;3;4]
let subset_test9 = not (subset [1;6] [1;2;3])
let subset_test10 = not (subset [1] [])
let subset_test11 = subset [[1;2];[1;3];[1;1]] [[6;9];[1;2];[1;3];[1;1];[1;1];[1;4];[4;1]]

let equal_sets_test0 = equal_sets [] []
let equal_sets_test1 = equal_sets [[1;2];[3;4]] [[3;4];[1;2]]
let equal_sets_test2 = not (equal_sets [[1;2];[3;4]] [[2;1];[4;3]])
let equal_sets_test3 = equal_sets [1;2] [2;1]
let equal_sets_test4 = equal_sets [1;2;3] [1;2;3]
let equal_sets_test5 = equal_sets [1;1;2] [1;2;1]
let equal_sets_test6 = not (equal_sets [1] []) 
let equal_sets_test7 = not (equal_sets [] [1])
let equal_sets_test8 = equal_sets [1;1] [1]
let equal_sets_test9 = not (equal_sets [1;2;3] [4;5;6])
let equal_sets_test10 = not (equal_sets [1;2;3;4] [1;2;3;5])

let set_union_test0 = equal_sets(set_union [] []) []
let set_union_test1 = equal_sets(set_union [1;1] [1;1]) [1]
let set_union_test2 = equal_sets(set_union [1;2] [2;3]) [1;2;3]
let set_union_test3 = equal_sets(set_union [1;2;3] []) [1;2;3]
let set_union_test4 = equal_sets(set_union [] [1;2;3]) [1;2;3]

let set_all_union_test0 = equal_sets(set_all_union [ [1;2]; []; []; [1;2;3;4] ]) [1;2;3;4]
let set_all_union_test1 = equal_sets(set_all_union [ [[1]]; [[2]]; [[2]]; [] ]) [[1];[2]]
let set_all_union_test2 = equal_sets(set_all_union [ [1;2]; [6;9]; [72]; [1;2;3;4] ]) [1;2;3;4;6;9;72]
let set_all_union_test3 = equal_sets(set_all_union [ [[1;2]]; [[2;3]]; [[1;2]]; [[1;4]] ]) [[1;2];[2;3];[1;4]]
let set_all_union_test4 = equal_sets(set_all_union [ [1;6;1]; [2;2;2]; [-1;1]; [1;2;3;4] ]) [-1;1;2;3;4;6]

let computed_fixed_point_test0 = computed_fixed_point (=) (fun x -> x) 10 = 10
let computed_fixed_point_test1 = computed_fixed_point (=) (fun x -> x / 3) 10000 = 0
let computed_fixed_point_test2 = computed_fixed_point (=) (fun x -> x *. 2.) 1. = infinity
let computed_fixed_point_test3 = computed_fixed_point (<) (fun x -> x / 2) 10 = 10
let computed_fixed_point_test3 = computed_fixed_point (>) (fun x -> x + 1) 10 = 10

type song_nonterminals = | A | B | C | D | E
let song_rules = 
	[	
		A, [N E; N B; N A];
		B, [N B; N C; T"polo"];
		C, [T"nle"; N D; T"tee"];
		D, [T"yacht"];
		E, [T"uzi"]
	]

let song_test0 = filter_reachable (A, song_rules) = (A, song_rules)
let song_test1 = filter_reachable (B, song_rules) = (B, [	B, [N B; N C; T"polo"];	C, [T"nle"; N D; T"tee"];	D, [T"yacht"] ])
let song_test2 = filter_reachable (D, song_rules) = (D, [	D, [T"yacht"] ])
let song_test3 = filter_reachable (A, List.tl song_rules) = (A, [])
let song_test4 = filter_reachable (B, List.tl song_rules) = (B, [	B, [N B; N C; T"polo"];	C, [T"nle"; N D; T"tee"];	D, [T"yacht"] ])

type brig_nonterminals = | A | B | C | D | E | F
let brig_rules = 
	[	
		A, [N B; N F; T"brrrr"];
		B, [N B; N C; T"pew"];
		C, [T"nyoo"; N D; T"vssssh"; N A; N E];
		D, [T"shkk"; N E];
		E, [T"eeeer"];
		F, [T"allmyhomieshatebrig"; N A]
	]

let brig_test0 = filter_reachable (A, brig_rules) = (A, brig_rules)
let brig_test1 = filter_reachable (B, brig_rules) = (B, brig_rules)
let brig_test2 = filter_reachable (D, brig_rules) = (D, [	D, [T"shkk"; N E]; E, [T"eeeer"] ])
let brig_test3 = filter_reachable (A, List.tl brig_rules) = (A, [])
let brig_test4 = filter_reachable (F, brig_rules) = (F, brig_rules)
let brig_test5 = filter_reachable (F, List.tl brig_rules) = (F, [ F, [T"allmyhomieshatebrig"; N A] ])

type circular_nonterminals = | A | B | C | D | E
let ciruclar_rules = 
	[	
		A, [N B];
		B, [N C];
		C, [N D];
		D, [N E];
		E, [N A]
	]
let circular_test0 = filter_reachable (A, ciruclar_rules) = (A, ciruclar_rules)
let circular_test1 = filter_reachable (B, ciruclar_rules) = (B, ciruclar_rules)
let circular_test2 = filter_reachable (C, ciruclar_rules) = (C, ciruclar_rules)
let circular_test3 = filter_reachable (D, ciruclar_rules) = (D, ciruclar_rules)
let circular_test4 = filter_reachable (E, ciruclar_rules) = (E, ciruclar_rules)

type empty_nonterminals = | S | A | B
let empty_rules = [(A, [])]

let empty_test0 = filter_reachable (S, empty_rules) = (S, [])
let empty_test1 = filter_reachable (A, empty_rules) = (A, [(A, [])])