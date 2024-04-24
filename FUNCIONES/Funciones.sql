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



-------------------------
    --REQUERIMENT 5.
-------------------------

CREATE OR REPLACE FUNCTION peusToCm(p_alcada IN VARCHAR2) RETURN NUMBER IS
    v_peus NUMBER;
    v_polzades NUMBER;
    v_cm NUMBER;
BEGIN
    -- Aqui separamos pies y pulgadas
    v_peus := TO_NUMBER(SUBSTR(p_alcada, 1, INSTR(p_alcada, '-') - 1));
    v_polzades := TO_NUMBER(SUBSTR(p_alcada, INSTR(p_alcada, '-') + 1));

    -- Filtramos con el if si los pies y las pulgadas son nulas que devuelva 0.
    IF v_peus IS NULL OR v_polzades IS NULL THEN
        RETURN 0;  -- Retornar 0 si el formato no es correcto
    END IF;

    -- Calculo para altura en centimetros
    v_cm := (v_peus * 30.48) + (v_polzades * 2.54);

    RETURN v_cm;
EXCEPTION
    WHEN OTHERS THEN
        RETURN 0;  -- Retornar 0 si hay algún error
END peusToCm;
/

-- EJECUCIÓN -- 

SQL> DECLARE
  2      altura_cm NUMBER;
  3  BEGIN
  4      altura_cm := peusToCm('7-00');
  5      DBMS_OUTPUT.PUT_LINE('Altura en cm: ' || altura_cm);
  6
  7      altura_cm := peusToCm('6-03');
  8      DBMS_OUTPUT.PUT_LINE('Altura en cm: ' || altura_cm);
  9
 10      altura_cm := peusToCm('7-');
 11      DBMS_OUTPUT.PUT_LINE('Altura en cm: ' || altura_cm);
 12
 13      altura_cm := peusToCm('45');
 14      DBMS_OUTPUT.PUT_LINE('Altura en cm: ' || altura_cm);
 15  END;
 16  /
Altura en cm: 213,36
Altura en cm: 190,5
Altura en cm: 0
Altura en cm: 0


-------------------------
    --REQUERIMENT 6.
-------------------------
CREATE OR REPLACE FUNCTION cmToPeus(p_alcada_cm IN NUMBER) RETURN VARCHAR2 IS
    v_peus NUMBER;
    v_polzades NUMBER;
    v_result VARCHAR2(10);
BEGIN
    -- Calcular peus y polzades
    v_peus := TRUNC(p_alcada_cm / 30.48); -- TRUNC REDONDEA hacia abajo EJ: TRUNC(10.9) devolverá 10
    v_polzades := ROUND(MOD(p_alcada_cm, 30.48) / 2.54);  -- 1 pulgada = 2.54 cm

    -- Compone el resultado en el formato X-YY
    v_result := v_peus || '-' || LPAD(v_polzades, 2, '0'); -- Formato "X-YY"

    RETURN v_result;
EXCEPTION
    WHEN OTHERS THEN
        RETURN '0-00';  -- Retorna "0-00" si hay algun error
END cmToPeus;
/


-- EJECUCIÓN --

SQL> DECLARE
  2      altura_cm NUMBER := 213.5;
  3      resultado VARCHAR2(10);
  4  BEGIN
  5      resultado := cmToPeus(altura_cm);
  6      DBMS_OUTPUT.PUT_LINE('Altura en pies y pulgadas: ' || resultado);
  7
  8      altura_cm := 190.5;
  9      resultado := cmToPeus(altura_cm);
 10      DBMS_OUTPUT.PUT_LINE('Altura en pies y pulgadas: ' || resultado);
 11  END;
 12  /
Altura en pies y pulgadas: 7-00
Altura en pies y pulgadas: 6-03


-------------------------
    --REQUERIMENT 7.
-------------------------

CREATE OR REPLACE FUNCTION posicioToString(p_posicio IN VARCHAR2) RETURN VARCHAR2 IS
    -- TRIM Elimina espacios al principio y al final de la cadena(Para no tenerlos en cuenta)
    -- y UPPER convierte a mayusculas si la letra que pasamos por parametro es miniscula.
    v_posicio VARCHAR2(10) := TRIM(UPPER(p_posicio));
    v_result VARCHAR2(50);
BEGIN
    -- Mapear las posiciones
    IF v_posicio = 'G' THEN
        v_result := 'Base';
    ELSIF v_posicio = 'F' THEN
        v_result := 'Alero';
    ELSIF v_posicio = 'C' THEN
        v_result := 'Pívot';
    ELSE
        -- Si no es una posición válida, devolver 'Posición Desconocida'
        v_result := 'Posición Desconocida';
    END IF;

    RETURN v_result;
END posicioToString;
/

-- EJECUCIÓN -- 
SQL> DECLARE
  2      posicio_jugador VARCHAR2(10) := 'G';
  3      resultat VARCHAR2(50);
  4  BEGIN
  5      resultat := posicioToString(posicio_jugador);
  6      DBMS_OUTPUT.PUT_LINE('Posición del jugador: ' || resultat);
  7
  8      posicio_jugador := 'F';
  9      resultat := posicioToString(posicio_jugador);
 10      DBMS_OUTPUT.PUT_LINE('Posición del jugador: ' || resultat);
 11
 12      posicio_jugador := 'C';
 13      resultat := posicioToString(posicio_jugador);
 14      DBMS_OUTPUT.PUT_LINE('Posición del jugador: ' || resultat);
 15
 16      posicio_jugador := 'X';  -- Una posición no válida
 17      resultat := posicioToString(posicio_jugador);
 18      DBMS_OUTPUT.PUT_LINE('Posición del jugador: ' || resultat);
 19  END;
 20
 21  /
Posición del jugador: Base
Posición del jugador: Alero
Posición del jugador: Pívot
Posición del jugador: Posición Desconocida




-- Ejercicio extra 
--(Funcion para borrar un cliente POR ID si tiene dependencias);

create or replace procedure borrar_cli (codi integer) IS
	aux integer;
	aux2 integer;
BEGIN
	select count(*) into aux
	from clients where codi_cli=codi;
	if (aux>0) THEN
		--Sabem que existeix un client amb el codi introduit
		select count(*) 
		into aux2
		from projectes
		where codi_cli=codi;
		if (aux2=0) then 
			-- Sabem que el client no té projectes depenents
			dbms_output.put_line('Client donat de baixa');
			delete from clients where codi_cli=codi;
		else 
			dbms_output.put_line('Aquest client té projectes vinculats');
		end if;
	ELSE
		dbms_output.put_line('No existeix cap client');
	end if;
end;
/

-- Crea un procediment que doni dalta un nou empleat:(PARAMETROS: Codi, nom, cognom, sou);
CREATE OR REPLACE PROCEDURE nou_empl (
        -- Creamos las variables para luego indicarles los valores en el insert.
        v_codi INTEGER,
        v_nom VARCHAR2,
        v_cognom VARCHAR2,
        v_sou FLOAT,
        v_codiProj integer
    )
IS
    aux INTEGER;
    aux3 integer;
BEGIN
    aux:=existe(v_codi);
    IF aux=0 THEN 
        IF (v_sou>1000) THEN
            select count(*) into aux3 from projectes where codi_proj=v_codiProj;
            if(aux3>0) then -- Si EXISTE EL PROYECTO
                insert into empleats (codi_empl, nom_empl, cognom_empl, sou, codi_proj)
				values(v_codi, v_nom, v_cognom, v_sou, v_codiProj);

                DBMS_OUTPUT.put_line('Empleat donat d''alta correctament');
                
                muestraEmpleados;
            ELSE
                DBMS_OUTPUT.put_line('No existe el proyecto indicado');
            END IF;
        ELSE
            DBMS_OUTPUT.put_line('Error. El sou ha de ser superior a 1000');
        END IF;
    ELSE
        DBMS_OUTPUT.put_line('Error. Ja existeix aquest codi');
    END IF;
END;
/

-- PARA MOSTRAR los prints por pantalla.
set serveroutput on;

CREATE OR REPLACE PROCEDURE muestraEmpleados IS
   v_codigo empleats.CODI_EMPL%type;
   v_nom empleats.NOM_EMPL%type;
   v_cognom empleats.COGNOM_EMPL%type;
   v_sou empleats.SOU%type;
   v_codigoPR empleats.CODI_PROJ%type;


BEGIN
   FOR empleat IN (SELECT CODI_EMPL, NOM_EMPL, COGNOM_EMPL, SOU, CODI_PROJ FROM empleats) LOOP
      v_codigo := empleat.CODI_EMPL;
      v_nom := empleat.NOM_EMPL;
      v_cognom := empleat.COGNOM_EMPL;
      v_sou := empleat.SOU;
      v_codigoPR := empleat.CODI_PROJ;

      dbms_output.put_line('---- DATOS EMPLEADO ----');
      dbms_output.put_line('Codigo: ' || v_codigo);
      dbms_output.put_line('Nombre: ' || v_nom);
      dbms_output.put_line('Apellido: ' || v_cognom);
      dbms_output.put_line('Sueldo: ' || v_sou);
      dbms_output.put_line('Codigo Proyecto: ' || v_codigoPR);
      
   END LOOP;
END;
/



-- COMO PONER ID AUTOINCREMENTABLE?, usaremos MAX para que coja el mayor numero de ID y le sume 1
-- si el max ID es 19 el siguiente le asignará automaticamente la ID 20.

create or replace procedure nou_empl (
		v_nom varchar2,
		v_cognom varchar2,
		v_sou FLOAT,
		v_proj integer
	)
IS
	aux integer;
	aux3 integer;
BEGIN
	select max(codi_empl) into aux from empleats;
	aux:=aux+1;

		if (sou>1000) then -- Si el sou és superior a 1000
			select count(*) into aux3 from projectes where codi_proj=v_proj;
			if (aux3>0) then -- Si existeix el projecte
				insert into empleats (codi_empl, nom_empl, cognom_empl, sou, codi_proj)
				values(aux, v_nom, v_cognom, v_sou, v_proj	);
				dbms_output.put_line('Empleat donat d''alta correctament');
			else 
				dbms_output.put_line('Error. No existeix el projecte indicat');
			end if;
		ELSE
			dbms_output.put_line('Error. El sou ha de ser superior a 1000');
		end if;
END;
/


-- 19. Amplia el procediment anterior de forma que no rebi com a paràmetre el número
-- de pokedex, sinó que el propi procediment obtingui l’últim codi assignat i li
-- assigni al nou pokemon l’últim +1. Si el procediment ha finalitzat correctament,
-- hauria de mostrar el codi assignat (ex: S’ha donat d’alta el pokemon i se li ha
-- assignat el codi: XXXX)


CREATE OR REPLACE PROCEDURE alta_pokemon(
    v_nombre pokemon.nombre%type,
    v_peso pokemon.peso%type,
    v_altura pokemon.altura%type
)
IS
    numero integer;
BEGIN
    select max(numero_pokedex) into numero from pokemon;
    numero:= numero+1;
    if v_nom is not null,
       v_peso
        insert into pokemon (numero_pokedex, nombre, peso, altura)
        values(aux, v_nombre, v_peso, v_altura);
        dbms

END;
/

Create or replace procedure problema19 
		(
			p_nom pokemon.nombre%type,
			p_peso pokemon.peso%type,
			p_altura pokemon.altura%type
		)
IS
	numero integer;
BEGIN
	if 	p_nom is not null 
		and p_peso is not null  
		and p_altura is not null 
	then 
		select max(numero_pokedex) into numero from pokemon;
		if numero is null then
			numero:=0;
		end if;
		numero:=numero+1;
		insert into pokemon
		values (numero, p_nom, p_peso, p_altura);
		dbms_output.put_line('Pokemon introduit amb codi: '|| numero);
	ELSE
		dbms_output.put_line('Error: Els valors no poden ser nulls');
	end if;
END;
/


-- Ejercicio EXTRA: Crea un procedimiento que busque un pokemon aun que no recordemos el nombre
-- entero, el codigo tiene que mostrar el nombre entero.

create or replace procedure buscar_pok (x varchar2) IS
	v_nom pokemon.nombre%type;
BEGIN
	--select nombre 
	--into v_nom
	--from pokemon where instr(upper(nombre),upper(x))>0;
	
	select nombre 
	into v_nom
	from pokemon where upper(nombre) LIKE '%'|| upper(x) || '%';
	
	dbms_output.put_line(v_nom);
EXCEPTION
	when no_data_found then
		dbms_output.put_line('No s''ha trobat cap pokemon amb aquest nom');
	when too_many_rows then
		dbms_output.put_line('No és prou concret');
end;
/

-- Ejercicico extra: Crea tu primera EXCEPTION custom:

reate or replace procedure borrar(
						codi empleats.codi_empl%type
					) IS
	aux integer;
	excp1 exception;
BEGIN
	aux:=existe(codi);
	if aux=0 then
		raise excp1; -- AQUI AÑADIMOS LA EXCEPTION USANDO RAISE.
	end if;
	mostra(codi);
	delete from empleats where codi_empl=codi;
	dbms_output.put_line('S''ha eliminat l''empleat');
exception
	when excp1 then
		dbms_output.put_line('Error: No existeix cap empleat amb aquest codi');
end;
/

------------------------------------------------------------------------------
                ANTES DE COMENZAR, TENER EN CUENTA ESTO!
1.- Crea el esqueleto del procedimiento/funcion
2.- Fes la consulta a SQL(No pl/SQL) hasta que funcione
3.- Lleva la consulta a pl/SQL i añade DBMS_OUTPUT para mostrar resultados
4.- Añade defensas/excepciones
------------------------------------------------------------------------------

-- 21. Crea un procediment que permeti modificar l’atac d’un pokemon. Aquest
-- procediment rebrà com a paràmetres d’entrada el número de pokedex i el nou
-- atac. Cal tenir present que el nou atac no podrà ser mai inferior al que ja tenia ni
-- tampoc podrà incrementar-se en més d’un 15%.

-- CON EXEPCIONES 

-- 21. Crea un procediment que permeti modificar l’atac d’un pokemon. Aquest
-- procediment rebrà com a paràmetres d’entrada el número de pokedex i el nou
-- atac. Cal tenir present que el nou atac no podrà ser mai inferior al que ja tenia ni
-- tampoc podrà incrementar-se en més d’un 15%.

CREATE OR REPLACE PROCEDURE mod_ataque(num_ataque number, )






--BUSCAR PARA QUE SIRVE.
select constraint_name, search_condition from user_constraint where table_name='POKEMON';

select table_name form user_tables;

select object_name from user_objects where object_type='PROCEDURE';
select object_name from user_objects where object_type='FUNCTION';











































