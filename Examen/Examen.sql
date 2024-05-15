

Crea un procediment anomenat ConsEstudiants que rebrà com a paràmetre el nom d’una casa i
caldrà que mostri per pantalla les dades dels alumnes que pertanyen a la casa. El format de
sortida hauria de ser similar a :


****************************************
ALUMNES x CASA
****************************************
Codi casa: XX
Nom Casa: XXXXXXXXXXX

ALUMNES ASSIGNATS:
NOM       ANYO
XXXXXXXXX XX
XXXXXXXXX XX


CREATE OR REPLACE PROCEDURE ConsEstudiants (p_nombreCasa casa.nom%type)
IS
    v_codigoCasa CASA.ID%type;
    v_nombreCasa CASA.NOM%type;
BEGIN
    SELECT ID, NOM into v_codigoCasa, v_nombreCasa
    FROM CASA
    WHERE NOM=p_nombreCasa;

    --Primeros prints
    DBMS_OUTPUT.PUT_LINE('****************************************');
    DBMS_OUTPUT.PUT_LINE('ALUMNES x CASA');
    DBMS_OUTPUT.PUT_LINE('****************************************');
    DBMS_OUTPUT.PUT_LINE('Codigo casa: ' || v_codigoCasa);
    DBMS_OUTPUT.PUT_LINE('Nom Casa: ' || v_nombreCasa);
    
    --Segundos prints
    DBMS_OUTPUT.PUT_LINE('ALUMNES ASSIGNATS:');
    DBMS_OUTPUT.PUT_LINE('NOM' || CHR(9) || 'ANYO');

    for x in(
        select NOM, ANYO
        from ESTUDIANT
        where CASA_ID=v_codigoCasa
    )LOOP
        DBMS_OUTPUT.PUT_LINE(x.NOM || chr(9) || x.anyo);
    END LOOP;
END;
/
























CREATE OR REPLACE PROCEDURE ConsEstudiants(p_nombreCasa CASA.NOM%type) 
IS
v_codigoCasa CASA.ID%type;
v_nombreCasa CASA.NOM%type;
BEGIN
    SELECT ID, NOM INTO v_codigoCasa, v_nombreCasa
    FROM CASA
    WHERE NOM=p_nombreCasa;

    -- Primera parte de los prints
    DBMS_OUTPUT.PUT_LINE('************************');
    DBMS_OUTPUT.PUT_LINE('ALUMNES X CASA');
    DBMS_OUTPUT.PUT_LINE('************************');
    DBMS_OUTPUT.PUT_LINE('CODIGO CASA: ' || v_codigoCasa);
    DBMS_OUTPUT.PUT_LINE('NOMBRE CASA: ' || v_nombreCasa);

    -- Segunda parte de los prints
    DBMS_OUTPUT.PUT_LINE('ALUMNES ASSIGNATS:');
    DBMS_OUTPUT.PUT_LINE('NOM' || CHR(9) || 'ANYO');

    FOR x IN(
        SELECT NOM, ANYO
        FROM ESTUDIANT
        WHERE CASA_ID = v_codigoCasa
    )LOOP
        DBMS_OUTPUT.PUT_LINE(x.NOM || CHR(9) || x.ANYO);
    END LOOP;

END;
/




































    



































