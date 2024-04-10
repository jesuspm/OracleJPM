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