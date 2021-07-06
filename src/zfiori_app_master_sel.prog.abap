*&---------------------------------------------------------------------*
*&  Include           ZFIORI_APP_MASTER_SEL
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*& Selection Screen
*&---------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-001.
PARAMETERS :
  rb2 RADIOBUTTON GROUP g1 USER-COMMAND uc DEFAULT 'X',
  rb1 RADIOBUTTON GROUP g1.
SELECTION-SCREEN END OF BLOCK b1.

SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE text-002.
PARAMETERS :
  p_fname TYPE rlgrap-filename MODIF ID v2.

SELECT-OPTIONS :
  s_role  FOR g_role  MODIF ID v3,
  s_user  FOR g_user  MODIF ID v3,
  s_tcode FOR g_tcode MODIF ID v3.
SELECTION-SCREEN END OF BLOCK b2.

SELECTION-SCREEN BEGIN OF BLOCK b3 WITH FRAME TITLE text-003.
PARAMETERS:
  p_gui    AS CHECKBOX MODIF ID v3 DEFAULT 'X',
  p_fiori  AS CHECKBOX MODIF ID v3 DEFAULT 'X',
  p_dynpro AS CHECKBOX MODIF ID v3 DEFAULT 'X'.

SELECTION-SCREEN END OF BLOCK b3.

SELECTION-SCREEN BEGIN OF BLOCK b4 WITH FRAME TITLE text-004.
PARAMETERS:
  p_desktp AS CHECKBOX MODIF ID v3 DEFAULT 'X',
  p_phone  AS CHECKBOX MODIF ID v3 DEFAULT 'X',
  p_tablet AS CHECKBOX MODIF ID v3 DEFAULT 'X'.

SELECTION-SCREEN END OF BLOCK b4.
