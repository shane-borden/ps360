REM psserverdefn.sql
DEF recname = 'SERVERDEFN'
@@psrecdefn

BEGIN
  :sql_text := '
SELECT row_number() over (order by servername) row_num
     , t.*
FROM   &&table_name t
ORDER BY row_num
'; 
END;				
/

@@psgenerichtml.sql
