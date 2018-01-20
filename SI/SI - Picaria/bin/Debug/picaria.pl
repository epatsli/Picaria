
% obs³uga ruchu pionka, dane: 

% LPozP - lista pozycji przeciwnika
% LNPoz - lista nowych pozycji
% LAPoz - lista aktualnych pozycji
% Poz1 - pierwsza pozycja
% Poz2 - druga pozycja

przesun(LAPoz, LNPoz, Poz1, Poz2, LPozP):- (member(Poz1, LAPoz), \+ member(Poz2, LAPoz),
	 \+ member(Poz2, LPozP), dozwolone(Poz1, X), member(Poz2, X) -> delete(LAPoz, Poz1, Temp), 
		append(Temp, [Poz2], Temp2), posortuj(Temp2, LNPoz); append(LAPoz, [], LNPoz)   ).


% obsluga nowego pionka, dane:

% LAPoz - lista aktualnych pozycj
% LNPoz - lista nowych pozycji
% LPozP - lista pozycji przeciwnika
% Poz - pozycja pionka

dodaj_pion(Poz, LAPoz, LNPoz, LPozP):- (   \+ member(Poz, LAPoz), \+ member(Poz, LPozP), Poz \= 6 ->
	       append(LAPoz, [Poz], TEMP), posortuj(TEMP, LNPoz); append(LAPoz, [], LNPoz)   ).

% tabela wygryeajacych ustawien dla pionow

wygrywajace([0, 1, 2]). 
wygrywajace([5, 6, 7]).
wygrywajace([10, 11, 12]).
wygrywajace([0, 5, 10]).
wygrywajace([1, 6, 11]).
wygrywajace([2, 7, 12]).
wygrywajace([0, 3, 6]).
wygrywajace([1, 3, 5]).
wygrywajace([1, 4, 7]).
wygrywajace([2, 4, 6]).
wygrywajace([5, 8, 11]).
wygrywajace([6, 8, 10]).
wygrywajace([6, 9, 12]).
wygrywajace([7, 9, 11]).
wygrywajace([3, 6, 9]).
wygrywajace([4, 6, 8]).

% tabela dozwolonych przemieszczen dla pionow

dozwolone(0, [1, 3, 5]).
dozwolone(1, [0, 2, 3, 4, 6]).
dozwolone(2, [1, 4, 7]).
dozwolone(3, [0, 1, 5, 6]).
dozwolone(4, [1, 2, 6, 7]).
dozwolone(5, [0, 3, 6, 8, 10]).
dozwolone(6, [1, 3, 4, 5, 7, 8, 9, 11]).
dozwolone(7, [2, 4, 6, 9, 12]).
dozwolone(8, [5, 6, 10, 11]).
dozwolone(9, [6, 7, 11, 12]).
dozwolone(10, [5, 8, 11]).
dozwolone(11, [6, 8, 9, 10, 12]).
dozwolone(12, [7, 9, 11]).


% obs³uga najkrótszej drogi do wygranej

% KPoz1 - pierwsza pozycja piona komputera
% KPoz2 - druga pozycja piona komputera
% KPoz3 - trzecia pozycja piona komputera
% LPozP - lista pozycji przeciwnika
% Droga - droga do celu (tu wygranej)

min_droga_dw([KPoz1, KPoz2, KPoz3], LPozP, Droga):-
			min_droga_wygryw([KPoz1, KPoz2, KPoz3], LPozP, 2, Droga).

min_droga_wygryw([KPoz1, KPoz2, KPoz3], LPozP, LK, Droga):-
			LK < 12, STAN = dopasuj_do_wygryw([KPoz1, KPoz2, KPoz3], LPozP, LK, Droga),
			(not(STAN) -> LPozPrz is LK + 1, min_droga_wygryw([KPoz1, KPoz2, KPoz3], LPozP, LPozPrz, Droga);
	       		dopasuj_do_wygryw([KPoz1, KPoz2, KPoz3], LPozP, LK, Droga), !).


dopasuj_do_wygryw([KPoz1, KPoz2, KPoz3], LPozP, LK, Droga):-
			wygrywajace([KPoz1, KPoz2, X]), min_droga(KPoz3, X, [KPoz1, KPoz2, KPoz3], LPozP, Droga), length(Droga, LK);
			wygrywajace([KPoz1, X, KPoz2]), min_droga(KPoz3, X, [KPoz1, KPoz2, KPoz3], LPozP, Droga), length(Droga, LK);
			wygrywajace([X, KPoz1, KPoz2]), min_droga(KPoz3, X, [KPoz1, KPoz2, KPoz3], LPozP, Droga), length(Droga, LK);
			wygrywajace([KPoz1, KPoz3, X]), min_droga(KPoz2, X, [KPoz1, KPoz2, KPoz3], LPozP, Droga), length(Droga, LK);
			wygrywajace([KPoz1, X, KPoz3]), min_droga(KPoz2, X, [KPoz1, KPoz2, KPoz3], LPozP, Droga), length(Droga, LK);
			wygrywajace([X, KPoz1, KPoz3]), min_droga(KPoz2, X, [KPoz1, KPoz2, KPoz3], LPozP, Droga), length(Droga, LK);
			wygrywajace([KPoz2, KPoz3, X]), min_droga(KPoz1, X, [KPoz1, KPoz2, KPoz3], LPozP, Droga), length(Droga, LK);
			wygrywajace([KPoz2, X, KPoz3]), min_droga(KPoz1, X, [KPoz1, KPoz2, KPoz3], LPozP, Droga), length(Droga, LK);
			wygrywajace([X, KPoz2, KPoz3]), min_droga(KPoz1, X, [KPoz1, KPoz2, KPoz3], LPozP, Droga), length(Droga, LK).



% obs³uga najkrótszej drogi do duetu z kombinacji wygrywaj¹cej


% KPoz1 - pierwsza pozycja piona komputera
% KPoz2 - druga pozycja piona komputera
% KPoz3 - trzecia pozycja piona komputera
% LPozP - lista pozycji przeciwnika
% Droga - % Droga - droga do celu (tu duetu)


min_droga_dp([KPoz1, KPoz2, KPoz3], LPozP, Droga):-
			min_droga_do_duetu([KPoz1, KPoz2, KPoz3], LPozP, 2, Droga).

min_droga_do_duetu([KPoz1, KPoz2, KPoz3], LPozP, LK, Droga):-
			LK < 12, STAN = kombinacje_duetow(KPoz1, KPoz2, KPoz3, LPozP, LK, Droga),(not(STAN) -> LPozPrz is LK + 1,
	       		min_droga_do_duetu([KPoz1, KPoz2, KPoz3], LPozP, LPozPrz, Droga);
	      		kombinacje_duetow(KPoz1, KPoz2, KPoz3, LPozP, LK, Droga), !).


kombinacje_duetow(Poz1, Poz2, Poz3, LPozP, LK, Droga):-
			dopasuj_do_duetu(Poz1, Poz2, Poz3, LPozP, LK, Droga); dopasuj_do_duetu(Poz1, Poz3, Poz2, LPozP, LK, Droga);
			dopasuj_do_duetu(Poz2, Poz1, Poz3, LPozP, LK, Droga); dopasuj_do_duetu(Poz2, Poz3, Poz1, LPozP, LK, Droga);
			dopasuj_do_duetu(Poz3, Poz1, Poz2, LPozP, LK, Droga); dopasuj_do_duetu(Poz3, Poz2, Poz1, LPozP, LK, Droga).


dopasuj_do_duetu(Poz1, Poz2, Poz3, LPozP, LK, Droga):-
			%print(Poz1), nl, wygrywajace([Poz1, X, Y]), min_droga(Poz2, X, [Poz1, Poz2, Poz3], LPozP, Droga), length(Droga, LK);
			wygrywajace([Poz1, X, Y]), min_droga(Poz2, Y, [Poz1, Poz2, Poz3], LPozP, Droga), length(Droga, LK);
			wygrywajace([X, Poz1, Y]), min_droga(Poz2, X, [Poz1, Poz2, Poz3], LPozP, Droga), length(Droga, LK);
			wygrywajace([X, Poz1, Y]), min_droga(Poz2, Y, [Poz1, Poz2, Poz3], LPozP, Droga), length(Droga, LK);
			wygrywajace([X, Y, Poz1]), min_droga(Poz2, X, [Poz1, Poz2, Poz3], LPozP, Droga), length(Droga, LK);
			wygrywajace([X, Y, Poz1]), min_droga(Poz2, Y, [Poz1, Poz2, Poz3], LPozP, Droga), length(Droga, LK).

% obs³uga nowego pionka komputera , dane:

% LAPoz - lista aktualnych pozycj
% LNPoz - lista nowych pozycji
% GPoz1 - pierwsza pozycja piona gracza
% GPoz2 - druga pozycja piona gracza

% przypadek dodania po 1 pionku gracza

nowy_pionek_komputera(LAPoz, LNPoz, [GPoz1]):- (   dozwolone(GPoz1, X), member(Poz, X),  \+ member(Poz, LAPoz),
	    Poz \= 6 -> append(LAPoz, [Poz], LNPoz), !).

% przypadek dodania po 2 pionku gracza

nowy_pionek_komputera([Poz1], LNPoz, [GPoz1, GPoz2]):- 
			(wygrywajace([GPoz1, GPoz2, PozWygr]); wygrywajace([GPoz1, PozWygr, GPoz2]);
			 wygrywajace([PozWygr, GPoz1, GPoz2])), PozWygr \= 6, PozWygr \= Poz1, LTPoz = [Poz1, PozWygr],
			 posortuj(LTPoz, LNPoz), !.


nowy_pionek_komputera([Poz1], LNPoz, [GPoz1, GPoz2]):- 
			( \+ (wygrywajace([GPoz1, GPoz2, PozWygr]); wygrywajace([GPoz1, PozWygr, GPoz2]);
			 wygrywajace([PozWygr, GPoz1, GPoz2])); (wygrywajace([GPoz1, GPoz2, PozWygr]); 
			 wygrywajace([GPoz1, PozWygr, GPoz2]); wygrywajace([PozWygr, GPoz1, GPoz2])),
			 (PozWygr == 6; PozWygr == Poz1)), dozwolone(Poz1, Dozw), member(Poz, Dozw),
			 Poz \= GPoz1, Poz \= GPoz2, Poz \= 6, LTPoz = [Poz1, Poz], posortuj(LTPoz, LNPoz), !.


% przypadek dodania po 3 pionku gracza

nowy_pionek_komputera([Poz1, Poz2], LNPoz, LPozP) :-
		     (   wygrywajace([Poz1, Poz2, PozWygr]); wygrywajace([Poz1, PozWygr, Poz2]); wygrywajace([PozWygr, Poz1, Poz2])),
		     \+ member(PozWygr, LPozP), PozWygr \= 6, LTPoz = [Poz1, Poz2, PozWygr], posortuj(LTPoz, LNPoz), !.



nowy_pionek_komputera(LAPoz, LNPoz, [GPoz1, GPoz2, GPoz3]):-
			(wygrywajace([GPoz1, GPoz2, PozWygr]); wygrywajace([GPoz1, PozWygr, GPoz2]); wygrywajace([PozWygr, GPoz1, GPoz2]);
	 		wygrywajace([GPoz1, GPoz3, PozWygr]); wygrywajace([GPoz1, PozWygr, GPoz3]); wygrywajace([PozWygr, GPoz1, GPoz3]);
	 		wygrywajace([GPoz2, GPoz3, PozWygr]); wygrywajace([GPoz2, PozWygr, GPoz3]); wygrywajace([PozWygr, GPoz2, GPoz3])),
			\+ member(PozWygr, LAPoz), PozWygr \= 6, append(LAPoz, [PozWygr], LTPoz), posortuj(LTPoz, LNPoz), !.


nowy_pionek_komputera([Poz1, Poz2], LNPoz, [GPoz1, GPoz2, GPoz3]):-
		(   \+ (wygrywajace([GPoz1, GPoz2, PozWygr]); wygrywajace([GPoz1, PozWygr, GPoz2]); wygrywajace([PozWygr, GPoz1, GPoz2]);
	        	wygrywajace([GPoz1, GPoz3, PozWygr]); wygrywajace([GPoz1, PozWygr, GPoz3]); wygrywajace([PozWygr, GPoz1, GPoz3]);
	        	wygrywajace([GPoz2, GPoz3, PozWygr]); wygrywajace([GPoz2, PozWygr, GPoz3]); wygrywajace([PozWygr, GPoz2, GPoz3]));
	       		(wygrywajace([GPoz1, GPoz2, PozWygr]); wygrywajace([GPoz1, PozWygr, GPoz2]); wygrywajace([PozWygr, GPoz1, GPoz2]);
	        	wygrywajace([GPoz1, GPoz3, PozWygr]); wygrywajace([GPoz1, PozWygr, GPoz3]); wygrywajace([PozWygr, GPoz1, GPoz3]);
	        	wygrywajace([GPoz2, GPoz3, PozWygr]); wygrywajace([GPoz2, PozWygr, GPoz3]); wygrywajace([PozWygr, GPoz2, GPoz3])),
	        	(   PozWygr == 6; PozWygr == Poz1; PozWygr == Poz2)), (dozwolone(Poz1, Dozw); dozwolone(Poz2, Dozw)),
			member(Poz, Dozw), Poz \= GPoz1, Poz \= GPoz2, Poz \= GPoz3, Poz \= Poz1, Poz \= Poz2, Poz \= 6,
			LTPoz = [Poz1, Poz2, Poz], posortuj(LTPoz, LNPoz), !.


% obs³uga wyznaczania najkrotszej œcie¿ki

% LKDC - Lista Kroków Do Celu
% LPozG - lista pozycji gracza
% LPozPrz - lista pozycji przeciwnika
% Poz1 - pierwsza pozycja
% Poz2 - druga pozycja
% LK - liczba kroków wymaganych do osi¹gniêcia celu

min_droga(Poz1, Poz2, LPozG, LPozPrz, Droga) :-
			sp(Poz1, Poz2, LPozG, LPozPrz, 0, Droga).

min_d(Poz1, Poz2, LPozG, LPozPrz, DL, Y) :-
			DL < 12, STATE = licznik_krokow(Poz1, Poz2, 1, [Poz1], LPozG, LPozPrz, DL, Y), ( not(STAN) -> DL2 is DL + 1, 
			min_d(Poz1, Poz2, LPozG, LPozPrz, DL2, Y); licznik_krokow(Poz1, Poz2, 1, [Poz1], LPozG, LPozPrz, DL, Y), !).


licznik_krokow(Poz, Poz, LK, LKDC, _, _, DL, Y) :-
			LK == DL, LKDC \= [], Y = LKDC.


licznik_krokow(Poz1, Poz2, LK, LKDC, LPozG, LPozPrz, DL, Y):-
			LKWG is LK + 1, dozwolone(Poz1, X), member(LPozK, X), \+ member(LPozK, LKDC), \+ member(LPozK, LPozG), \+ member(LPozK, LPozPrz),
			append(LKDC, [LPozK], LKDC2), licznik_krokow(LPozK, Poz2, LKWG, LKDC2, LPozG, LPozPrz, DL, Y).


/*
licznik_krokow2(Poz, Poz, LK, LKDC, _, _, Y) :- 
			LKDC \= [], Y = LKDC.
licznik_krokow2(Poz1, Poz2, LK, LKDC, LPozG, LPozPrz, Y):-
			LKWG is LK + 1, dozwolone(Poz1, X), member(LPozK, X), \+ member(LPozK, LKDC), \+ member(LPozK, LPozG), \+ member(LPozK, LPozPrz),
			append(LKDC, [LPozK], LKDC2), licznik_krokow2(LPozK, Poz2, LKWG, LKDC2, LPozG, LPozPrz, Y).
*/



% obs³uga wyboru œcie¿ki bloku z jednego z 3 pionów do zablokowania gracza d¹¿¹cego do zwyciêstwa

% LPozP - lista pozycji przeciwnika (tu gracza)
% CEL - punkt docelowy
% Droga - droga do celu
% Poz1 - pierwsza pozycja 
% Poz2 - drugaa pozycja
% Poz3 - trzecia pozycja


droga_bloku(Poz1, Poz2, Poz3, LPozP, CEL, Droga) :-
			CelBloku1 = min_droga(Poz1, CEL, [Poz1, Poz2, Poz3], LPozP, BlokPoz1),
			CelBloku2 = min_droga(Poz2, CEL, [Poz1, Poz2, Poz3], LPozP, BlokPoz2),
			CelBloku3 = min_droga(Poz3, CEL, [Poz1, Poz2, Poz3], LPozP, BlokPoz3),
			(CelBloku1 -> min_droga(Poz1, CEL, [Poz1, Poz2, Poz3], LPozP, BlokPoz1); BlokPoz1 = []),
			(CelBloku2 -> min_droga(Poz2, CEL, [Poz1, Poz2, Poz3], LPozP, BlokPoz2); BlokPoz2 = []),
			(CelBloku3 -> min_droga(Poz3, CEL, [Poz1, Poz2, Poz3], LPozP, BlokPoz3); BlokPoz3 = []),
			min_z3(BlokPoz1, BlokPoz2, BlokPoz3, Droga).


% KPoz1 - pierwsza pozycja piona komputera
% KPoz2 - druga pozycja piona komputera
% KPoz3 - trzecia pozycja piona komputera
% GPoz1 - pierwsza pozycja piona gracza
% GPoz2 - druga pozycja piona gracza
% GPoz3 - trzecia pozycja piona gracza
% DWK - droga wygrywaj¹ca komputera
% DWG - droga wygrywaj¹ca gracza
% LKWK - liczba krokow drogi wygrywaj¹cej komputera
% LKWG - liczba krokow drogi wygrywaj¹cej gracza
% CEL - ostatni punkt œcie¿ki
%LPozK - lista pozycji pionków gracza komputerowego
%Droga - droga do celu


% obydwaj gracze mog¹ wygraæ

ogmw([KPoz1, KPoz2, KPoz3], [GPoz1, GPoz2, GPoz3], Droga):-
			min_droga_dw([KPoz1, KPoz2, KPoz3], [GPoz1, GPoz2, GPoz3], DWK), 
			min_droga_dw([GPoz1, GPoz2, GPoz3], [KPoz1, KPoz2, KPoz3], DWG),length(DWK, LKWK), length(DWG, LKWG),
			(LKWK =< LKWG -> Droga = DWK; last(DWG, CEL),
	   		 MozeBlokowac = droga_bloku(KPoz1, KPoz2, KPoz3, [GPoz1, GPoz2, GPoz3], CEL, Droga) 
			(MozeBlokowac -> droga_bloku(KPoz1, KPoz2, KPoz3, [GPoz1, GPoz2, GPoz3], CEL, Droga); Droga = DWK)).


% gracz mo¿e wygraæ.

gmw([KPoz1, KPoz2, KPoz3], [GPoz1, GPoz2, GPoz3], Droga):-
			min_droga_dw([GPoz1, GPoz2, GPoz3], [KPoz1, KPoz2, KPoz3], DWG), last(DWG, CEL),
			MozeBlokowac = droga_bloku(KPoz1, KPoz2, KPoz3, [GPoz1, GPoz2, GPoz3], CEL, Droga),
	   		(MozeBlokowac -> droga_bloku(KPoz1, KPoz2, KPoz3, [GPoz1, GPoz2, GPoz3], CEL, Droga);
	        	Droga = min_droga_dp([KPoz1, KPoz2, KPoz3], [GPoz1, GPoz2, GPoz3], Droga)).



% komputer mo¿e wygraæ 

kmw([KPoz1, KPoz2, KPoz3], [GPoz1, GPoz2, GPoz3], Droga):-
			min_droga_dw([KPoz1, KPoz2, KPoz3], [GPoz1, GPoz2, GPoz3], Droga).

% nikt nie mo¿e wygraæ

nnmw([KPoz1, KPoz2, KPoz3], [GPoz1, GPoz2, GPoz3], Droga):-
			min_droga_dp([KPoz1, KPoz2, KPoz3], [GPoz1, GPoz2, GPoz3], Droga).

			
ruch_komputera([KPoz1, KPoz2, KPoz3], [GPoz1, GPoz2, GPoz3], LK):-
			WK = min_droga_dw([KPoz1, KPoz2, KPoz3], [GPoz1, GPoz2, GPoz3], _DWK),
			WG = min_droga_dw([GPoz1, GPoz2, GPoz3], [KPoz1, KPoz2, KPoz3], _DWG),
			(WK, WG -> ogmw([KPoz1, KPoz2, KPoz3], [GPoz1, GPoz2, GPoz3], Droga);
			(WK, not(WG) -> kmw([KPoz1, KPoz2, KPoz3], [GPoz1, GPoz2, GPoz3], Droga);
			(not(WK), wG -> gmw([KPoz1, KPoz2, KPoz3], [GPoz1, GPoz2, GPoz3], Droga);
			(not(WK), not(WG) -> nnmw([KPoz1, KPoz2, KPoz3], [GPoz1, GPoz2, GPoz3], Droga))))),
			przesun_pion_komputera([KPoz1, KPoz2, KPoz3], Droga, LK).



% predykat min - zwraca najmniejsz¹ liczbê na liœce pod warunkiem ¿e jest wiêksza ni¿ 1

min([Obiekt], Obiekt).
min([Obiekt | Lista], Obiekt) :- 
			min(Lista, Lista_Odpowiedz), Obiekt =< Lista_Odpowiedz, Obiekt > 1, !. 
min([_Obiekt | Lista], Odpowiedz) :- 
			min(Lista, Odpowiedz), !.



% zwraca najkrótsz¹ listê z 3 podanych (o d³ugoœci co najmniej 2)

% NAJ - najkrótsza z list
% Droga1 - pierwsza lista
% Droga2 - druga lista
% Droga3 - trzecia lista


min_z3(Droga1, Droga2, Droga3, NAJ) :-
			length(Droga1, LPozG), length(Droga2, LPozPrz), length(Droga3, LPozT),(LPozG =< 1 -> LKWG1 is 999; LKWG1 is LPozG),
			(   LPozPrz =< 1 -> LKWG2 is 999; LKWG2 is LPozPrz), (   LPozT =< 1 -> LKWG3 is 999; LKWG3 is LPozT),
			min([LKWG1, LKWG2, LKWG3], MIN), (LKWG1 == MIN -> NAJ = Droga1;(LKWG2 == MIN -> NAJ = Droga2; 
			(LKWG3 == MIN -> NAJ = Droga3))).




% obs³uga przesuwanie piona

przesun_pion_komputera([KPoz1, KPoz2, KPoz3], Droga, LK):-
			[P, K | _T] = Droga, (KPoz1 == P -> LPozPrz = [K, KPoz2, KPoz3];
	    		(KPoz2 == P -> LPozPrz = [KPoz1, K, KPoz3];(KPoz3 == P -> LPozPrz = [KPoz1, KPoz2, K]))),
			posortuj(LPozPrz, LK).

% sortowanie danych

idzdo(X,Y):- X > Y.

posortuj([],[]).
posortuj([X|Tail],Sortowane):- posortuj(Tail,SortowaneTail), wstaw(X,SortowaneTail, Sortowane).
wstaw(X,[Y|Sortowane],[Y|Sortowane1]):- idzdo(X,Y),!, wstaw(X,Sortowane,Sortowane1).
wstaw(X,Sortowane,[X|Sortowane]).
	
