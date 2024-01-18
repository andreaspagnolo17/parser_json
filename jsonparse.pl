%%%% -*- Mode: Prolog -*-

%%%% Spagnolo Andrea 879254
%%%% json-parsing.pl

%%%% per spiegazione codice leggere README.txt

%%% jsonparse(JSONStr, Object).
%%% jsonparse di un oggetto

jsonparse({}, jsonobj([])) :- !.

jsonparse(JSONStr, jsonobj(ParsedObj)) :-
    string(JSONStr),
    string_chars(JSONStr, Chars),
    fix_str(Chars, FixChars),
    string_chars(RealJSONStr, FixChars),
    catch(term_string(JSON, RealJSONStr), _, false),
    JSON =.. [{}, Object],
    jsonobj([Object], ParsedObj),
    !.

jsonparse(JSONAtom, JSONParsed) :-
    atom(JSONAtom),
    atom_string(JSONAtom, JSONStr),
    jsonparse(JSONStr, JSONParsed),
    !.

jsonparse(JSON, jsonobj(ParsedObj)) :-
    JSON =.. [{}, Object],
    jsonobj([Object], ParsedObj),
    !.

%%% jsonparese di un array

jsonparse(ArrayStr, json_array(ArrayParsed)) :-
    string(ArrayStr),
    catch(term_string(Array, ArrayStr), _, false),
    json_array(Array, ArrayParsed),
    !.

jsonparse(ArrayAtom, JSONParsed) :-
    atom(ArrayAtom),
    atom_string(ArrayAtom, ArrayStr),
    jsonparse(ArrayStr, JSONParsed),
    !.

jsonparse(Array, json_array(ArrayParsed)) :-
    json_array(Array, ArrayParsed),
    !.

%%% jsonobj(Object).

jsonobj([], []) :- !.

jsonobj([Member], [MemberParsed]) :-
    json_member(Member, MemberParsed),
    !.

jsonobj([Obj], [MemberParsed | MemberParseds]) :-
    Obj =.. [',', Member | MoreMembers],
    json_member(Member, MemberParsed),
    jsonobj(MoreMembers, MemberParseds),
    !.

%%% json_array(Elements)

json_array([], []) :- !.

json_array([Value | MoreElements], [ValueParsed | ElementsParsed]) :-
    is_value(Value, ValueParsed),
    json_array(MoreElements, ElementsParsed),
    !.

%%% json_member(Members)

json_member(Member, (ParsedAttribute, ValueParsed)) :-
    Member =.. [':', Attribute, Value],
    json_pair(Attribute, Value, ParsedAttribute, ValueParsed),
    !.

%%% json_pair(Pair)
json_pair(Attribute, Value, Attribute, ValueParsed) :-
    string(Attribute),
    is_value(Value, ValueParsed),
    !.

%%% json_value(Value)

is_value([], []) :- !.

is_value(Value, Value) :-
    string(Value), !.

is_value(Value, Value) :-
    number(Value), !.

is_value(Value, ValueParsed) :-
    jsonparse(Value, ValueParsed), !.

%%% jsonaccess(jsonobj, Fields, Result).

jsonaccess(PartialResult, [], PartialResult) :- !.

jsonaccess(jsonobj(ParsedObj), [Field | Fields], Result) :-
    jsonaccess(jsonobj(ParsedObj), Field, PartialResult),
    jsonaccess(PartialResult, Fields, Result),
    !.

jsonaccess(json_array(ArrayParsed), [Field | Fields], Result) :-
    jsonaccess(json_array(ArrayParsed), Field, PartialResult),
    jsonaccess(PartialResult, Fields, Result),
    !.

%%% caso in cui Fields è un numero

jsonaccess(json_array(ArrayParsed), N, Result) :-
    number(N),
    get_indice(ArrayParsed, N, Result),
    !.

%%% caso in cui Fields è una stringa SWI Prolog

jsonaccess(jsonobj(ParsedObj), Str, Result) :-
    string(Str),
    get_str(ParsedObj, Str, Result),
    !.


%%% ricerca di un indice in un array

get_indice([Var | _], 0, Var) :- !.

get_indice([], _, _) :-
    fail,
    !.

get_indice([_ | Vars], N, Result) :-
    N > 0,
    P is N-1,
    get_indice(Vars, P, Result),
    !.

%%% ricerca di un attributo fra gli oggetti

get_str(_, [], _) :-
    fail,
    !.

get_str([(Var1, Var2) | _], Str, Result) :-
    Str = Var1,
    Result = Var2,
    !.

get_str([(_) | Vars], Str, Result) :-
    get_str(Vars, Str, Result),
    !.

%%% jsonread(FileName, JSON)

jsonread(FileName, JSON) :-
    read_file_to_string(FileName, JSONStr, []),
    jsonparse(JSONStr, JSON).

%%% jsondump

jsondump(JSON, FileName) :-
    atom(FileName),
    json_transformation(JSON, Term),
    json_fix(Term, JSONAtom),
    open(FileName, write, File),
    write(File, JSONAtom),
    close(File),
    !.

%%% se fallisce il fix (non ci sono parentesi graffe quindi  è un array)

jsondump(JSON, FileName) :-
    atom(FileName),
    json_transformation(JSON, JSONStr),
    open(FileName, write, File),
    write(File, JSONStr),
    close(File),
    !.

%%% rimuove gli apici singoli (chiamato nel jsonparse)

fix_str(['\'' | Stuff], ['"' | OtherStuff]) :-
    fix_str(Stuff, OtherStuff),
    !.

fix_str([Char | Stuff], [Char | OtherStuff]) :-
    fix_str(Stuff, OtherStuff),
    !.

fix_str([], []) :- !.

%%% trasforma in sintassi JSON (chiamato nel write)

json_transformation(json_array(O), JSONStr) :-
    jsonparse(JSONStr, json_array(O)),
    !.

json_transformation(jsonobj([]), {}) :- !.

json_transformation(jsonobj(O), JSONStr) :-
    json_transformation(O, Pairs),
    JSONStr =.. [{}, Pairs],
    !.

json_transformation([], []) :- !.

json_transformation([], [ParsedObjs]) :-
    JSONStr =.. [{}, ParsedObjs],
    json_transformation([], JSONStr),
    !.

json_transformation(([(O1, json_array(O2)) | Objects]), [Pair | Pairs]) :-
    jsonparse(Array, json_array(O2)),
    Pair =.. [':', O1, Array],
    json_transformation(Objects, Pairs),
    !.

json_transformation(([(O1, O2) | Objects]), [Pair | Pairs]) :-
    Pair =.. [':', O1, O2],
    json_transformation(Objects, Pairs),
    !.

json_transformation(Value, Value).

json_fix(Term, JSONStr) :-
    term_string(Term, String),
    string_chars(String, Chars),
    remove_parens(Chars, ParsedChars),
    string_chars(JSONStr, ParsedChars),
    !.

%%% rimuove parentesi in eccesso, aggiunge spazi
%%% dopo virgole e intorno ai due punti

remove_parens(['{', '[' | Chars1], ['{' | Chars2]) :-
    remove_parens(Chars1, Chars2).

remove_parens([']', '}'], ['}']):-!.

remove_parens([':' | Chars1], [' ', ':', ' ' | Chars2]) :-
    remove_parens(Chars1, Chars2),
    !.

remove_parens([',' | Chars1], [',', ' ' | Chars2]) :-
    remove_parens(Chars1, Chars2),
    !.

remove_parens([Char | Chars1], [Char | Chars2]) :-
    remove_parens(Chars1, Chars2).

%%%% fine del file -- json-parsing.pl
