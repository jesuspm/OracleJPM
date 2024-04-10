/*UPDATE/SAVEPOINT/DELETE/ROLLBACK*/
INSERT INTO pesca VALUES(4, TO_DATE('11/11/24','YYYY-MM-DD'), 11);

/*RESULTADO*/
SQL> select * from pesca;

      CODI DATA      QUANTITAT
---------- -------- ----------
         1 20/03/24         20
         2 21/03/24         15
         3 22/03/24         20
         4 24/11/11         11

/*ACTUALIZAMOS LA CANTIDAD A 2O3 DEL CODIGO 3*/
UPDATE PESCA SET QUANTITAT=203 WHERE CODI=3;

1 row updated.

SQL> select * from pesca;

      CODI DATA      QUANTITAT
---------- -------- ----------
         1 20/03/24         20
         2 21/03/24         15
         3 22/03/24        203
         4 24/11/11         11

/*CREAMOS UN SAVEPOINT CON EL NOMBRE -> Uno */
SQL> SAVEPOINT uno;

Savepoint created.

SQL> select * from pesca;

      CODI DATA      QUANTITAT
---------- -------- ----------
         1 20/03/24         20
         2 21/03/24         15
         3 22/03/24        203
         4 24/11/11         11

/*BORRAMOS TABBLA PESCA*/
SQL> DELETE FROM pesca;

4 rows deleted.

/*HACEMOS UN SELECT DE LA TABLA PARA VERIFICAR QUE SE HA BORRADO TODO*/
SQL> select * from pesca;

no rows selected

/*HACEMOS EL ROLLBACK AL SAVE POINT QUE LE HEMOS LLAMADO -> Uno*/
SQL> rollback to savepoint uno;

Rollback complete.

/*AL HACER EL ROLLBACK VUELVE AL ESTADO QUE GUARDAMOS CON EL SAVEPOINT -> Uno*/
SQL> select * from pesca;

      CODI DATA      QUANTITAT
---------- -------- ----------
         1 20/03/24         20
         2 21/03/24         15
         3 22/03/24        203
         4 24/11/11         11

/*GUARDAMOS LOS CAMBIOS.*/
SQL> commit;

Commit complete.


