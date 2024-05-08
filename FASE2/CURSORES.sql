
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