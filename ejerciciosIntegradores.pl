
% --- Saltos
%
% En una competencia de saltos, cada competidor puede hacer hasta 5 saltos;
% a cada salto se le asigna un puntaje de 0 a 10. Se define el predicado puntajes
% que relaciona cada competidor con los puntajes de sus saltos, p.ej.
% 
% puntajes(hernan,[3,5,8,6,9]).
% puntajes(julio,[9,7,3,9,10,2]).
% puntajes(ruben,[3,5,3,8,3]).
% puntajes(roque,[7,10,10]).
% 
% Se pide armar un programa Prolog que a partir de esta información permita consultar:
% Ayuda: investigar predicado nth1/3 y nth0/3 en el prolog.


% 1. Qué puntaje obtuvo un competidor en un salto, p.ej. qué puntaje obtuvo Hernán en el salto 4 (respuesta: 6).

puntajes(hernan,[3,5,8,6,9]).
puntajes(julio,[9,7,3,9,10,2]).
puntajes(ruben,[3,5,3,8,3]).
puntajes(roque,[7,10,10]).

puntaje(Competidor, NumSalto, Puntaje) :- puntajes(Competidor, Saltos), nth1(NumSalto, Saltos, Puntaje).


% 2. Si un competidor está descalificado o no. Un competidor está descalificado si hizo más de 5 saltos.
% En el ejemplo, Julio está descalificado.

descalificado(Competidor) :- puntajes(Competidor, Puntajes), length(Puntajes, Cantidad), Cantidad > 5.


% 3. Si un competidor clasifica a la final. Un competidor clasifica a la final si la suma de sus puntajes
% es mayor o igual a 28, o si tiene dos saltos de 8 o más puntos.

clasificaALaFinal(Competidor) :- puntajes(Competidor, Puntajes), sum_list(Puntajes, Suma), Suma >= 28.
clasificaALaFinal(Competidor) :-
    puntajes(Competidor, Puntajes),
    nth0(Indice1, Puntajes, Puntaje1),
    nth0(Indice2, Puntajes, Puntaje2),
    Indice1 \= Indice2,
    muchoPuntaje(Puntaje1),
    muchoPuntaje(Puntaje2).

muchoPuntaje(Puntaje) :- Puntaje >= 8.



% --- Subtes
% En este ejercicio viene bien usar el predicado nth1/3, que relaciona un número, una lista,
% y el elemento de la lista en la posición indicada por el número (empezando a contar de 1). P.ej. prueben estas consultas
% ?- nth1(X,[a,b,c,d,e],d).
% ?- nth1(4,[a,b,c,d,e],X).
% ?- nth1(Orden,[a,b,c,d,e],Elem).
% ?- nth1(X,[a,b,c,d,e],j).
% ?- nth1(22,[a,b,c,d,e],X).
% Tenemos un modelo de la red de subtes, por medio de un predicado linea que relaciona el nombre de la linea con
% la lista de sus estaciones, en orden. P.ej. (reduciendo las lineas)
% 
% No hay dos estaciones con el mismo nombre.
% 
% Se pide armar un programa Prolog que a partir de esta información permita consultar:


linea(a,[plazaMayo,peru,lima,congreso,miserere,rioJaneiro,primeraJunta,nazca]).
linea(b,[alem,pellegrini,callao,pueyrredonB,gardel,medrano,malabia,lacroze,losIncas,urquiza]).
linea(c,[retiro,diagNorte,avMayo,independenciaC,plazaC]).
linea(d,[catedral,nueveJulio,medicina,pueyrredonD,plazaItalia,carranza,congresoTucuman]).
linea(e,[bolivar,independenciaE,pichincha,jujuy,boedo,varela,virreyes]).
linea(h,[lasHeras,santaFe,corrientes,once,venezuela,humberto1ro,inclan,caseros]).

combinacion([lima, avMayo]).
combinacion([once, miserere]).
combinacion([pellegrini, diagNorte, nueveJulio]).
combinacion([independenciaC, independenciaE]).
combinacion([jujuy, humberto1ro]).
combinacion([santaFe, pueyrredonD]).
combinacion([corrientes, pueyrredonB]).


% 1. En qué linea está una estación, predicado estaEn/2.

estaEn(Linea, Estacion) :- linea(Linea, Estaciones), member(Estacion, Estaciones).

% 2. dadas dos estaciones de la misma línea, cuántas estaciones hay entre ellas,
% p.ej. entre Perú y Primera Junta hay 5 estaciones. Predicado distancia/3 (relaciona las dos estaciones y la distancia).

distancia(Estacion1, Estacion2, Distancia) :-
    linea(_, Estaciones),
    nth0(Indice1, Estaciones, Estacion1),
    nth0(Indice2, Estaciones, Estacion2),
    Diferencia is Indice2 - Indice1,
    abs(Diferencia, Distancia).

% 3. Dadas dos estaciones de distintas líneas, si están a la misma altura (o sea, las dos terceras, las dos quintas, etc.),
% p.ej. Independencia C y Jujuy que están las dos cuartas. Predicado mismaAltura/2.

mismaAltura(Estacion1, Estacion2) :-
    linea(Linea1, Estaciones1),
    linea(Linea2, Estaciones2),
    Linea1 \= Linea2, % Si se consulta por mismaAltura(Estacion1, Estacion2)., entonces no muestra las que son de la misma Linea.
    nth0(Indice, Estaciones1, Estacion1),
    nth0(Indice, Estaciones2, Estacion2).


% 4. Dadas dos estaciones, si puedo llegar fácil de una a la otra, esto es, si están en la misma línea,
% o bien puedo llegar con una sola combinación. Predicado viajeFacil/2.

viajeFacil(Estacion1, Estacion2) :- estaEn(Linea, Estacion1), estaEn(Linea, Estacion2).
viajeFacil(Estacion1, Estacion2) :- combinacion(Combinacion), member(Estacion1, Combinacion), member(Estacion2, Combinacion).






% --- Viajes
% Una agencia de viajes lleva un registro con todos los vuelos que maneja de la siguiente manera:
% vuelo(Codigo de vuelo, capacidad en toneladas, [lista de destinos]).
% Esta lista de destinos está compuesta de la siguiente manera:
% escala(ciudad, tiempo de espera)
% tramo(tiempo en vuelo)
% Siempre se comienza de una ciudad (escala) y se termina en otra (no puede terminar en el aire al vuelo),
% con tiempo de vuelo entre medio de las ciudades. Considerar que los viajes son de ida y de vuelta por la misma ruta.
%
% Definir los siguientes predicados; en todos vamos a identificar cada vuelo por su código.


vuelo(arg845, 30, [escala(rosario,0), tramo(2), escala(buenosAires,0)]).

vuelo(mh101, 95, [escala(kualaLumpur,0), tramo(9), escala(capeTown,2), 
    tramo(15), escala(buenosAires,0)]).

vuelo(dlh470, 60, [escala(berlin,0), tramo(9), escala(washington,2), 
    tramo(2), escala(nuevaYork,0)]).

vuelo(aal1803, 250, [escala(nuevaYork,0), tramo(1), escala(washington,2),
    tramo(3), escala(ottawa,3), tramo(15), escala(londres,4), tramo(1),
    escala(paris,0)]).

vuelo(ble849, 175, [escala(paris,0), tramo(2), escala(berlin,1), tramo(3),
    escala(kiev,2), tramo(2), escala(moscu,4), tramo(5), 
    escala(seul,2), tramo(3), escala(tokyo,0)]).

vuelo(npo556, 150, [escala(kiev,0), tramo(1), escala(moscu,3), tramo(5),
    escala(nuevaDelhi,6), tramo(2), escala(hongKong,4), 
    tramo(2), escala(shanghai,5), tramo(3), escala(tokyo,0)]).

vuelo(dsm3450, 75, [escala(santiagoDeChile,0), tramo(1), escala(buenosAires,2), tramo(7), 
    escala(washington,4), tramo(15), escala(berlin,3), tramo(15), escala(tokyo,0)]).


% 1. tiempoTotalVuelo/2 : Relaciona un vuelo con el tiempo que lleva en total, contando las esperas en las escalas
% (y eventualmente en el origen y/o destino) más el tiempo de vuelo.

tiempoTotalVuelo(CodVuelo, TiempoTotal) :-
    vuelo(CodVuelo, _, Destinos),
    tiempoTotalDestinos(Destinos, TiempoTotal).

tiempoTotalDestinos([], 0).
tiempoTotalDestinos([DestinoActual | RestoDestinos], TiempoTotal) :-
    tiempoTotalDestinos(RestoDestinos, TiempoAcumulado),
    tiempoDestino(DestinoActual, TiempoActual),
    TiempoTotal is TiempoAcumulado + TiempoActual.

tiempoDestino(escala(_, Tiempo), Tiempo).
tiempoDestino(tramo(Tiempo), Tiempo).


% 2. escalaAburrida/2 : Relaciona un vuelo con cada una de sus escalas aburridas;
% una escala es aburrida si hay que esperar mas de 3 horas.

escalaAburrida(CodVuelo, Escala) :-
    vuelo(CodVuelo, _, Destinos),
    member(Escala, Destinos),
    escalaAburrida(Escala).

escalaAburrida(escala(_, Tiempo)) :- Tiempo > 3.
    

% 3. ciudadesAburridas/2 : Relaciona un vuelo con la lista de ciudades de sus escalas aburridas.

ciudadAburrida(CodVuelo, Ciudad) :- escalaAburrida(CodVuelo, escala(Ciudad, _)).

ciudadesAburridas(CodVuelo, Ciudades) :-
    findall(Ciudad, ciudadAburrida(CodVuelo, Ciudad), Ciudades).
    


% 4. vueloLargo/1: Si un vuelo pasa 10 o más horas en el aire, entonces es un vuelo largo.
% OJO que dice "en el aire", en este punto no hay que contar las esperas en tierra.
% conectados/2: Relaciona 2 vuelos si tienen al menos una ciudad en común.

tiempoVueloTramos([], 0).

tiempoVueloTramos([tramo(TiempoTramo) | RestoDestinos], TiempoTotal) :-
    tiempoVueloTramos(RestoDestinos, TiempoAcumulado),
    TiempoTotal is TiempoAcumulado + TiempoTramo.

tiempoVueloTramos([escala(_, _) | RestoDestinos], TiempoTotal) :-
    tiempoVueloTramos(RestoDestinos, TiempoTotal).

vueloLargo(CodVuelo) :-
    vuelo(CodVuelo, _, Destinos),
    tiempoVueloTramos(Destinos, Tiempo),
    Tiempo >= 10.


% 5. bandaDeTres/3: Relaciona 3 vuelos si están conectados, el primero con el segundo, y el segundo con el tercero.

conectados(CodVuelo1, CodVuelo2) :-
    vuelo(CodVuelo1, _, Destinos1),
    vuelo(CodVuelo2, _, Destinos2),
    member(escala(Ciudad, _), Destinos1),
    member(escala(Ciudad, _), Destinos2).

bandaDeTres(CodVuelo1, CodVuelo2, CodVuelo3) :-
    conectados(CodVuelo1, CodVuelo2),
    conectados(CodVuelo2, CodVuelo3).


% 6. distanciaEnEscalas/3: Relaciona dos ciudades que son escalas del mismo vuelo y la cantidad de escalas entre las mismas;
% si no hay escalas intermedias la distancia es 1. P.ej. París y Berlín están a distancia 1 (por el vuelo BLE849), 
% Berlín y Seúl están a distancia 3 (por el mismo vuelo). No importa de qué vuelo, lo que tiene que pasar es que haya
% algún vuelo que tenga como escalas a ambas ciudades. Consejo: usar nth1.

distanciaEnEscalas(Ciudad1, Ciudad2, Distancia) :-
    vuelo(_, _, Destinos),
    nth0(Indice1, Destinos, escala(Ciudad1, _)),
    nth0(Indice2, Destinos, escala(Ciudad2, _)),
    CantidadEscalasIntermedias is (Indice2 - Indice1) / 2,
    abs(CantidadEscalasIntermedias, Distancia).
    

% 7. vueloLento/1: Un vuelo es lento si no es largo, y además cada escala es aburrida.

vueloLento(CodVuelo) :-
    vuelo(CodVuelo, _, Destinos),
    not(vueloLargo(CodVuelo)),
    forall(escalaDeDestinos(Escala, Destinos), escalaAburrida(Escala)).
    
escalaDeDestinos(Escala, Destinos) :-
    member(Escala, Destinos),
    Escala = escala(_, _).




