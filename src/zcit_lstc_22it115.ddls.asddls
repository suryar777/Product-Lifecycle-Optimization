@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Item Consumption View'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view entity ZCIT_LSTC_22IT115
  as projection on ZCIT_LSTI_22IT115
{
  key ProductId,
  key StageNum,
  @Search.defaultSearchElement: true
      StageName,
      Phase,
      StartDate,
      EndDate,
  @Semantics.quantity.unitOfMeasure: 'ProgUnit'
      ProgressPct,
      ProgUnit,
      Owner,
      StageNotes,
      LocalCreatedBy,
      LocalCreatedAt,
      LocalLastChangedBy,
      LocalLastChangedAt,

      /* Associations */
      _ProductHeader : redirected to parent ZCIT_PRDC_22IT115
}
