set serveroutput on;

desc empleats; -- Para saber que tipo de dato tiene cada campo.

------------ 1. EJEMPLO --------------

create or replace procedure mostra IS
	x1 varchar2(20);
	x2 varchar2(50);
	x3 float;
BEGIN

	select nom_empl, cognom_empl, sou 
	into x1, x2, x3
	from empleats 
	where codi_empl=1;
	dbms_output.put_line('-----------------------------------');
	dbms_output.put_line('--- DADES DE L''EMPLEAT    -------');
	dbms_output.put_line('-----------------------------------');
	dbms_output.put_line('Nom: ' || x1);
	dbms_output.put_line('Cognom: ' || x2);
	dbms_output.put_line('Sou: ' || x3);
end;
/

-- RESULTADO:

SQL> execute mostra;
-----------------------------------
--- DADES DE L'EMPLEAT    -------
-----------------------------------
Nom: Maria
Cognom: Puig
Sou: 2000

-- AMPLIACIÓN.
create or replace procedure mostra IS
	id number(38);
	nombre varchar2(20);
	apellido varchar2(50);
    sueldo float(126);
    ciutat_DPT varchar2(20);
BEGIN

	select codi_empl, nom_empl, cognom_empl, sou, ciutat_DPT 
	into id, nombre, apellido, sueldo , ciutat_DPT
	from empleats 
	where codi_empl=1;
	dbms_output.put_line('-----------------------------------');
	dbms_output.put_line('--- DADES DE L''EMPLEAT    -------');
	dbms_output.put_line('-----------------------------------');
	
    dbms_output.put_line('Codi: ' || id);
    dbms_output.put_line('Nom: ' || nombre);
	dbms_output.put_line('Cognom: ' || apellido);
	dbms_output.put_line('Sou: ' || sueldo);
    dbms_output.put_line('Ciutat:' || ciutat_DPT);

end;
/
