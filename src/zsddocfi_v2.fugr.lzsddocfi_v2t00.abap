*---------------------------------------------------------------------*
*    view related data declarations
*   generation date: 30.08.2019 at 09:55:31
*   view maintenance generator version: #001407#
*---------------------------------------------------------------------*
*...processing: ZSDDOCFI_V2.....................................*
DATA:  BEGIN OF STATUS_ZSDDOCFI_V2                   .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZSDDOCFI_V2                   .
CONTROLS: TCTRL_ZSDDOCFI_V2
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZSDDOCFI_V2                   .
TABLES: ZSDDOCFI_V2                    .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
