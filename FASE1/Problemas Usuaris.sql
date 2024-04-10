-- EXTRA:

--Para saber con que usuario estoy conectado escribir:

SELECT USER FROM dual;

--Para saber las tablas que tengo creadas:
select table_name
from all_tables
where owner='MARINERO';


-- 1. Crea un usuari “capitan” amb password “pescanova”, assignat a l’espai
-- de taules users amb una quota de 500Kb

-- USUARIO SYSTEM:
CREATE USER capitan --obligatorio
identified BY pescanova --obligatorio
DEFAULT tablespace users --obligatorio
quota 500K ON users; --oligatorio

-- 2. Intenta accedir a la base de dades amb l’usuari “capitan”. Explica que
-- succeeix i què hauries de fer per tal que es pugui connectar
-- correctament.


-- USUARIO CAPITAN:
ERROR:
ORA-01045: user CAPITAN lacks CREATE SESSION privilege; logon denied

-- Aparece este error por que le faltan permisos al usuario para acceder a oracle.

-- USUARIO SYSTEM:
GRANT CREATE SESSION TO capitan;

-- 3. Intenta crear una taula amb l’usuari “capitan”. Explica què succeeix i què
-- hauries de fer per tal que la pugui crear correctament.

-- USUARIO CAPITAN:
CREATE TABLE BANCO(
    codi number(8) primary key,
    propietario varchar(20),
    saldo number(10)
);

ERROR at line 1:
ORA-01031: insufficient privileges

--USUARIO SYSTEM:
GRANT CREATE TABLE TO capitan;

-- USUARIO CAPITAN:
CREATE TABLE BANCO(
    ID number(8) primary key,
    propietario varchar(10),
    saldo number(11)
);

--Si todo va bien saldrá el siguiente mensaje:
Table created.


-- 4. Crea un usuari “marinero” amb password 123 però expirat, assignat a
-- l’espai de taules users amb una quota de 2Mb i dona-li permisos de crear
-- sessió.

-- USUARIO SYSTEM;

CREATE USER marinero
identified by 123
password expire
DEFAULT tablespace users
quota 2M on users;

GRANT CREATE SESSION TO marinero;

-- Cuando intentes iniciar session con el usuario marinero te saldrá lo siguiente:

Enter user-name: marinero
Enter password: 123
ERROR:
ORA-28001: the password has expired


Changing password for marinero
New password: 1234
Retype new password: 1234
Password changed

Connected to:
Oracle Database 11g Express Edition Release 11.2.0.2.0 - 64bit Production

SQL>


-- 5. Intenta connectar amb l’usuari “marinero”, ¿Què succeeix?

    Entra Sin problema.


-- 6. Des de l’usuari marinero crea una taula anomenada “pesca”:
-- PESCA(codi, data, quantitat)

--USUARIO marinero
    CREATE TABLE PESCA(
        codi number(20),
        data date,
        quantitat number(10)
    );

ERROR at line 1:
ORA-01031: insufficient privileges

--USUARIO SYSTEM:
GRANT CREATE TABLE TO marinero;



-- amb totes les columnes NOT NULL. ¿Què succeeix?¿Com ho podem
-- solucionar?
CREATE TABLE PESCA(
        codi number(20) NOT NULL,
        data date NOT NULL,
        quantitat number(10) NOT NULL
);
    --Pasa exactamente lo mismo, para solucionarlo tendríamos que darle permisos al usuario "marinero",7
    --desde el SYSTEM.

-- 7. Quan l’usuari “marinero” tingui permisos, crea la taula pesca i fes un
-- parell de inserts

-- USUARIO MARINERO
CREATE TABLE PESCA (
    CODI NUMBER(10) PRIMARY KEY,
    DATA DATE,
    QUANTITAT NUMBER(10)
);

Table created.

-- USUARIO MARINERO
INSERT INTO PESCA (CODI, DATA, QUANTITAT) VALUES (1, TO_DATE('2024-03-20', 'YYYY-MM-DD'), 10);
INSERT INTO PESCA (CODI, DATA, QUANTITAT) VALUES (2, TO_DATE('2024-03-21', 'YYYY-MM-DD'), 15);


-- 8. Des de l’usuari “marinero” dona permisos a l’usuari “capitan” per poder
-- consultar i insertar informació a la taula pesca

--PERMISOS:
GRANT SELECT, INSERT ON PESCA TO capitan;

--SELECT PARA COMPROBAR DE QUE PODEMOS HACER SELECT A LA TABLA PESCA:
-- USUARIO CAPITAN
SELECT * FROM marinero.PESCA;

-- 9. Amb l’usuari “capitan” mostra la informació de la taula pesca de l’usuari
-- “marinero” i fes algun insert més.

--USUARIO CAPITAN:
SELECT * FROM marinero.PESCA;

-- INSERT:
INSERT INTO marinero.PESCA (CODI, DATA, QUANTITAT) VALUES (3, TO_DATE('2024-03-22', 'YYYY-MM-DD'), 20);


                                        -- Segona part: Enunciats sobre MySQL


-- 10. Crea un usuari anomenat ash amb contrasenya pikachu que es pugui connectar des de qualsevol equip


--USUARIO SYSTEM
CREATE USER ash
identified BY pikachu
DEFAULT tablespace users
quota 15M ON users;

GRANT CONNECT TO ash;
o
GRANT CREATE SESSION TO ash;


-- 11. Aquest usuari pot crear alguna base de dades nova?

Por defecto no, le tendríamos que dar permisos como tal.

-- 12. Investiga com podem donar-li el permís per tal que pugui crear una bases de dades nova.

GRANT CREATE Database to ash;

Con esto lo que hacemos es darle el rol de DBA.

-- 13. Crea un usuari jessie amb contrasenya james
CREATE USER jessie
identified by james
DEFAULT TABLESPACE users
quota 10M on users;

-- 14. Amb l’usuari ash crea una base de dades anomeda pokemon.

1- Dar permisos al usuario ash desde SYSTEM.
--USUARIO SYSTEM:
GRANT CREATE SESSION TO ash;
GRANT CREATE TABLE TO ash;

--USUARIO ASH;

-PASO 1

 CREATE TABLE pokemon (
 id NUMBER PRIMARY KEY,
 nombre VARCHAR2(50),
 peso NUMBER(5));

-Paso 2

INSERT INTO pokemon (id, nombre, peso) VALUES (1, 'Pikachu', 6.0);

SELECT * FROM pokemon;


-- 15. Dona tots els permisos a l’usuari ash per treballar amb la bbdd pokemon

-- USER SYSTEM:
GRANT ALL PRIVILEGES TO ash;

-- 16. Amb l’usuari ash carrega l’arxiu carrega l’arxiu que trobaràs a:
-- https://drive.google.com/file/d/1ckmhdd0tQRmvbHimdM9qzE1wXPDY0
-- Sei/view?usp=sharing
-- La base de dades correspon al següent model:


-- 17. Amb l’usuari ash dona permisos a l’usuari jessie per consultar la taula
-- pokemon i també per a modificar qualsevol dada d’aquesta taula. A més,
-- ha de poder otorgar els mateixos permisos a altres usuaris.



-- 18. Amb l’usuari root, crea un usuari anomenat misty. Ha de poder realitzar
-- com a màxim 5 consultes per hora, el seu password caducarà als 30
-- dies.

CREATE USER misty IDENTIFIED BY 1234
  DEFAULT TABLESPACE users
  LIMIT SESSIONS_PER_USER 5
  PASSWORD EXPIRE IN 30
  QUOTA UNLIMITED ON users;
-- 19. Connectat amb l’usuari jessie i fes una consulta a la taula pokemon.

--USUARIO SYSTEM
GRANT SELECT ON ash.POKEMON TO jessie;

--USUARIO jessie
select * from ash.pokemon;


-- 20. L’usuari jessie pot donar els permisos que té a l’usuari misty? Dona el
-- privilegi de consulta sobre la taula pokemon a l’usuari misty


-- 21. Connecta amb l’usuari misty i fes una consulta sobre la taula pokemon


-- 22. L’usuari Ash ha donat permisos a l’usuari jessie i aquest li ha donat a
-- l’usuari misty. Treu els permisos a l’usuari jessie.


-- 23. L’usuari jessie pot seguir consultant la taula pokemon?



-- 24. I l’usuari misty segueix tenint permisos?


