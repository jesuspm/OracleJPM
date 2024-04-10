/* *****************************************************
//  Institut TIC de Barcelona
//	CFGS Desenvolupament d'aplicacions Web
//	M20: Bases de dades. UF3: PL/SQL
//	PRÀCTICA UF3. FASE 1
//	AUTOR: Jesús Pujada Montoya
//	DATA: 04/04/2024
****************************************************** */


-------------------------
    --REQUERIMENT 1.
-------------------------


CREATE OR REPLACE FUNCTION treureEspais(cadena varchar2)
return varchar2
IS
    aux varchar2(1000);
BEGIN
    FOR i in 1..LENGTH(cadena) LOOP
        IF SUBSTR(cadena,i,1) != ' ' THEN
            aux:= aux || SUBSTR(cadena,i,1);

        END IF;
    END LOOP;

    return aux;
END;
/

-- CONSULTA:
SQL> select treureEspais('Hola Mundo') from dual;

TREUREESPAIS('HOLAMUNDO')
-------------------------
HolaMundo


-------------------------
    --REQUERIMENT 2.
-------------------------

CREATE OR REPLACE FUNCTION kgToLliures(cantidad integer)
return integer
IS
    resultado integer;
BEGIN
    resultado:=cantidad*2.2;
    return resultado;
END;
/

-- CONSULTA:
SQL> select kgToLliures(50) from dual;

kgToLliures(50)
--------------
           110


-------------------------
    --REQUERIMENT 3.
-------------------------

CREATE OR REPLACE FUNCTION lliuresToKg(cantidad integer)
RETURN integer
IS
    resultado integer;
BEGIN
    resultado:=cantidad/2.2;
    return resultado;
END;
/

-- CONSULTA:
SQL> select lliuresToKg(220) from dual;

LLIURESTOKG(220)
----------------
             100

SQL>

-------------------------
    --REQUERIMENT 4.
-------------------------
CREATE OR REPLACE FUNCTION esPesValid1(num INTEGER, formato VARCHAR2)
RETURN INTEGER
IS
    resultado INTEGER;
BEGIN
    -- Concatenar el número y el formato en una cadena
    resultado := TO_NUMBER(TO_CHAR(num) || formato);
    
    -- Devolver el resultado
    RETURN resultado;
END;
/

