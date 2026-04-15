CLASS lhc_LifecycleStage DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE LifecycleStage.
    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE LifecycleStage.
    METHODS read FOR READ
      IMPORTING keys FOR READ LifecycleStage RESULT result.
    METHODS rba_ProductHeader FOR READ
      IMPORTING keys_rba FOR READ LifecycleStage\_ProductHeader
      FULL result_requested RESULT result LINK association_links.
ENDCLASS.

CLASS lhc_LifecycleStage IMPLEMENTATION.

  METHOD update.
    DATA ls_itm TYPE zcit_lcs_22it115.
    LOOP AT entities INTO DATA(ls_e).
      ls_itm = CORRESPONDING #( ls_e MAPPING FROM ENTITY ).
      IF ls_itm-productid IS NOT INITIAL.
        SELECT FROM zcit_lcs_22it115 FIELDS *
          WHERE productid = @ls_itm-productid
            AND stagenum  = @ls_itm-stagenum
          INTO TABLE @DATA(lt_exists).
        IF sy-subrc = 0.
          DATA(lo_util) = zcit_util_22it115=>get_instance( ).
          lo_util->set_itm_value(
            EXPORTING im_itm     = ls_itm
            IMPORTING ex_created = DATA(lv_ok) ).
          IF lv_ok = abap_true.
            APPEND VALUE #( productid = ls_itm-productid stagenum = ls_itm-stagenum )
              TO mapped-lifecyclestage.
            APPEND VALUE #( %key = ls_e-%key
              %msg = new_message( id = 'ZCIT_PLO_MSG' number = 001
                v1 = 'Stage updated successfully'
                severity = if_abap_behv_message=>severity-success ) )
              TO reported-lifecyclestage.
          ENDIF.
        ELSE.
          APPEND VALUE #( %cid = ls_e-%cid_ref productid = ls_itm-productid stagenum = ls_itm-stagenum )
            TO failed-lifecyclestage.
          APPEND VALUE #( %cid = ls_e-%cid_ref productid = ls_itm-productid
            %msg = new_message( id = 'ZCIT_PLO_MSG' number = 003
              v1 = 'Stage not found'
              severity = if_abap_behv_message=>severity-error ) )
            TO reported-lifecyclestage.
        ENDIF.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD delete.
    DATA(lo_util) = zcit_util_22it115=>get_instance( ).
    LOOP AT keys INTO DATA(ls_key).
      lo_util->set_itm_del(
        im_key = VALUE #( productid = ls_key-productid stagenum = ls_key-stagenum ) ).
      APPEND VALUE #( %cid = ls_key-%cid_ref productid = ls_key-productid
        stagenum = ls_key-stagenum
        %msg = new_message( id = 'ZCIT_PLO_MSG' number = 001
          v1 = 'Stage deleted successfully'
          severity = if_abap_behv_message=>severity-success ) )
        TO reported-lifecyclestage.
    ENDLOOP.
  ENDMETHOD.

  METHOD read. ENDMETHOD. "Optional for transactional flow
  METHOD rba_ProductHeader. ENDMETHOD. "Optional RBA

ENDCLASS.
