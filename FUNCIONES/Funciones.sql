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
CREATE OR REPLACE FUNCTION esAlcadaValida (entrada IN VARCHAR2)
RETURN NUMBER
IS
    pies NUMBER;
    pulgadas NUMBER;
    pos_separador NUMBER;
BEGIN
    -- Encontrar la posición del separador "-" con la funcion INSTR
    pos_separador := INSTR(entrada, '-');

    -- Si el separador "-" está en la posición 2 o mayor (indicando al menos un dígito antes del "-")
    -- y la longitud total es al menos 3 (X-YY), entonces intentamos extraer los pies y polzadas
    IF pos_separador >= 2 AND LENGTH(entrada) >= 3 THEN
        -- Extraer los pies(SUBSTR) y los convierte en numero(TO_NUMBRER)
        pies := TO_NUMBER(SUBSTR(entrada, 1, pos_separador - 1));
        
        -- esto extrae la parte de "pulgadas" de la cadena de entrada después del separador "-",
        -- lo convierte en un número y lo asigna a la variable pulgadas.
        pulgadas := TO_NUMBER(SUBSTR(entrada, pos_separador + 1));
       
        -- Comprobar que las polzadas no sean mayores a 11 y que haya pies y polzadas
        IF pulgadas < 12 AND pies IS NOT NULL AND pulgadas IS NOT NULL THEN
            RETURN 1; -- Entrada válida
        END IF;
    END IF;
    
    RETURN 0; -- Entrada no válida
EXCEPTION
    WHEN OTHERS THEN
        RETURN 0; -- Manejo de excepciones
END esAlcadaValida;
/





































































