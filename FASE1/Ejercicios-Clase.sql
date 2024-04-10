PRIMERO -> set serveroutput on

/*1.- Mostrar por pantalla los numeros pares entre el 1 y el 20*/
DECLARE
    aux integer;
    i integer;
BEGIN
    for i in 1..20 LOOP
        aux:=mod(i,2);
        if (aux=0) then
            dbms_output.put_line(i);
        end if;
    end loop;
END;
/


/*2.- Mostrar un triangulo de 10 filas*/

PRIMERA MANERA:

BEGIN
	for i in 1..10 LOOP
		for j in 1..i loop
			dbms_output.put(j);
		end loop;
		dbms_output.put_line('');
	end loop;
end;
/

SEGUNDA MANERA:

DECLARE
	i integer;
	j integer;
	aux varchar2(20);
BEGIN
	for i in 1..10 LOOP
		for j in 1..i loop
			dbms_output.put(j);
		end loop;
		dbms_output.put_line('');
	end loop;
end;
/

/*CREAR TABLA DEL 3 CON PROCEDURE.*/
SQL> create or replace procedure tabladel3 as
  2     tabla integer:=3;
  3  BEGIN
  4     for i in 0..10 loop
  5             dbms_output.put_line(tabla || ' x ' || i || ' = ' || (tabla*i));
  6     end loop;
  7  end;
  8  /

SQL> execute tabladel3;
3 x 0 = 0
3 x 1 = 3
3 x 2 = 6
3 x 3 = 9
3 x 4 = 12
3 x 5 = 15
3 x 6 = 18
3 x 7 = 21
3 x 8 = 24
3 x 9 = 27
3 x 10 = 30

PL/SQL procedure successfully completed.

create or replace procedure tabladel3 (num integer) as 
BEGIN
	for i in 0..10 loop
		dbms_output.put_line(num || ' x ' || i || ' = ' || (num*i));
	end loop;
end;
/

/*PARA EJECUTARLO*/
execute tabladel3(20);

CREATE OR REPLACE PROCEDURE escribe (txt varchar2) as
BEGIN
    dbms_output.put_line(txt);
end;
/

create or replace procedure tabladel3 (num integer) as 
BEGIN
	for i in 0..10 loop
		escribe(num || ' x ' || i || ' = ' || (num*i));
	end loop;
end;
/
