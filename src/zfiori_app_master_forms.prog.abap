*&---------------------------------------------------------------------*
*&      Form  SCREEN_MODIFICATION
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM screen_modification .
  IF rb1 = 'X'.
    REFRESH : s_role[],s_user[].
    LOOP AT SCREEN.
      IF screen-group1 = 'V3'.
        screen-active = '0'.
        MODIFY SCREEN.
      ENDIF.
    ENDLOOP.
  ELSEIF rb2 = 'X'.
    CLEAR : p_fname.
    LOOP AT SCREEN.
      IF screen-group1 = 'V2'.
        screen-active = '0'.
        MODIFY SCREEN.
      ENDIF.
    ENDLOOP.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F4_HELP_FILE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM f4_help_file .
  CALL FUNCTION 'F4_FILENAME'
    EXPORTING
      program_name  = sy-cprog
      dynpro_number = sy-dynnr
    IMPORTING
      file_name     = p_fname.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_APP_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM get_app_data .
  SELECT *
    FROM zfiori_app
    INTO TABLE it_app
    WHERE tcode IN s_tcode.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_ROLE_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM get_role_data .
  SELECT a~agr_name
         a~uname
         a~from_dat
         a~to_dat
         b~counter
         b~object
         b~low
    FROM agr_users AS a
  INNER JOIN agr_1251 AS b
      ON a~agr_name = b~agr_name
    INTO TABLE it_user
  WHERE object     = 'S_TCODE'
   AND a~agr_name IN s_role
   AND a~uname    IN s_user
   AND b~low      IN s_tcode.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  UPLOAD_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM upload_data .
  CALL FUNCTION 'TEXT_CONVERT_XLS_TO_SAP'
    EXPORTING
      i_line_header        = 'X'
      i_tab_raw_data       = i_tabrd
      i_filename           = p_fname
    TABLES
      i_tab_converted_data = it_upd[]
    EXCEPTIONS
      conversion_failed    = 1
      OTHERS               = 2.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  UPLOAD_TABLE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM upload_table .
  CLEAR : wa_upd,wa_app.
  LOOP AT it_upd INTO wa_upd.
    MOVE-CORRESPONDING wa_upd TO wa_app.
    MODIFY zfiori_app FROM wa_app.
    CLEAR : wa_upd,wa_app.
  ENDLOOP.
  IF it_upd[] IS NOT INITIAL.
    MESSAGE 'Data Uplodaed Successfully'(005) TYPE 'S'.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_FINAL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_final .
  DATA:
     lv_devices TYPE string.

  CLEAR : wa_user,wa_final.
  LOOP AT it_user INTO wa_user.
    wa_final-user                  = wa_user-uname.
    wa_final-agr_name              = wa_user-agr_name.
    wa_final-tcode                 = wa_user-low.
    READ TABLE it_app INTO wa_app WITH KEY tcode = wa_final-tcode.
    IF sy-subrc = 0.
      CLEAR : wa_app.
      LOOP AT it_app INTO wa_app WHERE tcode = wa_final-tcode.
        wa_final-app_id           = wa_app-app_id.
        wa_final-app              = wa_app-app.
        wa_final-app_type         = wa_app-app_type.
        wa_final-app_support      = wa_app-app_support.
        wa_final-line_of_business = wa_app-line_of_business.
        wa_final-ui_technology    = wa_app-ui_technology.
        wa_final-product_category = wa_app-product_category.
        wa_final-data_base        = wa_app-data_base.


        IF ( p_desktp IS NOT INITIAL AND  wa_final-app_support CS 'DESK')    OR
           ( p_tablet IS NOT INITIAL AND  wa_final-app_support CS 'TABLET' ) OR
           ( p_phone  IS NOT INITIAL AND  wa_final-app_support CS 'PHONE' ).

        ELSE.
          CONTINUE.
        ENDIF.

        IF p_gui IS NOT INITIAL AND wa_final-ui_technology CS 'SAP GUI'.
          APPEND wa_final TO it_final.
          CLEAR : wa_app.

        ELSEIF p_dynpro IS NOT INITIAL AND wa_final-ui_technology CS 'WEB DYNPRO'.
          APPEND wa_final TO it_final.
          CLEAR : wa_app.

        ELSEIF p_fiori IS NOT INITIAL AND wa_final-ui_technology CS 'FIORI'.
          APPEND wa_final TO it_final.
          CLEAR : wa_app.

        ELSE.
          CLEAR : wa_app.
          CONTINUE.
        ENDIF.
      ENDLOOP.

    ENDIF.
    CLEAR : wa_user,wa_final.
  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_DISPLAY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_display .
  IF it_final[] IS NOT INITIAL.
    wa_layout-zebra             = 'X'.
    wa_layout-colwidth_optimize = 'X'.
    wa_layout-box_fieldname     = 'SEL'.

    PERFORM fcat USING :
        '1'    'USER'             'User'(006)                  '12',
        '2'    'AGR_NAME'         'Role'(007)                  '30',
        '3'    'TCODE'            'Transaction'(008)           '20',
        '4'    'APP_ID'           'APP Id'(009)                '20',
        '5'    'APP'              'Application Name'(010)      '50',
        '6'    'APP_TYPE'         'Application Type'(011)      '20',
        '7'    'APP_SUPPORT'      'App Supported Devices'(004) '30',
        '8'    'LINE_OF_BUSINESS' 'Line Of Business'(012)      '30',
        '9'    'UI_TECHNOLOGY'    'UI Technology'(013)         '30',
        '10'   'PRODUCT_CATEGORY' 'Product Category'(014)      '30',
        '11'   'DATA_BASE'        'Data Base'(015)             '30'.

    SORT it_final BY user.

    CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
      EXPORTING
        i_callback_program = sy-repid
        is_layout          = wa_layout
        it_fieldcat        = it_fcat
      TABLES
        t_outtab           = it_final
      EXCEPTIONS
        program_error      = 1
        OTHERS             = 2.
  ELSE.
    MESSAGE 'No Data found....'(016) TYPE 'I'.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  FCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM fcat  USING col_pos
                 field_name
                 ltext
                 output_len.

  wa_fcat-col_pos   = col_pos.
  wa_fcat-fieldname = field_name.
  wa_fcat-seltext_l = ltext.
  wa_fcat-outputlen = output_len.
  APPEND wa_fcat TO it_fcat.
  CLEAR wa_fcat.

ENDFORM.                    " FCAT
*&---------------------------------------------------------------------*
*&      Form  VALIDATE_ROLE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM validate_role.

  SELECT agr_name
    FROM agr_define
    INTO g_role UP TO 1 ROWS
    WHERE agr_name IN s_role.
  ENDSELECT.
  IF sy-subrc NE 0.
    MESSAGE 'Enter Valid Role Name'(017) TYPE 'E'.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  VALIDATE_USER
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM validate_user .

  SELECT bname
    FROM usr02
    INTO g_user UP TO 1 ROWS
    WHERE bname IN s_user.
  ENDSELECT.
  IF sy-subrc NE 0.
    MESSAGE 'Enter Valid User Name'(018) TYPE 'E'.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  VALIDATE_CHECK_BOXES
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM validate_check_boxes .

  IF ( p_gui    IS INITIAL AND
       p_fiori  IS INITIAL AND
       p_dynpro IS INITIAL ).

    MESSAGE 'Select at least One Option for Application Options'(019) TYPE 'E'.
  ENDIF.

  IF ( p_desktp IS INITIAL AND
       p_phone  IS INITIAL AND
       p_tablet IS INITIAL ).

    MESSAGE 'Select at least One Option for Supported Devices'(020) TYPE 'E'.
  ENDIF.
ENDFORM.
