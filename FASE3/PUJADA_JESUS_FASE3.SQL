/* *****************************************************
//  Institut TIC de Barcelona
//	CFGS Desenvolupament d'aplicacions Web
//	M20: Bases de dades. UF3: PL/SQL
//	PRÀCTICA UF3. FASE 3
//	AUTOR: Jesús Pujada Montoya
//	DATA: 09/05/2024
****************************************************** */


Requeriment 1:
-- Nom: BuscaJugador
-- Entrada: cadena de caràcters
-- Sortida: -
-- Descripció: Cal mostrar les dades de tots els jugadors que el seu nom es correspongui
-- amb la cadena introduïda. Per exemple, si la cadena introduïda és ‘sol’, entre d’altres,
-- hauria de mostrar les dades del jugador ‘Pau Gasol’ ja que al seu nom, trobem la cadena
-- ‘sol’.
    En concret, les dades a mostrar són:
    Codi Nom Equip Ciutat
    *******************************************************
    XX XXXX XXXX XXXXXXXXX
    XX XXXX XXXX XXXXXXXXX
    XX XXXX XXXX XXXXXXXXX
    XX XXXX XXXX XXXXXXXXX
    Total jugadors mostrats: XX

CREATE OR REPLACE PROCEDURE filtrar_jugador(p_entrada jugador.nombre%type) is
    contador NUMBER :=0;
    cursor c_jugador is
        SELECT CODIGO, NOMBRE, NOMBRE_EQUIPO, PROCEDENCIA 
        FROM Jugador
        WHERE nombre LIKE '%'||p_entrada||'%';
BEGIN
    DBMS_OUTPUT.PUT_LINE('Codi' || chr(9) || 'Nom' || chr(9) || 'Equip' || chr(9) || 'Ciutat' || chr(9));
    DBMS_OUTPUT.PUT_LINE('*******************************************************');
    for x in c_jugador loop
        contador:= contador+1;
        DBMS_OUTPUT.PUT_LINE(x.CODIGO || chr(9) || x.NOMBRE ||  X.NOMBRE_EQUIPO || chr(9) || x.PROCEDENCIA || chr(9));
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('Total jugadors mostrats: ' || contador);
END;
/

Ejecucion:

    SQL> execute filtrar_jugador('war');  
    Codi    Nom     Equip   Ciutat
    *******************************************************
    430     Dwight HowardMagic      SW Atlanta Crhistian
    444     Josh HowardMavericks    Wake Forest
    445     Juwan HowardMavericks   Michigan
    485     Yakhouba DiawarraNuggets        Pepperdine
    Total jugadors mostrats: 4


Requeriment 2:
-- Nom: JugadorsCiutat
-- Entrada: cadena de caràcters
-- Sortida: -
-- Descripció: Cal mostrar les dades de tots els jugadors que juguin en algun equip que
-- estigui a la ciutat que ens indiquin per paràmetre, per exemple, si ens indiquen “Los
-- Angeles” caldrà mostrar tots els jugadors dels equips Clippers i Lakers. Caldrà mostrar
-- el resutat ordenat primer per l’equip i desprès pel nom de jugador alfabèticament. El
-- format de sortida demanat hauria de ser similar a:

Nom Equip
****************************
XXXX XXXX
XXXX XXXX
XXXX XXXX
XXXX XXXX

CREATE OR REPLACE PROCEDURE JugadorCiutat(p_entrada jugador.PROCEDENCIA%type) is
    cursor c_jugadorCiutat is
        select NOMBRE, NOMBRE_EQUIPO
        FROM JUGADOR
        WHERE PROCEDENCIA LIKE '%'||p_entrada||'%';
BEGIN
    DBMS_OUTPUT.PUT_LINE('Nom' || chr(9) || 'Equip' || chr(9));
    for x in c_jugadorCiutat loop
        DBMS_OUTPUT.PUT_LINE(x.NOMBRE || chr(9) || x.NOMBRE_EQUIPO);
    END LOOP;
END;
/

Ejecucion:

    SQL> execute JugadorCiutat('España');
    Nom     Equip
    jesus   Warriors
    LOLO    Warriors
    Marta   Warriors
    pepe    Warriors
    Mireya  Warriors
    Row     Warriors
    Rowins  Warriors
    Row     Warriors
    Row     Warriors



Requeriment 3:
-- Nom: trig_audit_jugador
-- Entrada: -
-- Sortida: -
-- Descripció: Crea un trigger que s’encarregui d’auditar totes les accions sobre la taula
-- jugador les operacions insert, delete i update. Per fer el trigger, caldrà crear una taula
-- auditoria_jug que contingui l’usuari que realitza la acció, la acció realitzada, el codi de
-- jugador afectat i la data i hora en la que s’ha realitzat l’acció.

Create table auditoria_jug (
    usuari varchar2(50),
    accio varchar2(20),
    codi_jug integer,
    data date
);

CREATE OR REPLACE TRIGGER trig_audit_jugador
    before insert or delete or update on Jugador for each row
BEGIN
    if inserting THEN
        insert into auditoria_jug
        values (user,'INSERT', :new.CODIGO, sysdate);
    elsif updating THEN
        insert into auditoria_jug
        values (user,'UPDATE', :new.CODIGO, sysdate);
    ELSE
        insert into auditoria_jug
        values (user,'DELETE', :old.CODIGO, sysdate);
    END IF;
END;
/





INSERT ->

insert into JUGADOR values(623,'jesus',null,null,null,null,null); │

UPDATE -> 

UPDATE jugador set peso=200 where codigo=621;

DELETE ->

delete from Jugador where CODIGO=622;


RESULTADO.

    USUARI                                             ACCIO
    -------------------------------------------------- --------------------
    CODI_JUG DATA
    ---------- --------
    SYSTEM                                             INSERT
        623 09/05/24

    SYSTEM                                             UPDATE
        621 09/05/24

    SYSTEM                                             DELETE
        622 09/05/24

