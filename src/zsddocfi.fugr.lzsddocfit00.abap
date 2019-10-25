*---------------------------------------------------------------------*
*    view related data declarations
*   generation date: 30.08.2019 at 09:54:48
*   view maintenance generator version: #001407#
*---------------------------------------------------------------------*
*...processing: ZSDDOCFI........................................*
DATA:  BEGIN OF STATUS_ZSDDOCFI                      .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZSDDOCFI                      .
CONTROLS: TCTRL_ZSDDOCFI
            TYPE TABLEVIEW USING SCREEN '0010'.
*.........table declarations:.................................*
TABLES: *ZSDDOCFI                      .
TABLES: ZSDDOCFI                       .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
