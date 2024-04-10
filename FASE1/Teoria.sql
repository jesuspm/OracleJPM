//Crear usuario.
create user 'jesus'@'%'
identified by '1234'

//Cambiar contraseña
alter user 'jesus'@'%'
identified by '123456';

//Borrar usuario
drop user 'jesus'@'%';

//Añadir privilegios al usuario jesus para hacer selects en la tabla profe de la BDD harry al usuario jesus.
grant SELECT on jesus.banc to 'jesus'@'%';

//Para ver los privilegios que tiene la cuenta
SHOW GRANTS FOR jesus;

//Para borrar permisos(desde el super usuario);
REVOKE SELECT ON jesus.banc from 'jesus'@'%';


/*ORACLE*/
/* No hi ha bases de dades
cada usuari té el seu espai de treball */
 
/* No podem fer show tables.
Disposem de APEX (entorn gràfic) incorporat
o podem fer la comanda:
*/
select table_name
from user_tables;
 
/* Tipus de dades:
	- char és igual
	- varchar és varchar2
	- No tenim smallint, mediumint... 
	- Tenim int (integer) i FLOAT
	- Tenim number(escala, precissió)
	- Les constraints són iguals
*/
create table coche(
	matricula char(8),
	marca varchar2(20),
	modelo varchar2(20),
	velocitat int,
	constraint pk_coche primary key(matricula)
	);
insert into coche values ('B1111A', 'Seat', 'Ibiza', 150);
 
/* És orientat a transaccions. No es guarda res fins que fem:
- Commit
- una instrucció DDL
*/
 
/*CREAR USUARIO*/
drop user pere;

create user pere --obligatorio
identified by pere --obligatorio
default tablespace users --obligatorio
quota 15M on users --oligatorio
password expire; --opcional


/*
Para desbloquear un usuario bloqueado
*/
alter user pere
identified by perepere;

--Para poder iniciar session necesita estos privilegios
grant create session
to pere;
-- Para darle permisos de crear tablas:
grant create table
to pere;

--Para darle permisos a otro usuario para que modifique 


