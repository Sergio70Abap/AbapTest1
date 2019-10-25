*&---------------------------------------------------------------------*
*& Include          ZZUE0001
*&---------------------------------------------------------------------*
************************************************************************
*       USEREXIT_FILL_XKOMK1                                           *
************************************************************************
*---------------------------------------------------------------------*
*       Fill fields in document header XKOMK1                         *
*       ---> VBRK                                                     *
*---------------------------------------------------------------------*
DATA: lf_xegld       LIKE t005-xegld,
      lf_land1       LIKE t001-land1,
      lf_zzxegld     LIKE zsddocfi_v2-zzxegld,
      ls_zsddocfi_v2 TYPE zsddocfi_v2,
      lf_string      TYPE string.
**********************************************************************
* Determinazione tipo doc FI da SD tramite logica IT compliant
**********************************************************************

* Paese destinazione fattura (i.e. destinazione merci)
CLEAR: lf_zzxegld, lf_land1, lf_xegld.
SELECT SINGLE land1 INTO lf_land1
      FROM t001
    WHERE bukrs = vbrk-bukrs.
IF lf_land1 = vbrk-land1.
*      CLIENTE NAZIONALE
  lf_zzxegld = '1'.
ELSE.
  SELECT SINGLE xegld FROM t005 INTO lf_xegld
                  WHERE land1 = vbrk-land1.
  CASE lf_xegld.
    WHEN 'X'.
* Membro UE
      lf_zzxegld = '2'.
    WHEN OTHERS.
* XUE
      lf_zzxegld = '3'.
  ENDCASE.
ENDIF.
CLEAR: ls_zsddocfi_v2.
SELECT SINGLE * INTO ls_zsddocfi_v2
        FROM zsddocfi_v2
       WHERE vkorg = vbrk-vkorg
         AND vtweg = vbrk-vtweg
         AND fkart = vbrk-fkart
         AND ktgrd = vbrk-ktgrd
         AND zzxegld = lf_zzxegld.
IF sy-subrc <> 0 OR ls_zsddocfi_v2-blart IS INITIAL.
  CONCATENATE vbrk-vkorg
              vbrk-vtweg
              vbrk-fkart
              vbrk-ktgrd
              lf_zzxegld INTO lf_string SEPARATED BY space.
  MESSAGE i001(zsd) WITH lf_string.
  MESSAGE ID 'ZSD' TYPE 'E' NUMBER 001 WITH lf_string RAISING error_01.
ELSE.
  xkomk1-blart = ls_zsddocfi_v2-blart.
ENDIF.

*Attivazione nuova procedura storno ex OSS 1259505 in casi particolari
IF lf_land1 EQ 'IT'.
  IF ( vbrk-vbtyp =  'N' OR vbrk-vbtyp =  'S' ) AND NOT "storno fattura
    vbrk-sfakn IS INITIAL. " fattura di riferimento
    rule_new_cancel = 'A'.
  ENDIF.
ENDIF.

***********************************************************************
* Versione con Triangolazioni Custom / Desueta
***********************************************************************
*DATA: ls_zsddocfi TYPE zsddocfi.
*
*DATA: ws_land1     LIKE kna1-land1,
*      ws_xegld     LIKE t005-xegld,
*      ws_xegldp    LIKE t005-xegld,
*      ws_ktgrd     LIKE knvv-ktgrd,
*      w_land1      LIKE t001-land1,
*      w_land1p     LIKE t001-land1,
*      ws_zxegld    LIKE zsddocfi-zxegld,
*      ws_zxegldp   LIKE zsddocfi-zxegldp,
*      lt_tvfk      LIKE tvfk,
*      l_string(20),
*      w_land1b     LIKE t001-land1.
*DATA:  lt_callstack TYPE  abap_callstack.
*
*CLEAR: ws_zxegld, ws_zxegldp.
*FREE: lt_callstack.
*
*CALL FUNCTION 'SYSTEM_CALLSTACK'
*  IMPORTING
*    callstack = lt_callstack.
*
*SORT lt_callstack BY mainprogram.
*READ TABLE lt_callstack WITH KEY mainprogram = 'SDBONT06'
*                                 BINARY SEARCH
*                                 TRANSPORTING NO FIELDS.
*IF sy-subrc <> 0. "verifica che non sia in atto la VBOF
** Si verifica se il paese di destinazione è CEE
*  SELECT SINGLE xegld FROM t005 INTO ws_xegld
*                  WHERE land1 = vbrk-land1.
** check se 1 = Nazionale 2= Cee 3 = ExtraCee
*  SELECT SINGLE land1 FROM t001 INTO w_land1
*                      WHERE bukrs = vbrk-bukrs.
*  IF w_land1 EQ vbrk-land1 .
*    ws_zxegld = 1.  "Nazionale
*  ELSE.
*    IF ws_xegld = 'X'.
*      ws_zxegld = 2. "Cee
*    ELSE.
*      ws_zxegld = 3. "ExtraCee
*    ENDIF.
*  ENDIF.
*
** Determinazione paese del pagatore o eccezione
*  CLEAR w_land1p.
*  CLEAR ws_xegldp.
*  SELECT SINGLE land1 INTO w_land1p FROM kna1
*    WHERE kunnr = vbrk-kunrg.
*  IF sy-subrc = 0 AND NOT  w_land1 IS INITIAL.
*    SELECT SINGLE xegld FROM t005 INTO ws_xegldp
*                     WHERE land1 = w_land1.
*    IF w_land1 EQ w_land1p .
*      ws_zxegldp = 1. "nazionale
*    ELSE.
*      IF ws_xegldp = 'X'.
*        ws_zxegldp = 2. "Cee
*      ELSE.
*        ws_zxegldp = 3. "ExtraCee
*      ENDIF.
*    ENDIF.
*  ENDIF.
*  IF vbrk-ktgrd EQ '04'.
*    ws_zxegldp = 4. "PA con split
*  ELSEIF vbrk-ktgrd EQ '05'.
*    ws_zxegldp = 5. "PA con split
*  ENDIF.
*
*  CLEAR: ls_zsddocfi.
*  SELECT SINGLE * INTO ls_zsddocfi
*          FROM zsddocfi
*         WHERE vkorg = vbrk-vkorg
*          AND vtweg = vbrk-vtweg
*          AND fkart = vbrk-fkart
**           AND ktgrd = vbrk-ktgrd
*          AND zxegldp = ws_zxegldp
*          AND zxegld = ws_zxegld.
** Se la tabella è valorizzata correttamente si imposta il documento
** contabile
*  IF sy-subrc EQ 0 AND NOT ls_zsddocfi-blart IS INITIAL AND ls_zsddocfi-blart NE ' '.
*    xkomk1-blart = ls_zsddocfi-blart.
*  ELSE.
*    CONCATENATE vbrk-vkorg
*                vbrk-vtweg
*                vbrk-fkart
*                vbrk-ktgrd
*                ws_zxegld INTO l_string SEPARATED BY space.
*    MESSAGE i001(zsd) WITH l_string.
*    MESSAGE ID 'ZSD' TYPE 'E' NUMBER 001 WITH l_string RAISING error_01.
*  ENDIF.
*ENDIF.
*
**Attivazione nuova procedura storno ex OSS 1259505 in casi particolari
*SELECT SINGLE land1 FROM t001
*   INTO w_land1b
*   WHERE bukrs = vbrk-bukrs.
*IF w_land1b EQ 'IT'.
*  IF ( vbrk-vbtyp =  'N' OR vbrk-vbtyp =  'S' ) AND NOT "storno fattura
*    vbrk-sfakn IS INITIAL. " fattura di riferimento
*    rule_new_cancel = 'A'.
*  ENDIF.
*ENDIF.
