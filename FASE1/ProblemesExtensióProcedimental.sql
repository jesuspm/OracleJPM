-- M10: Administració i Gestió de Bases de Dades

-- Primera part: Procediments i funcions bàsics

!!!!!!!!!!!!! ANTES DE COMENZAR !!!!!!!!!!!!!!!!!!

SET SERVEROUTPUT ON;


CREATE OR REPLACE PROCEDURE escribe (txt varchar2) as
BEGIN
    dbms_output.put_line(txt);
end;
/

----------------------------------------------------

                    EJERCICIOS

----------------------------------------------------


-- 1. Crea un procediment que rebi dos números i mostri per pantalla la seva suma
CREATE OR REPLACE PROCEDURE SUMA(num1 integer, num2 integer) as
BEGIN
    DBMS_OUTPUT.PUT_LINE(num1+num2);
END;
/
-- RESULTADO:
SQL> EXECUTE SUMA(5,5);
10

-- 2. Crear un procediment anomenat escriu que rebi una cadena de caràcters i la
-- mostri per pantalla. Aquest procediment ens servirà a partir d’aquest
-- moment com a variant de la funció DBMS_OUTPUT.PUT_LINE

-- PROCEDIMIENTO PARA REMPLAZAR DBMS_OUTPUT.PUT_LINE -> escribe
CREATE OR REPLACE PROCEDURE escribe (txt varchar2) as
BEGIN
    dbms_output.put_line(txt);
end;
/

Procedure created.

-- PROCEDIMIENTO:
CREATE OR REPLACE PROCEDURE SUMA(num1 integer, num2 integer) as
BEGIN
    escribe(num1+num2);
END;
/

Procedure created.

-- EJECUCIÓN:
SQL> execute suma(20,20);

-- RESULTADO:
40

PL/SQL procedure successfully completed.


-- 3. Crea un procediment que rebi una cadena de caràcters i mostri per pantalla
-- el número de caràcters que té i mostri per pantalla la cadena rebuda però en
-- majúscules i en minúscules

-- PROCEDIMIENTO
CREATE OR REPLACE PROCEDURE EJ3(cadena IN varchar2) as
BEGIN
    escribe(UPPER(cadena));
    escribe(LOWER(cadena));
    escribe(LENGTH(cadena));
END;
/

-- EJECUCIÓN:
SQL> BEGIN
  2  EJ3('Hola Mundo');
  3  END;
  4  /

-- RESULTADO:
HOLA MUNDO
hola mundo
10
    
-- 4. Crea un procediment que rebi una cadena de caràcters i mostri per pantalla
-- en quina posició es troba el primer espai en blanc (si no n’hi ha cap o si la
-- cadena és buida informarà d’aquest fet).

-- PROCEDIMIENTO:
CREATE OR REPLACE PROCEDURE EJ4(cadena in varchar2) as
    posicion NUMBER; -- Aquí delcaramos la variable para almacenar la posicion para el primer espacio en blanco.
BEGIN
    --Se utiliza la función INSTR para encontrar la posición del primer espacio en blanco
    --en el STRING cadena. El resultado se asigna a la variable posicion.
    posicion:= INSTR(cadena, ' ');

    --Se inicia una estructura condicional. Si posicion es mayor que 0,
    --significa que se encontró al menos un espacio en blanco en la cadena.
    IF posicion > 0 then
        escribe('El primer espacio en blanco se encuentra en la posicion: ' || posicion);
    ELSE
        --Se verifica si la cadena es nula (NULL) o si 
        --después de quitar los espacios en blanco con TRIM la cadena está vacía.
        IF cadena IS NULL OR TRIM(cadena) = '' then
           escribe('La cadena está vacía o solo contiene espacios en blanco.');
        ELSE
            escribe('La cadena no contiene espacios en blanco.');
        END IF;
    END IF; 
END;
/

-- EJECUCIÓN:
BEGIN
    EJ4('Esta es una cadena');
    EJ4(' OtraCadenaSinEspacios');
    EJ4('');
END;
/

-- RESULTADO:
El primer espacio en blanco se encuentra en la posicion: 5
El primer espacio en blanco se encuentra en la posicion: 1
La cadena está vacía o solo contiene espacios en blanco.

PL/SQL procedure successfully completed.


                --------------------------------
                        -SOLUCION PROFE-
                --------------------------------

CREATE OR REPLACE PROCEDURE problema4(cadena VARCHAR2) IS
    aux INTEGER;
    lletra VARCHAR2(1);
    posicio INTEGER:=0;
BEGIN
    aux:=LENGTH(cadena); -- Obtenim el número de lletres de la cadena
    IF (aux>0) THEN
        FOR i IN 1..aux LOOP
            lletra:=SUBSTR(cadena, i, 1); --agafem 1 lletra cada vegada
                                            -- corresponent a la posició i
            IF (lletra=' ' AND posicio=0) THEN
                posicio:=i;
            END IF;
        END LOOP;
    END IF;
    -- Quan acaba el bucle mostrem el resultat
    -- Si la posició és >0 vol dir que hem trobat l'espai en blanc
    IF (posicio>0) THEN 
        DBMS_OUTPUT.put_line('Espai en blanc a la posició: ' || posicio);
    ELSE 
        IF (LENGTH(cadena) IS NULL) THEN
            DBMS_OUTPUT.put_line('La cadena és buida');
        ELSE
            DBMS_OUTPUT.put_line('La cadena no té cap espai en blanc');
        END IF;
    END IF;
END;
/







-- 5. Crea un procediment que rebi una cadena de caràcters i la visualitzi al revés.
-- Fes servir el bucle FOR.

--PROCEDIMIENTO:     
CREATE OR REPLACE PROCEDURE problema5 (cadena VARCHAR2) IS
    aux VARCHAR2(1000);
BEGIN
    FOR i IN REVERSE 1..LENGTH(cadena) LOOP
        aux:=aux || SUBSTR(cadena,i,1);
    END LOOP;
    DBMS_OUTPUT.put_line(aux);
END;
/

--EJECUCIOÓN:

 invertirString('jesus');
 

--RESULTADO:
susej



--8. Crea una funció que rebi un número i retorni el seu factorial. (exemple 5! = 5 *
--4 * 3 * 2 * 1)

    CREATE OR REPLACE FUNCTION probelma8 (numero integer)
    return integer
    IS
        aux integer:=1;
    BEGIN
        for i in..numero LOOP
            aux:=aux*i;
        END LOOP;
        return aux;
    END;
    /


---------------------------------------------------------------------------------------
                                    -SEGUNDA PARTE-
---------------------------------------------------------------------------------------


-- 14. Crea un procediment que permeti consultar les dades d’un pokemon en format
-- fitxa a partir de un codi empleat passat com a paràmetre (ampliació de l’exercici
-- de mostra fet a classe)

CREATE OR REPLACE FUNCTION existe_pokemon(x INTEGER) RETURN INTEGER IS
    aux INTEGER;
BEGIN
    SELECT COUNT(*) INTO aux FROM pokemon WHERE numero_pokedex=x;
    RETURN aux;
END;
/
                       
CREATE OR REPLACE PROCEDURE problema14(codi INTEGER) IS
    v_numero    pokemon.numero_pokedex%TYPE;
    v_nom       pokemon.nombre%TYPE;
    v_pes       pokemon.peso%TYPE;
    v_alcada    pokemon.altura%TYPE;
    valida      INTEGER;
BEGIN
    /* pasos a fer:
        1. validar que existeix el pokemon
        2. Obtenir les dades
        3. Mostrar-les per pantalla
    */
    valida:=existe_pokemon(codi);
    IF (valida=1) THEN
        SELECT * 
        INTO v_numero, v_nom, v_pes, v_alcada
        FROM                            pokemon WHERE numero_pokedex=codi;
 
        mostra(v_numero, v_nom, v_pes, v_alcada);
    ELSE
        DBMS_OUTPUT.put_line('No existeix cap pokemon amb codi: '|| codi);
    END IF;
END;
/

CREATE OR REPLACE PROCEDURE mostra( v_numero    pokemon.numero_pokedex%TYPE,
                                    v_nom       pokemon.nombre%TYPE,
                                    v_pes       pokemon.peso%TYPE,
                                    v_alcada    pokemon.altura%TYPE 
                                )IS
BEGIN
    DBMS_OUTPUT.put_line('--------------------------------');
    DBMS_OUTPUT.put_line('       POKEDEX LIBRARY ');
    DBMS_OUTPUT.put_line('--------------------------------');
    DBMS_OUTPUT.put_line('Número: '|| CHR(9) || v_numero);
    DBMS_OUTPUT.put_line('Nom: '|| CHR(9) || CHR(9) || v_nom);
    DBMS_OUTPUT.put_line('Pes: '|| CHR(9) || CHR(9) || v_pes);
    DBMS_OUTPUT.put_line('Alçada: '|| CHR(9) || v_alcada);
END;
/
-- 15. Amplia el procediment anterior per tal que a més de les dades pròpies del
-- pokemon mostri també les dades de les estadístiques base com l’atac,
-- defensa...


-- 16. Crea un procediment que permeti eliminar les dades d’un pokemon. Aquest
-- procediment rebrà com a paràmetre d’entrada el número de pokedex.


-- 17. Amplia el procediment anterior de forma que es faci abans de la eliminació una
-- comprovació de si el pokemon existeix o no. Si no existeix hauria de mostrar un
-- missatge per pantalla informat que no existeix cap pokemon amb el codi introduït, 
-- mentre que si existeix, hauria de mostrar les dades del pokemon
-- eliminat. Es pot realitzar aquest exercici mitjançant una crida al procediment fet
-- a l’exercici 13.