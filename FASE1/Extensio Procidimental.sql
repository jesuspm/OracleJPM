
2.4. Condicionals


--IF

DECLARE
    x int;
BEGIN
    x:=10;
    IF (x>5) THEN
    dbms_output.PUT_LINE('El valor de x és mayor que 5:');
    END IF;
    IF (x<5) THEN
    dbms_output.PUT_LINE('El valor de x es menor que 5:');
    END IF;
END;
/

--ELSE IF
DECLARE
    x int;
BEGIN
    x:=7;
    IF (x<5) THEN
        dbms_output.PUT_LINE('El valor ' || x ||' es un valor pequeño');
    ELSIF (x>=5 and x<10) THEN
        dbms_output.PUT_LINE('El valor ' || x ||' es un valor mediano');
    ELSIF (x>10) THEN
        dbms_output.PUT_LINE('El valor ' || x ||' es un valor grande');
    END IF;
END;
/