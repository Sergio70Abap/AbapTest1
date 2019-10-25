*---------------------------------------------------------------------*
*    program for:   TABLEFRAME_ZSDDOCFI
*   generation date: 30.08.2019 at 09:54:48
*   view maintenance generator version: #001407#
*---------------------------------------------------------------------*
FUNCTION TABLEFRAME_ZSDDOCFI           .

  PERFORM TABLEFRAME TABLES X_HEADER X_NAMTAB DBA_SELLIST DPL_SELLIST
                            EXCL_CUA_FUNCT
                     USING  CORR_NUMBER VIEW_ACTION VIEW_NAME.

ENDFUNCTION.
