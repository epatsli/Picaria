%ustawienia wygrywaj¹ce
won([0, 1, 2]).
won([5, 6, 7]).
won([10, 11, 12]).
won([0, 5, 10]).
won([1, 6, 11]).
won([2, 7, 12]).
won([0, 3, 6]).
won([1, 3, 5]).
won([1, 4, 7]).
won([2, 4, 6]).
won([5, 8, 11]).
won([6, 8, 10]).
won([6, 9, 12]).
won([7, 9, 11]).
won([3, 6, 9]).
won([4, 6, 8]).

%lista dozwolonych przesuniêæ pionków
allowed(0, [1, 3, 5]).
allowed(1, [0, 2, 3, 4, 6]).
allowed(2, [1, 4, 7]).
allowed(3, [0, 1, 5, 6]).
allowed(4, [1, 2, 6, 7]).
allowed(5, [0, 3, 6, 8, 10]).
allowed(6, [1, 3, 4, 5, 7, 8, 9, 11]).
allowed(7, [2, 4, 6, 9, 12]).
allowed(8, [5, 6, 10, 11]).
allowed(9, [6, 7, 11, 12]).
allowed(10, [5, 8, 11]).
allowed(11, [6, 8, 9, 10, 12]).
allowed(12, [7, 9, 11]).

% sortowanie

gt(X,Y):- X > Y.

insertsort([],[]).

insertsort([X|Tail],Sorted):-
 insertsort(Tail,SortedTail),
 insert(X,SortedTail, Sorted).

insert(X,[Y|Sorted],[Y|Sorted1]):-
 gt(X,Y),!,
 insert(X,Sorted,Sorted1).

insert(X,Sorted,[X|Sorted]).

% Procedura przesuniêcia pionka
% WEJŒCIE:
% T1 - aktualna lista, P1 - aktualna pozycja, P2 - nowa pozycja
% OPL - lista przeciwnika
% WYJŒCIE: T2 - nowa lista
move(T1, T2, P1, P2, OPL):-
	(   member(P1, T1),
	    \+ member(P2, T1),
	    \+ member(P2, OPL),
            allowed(P1, X),
	    member(P2, X) ->
	       delete(T1, P1, TEMP),
	       append(TEMP, [P2], TEMP2),
	       insertsort(TEMP2, T2);
               append(T1, [], T2)   ).

% Procedura dodania pionka
% WEJŒCIE:
% P - pozycja na nowy pionek, T1 - aktualna lista
% OPL - lista przeciwnika
% WYJŒCIE: T2 - nowa lista

add_pawn(P, T1, T2, OPL):-
	(   \+ member(P, T1),
	    \+ member(P, OPL),
	    P \= 6 ->
	       append(T1, [P], TEMP),
	       insertsort(TEMP, T2);
	       append(T1, [], T2)   ).

% add_ai_pawn - dodanie pierwszego gr. komp.
% WEJŒCIE:
% T1 - lista gracza komputerowego
% O1 - pozycja pionka gracza
% WYJŒCIE:
% T2 - nowa lista gracza komputerowego

% jeden pionek gracza

add_ai_pawn(T1, T2, [O1]):-
	(   allowed(O1, X),
	    member(P, X),
	    \+ member(P, T1),
	    P \= 6 ->
	    append(T1, [P], T2), !).


% 2 pionki gracza

add_ai_pawn([P1], T2, [O1, O2]):-
	(won([O1, O2, WP]); won([O1, WP, O2]); won([WP, O1, O2])), WP \= 6, WP \= P1,
	    T3 = [P1, WP], insertsort(T3, T2), !.

add_ai_pawn([P1], T2, [O1, O2]):-
	( \+ (won([O1, O2, WP]); won([O1, WP, O2]); won([WP, O1, O2]));
	     (won([O1, O2, WP]); won([O1, WP, O2]); won([WP, O1, O2])), (WP == 6; WP == P1)),
	allowed(P1, AL),
	member(P, AL),
	P \= O1, P \= O2, P \= 6,
	T3 = [P1, P], insertsort(T3, T2), !.

% 3 pionki gracza

add_ai_pawn([P1, P2], T2, OPL) :-
	(   won([P1, P2, WP]); won([P1, WP, P2]); won([WP, P1, P2])),
	\+ member(WP, OPL), WP \= 6,
	T3 = [P1, P2, WP], insertsort(T3, T2), !.

add_ai_pawn(T1, T2, [O1, O2, O3]):-
	(won([O1, O2, WP]); won([O1, WP, O2]); won([WP, O1, O2]);
	 won([O1, O3, WP]); won([O1, WP, O3]); won([WP, O1, O3]);
	 won([O2, O3, WP]); won([O2, WP, O3]); won([WP, O2, O3])),
	\+ member(WP, T1), WP \= 6,
	append(T1, [WP], T3), insertsort(T3, T2), !.

add_ai_pawn([P1, P2], T2, [O1, O2, O3]):-
	(   \+ (won([O1, O2, WP]); won([O1, WP, O2]); won([WP, O1, O2]);
	        won([O1, O3, WP]); won([O1, WP, O3]); won([WP, O1, O3]);
	        won([O2, O3, WP]); won([O2, WP, O3]); won([WP, O2, O3]));
	       (won([O1, O2, WP]); won([O1, WP, O2]); won([WP, O1, O2]);
	        won([O1, O3, WP]); won([O1, WP, O3]); won([WP, O1, O3]);
	        won([O2, O3, WP]); won([O2, WP, O3]); won([WP, O2, O3])),
	        (   WP == 6; WP == P1; WP == P2)),
	(allowed(P1, AL); allowed(P2, AL)),
	member(P, AL),
	P \= O1, P \= O2, P \= O3, P \= P1, P \= P2, P \= 6,
	T3 = [P1, P2, P], insertsort(T3, T2), !.

%procedura wyznaczaj¹ca nakrótsz¹ œcie¿k¹ z punktu do punktu
%P1 - pozycja 1
%P2 - pozycja 2
%L - liczba ruchów do osi¹gniêcia celu
%LIST - lista ruchów do osi¹gniêcia celu
%L1 - lista pionków gracza
%L2 - lista pionków przeciwnika

shortest_path(P1, P2, L1, L2, PATH) :-
	sp(P1, P2, L1, L2, 0, PATH).

sp(P1, P2, L1, L2, LEN, Y) :-
	LEN < 12,
	STATE = count_length(P1, P2, 1, [P1], L1, L2, LEN, Y),
	(   not(STATE) ->
	       LEN2 is LEN + 1,
	       sp(P1, P2, L1, L2, LEN2, Y);
	       count_length(P1, P2, 1, [P1], L1, L2, LEN, Y), !).

count_length(P, P, L, LIST, _, _, LEN, Y) :-
	L == LEN, LIST \= [], Y = LIST.

count_length(P1, P2, L, LIST, L1, L2, LEN, Y):-
	LL is L + 1,
	allowed(P1, X),
	member(H, X),
	\+ member(H, LIST),
	\+ member(H, L1),
	\+ member(H, L2),
	append(LIST, [H], LIST2),
	count_length(H, P2, LL, LIST2, L1, L2, LEN, Y).

/*
count_length2(P, P, L, LIST, _, _, Y) :-
	LIST \= [], Y = LIST.

count_length2(P1, P2, L, LIST, L1, L2, Y):-
	LL is L + 1,
	allowed(P1, X),
	member(H, X),
	\+ member(H, LIST),
	\+ member(H, L1),
	\+ member(H, L2),
	append(LIST, [H], LIST2),
	count_length2(H, P2, LL, LIST2, L1, L2, Y).
*/

% path_to_block - wyznacza najkrótsz¹ œcie¿kê z jednego z 3 punktów do
% zablokowania gracza, który mo¿e wygraæ grê, o ile taka œcie¿ka jest
% mo¿liwa
% WEJŒCIE:
% P1, P2, P3 - pozycje pionków gracza komputerowego
% OPL - lista pozycji gracza
% LP - punkt docelowy
% WYJŒCIE:
% PATH - œcie¿ka

path_to_block(P1, P2, P3, OPL, LP, PATH) :-
	CB1 = shortest_path(P1, LP, [P1, P2, P3], OPL, BP1),
	CB2 = shortest_path(P2, LP, [P1, P2, P3], OPL, BP2),
	CB3 = shortest_path(P3, LP, [P1, P2, P3], OPL, BP3),
	(   CB1 -> shortest_path(P1, LP, [P1, P2, P3], OPL, BP1); BP1 = []),
	(   CB2 -> shortest_path(P2, LP, [P1, P2, P3], OPL, BP2); BP2 = []),
	(   CB3 -> shortest_path(P3, LP, [P1, P2, P3], OPL, BP3); BP3 = []),
	shortest_from_three(BP1, BP2, BP3, PATH).

% min - zwraca najmniejsz¹ liczbê z podanej listy, lecz wiêksz¹ od 1
% (najkrótsza lista ma rozmiar 2)

min([Item], Item).
min([Item | List], Item) :-
	min(List, List_Answer),
	Item =< List_Answer, Item > 1, !.
min([_Item | List], Answer) :-
	min(List, Answer), !.

% zwraca najkrótsz¹ listê z 3 podanych (o d³ugoœci co najmniej 2)
% WEJŒCIE:
% PATH1, PATH2, PATH3 - listy
% WYJŒCIE:
% SHORTEST - najkrótsza lista

shortest_from_three(PATH1, PATH2, PATH3, SHORTEST) :-
	length(PATH1, L1), length(PATH2, L2), length(PATH3, L3),
	(   L1 =< 1 -> LL1 is 999; LL1 is L1),
	(   L2 =< 1 -> LL2 is 999; LL2 is L2),
        (   L3 =< 1 -> LL3 is 999; LL3 is L3),
	min([LL1, LL2, LL3], M),
	(   LL1 == M -> SHORTEST = PATH1;
	    (   LL2 == M -> SHORTEST = PATH2;
	        (   LL3 == M -> SHORTEST = PATH3))).

%H1, H2, H3 - lista pionków gracza komputerowego,
%O1, O2, O3 - lista pionków gracza
%PW - œcie¿ka wygrywaj¹ca dla gracza komputerowego
%PL - œcie¿ka wygrywaj¹ca dla gracza
%WL - d³ugoœæ œcie¿ki wygrywaj¹cej dla gracza komputerowego
%LL - d³ugoœæ œcie¿ki wygrywaj¹cej dla gracza
%LP - ostatni punkt œcie¿ki

%WINPOSSIBLE, LOSSPOSSIBLE - gracz i gracz komputerowy maj¹ mo¿liwoœæ
%wygranej
%WEJŒCIE:
%H - lista pozycji pionków gracza komputerowego
%O - lista pozycji pionków gracza
%PW - œcie¿ka wygrywaj¹ca dla gracza komputerowego
%PL - œcie¿ka wygrywaj¹ca dla gracza
%WYJŒCIE:
%PATH - œcie¿ka
%DODATKOWE:
%WL - d³ugoœæ œcie¿ki wygrywaj¹cej dla gracza komputerowego
%LL - d³ugoœæ œcie¿ki wygrywaj¹cej dla gracza
%LP - ostatni punkt œcie¿ki

wplp([H1, H2, H3], [O1, O2, O3], PATH):-
	sptwc([H1, H2, H3], [O1, O2, O3], PW),
	sptwc([O1, O2, O3], [H1, H2, H3], PL),
	length(PW, WL), length(PL, LL),
	(   WL =< LL -> PATH = PW;
	    last(PL, LP),
	    CANBLOCK = path_to_block(H1, H2, H3, [O1, O2, O3], LP, PATH),
	    (	CANBLOCK -> path_to_block(H1, H2, H3, [O1, O2, O3], LP, PATH);
	        PATH = PW)).

%LOSSPOSSIBLE - gracz komputerowy nie mo¿e wygraæ, lecz	mo¿e przegraæ

lp([H1, H2, H3], [O1, O2, O3], PATH):-
	sptwc([O1, O2, O3], [H1, H2, H3], PL),
	last(PL, LP),
	CANBLOCK = path_to_block(H1, H2, H3, [O1, O2, O3], LP, PATH),
	    (	CANBLOCK -> path_to_block(H1, H2, H3, [O1, O2, O3], LP, PATH);
	        PATH = sptp([H1, H2, H3], [O1, O2, O3], PATH)).

%WINPOSSIBLE - gracz komputerowy mo¿e wygraæ i nie mo¿e przegraæ

wp([H1, H2, H3], [O1, O2, O3], PATH):-
	sptwc([H1, H2, H3], [O1, O2, O3], PATH).

%SAFE - gracz komputerowy nie mo¿e wygraæ i przegraæ

safe([H1, H2, H3], [O1, O2, O3], PATH):-
	sptp([H1, H2, H3], [O1, O2, O3], PATH).

ai_move([H1, H2, H3], [O1, O2, O3], L):-
	WINPOSSIBLE = sptwc([H1, H2, H3], [O1, O2, O3], _PW),
	LOSSPOSSIBLE = sptwc([O1, O2, O3], [H1, H2, H3], _PL),
	(   WINPOSSIBLE, LOSSPOSSIBLE ->
	       wplp([H1, H2, H3], [O1, O2, O3], PATH);
	(   WINPOSSIBLE, not(LOSSPOSSIBLE) ->
	       wp([H1, H2, H3], [O1, O2, O3], PATH);
	(   not(WINPOSSIBLE), LOSSPOSSIBLE ->
	       lp([H1, H2, H3], [O1, O2, O3], PATH);
	(   not(WINPOSSIBLE), not(LOSSPOSSIBLE) ->
	       safe([H1, H2, H3], [O1, O2, O3], PATH))))),
	ai_make_move([H1, H2, H3], PATH, L).

%dokonanie ruchu

ai_make_move([H1, H2, H3], PATH, L):-
	[S, E | _T] = PATH,
	(   H1 == S -> L2 = [E, H2, H3];
	    (   H2 == S -> L2 = [H1, E, H3];
	       (   H3 == S -> L2 = [H1, H2, E]))),
	insertsort(L2, L).

% TO DO:
% jeœli œcie¿ka do wygranej komputera jest krótsza od œcie¿ki gracza
% realizuj przejœcie do œcie¿ki gracza jeœli to mo¿liwe, w przeciwnym
% razie rób swoj¹ œcie¿kê, jeœli jej nie ma to ustanów parê

% sptwc - najkrótsza droga do ustanowienia kombinacji wygrywaj¹cej
% WEJŒCIE:
% [H1, H2, H3] - lista pionków gracza komputerowego,
% OPL - lista pionków gracza
% WYJŒCIE:
% PATH - najktórsza wyznaczona œcie¿ka danego pionka do osi¹gniêcia
% ustawienia wygrywaj¹cego

sptwc([H1, H2, H3], OPL, PATH):-
	shortest_path_to_winning_combination([H1, H2, H3], OPL, 2, PATH).

shortest_path_to_winning_combination([H1, H2, H3], OPL, L, PATH):-
	L < 12,
	STATE = match_to_winning_combination([H1, H2, H3], OPL, L, PATH),
	(   not(STATE) ->
	       L2 is L + 1,
	       shortest_path_to_winning_combination([H1, H2, H3], OPL, L2, PATH);
	       match_to_winning_combination([H1, H2, H3], OPL, L, PATH), !).


match_to_winning_combination([H1, H2, H3], OPL, L, PATH):-
	won([H1, H2, X]), shortest_path(H3, X, [H1, H2, H3], OPL, PATH), length(PATH, L);
	won([H1, X, H2]), shortest_path(H3, X, [H1, H2, H3], OPL, PATH), length(PATH, L);
	won([X, H1, H2]), shortest_path(H3, X, [H1, H2, H3], OPL, PATH), length(PATH, L);
	won([H1, H3, X]), shortest_path(H2, X, [H1, H2, H3], OPL, PATH), length(PATH, L);
	won([H1, X, H3]), shortest_path(H2, X, [H1, H2, H3], OPL, PATH), length(PATH, L);
	won([X, H1, H3]), shortest_path(H2, X, [H1, H2, H3], OPL, PATH), length(PATH, L);
	won([H2, H3, X]), shortest_path(H1, X, [H1, H2, H3], OPL, PATH), length(PATH, L);
	won([H2, X, H3]), shortest_path(H1, X, [H1, H2, H3], OPL, PATH), length(PATH, L);
	won([X, H2, H3]), shortest_path(H1, X, [H1, H2, H3], OPL, PATH), length(PATH, L).

% sptp - najkrótsza droga do ustanowienia pary z kombinacji wygrywaj¹cej
% WEJŒCIE:
% [H1, H2, H3] - lista pionków gracza komputerowego,
% OPL - lista pionków gracza
% WYJŒCIE:
% PATH - najktórsza wyznaczona œcie¿ka danego pionka do osi¹gniêcia pary
% z ustawienia wygrywaj¹cego

sptp([H1, H2, H3], OPL, PATH):-
	shortest_path_to_pair([H1, H2, H3], OPL, 2, PATH).

shortest_path_to_pair([H1, H2, H3], OPL, L, PATH):-
	L < 12,
	STATE = pair_combinations(H1, H2, H3, OPL, L, PATH),
	(   not(STATE) ->
	       L2 is L + 1,
	       shortest_path_to_pair([H1, H2, H3], OPL, L2, PATH);
	       pair_combinations(H1, H2, H3, OPL, L, PATH), !).

pair_combinations(P1, P2, P3, OPL, L, PATH):-
	match_to_pair(P1, P2, P3, OPL, L, PATH);
	match_to_pair(P1, P3, P2, OPL, L, PATH);
	match_to_pair(P2, P1, P3, OPL, L, PATH);
	match_to_pair(P2, P3, P1, OPL, L, PATH);
	match_to_pair(P3, P1, P2, OPL, L, PATH);
	match_to_pair(P3, P2, P1, OPL, L, PATH).

match_to_pair(P1, P2, P3, OPL, L, PATH):-
	%print(P1), nl,
	won([P1, X, Y]), shortest_path(P2, X, [P1, P2, P3], OPL, PATH), length(PATH, L);
	won([P1, X, Y]), shortest_path(P2, Y, [P1, P2, P3], OPL, PATH), length(PATH, L);
	won([X, P1, Y]), shortest_path(P2, X, [P1, P2, P3], OPL, PATH), length(PATH, L);
	won([X, P1, Y]), shortest_path(P2, Y, [P1, P2, P3], OPL, PATH), length(PATH, L);
	won([X, Y, P1]), shortest_path(P2, X, [P1, P2, P3], OPL, PATH), length(PATH, L);
	won([X, Y, P1]), shortest_path(P2, Y, [P1, P2, P3], OPL, PATH), length(PATH, L).


