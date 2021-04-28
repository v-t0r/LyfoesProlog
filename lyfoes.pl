% Cores: Red, Blue, Green, White, Violet, Orange, Pink, Yellow, Cyan, Light Pink.
cor(r).
cor(b).
cor(g).
cor(w).
cor(v).
cor(o).
cor(p).
cor(y).
cor(c).
cor(l).

% 1- Verifica se todo mundo eh cor.
ehCor([[H|T1]|T2]):- cor(H), ehCor([T1|T2]).
ehCor([[]|T2]):- ehCor(T2).
ehCor([]).

% 2- Verifica se cada tubo tem no maximo 4 lyfoes.
max4([H|T]):- length(H,X), X=<4, max4(T).
max4([]).

% 3- Compara dois tubos para garantir que o Lyfoe nao volte para o msm tubo.
igual([H1|T1],[H2|T2]):- H1==H2, igual(T1,T2).
igual([],[]).

% 4- Confere se um tubo foi resolvido, e chama o proximo tubo.
verificaTubo([[H1,H2|T1]|T2],L):- H1==H2, verificaTubo([[H1|T1]|T2],[H1|L]),!.
verificaTubo([[X]|T],L):- proxTubo(T,[X|L]).
verificaTubo([[]|T],L):- proxTubo(T,L).

% 5- Avanca um tubo na verificacao de conclusao.
proxTubo([[H|T1]|T2],L):- not(member(H,L)), verificaTubo([[H|T1]|T2],L).
proxTubo([[]|T],L):- proxTubo(T,L).
proxTubo([],_).

% 6- Retira um Lyfoe de algum tubo.
retira([[H|T1]|T2],[T1|T2], H,T1).
retira([[H|T1]|T2],[[H|T1]|R], X,Ant):- retira(T2,R,X,Ant).
retira([[]|T2], [[]|R],X,Ant):- retira(T2,R,X,Ant).
retira([],_,_,_):- !, fail.

% 7- Verifica se um movimento é idiota.
movIdiota([H1|Prox],[H2|Ant],X):- verificaTubo([[H1|Prox]],[]),
verificaTubo([[H2|Ant]],[]), length([H2|Ant],X1),     length([H1|Prox],X2), X1>1, X2==1, H1==X, H2==X.
movIdiota([],[H2|Ant],X):- verificaTubo([[H2|Ant]],[]), H2==X.
                                  
% 8- Insere um Lyfoe em algum tubo.
insere([[H|T1]|T2],[[X,H|T1]|T2],X,Ant):- length([H|T1],Qnt), not(igual([H|T1],Ant)), 
                                          		          not(movIdiota([H|T1],Ant,X)), Qnt<4, H==X.
insere([[]|T],[[X]|T],X,Ant):- not(igual(Ant,[])), not(movIdiota([],Ant,X)).
insere([H|T],[H|L],X,Ant):- insere(T,L,X,Ant).

% 9- Retira de um Lyfoe de um tubo e insere em outro.
move(L,Hist,R,Mov):- Mov>0, retira(L,LN,H,T1), insere(LN,LNN,H,T1),
not(member(LNN,Hist)), confere(LNN,[LNN|Hist],R,Mov).

% 10- Confere se o problema foi resolvido.
confere(L,Hist,Hist,_):- verificaTubo(L,[]),!.
confere(L,Hits,R,Mov):- Mov>0, Mov1 is Mov-1, move(L,Hits,R,Mov1).

% 11- Calcula a quantidade de movimentos.
qntMov(X,X1):- X<10, X1 is X*3.
qntMov(X,X1):- X>=10, X<15, X1 is X*4.
qntMov(X,X1):- X>=15, X1 is X*6.

% 12- Imprimi o resultado linha a linha.
imprime([H|T]):- write(H), nl, imprime(T).
imprime([]).

% 13.A- Resolve o problema dado.
lyfoes(L):-  verificaTubo(L,[]),!.
lyfoes(L):- ehCor(L), max4(L), length(L,X), qntMov(X,X1), 
                  move(L,[L],R,X1), reverse(R,R1), imprime(R1). 

% 13.B- Resolve o problema dado, com entrada de limite de movimentos.
lyfoes(L,_):-  verificaTubo(L,[]),!.
lyfoes(L,X):- ehCor(L), max4(L), move(L,[L],R,X), reverse(R,R1), imprime(R1). 

