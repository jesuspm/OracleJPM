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
create or replace procedure mostra (p_codi integer)  IS
	v_nom_empl varchar2(20);
	v_cognom_empl varchar2(50);
	v_sou float;
	aux integer;
BEGIN
	-- Validació que el codi existeix
	select count(*) 
	into aux
	from empleats
	where codi_empl = p_codi;

	if aux=1 then
		select nom_empl, cognom_empl, sou 
		into v_nom_empl, v_cognom_empl, v_sou
		from empleats 
		where codi_empl=p_codi;
		dbms_output.put_line('-----------------------------------');
		dbms_output.put_line('--- DADES DE L''EMPLEAT    -------');
		dbms_output.put_line('-----------------------------------');
		dbms_output.put_line('Nom: ' || v_nom_empl);
		dbms_output.put_line('Cognom: ' || v_cognom_empl);
		dbms_output.put_line('Sou: ' || v_sou);
	ELSE
		dbms_output.put_line('Error: No existeix cap empleat amb codi: ' || p_codi);
	end if;
end;
/


-- EJERCICIO: Crea una funcion llamada existe que reciba un codigo de empleado y retorne si el empleado existe o no
--( Ejemplo: 0 si no existe y 1 si existe.)

CREATE OR REPLACE FUNCTION EXISTE(p_codigo_empl integer)
return integer
IS




EXTRA:

select table_name from user tables;