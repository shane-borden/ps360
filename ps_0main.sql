REM ps_0main.sql
SET TERM OFF MARK HTML OFF HEA OFF LIN 32767 NEWP NONE PAGES 0 FEED OFF ECHO OFF VER OFF LONG 32000 LONGC 2000 WRA ON TRIMS ON TRIM ON TI OFF TIMI OFF ARRAY 100 NUM 20 SQLBL ON BLO . RECSEP OFF;
DEF ps_echo_off = "off"
DEF ps_term_off = "off"

SET TERM &&ps_term_off ECHO &&ps_echo_off

DEF pstemp="pstemp.sql"
DEF ps_prefix = "ps360"
DEF ps_report_prefix = "PeopleSoft:"
DEF section = "main";
DEF htmlsuffix = "html";
DEF max_col_number=3
DEF charttype="LineChart";

VAR old_module VARCHAR2(64)
VAR old_action VARCHAR2(64)
VAR sql_text_stub VARCHAR2(4000)
VAR sql_text VARCHAR2(4000)
VAR sql_text_display VARCHAR2(4000)

BEGIN
 dbms_application_info.read_module(:old_module,:old_action);
 dbms_application_info.set_module('&&ps_prefix','&&section');
END;
/
COLUMN dbname NEW_VALUE psdbname
COLUMN ownerid NEW_VALUE sysadm
SELECT dbname 
,      ownerid
FROM	  ps.psdbowner 
WHERE  rownum = 1
/
DEF ps360_main_report="&&ps_prefix._&&psdbname._0_index";

COLUMN row_num NEW_VALUE row_num HEADING '#'
COLUMN rownum NEW_VALUE row_num HEADING '#'
COLUMN file_time NEW_VALUE file_time
SELECT TO_CHAR(SYSDATE,'YYYYMMDD_HH24MISS') file_time
FROM   dual
/

ALTER SESSION SET CURRENT_SCHEMA=&&sysadm;

DEF zipfile="&&ps_prefix._&&psdbname._&&file_time..zip"

SET TERM &&ps_term_off HEA OFF LIN 32767 NEWP NONE PAGES 0 FEED OFF ECHO &&ps_echo_off VER OFF LONG 32000 LONGC 2000 WRA ON TRIMS ON TRIM ON TI OFF TIMI OFF ARRAY 100 NUM 20 SQLBL ON BLO . RECSEP OFF;

REM debugging set term on feed on echo on

SPOOL &&ps360_main_report..html

PRO <head>
PRO <meta http-equiv="Content-Type" content="text/html;charset=utf-8" />
PRO <title>&&ps_report_prefix Main Menu</title>

@@ps_0pre.sql
@@ps_0config.sql

SPOOL &&ps360_main_report..html APP

@@pshtmlstyle.sql

PRO </head>
PRO <body>
PRO <h1>PS360: PeopleSoft Configuration and Metrics</h1>

PRO <pre>
PRO version:0006 dbname:&&database_name_short. version:&&db_version. host:&&host_name_short. PT version:&&toolsrel. today:&&ps360_time_stamp.
PRO </pre>

PRO <table><tr class="main">
PRO <td class="c">1/&&max_col_number.:configuration</td>
PRO <td class="c">2/&&max_col_number.:metrics</td>
PRO <td class="c">3/&&max_col_number.:checks</td>
PRO </tr><tr class="main"><td>
DEF repcol = "1"

PRO <h2>General</h2>
SPOOL OFF
@@psstatus
@@psinstallation

SPOOL &&ps360_main_report..html APP
PRO <h2>Process Scheduler</h2>
SPOOL OFF
@@psprcssystem
@@psserverdefn
@@psserverstat
@@psserverclass
@@psprcstypedefn
@@psprcsdefn
@@psprcsdefn_trace
@@pscdm_dist_node

SPOOL &&ps360_main_report..html APP
PRO <h2>Trees</h2>
SPOOL OFF
@@pstreedefn
@@pstreestrct
@@pstreeselctl
@@pstreeselctlorphan
@@pstreeselectnndynamic

SPOOL &&ps360_main_report..html APP
PRO </td><td>
DEF repcol = "2"
PRO <h2>Process Scheduler Timings</h2>
REM 1 day
DEF date_filter_sql="AND enddttm>=SYSDATE-1"
DEF date_filter_desc="(1 day)"
DEF date_filter_suffix="_1d"
@@pstopprcs
DEF date_filter_sql="AND enddttm>=SYSDATE-7 AND TO_CHAR(enddttm,''D'') >= ''&&ps360_conf_work_day_from'' AND TO_CHAR(begindttm,''D'') <= ''&&ps360_conf_work_day_to'' AND TO_CHAR(enddttm, ''HH24'') >= ''&&ps360_conf_work_time_from'' AND TO_CHAR(begindttm, ''HH24'') <= ''&&ps360_conf_work_time_to''"
DEF date_filter_desc="(5 working days)"
DEF date_filter_suffix="_5d"
@@pstopprcs
DEF date_filter_sql="AND enddttm>=SYSDATE-7"
DEF date_filter_desc="(1 week)"
DEF date_filter_suffix="_1w"
@@pstopprcs
DEF date_filter_sql="AND enddttm>=SYSDATE-28 AND TO_CHAR(enddttm,''D'') >= ''&&ps360_conf_work_day_from'' AND TO_CHAR(begindttm,''D'') <= ''&&ps360_conf_work_day_to'' AND TO_CHAR(enddttm, ''HH24'') >= ''&&ps360_conf_work_time_from'' AND TO_CHAR(begindttm, ''HH24'') <= ''&&ps360_conf_work_time_to''"
DEF date_filter_desc="(4 working weeks)"
DEF date_filter_suffix="_4w"
@@pstopprcs
DEF date_filter_sql="AND enddttm>=ADD_MONTHS(SYSDATE,-1)"
DEF date_filter_desc="(1 month)"
DEF date_filter_suffix="_1m"
@@pstopprcs
DEF date_filter_sql=""
DEF date_filter_desc="(All)"
DEF date_filter_suffix=""
@@pstopprcs

SPOOL &&ps360_main_report..html APP
PRO <h2>Process Scheduler Queueing</h2>
REM 1 day
DEF date_filter_sql="AND enddttm>=SYSDATE-1"
DEF date_filter_desc="(1 day)"
DEF date_filter_suffix="_1d"
@@psprcsqueue
DEF date_filter_sql="AND enddttm>=SYSDATE-7"
DEF date_filter_desc="(1 week)"
DEF date_filter_suffix="_1w"
@@psprcsqueue
DEF date_filter_sql="AND enddttm>=ADD_MONTHS(SYSDATE,-1)"
DEF date_filter_desc="(1 month)"
DEF date_filter_suffix="_1m"
@@psprcsqueue
DEF date_filter_sql=""
DEF date_filter_desc="(All)"
DEF date_filter_suffix=""
@@psprcsqueue

SPOOL &&ps360_main_report..html APP
PRO <h2>Application Engine Batch Timings</h2>
REM 1 day
DEF date_filter_sql="WHERE enddttm>=SYSDATE-1"
DEF date_filter_desc="(1 day)"
DEF date_filter_suffix="_1d"
@@pstopae
DEF date_filter_sql="WHERE enddttm>=SYSDATE-7 AND TO_CHAR(enddttm,''D'') >= ''&&ps360_conf_work_day_from'' AND TO_CHAR(begindttm,''D'') <= ''&&ps360_conf_work_day_to'' AND TO_CHAR(enddttm, ''HH24'') >= ''&&ps360_conf_work_time_from'' AND TO_CHAR(begindttm, ''HH24'') <= ''&&ps360_conf_work_time_to''"
DEF date_filter_desc="(5 working days)"
DEF date_filter_suffix="_5d"
@@pstopae
DEF date_filter_sql="WHERE enddttm>=SYSDATE-7"
DEF date_filter_desc="(1 week)"
DEF date_filter_suffix="_1w"
@@pstopae
DEF date_filter_sql="WHERE enddttm>=SYSDATE-28 AND TO_CHAR(enddttm,''D'') >= ''&&ps360_conf_work_day_from'' AND TO_CHAR(begindttm,''D'') <= ''&&ps360_conf_work_day_to'' AND TO_CHAR(enddttm, ''HH24'') >= ''&&ps360_conf_work_time_from'' AND TO_CHAR(begindttm, ''HH24'') <= ''&&ps360_conf_work_time_to''"
DEF date_filter_desc="(4 working weeks)"
DEF date_filter_suffix="_4w"
@@pstopae
DEF date_filter_sql="WHERE enddttm>=ADD_MONTHS(SYSDATE,-1)"
DEF date_filter_desc="(1 month)"
DEF date_filter_suffix="_1m"
@@pstopae
DEF date_filter_sql=""
DEF date_filter_desc="(All)"
DEF date_filter_suffix=""
@@pstopae

SPOOL &&ps360_main_report..html APP
PRO <h2>Application Engine Batch Detail Timings</h2>
REM 1 day
DEF date_filter_sql="AND enddttm>=SYSDATE-1"
DEF date_filter_desc="(1 day)"
DEF date_filter_suffix="_1d"
@@pstopaestep
DEF date_filter_sql="AND enddttm>=SYSDATE-7 AND TO_CHAR(enddttm,''D'') >= ''&&ps360_conf_work_day_from'' AND TO_CHAR(begindttm,''D'') <= ''&&ps360_conf_work_day_to'' AND TO_CHAR(enddttm, ''HH24'') >= ''&&ps360_conf_work_time_from'' AND TO_CHAR(begindttm, ''HH24'') <= ''&&ps360_conf_work_time_to''"
DEF date_filter_desc="(5 working days)"
DEF date_filter_suffix="_5d"
@@pstopaestep
DEF date_filter_sql="AND enddttm>=SYSDATE-7"
DEF date_filter_desc="(1 week)"
DEF date_filter_suffix="_1w"
@@pstopaestep
DEF date_filter_sql="AND enddttm>=SYSDATE-28 AND TO_CHAR(enddttm,''D'') >= ''&&ps360_conf_work_day_from'' AND TO_CHAR(begindttm,''D'') <= ''&&ps360_conf_work_day_to'' AND TO_CHAR(enddttm, ''HH24'') >= ''&&ps360_conf_work_time_from'' AND TO_CHAR(begindttm, ''HH24'') <= ''&&ps360_conf_work_time_to''"
DEF date_filter_desc="(4 working weeks)"
DEF date_filter_suffix="_4w"
@@pstopaestep
DEF date_filter_sql="AND enddttm>=ADD_MONTHS(SYSDATE,-1)"
DEF date_filter_desc="(1 month)"
DEF date_filter_suffix="_1m"
@@pstopaestep
DEF date_filter_sql=""
DEF date_filter_desc="(All)"
DEF date_filter_suffix=""
@@pstopaestep

SPOOL &&ps360_main_report..html APP
PRO <h2>Schedueled PS/Query</h2>
REM 1 day
DEF date_filter_sql="AND enddttm>=SYSDATE-1"
DEF date_filter_desc="(1 day)"
DEF date_filter_suffix="_1d"
@@pstopaepsquery
DEF date_filter_sql="AND enddttm>=SYSDATE-7 AND TO_CHAR(enddttm,''D'') >= ''&&ps360_conf_work_day_from'' AND TO_CHAR(begindttm,''D'') <= ''&&ps360_conf_work_day_to'' AND TO_CHAR(enddttm, ''HH24'') >= ''&&ps360_conf_work_time_from'' AND TO_CHAR(begindttm, ''HH24'') <= ''&&ps360_conf_work_time_to''"
DEF date_filter_desc="(5 working days)"
DEF date_filter_suffix="_5d"
@@pstopaepsquery
DEF date_filter_sql="AND enddttm>=SYSDATE-7"
DEF date_filter_desc="(1 week)"
DEF date_filter_suffix="_1w"
@@pstopaepsquery
DEF date_filter_sql="AND enddttm>=SYSDATE-28 AND TO_CHAR(enddttm,''D'') >= ''&&ps360_conf_work_day_from'' AND TO_CHAR(begindttm,''D'') <= ''&&ps360_conf_work_day_to'' AND TO_CHAR(enddttm, ''HH24'') >= ''&&ps360_conf_work_time_from'' AND TO_CHAR(begindttm, ''HH24'') <= ''&&ps360_conf_work_time_to''"
DEF date_filter_desc="(4 working weeks)"
DEF date_filter_suffix="_4w"
@@pstopaepsquery
DEF date_filter_sql="AND enddttm>=ADD_MONTHS(SYSDATE,-1)"
DEF date_filter_desc="(1 month)"
DEF date_filter_suffix="_1m"
@@pstopaepsquery
DEF date_filter_sql=""
DEF date_filter_desc="(All)"
DEF date_filter_suffix=""
@@pstopaepsquery

SPOOL &&ps360_main_report..html APP
PRO </td><td>
DEF repcol = "3"
PRO <h2>Application Engine</h2>
@@pstemptblinstances
@@psaetemptblmgr

SPOOL &&ps360_main_report..html APP
PRO <h2>Query</h2>
@@psqrynonkeyeff


SPOOL &&ps360_main_report..html APP
PRO <h2>Database Management</h2>
@@psdescindex
@@pstemptabstats

PRO </td>
PRO </body>
PRO
SPO OFF;

HOS zip -m9   &&zipfile &&ps360_main_report..html
HOS zip       &&zipfile sorttable.js

EXEC dbms_application_info.set_module(:old_module,:old_action);
SET HEA ON LIN 80 NEWP 1 PAGES 14 FEED ON ECHO &&ps_echo_off VER ON LONG 80 LONGC 80 WRA ON TRIMS ON TRIM OFF TI OFF TIMI OFF ARRAY 1 TERMOUT ON
