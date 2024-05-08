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
        -- CHECK1 - PESO AUTOINCREMENTABLE
        -- CHECK2 - PESO >=130 AND <=400
        -- CHECK3 - POSICION(C,F,C-F,C-G,F-C,F-G,G-C,G-F,C-F-G,C-G-F)
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

CREATE OR REPLACE PROCEDURE NouJugadorEuropeu(
    p_nombre jugador.NOMBRE%type,
    p_procedencia jugador.PROCEDENCIA%type,
    p_altura jugador.ALTURA%type,
    p_peso jugador.PESO%type,
    p_posicion jugador.POSICION%type,
    p_nombreEquipo jugador.NOMBRE_EQUIPO%type
)
IS
    v_idAuto integer;
    v_KGtoLibras float;
BEGIN
            -- CHECK4 - KG To libras
    v_KGtoLibras:=p_peso*2.20462;
    -- CHECK1 - ID AUTO.
    select MAX(codigo) into v_idAuto from jugador;
    v_idAuto:= v_idAuto+1;
    -- CHECK2 - PESO.
    IF p_peso>=130 AND p_peso<=400 THEN
    -- CHECK3 - POSICION
        IF p_posicion IN('C','F','G','C-F','C-G','F-C','F-G','G-C','G-F','C-F-G','C-G-F') THEN
            INSERT INTO JUGADOR
            VALUES(v_idAuto, p_nombre, p_procedencia, p_altura, v_KGtoLibras, p_posicion, p_nombreEquipo);
            DBMS_OUTPUT.PUT_LINE('El jugador ' || p_nombre || ' ingresado correctamente con el código: ' || v_idAuto || '. Su peso en libras es: ' || v_KGtoLibras);
        ELSE
            DBMS_OUTPUT.PUT_LINE('El caracter de la posicion que has indicado no es correcto.');
        END IF;
    ELSE
        DBMS_OUTPUT.PUT_LINE('El peso que has introducido es incorrecto.(130-400)');
    END IF;
END;
/

-- RESULTADO:
execute NouJugadorEuropeu('Row','España',7-7,150,'C','Warriors'); 

El jugador Row ingresado correctamente con el código: 624. Su peso en libras es:  
330,693



***************************************************

    CHECKS:
    -- CHECK1 - Buscar el jugador por su codigo y guardar sus datos en variables.
    -- CHECK2 - Borrar al jugador
    -- CHECK3 - Imprimir mensaje de borrado con exito.
    -- CHECK4 - Imprime la exception cuando no encuentre el codigo del jugador.
    -- CHECK5 - Mostrar mensaje de error genérico.

Requeriment 3 (2 punts):
-- Nom: BaixaJugador
-- Entrada: Numèric sense decimals
-- Sortida: -
-- Descripció: Aquesta funcionalitat s’ha d’encarregar de donar de baixa de la base de
-- dades al jugador amb el codi que rebem com a paràmetre. Si tot ha anat correctament
-- caldrà mostrar per pantalla un missatge tipus “S’ha donat de baixa correctament al
-- jugador: <<Mostrar les dades del jugador: codi, nom, posició, equip...>>”. En cas que
-- alguna cosa no hagi anat correctament caldrà també avisar per pantalla. 

****************************************************

CREATE OR REPLACE PROCEDURE BaixaJugador (
    p_codigoJugador jugador.CODIGO%type
)
IS
    v_nombreJuador jugador.NOMBRE%type;
    v_procedenciaJugador jugador.PROCEDENCIA%type;
    v_alturaJugador jugador.ALTURA%type;
    v_pesoJugador jugador.PESO%type;
    v_posicionJugador jugador.POSICION%type;
    v_nombreEqJugador jugador.NOMBRE_EQUIPO%type;
BEGIN

    -- CHECK1 - Buscar el jugador por su codigo y guardar sus datos en variables.
    SELECT NOMBRE, PROCEDENCIA, ALTURA, PESO, POSICION, NOMBRE_EQUIPO
    INTO v_nombreJuador, v_procedenciaJugador, v_alturaJugador, v_pesoJugador, v_posicionJugador, v_nombreEqJugador
    FROM JUGADOR
    WHERE CODIGO=p_codigoJugador;

    -- CHECK2 - Borrar al jugador
    DELETE FROM JUGADOR
    WHERE CODIGO = p_codigoJugador;

    -- CHECK3 - Imprimir mensaje de borrado con exito.
    DBMS_OUTPUT.PUT_LINE('Ha sido dado de baja el siguiente jugador: ' || v_nombreJuador || ', ' || v_procedenciaJugador || ', ' || v_alturaJugador || ',' || v_pesoJugador || ',' || v_posicionJugador || ',' || v_nombreEqJugador);

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        -- CHECK4 - Imprime la exception cuando no encuentre el codigo del jugador.
        DBMS_OUTPUT.PUT_LINE('Error: No se ha encontrado el siguiente jugador con el codigo: ' || p_codigoJugador);
    WHEN OTHERS THEN
        -- CHECK5 - Mostrar mensaje de error genérico.
        DBMS_OUTPUT.PUT_LINE('Error: Contacta con el Admin =) ');
END BaixaJugador;
/

-- RESULTADO:
SQL> select * from jugador where codigo=623; 

    CODIGO NOMBRE                         PROCEDENCIA          ALTU       PESO     
---------- ------------------------------ -------------------- ---- ----------     
POSIC NOMBRE_EQUIPO
----- --------------------
       623 Row                            España               0           150     
C     Warriors


SQL> execute BaixaJugador(623);
Ha sido dado de baja el siguiente jugador: Row, España, 0,150,C,Warriors

PL/SQL procedure successfully completed.

****************************************************

    Requeriment 4 (2 punts):
    -- Nom: ConsultarJugador
    -- Entrada: Numèric sense decimals
    -- Sortida: -
    -- Descripció: Aquesta funcionalitat s’ha d’encarregar de mostrar per pantalla les dades
    -- del jugador amb el codi que rebem com a paràmetre.

****************************************************


CREATE OR REPLACE PROCEDURE ConsultarJugador (
    p_codigoJugador jugador.CODIGO%type
)
IS
    v_nombreJ jugador.NOMBRE%type;
    v_procedenciaJ jugador.PROCEDENCIA%type;
    v_alturaJ jugador.ALTURA%type;
    v_pesoJ jugador.PESO%type;
    v_posicionJ jugador.POSICION%type;
    v_nombreEquipoJ jugador.NOMBRE_EQUIPO%type;
    v_altura_cm NUMBER;
    v_LibrasTOKg NUMBER;

BEGIN
    -- CHECK1 - Query para buscar todos los datos por separados y guardarlos en las variables
    -- Declaradas arriba.
    SELECT NOMBRE, PROCEDENCIA, ALTURA, PESO, POSICION, NOMBRE_EQUIPO
    INTO v_nombreJ, v_procedenciaJ, v_alturaJ, v_pesoJ, v_posicionJ, v_nombreEquipoJ
    FROM JUGADOR
    WHERE CODIGO = p_codigoJugador;

    -- Llamada a la Function peusToCm para convertir la los pies a centímetros.
    v_altura_cm := peusToCm(v_alturaJ);
    -- Pasar de Libras a Kilos.
    v_LibrasTOKg:=v_pesoJ*2.20462;

    -- Mostrar los datos del jugador
    DBMS_OUTPUT.PUT_LINE('*******************************************************');
    DBMS_OUTPUT.PUT_LINE('Dades de jugador');
    DBMS_OUTPUT.PUT_LINE('*******************************************************');
    DBMS_OUTPUT.PUT_LINE('CODI: ' || p_codigoJugador);
    DBMS_OUTPUT.PUT_LINE('NOMBRE: ' || v_nombreJ);
    DBMS_OUTPUT.PUT_LINE('PROCEDÈNCIA: ' || v_procedenciaJ);
    DBMS_OUTPUT.PUT_LINE('ALTURA (pies): ' || v_alturaJ || ' ALTURA (cm): ' || v_altura_cm);
    DBMS_OUTPUT.PUT_LINE('PES (lliures): ' || v_pesoJ || ' PES (Kg): ' || v_LibrasTOKg);
    DBMS_OUTPUT.PUT_LINE('POSICIÓ: ' || v_posicionJ);
    DBMS_OUTPUT.PUT_LINE('EQUIP: ' || v_nombreEquipoJ );
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        -- Mostrar mensaje si no se encuentra el jugador
        DBMS_OUTPUT.PUT_LINE('Error: No se ha encontrado ningún jugador con el codigo: ' || p_codigoJugador);
END;
/



