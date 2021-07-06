REPORT zfiori_app_master.
*&---------------------------------------------------------------------*
*& Report  ZFIORI_APP_MASTER
*&
*&---------------------------------------------------------------------*
*& P_FNAME  File name
*& RB1  Upload Fiori App Master
*& RB2  Report
*& S_ROLE	Role
*& S_USER	User
*&---------------------------------------------------------------------*

* Include for Top Declartions
INCLUDE zfiori_app_master_top.
* Include for Selection Screen
INCLUDE zfiori_app_master_sel.
* Include for Forms
INCLUDE zfiori_app_master_forms.

*&---------------------------------------------------------------------*
*& Selection Screen Output
*&---------------------------------------------------------------------*
AT SELECTION-SCREEN OUTPUT.
* Perfrom for Screen Modification
  PERFORM screen_modification.

*&---------------------------------------------------------------------*
*& F4 Help for p_fname
*&---------------------------------------------------------------------*
AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_fname.
* Perfrom for F4 help Input File
  PERFORM f4_help_file.

AT SELECTION-SCREEN.
* Perform for Check boxes
  PERFORM validate_check_boxes.

AT SELECTION-SCREEN ON s_role.
* Perform for Valdate Role
  PERFORM validate_role.

AT SELECTION-SCREEN ON s_user.
* Perform for Valdate User
  PERFORM validate_user.
*&---------------------------------------------------------------------*
*& START-OF-SELECTION.
*&---------------------------------------------------------------------*
START-OF-SELECTION.
  IF rb2 = abap_true.
* Perfrom for Get Data
    PERFORM get_app_data.
* Perfrom for Get Role Data
    PERFORM get_role_data.
  ELSEIF rb1 = abap_true.
    IF p_fname IS INITIAL.
      MESSAGE 'Provide Input file'(021) TYPE 'I' DISPLAY LIKE 'E'.
      LEAVE LIST-PROCESSING.
    ENDIF.
* Perfrom for Upload input file data into ITAB
    PERFORM upload_data.
  ENDIF.

*&---------------------------------------------------------------------*
*& End Of Selection
*&---------------------------------------------------------------------*
END-OF-SELECTION.

* Perfrom for Update the table
  PERFORM upload_table.
* Perfrom for fill final ITAB
  PERFORM get_final.
* Perfrom for Display Data
  PERFORM get_display.
