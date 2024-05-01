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




***************************************************

        -- PROCEDIMIENTO 1 HECHO CON IFS --

        CHECKS:
        -- PESO AUTOINCREMENTABLE
        -- PESO >=130 AND <=400
        -- POSICION(C,F,C-F,C-G,F-C,F-G,G-C,G-F,C-F-G,C-G-F)
        select constraint_name, search_condition from user_constraints where table_name='JUGADOR';

****************************************************


CREATE OR REPLACE PROCEDURE NouJugador(
    p_nombre jugador.NOMBRE%type,
    p_procedencia jugador.PROCEDENCIA%type,
    p_altura jugador.ALTURA%TYPE,
    p_peso jugador.PESO%type,
    p_posicion jugador.posicion%type,
    p_nombreEquipo jugador.nombre_equipo%type
)
IS
    v_numeroAUTO integer;
BEGIN
    -- CHECK1 - AutoIncrementar ID en el insert
    select max(CODIGO) into v_numeroAUTO from JUGADOR;
    v_numeroAUTO:= v_numeroAUTO+1;
    
    -- CHECK 2 - PESO
    IF p_peso>=130 AND p_peso<=400 THEN
    
    -- CHECk 3 - LETRA POSICION.
        IF p_posicion IN('C','F','G','C-F','C-G','F-C','F-G','G-C','G-F','C-F-G','C-G-F') THEN
            -- CHECKS OK HACE INSERT + PRINT.
            insert into jugador
            values(v_numeroAUTO, p_nombre, p_procedencia, p_altura, p_peso, p_posicion, p_nombreEquipo);
            dbms_output.put_line('El jugador ' || p_nombre || ' ingresado correctamente con el codigo: '|| v_numeroAUTO);    
        ELSE
            dbms_output.put_line('La posición introducida no es correcta, debe ser una de las siguientes: C,F,C-F,C-G,F-C,F-G,G-C,G-F,C-F-G,C-G-F');
        END IF;
    ELSE
        dbms_output.put_line('El peso introducido es incorrecto, peso correcto (130-400).');    
    END IF;
END;
/

-- EJECUCIÓN:
execute NouJugador('LOLO','España',7-7,100,'G','Warriors'); 


***************************************************

        -- PROCEDIMIENTO 2 HECHO CON IFS --

        CHECKS:
        
        select constraint_name, search_condition from user_constraints where table_name='JUGADOR';

****************************************************

Requeriment 2 (1.5 punts):
-- Nom: NouJugadorEuropeu
-- Entrada: nom, procedència, alçada, pes, posicio, equip
-- Sortida: -
-- Descripció: Aquesta funcionalitat és igual que l’anterior i ha de fer el mateix, però amb
-- la diferència que ara, els paràmetres d’entrada vindran donats en kilograms per al pes i
-- en centímetres per a l’alçada. Recordeu que el format que es vol per a la base de dades
-- és en lliures per al pes i en peus i polzades per a l’alçada