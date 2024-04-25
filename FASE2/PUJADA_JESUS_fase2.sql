/* *****************************************************
//  Institut TIC de Barcelona
//	CFGS Desenvolupament d'aplicacions Web
//	M20: Bases de dades. UF3: PL/SQL
//	PRÀCTICA UF3. FASE 2
//	AUTOR: Jesús Pujada Montoya
//	DATA: 25/04/2024
****************************************************** */
set serveroutput on;

------------------------------------------------------------------------------
                ANTES DE COMENZAR, TENER EN CUENTA ESTO!
1.- Crea el esqueleto del procedimiento/funcion
2.- Fes la consulta a SQL(No pl/SQL) hasta que funcione
3.- Lleva la consulta a pl/SQL i añade DBMS_OUTPUT para mostrar resultados
4.- Añade defensas/excepciones


--ESTO LO QUE HARÁ SERÁ MOSTRAR LAS CONTRAINTS(RESTRICCIONES) QUE TIENE LA TABLA, PARA
--TENER EN CUENTA LAS DEFENSAS QUE TENDREMOS QUE HACER MEDIANTE : IF O EXCEPTIONS PARA
--CONTROLAR.
select constraint_name, search_condition from user_constraints where table_name='JUGADOR';

EXCEPTIONS SIN NOMBRE -> 2290 CHECK Y -> 2291 FK-
------------------------------------------------------------------------------

Requeriment 1 (1.5 punts):
-- Nom: NouJugador
-- Entrada: nom, procedència, alçada, pes, posicio, equip
-- Sortida: -
-- Descripció: Aquesta funcionalitat ha de donar d’alta un nou jugador a la base de dades,
-- però ha de garantir que no es produirà cap errada. Si per alguna raó no es pot donar
-- d’alta el jugador, caldrà mostrar per pantalla la descripció de l’error, quin dels
-- paràmetres és incorrecte, etc. Cal tenir present que no es demana com a paràmetre
-- d’entrada el codi del jugador. Caldrà que el procediment obtingui el següent codi
-- corresponent i l’assigni automàticament. Si tot ha anat correctament, caldrà que mostri
-- per pantalla un missatge tipus “S’ha donat d’alta correctament al jugador <<Nom>> i se
-- li ha assignat el codi <<codi>>”


