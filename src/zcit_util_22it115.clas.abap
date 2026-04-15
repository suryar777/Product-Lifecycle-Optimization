CLASS zcit_util_22it115 DEFINITION
  PUBLIC FINAL CREATE PRIVATE.

  PUBLIC SECTION.
    TYPES:
      BEGIN OF ty_prod_key,
        productid TYPE zcit_de_productid,
      END OF ty_prod_key,
      BEGIN OF ty_stage_key,
        productid TYPE zcit_de_productid,
        stagenum  TYPE int2,
      END OF ty_stage_key,
      tt_prod_keys  TYPE STANDARD TABLE OF ty_prod_key,
      tt_stage_keys TYPE STANDARD TABLE OF ty_stage_key.

    CLASS-METHODS get_instance
      RETURNING VALUE(ro_instance) TYPE REF TO zcit_util_22it115.

    METHODS:
      set_hdr_value
        IMPORTING im_hdr     TYPE zcit_pro_22it115
        EXPORTING ex_created TYPE abap_boolean,
      get_hdr_value
        EXPORTING ex_hdr TYPE zcit_pro_22it115,
      set_itm_value
        IMPORTING im_itm     TYPE zcit_lcs_22it115
        EXPORTING ex_created TYPE abap_boolean,
      get_itm_value
        EXPORTING ex_itm TYPE zcit_lcs_22it115,
      set_hdr_del
        IMPORTING im_key TYPE ty_prod_key,
      set_itm_del
        IMPORTING im_key TYPE ty_stage_key,
      get_hdr_del
        EXPORTING ex_keys TYPE tt_prod_keys,
      get_itm_del
        EXPORTING ex_keys TYPE tt_stage_keys,
      set_hdr_del_flag
        IMPORTING im_flag TYPE abap_boolean,
      get_del_flag
        EXPORTING ex_flag TYPE abap_boolean,
      cleanup_buffer.

  PRIVATE SECTION.
    CLASS-DATA:
      mo_instance    TYPE REF TO zcit_util_22it115,
      gs_hdr_buff    TYPE zcit_pro_22it115,
      gs_itm_buff    TYPE zcit_lcs_22it115,
      gt_hdr_del     TYPE tt_prod_keys,
      gt_itm_del     TYPE tt_stage_keys,
      gv_del_flag    TYPE abap_boolean.
ENDCLASS.

CLASS zcit_util_22it115 IMPLEMENTATION.
  METHOD get_instance.
    IF mo_instance IS INITIAL.
      CREATE OBJECT mo_instance.
    ENDIF.
    ro_instance = mo_instance.
  ENDMETHOD.

  METHOD set_hdr_value.
    IF im_hdr-productid IS NOT INITIAL.
      gs_hdr_buff = im_hdr.
      ex_created  = abap_true.
    ENDIF.
  ENDMETHOD.

  METHOD get_hdr_value.
    ex_hdr = gs_hdr_buff.
  ENDMETHOD.

  METHOD set_itm_value.
    IF im_itm IS NOT INITIAL.
      gs_itm_buff = im_itm.
      ex_created  = abap_true.
    ENDIF.
  ENDMETHOD.

  METHOD get_itm_value.
    ex_itm = gs_itm_buff.
  ENDMETHOD.

  METHOD set_hdr_del.
    APPEND im_key TO gt_hdr_del.
  ENDMETHOD.

  METHOD set_itm_del.
    APPEND im_key TO gt_itm_del.
  ENDMETHOD.

  METHOD get_hdr_del.
    ex_keys = gt_hdr_del.
  ENDMETHOD.

  METHOD get_itm_del.
    ex_keys = gt_itm_del.
  ENDMETHOD.

  METHOD set_hdr_del_flag.
    gv_del_flag = im_flag.
  ENDMETHOD.

  METHOD get_del_flag.
    ex_flag = gv_del_flag.
  ENDMETHOD.

  METHOD cleanup_buffer.
    CLEAR: gs_hdr_buff, gs_itm_buff, gt_hdr_del, gt_itm_del, gv_del_flag.
  ENDMETHOD.
ENDCLASS.
