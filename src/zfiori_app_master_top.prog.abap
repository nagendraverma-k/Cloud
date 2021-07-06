*&---------------------------------------------------------------------*
*&  Include           ZFIORI_APP_MASTER_TOP
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Structure Declarations
*&---------------------------------------------------------------------*
TYPES:
  BEGIN OF ty_final,
    sel,
    user             TYPE sy-uname,
    agr_name         TYPE agr_name,
    tcode            TYPE tcode,
    app_id           TYPE string,
    app              TYPE string,
    app_type         TYPE string,
    app_support      TYPE string,
    line_of_business TYPE string,
    ui_technology    TYPE string,
    product_category TYPE string,
    data_base        TYPE string,
  END OF ty_final,

  BEGIN OF ty_user,
    agr_name TYPE agr_name,
    uname    TYPE xubname,
    from_dat TYPE agr_fdate,
    to_dat   TYPE agr_tdate,
    counter  TYPE menu_num_6,
    object   TYPE agobject,
    low      TYPE agval,
  END OF ty_user,

  BEGIN OF ty_upload,
    tcode            TYPE string,
    app_id           TYPE string,
    app              TYPE string,
    app_type         TYPE string,
    app_support      TYPE string,
    line_of_business TYPE zlob,
    ui_technology    TYPE zui_tech,
    product_category TYPE zproduct_cat,
    data_base        TYPE zdb,
  END OF ty_upload.

*&---------------------------------------------------------------------*
*& Internal table and work Area Declarations
*&---------------------------------------------------------------------*
DATA:
  it_final  TYPE STANDARD TABLE OF ty_final,
  it_user   TYPE STANDARD TABLE OF ty_user,
  it_fcat   TYPE STANDARD TABLE OF slis_fieldcat_alv,
  it_app    TYPE STANDARD TABLE OF zfiori_app,
  it_upd    TYPE STANDARD TABLE OF ty_upload,
  wa_final  TYPE ty_final,
  wa_user   TYPE ty_user,
  wa_layout TYPE slis_layout_alv,
  wa_fcat   TYPE slis_fieldcat_alv,
  wa_app    TYPE zfiori_app,
  wa_upd    TYPE ty_upload,
  i_tabrd   TYPE truxs_t_text_data.

*&---------------------------------------------------------------------*
*& Global Declarations
*&---------------------------------------------------------------------*
DATA:
  g_role  TYPE agr_name,
  g_user  TYPE usr02-bname,
  g_tcode TYPE tcode.
