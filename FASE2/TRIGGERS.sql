
********************
----- TRIGGERS -----
********************

Trabajaremos sobre la tabla de empleats.

select nom_empl, sou from empleats;

-- Esta tabla es para almacenar totdas las acciones.
CREATE TABLE audi_empl (
    usuari varchar(30),
    accio varchar(20),
    empleat integer,
    data DATE
);

-- Primer trigger donde lo que hará será que despues de borrar se almacenará
-- el insert de en la tabla audi_empl.
CREATE OR REPLACE TRIGGER tr_audit_empl
    before delete on empleats
BEGIN
    insert into audi_empl
    values('jesus', 'delete', null, null);
end;
/

***************************************************************

        EJEMPLO: 
        SQL> select codi_empl, nom_empl from empleats;

        CODI_EMPL NOM_EMPL
        ---------- --------------------
                1 Maria
                2 Pere
                3 Anna
                4 Jordi
                5 Clara
                6 Laura
                7 Roger
                8 Sergi
                9 Jesus
                15 Marta
                19 Mari

        11 rows selected.

        SQL> delete from empleats where codi_empl=2;

        1 row deleted.

        SQL> select * from audi_empl;

        USUARI                         ACCIO                   EMPLEAT DATA
        ------------------------------ -------------------- ---------- --------
        jesus                          delete
        jesus                          delete

        SQL>

***************************************************************

-- Este TRIGGER marcaria el usuario(SYSTEM) que ha hecho la accion.
create or replace trigger tr_audit_empl
	before delete on empleats
begin
	insert into audi_empl 
	values (user, 'delete', null, sysdate);
end;
/

***************************************************************

        EJEMPLO:
        SQL> delete from empleats where codi_empl=3; 

        1 row deleted.

        SQL> select * from audi_empl;

        USUARI                         ACCIO                   EMPLEAT DATA
        ------------------------------ -------------------- ---------- --------
        jesus                          delete
        jesus                          delete
        SYSTEM                         delete                          08/05/24

        SQL>

***************************************************************


-- Con este TRIGGER lo que pretendemos es que al borrar todos los empleados
-- de la tabla empleats recorrra cada uno de las filas y haga
-- El insert del usuario, la accion(delete), el codigo de empleado que tenian
-- antes de borrarlo y la fecha/hora en la que se ha producido dicha accion.
create or replace trigger tr_audit_empl
	before delete on empleats for each row
begin
	insert into audi_empl 
	values (user, 'delete', :old.codi_empl, sysdate);
end;
/


EJEMPLO:

***************************************************************

    1- borramos las acciones que esten en la tabla audi_empl.
    2- borramos todos los datos de la tabla empleats;
    3- hacemos un select * from audi_empl para ver las acciones.
    4- hacemos rollback.


***************************************************************

create or replace trigger tr_audit_empl
	before delete or insert or update on empleats for each row
begin
	if inserting THEN
		insert into audi_empl 
		values (user, 'insert', :new.codi_empl, sysdate);
	elsif updating THEN
		insert into audi_empl 
		values (user, 'update', :new.codi_empl, sysdate);
	ELSE
		insert into audi_empl 
		values (user, 'delete', :old.codi_empl, sysdate);
	end if;
end; 
/


EJEMPLO: 
***************************************************************

    1- hacemos un insert en empleats.
        SQL> insert into Empleats(codi_empl,nom_empl,cognom_empl,sou,nom_dpt,ciutat_dpt,codi_proj)
             values('20','Mireya','Puig',2000,'DIR','Girona','1'); 
        
        1 row created.
        
        1.2 -  Si hacemos un select * from audi_empl;
        SQL> select * from audi_empl;  

        USUARI                         ACCIO                   EMPLEAT DATA
        ------------------------------ -------------------- ---------- --------
        SYSTEM                         insert                       20 08/05/24

    2- hacemos un update en empleats.
    SQL> update empleats set sou=2050 where codi_empl=20;

    1 row created.

    SQL> select * from audi_empl;

    USUARI                         ACCIO                   EMPLEAT DATA     
    ------------------------------ -------------------- ---------- -------- 
    SYSTEM                         insert                       20 08/05/24 
    SYSTEM                         update                       20 08/05/24 

    3- hacemos un delete en empleats.

    SQL> DELETE FROM empleats;

    SQL> select * from audi_empl;

    USUARI                         ACCIO                   EMPLEAT DATA
    ------------------------------ -------------------- ---------- --------
    SYSTEM                         insert                       20 08/05/24
    SYSTEM                         update                       20 08/05/24
    SYSTEM                         delete                        1 08/05/24
    SYSTEM                         delete                        3 08/05/24
    SYSTEM                         delete                        4 08/05/24
    SYSTEM                         delete                        5 08/05/24
    SYSTEM                         delete                        6 08/05/24
    SYSTEM                         delete                        7 08/05/24
    SYSTEM                         delete                        8 08/05/24
    SYSTEM                         delete                        9 08/05/24
    SYSTEM                         delete                       15 08/05/24

    USUARI                         ACCIO                   EMPLEAT DATA
    ------------------------------ -------------------- ---------- --------
    SYSTEM                         delete                       19 08/05/24
    SYSTEM                         delete                       20 08/05/24

    Explicación: con esto lo que conseguimos es dejar reflejado en la tabla
    audi_empl las 3 acciones de arriba.


***************************************************************


-- Trigger para controlar que el sueldo NUEVO introducido en el insert no sea menor que el anterior.

CREATE OR REPLACE TRIGGER tr_sueldo_empleat
	before update on empleats for each row
DECLARE
	mi_error exception;
begin
	if :new.sou < :old.sou THEN
		raise mi_error;
	end if;
end;
/


O també podem fer que el sou no es decrementi modificant el valor

create or replace trigger tr_sueldo_empleat
	before update on empleats for each row
begin
	if :new.sou < :old.sou THEN
        dbms_output.put_line('No es pot decrementar');
        :new.sou := :old.sou;
	end if;
end;
/


PASO 1 - 

SQL> select codi_empl, sou from empleats;

 CODI_EMPL        SOU
---------- ----------
         1       2000
         3       1850
         4       1800
         5       1500
         6       1420
         7       1200
         8       1435
         9       1750
        15       1500
        19       1900

10 rows selected.

SQL> update empleats set sou=2502 where codi_empl=1; 

1 row updated.

-- SI INTENTAMOS hacerlo con menos nos petará.

SQL> update empleats set sou=2501 where codi_empl=1; 
update empleats set sou=2501 where codi_empl=1
       *
ERROR at line 1:
ORA-06510: PL/SQL: unhandled user-defined exception
ORA-06512: at "SYSTEM.TR_SUELDO_EMPLEAT", line 6
ORA-04088: error during execution of trigger 'SYSTEM.TR_SUELDO_EMPLEAT'       




-------------------------------------------------------------------------------
Ejercicio EXTRA:

-- 27. Crea un trigger encarregat de controlar que no es pot decrementar
-- l’atac d’un pokemon. En cas que s’intenti fer la operació, el trigger
-- haurà de cancel·lar-la 
    
    Query para ver los campos -> desc estadisticas_base;
    Query para ver los ataques -> select * from estadisticas_base;

-- Lo que hace este trigger es que si el ataque que es modificado es menor que el 
-- original saltará un error.

MIRAR SI SE PUEDE AÑADIR UN MENSAJE CUANDO PETA.


CREATE OR REPLACE TRIGGER tr_attack_pokemon
    before update on estadisticas_base for each row
DECLARE
   
BEGIN
    if :new.ataque < :old.ataque THEN
     RAISE_APPLICATION_ERROR(-20001, 'El nuevo valor de ataque no puede ser menor que el valor anterior.');
    end if;
--EXCEPTION
--WHEN my_error THEN
    -- Lo que conseguimos con RAISE_APPLICATION_ERROR es sacar un mensaje para nuestra APP en este
    -- caso nuestro trigger, que lo que hará es basicamente poder lanzar un mensaje custom para el error,
    -- Y el -20001 es el numero de errores que podriamos poner, el rango va del -20000 hasta el -20999
    -- para asignaro todo tipo de errores custom.

END;
/

Query para hacer update de ataque:
-> update estadisticas_base set ataque=150 where numero_pokedex=151;