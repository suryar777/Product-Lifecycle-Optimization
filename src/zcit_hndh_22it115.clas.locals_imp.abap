CLASS lhc_ProductHdr DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations
      FOR ProductHdr RESULT result.
    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations
      FOR ProductHdr RESULT result.
    METHODS create FOR MODIFY
      IMPORTING entities FOR CREATE ProductHdr.
    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE ProductHdr.
    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE ProductHdr.
    METHODS read FOR READ
      IMPORTING keys FOR READ ProductHdr RESULT result.
    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK ProductHdr.
    METHODS rba_LifecycleStage FOR READ
      IMPORTING keys_rba FOR READ ProductHdr\_LifecycleStage
      FULL result_requested RESULT result LINK association_links.
    METHODS cba_LifecycleStage FOR MODIFY
      IMPORTING entities_cba FOR CREATE ProductHdr\_LifecycleStage.
ENDCLASS.

CLASS lhc_ProductHdr IMPLEMENTATION.

  METHOD get_instance_authorizations. ENDMETHOD.
  METHOD get_global_authorizations.  ENDMETHOD.
  METHOD lock.                       ENDMETHOD.

  METHOD create.
    DATA ls_hdr TYPE zcit_pro_22it115.
    LOOP AT entities INTO DATA(ls_e).
      ls_hdr = CORRESPONDING #( ls_e MAPPING FROM ENTITY ).
      IF ls_hdr-productid IS NOT INITIAL.
        SELECT FROM zcit_pro_22it115 FIELDS productid
          WHERE productid = @ls_hdr-productid
          INTO TABLE @DATA(lt_exists).
        IF sy-subrc <> 0.
          DATA(lo_util) = zcit_util_22it115=>get_instance( ).
          lo_util->set_hdr_value(
            EXPORTING im_hdr     = ls_hdr
            IMPORTING ex_created = DATA(lv_ok) ).
          IF lv_ok = abap_true.
            APPEND VALUE #( %cid = ls_e-%cid productid = ls_hdr-productid )
              TO mapped-producthdr.
            APPEND VALUE #( %cid = ls_e-%cid productid = ls_hdr-productid
              %msg = new_message( id = 'ZCIT_PLO_MSG' number = 001
                v1 = 'Product created successfully'
                severity = if_abap_behv_message=>severity-success ) )
              TO reported-producthdr.
          ENDIF.
        ELSE.
          APPEND VALUE #( %cid = ls_e-%cid productid = ls_hdr-productid )
            TO failed-producthdr.
          APPEND VALUE #( %cid = ls_e-%cid productid = ls_hdr-productid
            %msg = new_message( id = 'ZCIT_PLO_MSG' number = 002
              v1 = 'Duplicate Product ID'
              severity = if_abap_behv_message=>severity-error ) )
            TO reported-producthdr.
        ENDIF.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD update.
    DATA ls_hdr TYPE zcit_pro_22it115.
    LOOP AT entities INTO DATA(ls_e).
      ls_hdr = CORRESPONDING #( ls_e MAPPING FROM ENTITY ).
      IF ls_hdr-productid IS NOT INITIAL.
        SELECT FROM zcit_pro_22it115 FIELDS *
          WHERE productid = @ls_hdr-productid
          INTO TABLE @DATA(lt_exists).
        IF sy-subrc = 0.
          DATA(lo_util) = zcit_util_22it115=>get_instance( ).
          lo_util->set_hdr_value(
            EXPORTING im_hdr     = ls_hdr
            IMPORTING ex_created = DATA(lv_ok) ).
          IF lv_ok = abap_true.
            APPEND VALUE #( productid = ls_hdr-productid )
              TO mapped-producthdr.
            APPEND VALUE #( %key = ls_e-%key
              %msg = new_message( id = 'ZCIT_PLO_MSG' number = 001
                v1 = 'Product updated successfully'
                severity = if_abap_behv_message=>severity-success ) )
              TO reported-producthdr.
          ENDIF.
        ELSE.
          APPEND VALUE #( %cid = ls_e-%cid_ref productid = ls_hdr-productid )
            TO failed-producthdr.
          APPEND VALUE #( %cid = ls_e-%cid_ref productid = ls_hdr-productid
            %msg = new_message( id = 'ZCIT_PLO_MSG' number = 003
              v1 = 'Product not found'
              severity = if_abap_behv_message=>severity-error ) )
            TO reported-producthdr.
        ENDIF.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD delete.
    DATA(lo_util) = zcit_util_22it115=>get_instance( ).
    LOOP AT keys INTO DATA(ls_key).
      lo_util->set_hdr_del( im_key = VALUE #( productid = ls_key-productid ) ).
      lo_util->set_hdr_del_flag( im_flag = abap_true ).
      APPEND VALUE #( %cid = ls_key-%cid_ref productid = ls_key-productid
        %msg = new_message( id = 'ZCIT_PLO_MSG' number = 001
          v1 = 'Product deleted'
          severity = if_abap_behv_message=>severity-success ) )
        TO reported-producthdr.
    ENDLOOP.
  ENDMETHOD.

  METHOD read.
    LOOP AT keys INTO DATA(ls_key).
      SELECT SINGLE FROM zcit_pro_22it115 FIELDS *
        WHERE productid = @ls_key-productid
        INTO @DATA(ls_hdr).
      IF sy-subrc = 0.
        APPEND CORRESPONDING #( ls_hdr ) TO result.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD rba_LifecycleStage.
    LOOP AT keys_rba INTO DATA(ls_key).
      SELECT FROM zcit_lcs_22it115 FIELDS *
        WHERE productid = @ls_key-productid
        INTO TABLE @DATA(lt_items).
      LOOP AT lt_items INTO DATA(ls_itm).
        APPEND CORRESPONDING #( ls_itm ) TO result.
        APPEND VALUE #(
          source-productid = ls_key-productid
          target-productid = ls_itm-productid
          target-stagenum  = ls_itm-stagenum )
          TO association_links.
      ENDLOOP.
    ENDLOOP.
  ENDMETHOD.

  METHOD cba_LifecycleStage.
    DATA ls_itm TYPE zcit_lcs_22it115.
    LOOP AT entities_cba INTO DATA(ls_cba).
      ls_itm = CORRESPONDING #( ls_cba-%target[ 1 ] ).
      IF ls_itm-productid IS NOT INITIAL AND ls_itm-stagenum IS NOT INITIAL.
        SELECT FROM zcit_lcs_22it115 FIELDS *
          WHERE productid = @ls_itm-productid
            AND stagenum  = @ls_itm-stagenum
          INTO TABLE @DATA(lt_exists).
        IF sy-subrc <> 0.
          DATA(lo_util) = zcit_util_22it115=>get_instance( ).
          lo_util->set_itm_value(
            EXPORTING im_itm     = ls_itm
            IMPORTING ex_created = DATA(lv_ok) ).
          IF lv_ok = abap_true.
            APPEND VALUE #(
              %cid      = ls_cba-%target[ 1 ]-%cid
              productid = ls_itm-productid
              stagenum  = ls_itm-stagenum )
              TO mapped-lifecyclestage.
            APPEND VALUE #(
              %cid = ls_cba-%target[ 1 ]-%cid
              productid = ls_itm-productid
              %msg = new_message( id = 'ZCIT_PLO_MSG' number = 001
                v1 = 'Lifecycle Stage created'
                severity = if_abap_behv_message=>severity-success ) )
              TO reported-lifecyclestage.
          ENDIF.
        ELSE.
          APPEND VALUE #(
            %cid = ls_cba-%target[ 1 ]-%cid
            productid = ls_itm-productid
            stagenum  = ls_itm-stagenum )
            TO failed-lifecyclestage.
          APPEND VALUE #(
            %cid = ls_cba-%target[ 1 ]-%cid
            productid = ls_itm-productid
            %msg = new_message( id = 'ZCIT_PLO_MSG' number = 004
              v1 = 'Duplicate Stage Number'
              severity = if_abap_behv_message=>severity-error ) )
            TO reported-lifecyclestage.
        ENDIF.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.
