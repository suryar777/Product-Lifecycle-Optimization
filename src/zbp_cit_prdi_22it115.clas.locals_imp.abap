CLASS lsc_ZCIT_PRDI_22IT115 DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.
    METHODS finalize          REDEFINITION.
    METHODS check_before_save  REDEFINITION.
    METHODS save               REDEFINITION.
    METHODS cleanup            REDEFINITION.
    METHODS cleanup_finalize   REDEFINITION.
ENDCLASS.

CLASS lsc_ZCIT_PRDI_22IT115 IMPLEMENTATION.

  METHOD finalize.          ENDMETHOD.
  METHOD check_before_save. ENDMETHOD.
  METHOD cleanup_finalize.  ENDMETHOD.

  METHOD save.
    "── Retrieve all buffered data from the utility singleton ──
    DATA(lo_util) = zcit_util_22it115=>get_instance( ).

    lo_util->get_hdr_value( IMPORTING ex_hdr  = DATA(ls_hdr) ).
    lo_util->get_itm_value( IMPORTING ex_itm  = DATA(ls_itm) ).
    lo_util->get_hdr_del(   IMPORTING ex_keys = DATA(lt_hdr_del) ).
    lo_util->get_itm_del(   IMPORTING ex_keys = DATA(lt_itm_del) ).
    lo_util->get_del_flag(  IMPORTING ex_flag = DATA(lv_hdr_del) ).

    "── 1. Save / Update Product Header ──
    IF ls_hdr IS NOT INITIAL.
      MODIFY zcit_pro_22it115 FROM @ls_hdr.
    ENDIF.

    "── 2. Save / Update Lifecycle Stage Item ──
    IF ls_itm IS NOT INITIAL.
      MODIFY zcit_lcs_22it115 FROM @ls_itm.
    ENDIF.

    "── 3. Handle Deletions ──
    IF lv_hdr_del = abap_true.
      "Delete header + cascade delete all items for each product
      LOOP AT lt_hdr_del INTO DATA(ls_del_hdr).
        DELETE FROM zcit_pro_22it115
          WHERE productid = @ls_del_hdr-productid.
        DELETE FROM zcit_lcs_22it115
          WHERE productid = @ls_del_hdr-productid.
      ENDLOOP.
    ELSE.
      "Delete individual headers
      LOOP AT lt_hdr_del INTO ls_del_hdr.
        DELETE FROM zcit_pro_22it115
          WHERE productid = @ls_del_hdr-productid.
      ENDLOOP.
      "Delete individual stages
      LOOP AT lt_itm_del INTO DATA(ls_del_itm).
        DELETE FROM zcit_lcs_22it115
          WHERE productid = @ls_del_itm-productid
            AND stagenum  = @ls_del_itm-stagenum.
      ENDLOOP.
    ENDIF.
  ENDMETHOD.

  METHOD cleanup.
    "Always clear the buffer after save — prevents stale data
    zcit_util_22it115=>get_instance( )->cleanup_buffer( ).
  ENDMETHOD.

ENDCLASS.
