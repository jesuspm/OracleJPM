
CREATE or replace procedure llista_empl is
	cursor c_empl is 
			SELECT nom_empl, cognom_empl, sou 
			from empleats
			order by sou desc;
	
BEGIN
	for x in c_empl loop 
		dbms_output.put_line(x.nom_empl || chr(9) || x.sou);
	end loop;
end;
/



-- Muestra todos los pokemosn mayores a los que pasemos por parametro.

CREATE OR REPLACE PROCEDURE listaPokemonPeso(p_peso pokemon.peso%type) is
    cursor pesoPkm is
            select nombre, peso 
            from pokemon
            where peso>=p_peso
            order by peso desc;
BEGIN
    for x in pesoPkm loop
        DBMS_OUTPUT.PUT_LINE(x.nombre || chr(25) || x.peso);
    end loop;
END;
/

-- EJEMPLO 
SQL> execute listaPokemonPeso(400); 
Snorlax↓460


-- EJERCICIO CON JOIN
CREATE OR REPLACE PROCEDURE problema23 IS
    CURSOR c_problema23 IS 
        SELECT tipo.nombre, COUNT(*) AS total 
        FROM tipo join pokemon_tipo ON (pokemon_tipo.id_tipo = tipo.id_tipo) 
        GROUP BY nombre;
BEGIN
    FOR aux IN c_problema23 LOOP
        DBMS_OUTPUT.put_line(aux.nombre || CHR(9) || aux.total); 
    END LOOP;
END;
/