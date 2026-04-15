@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Child Interface View'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
  serviceQuality: #X,
  sizeCategory: #S,
  dataClass: #MIXED
}
define view entity ZCIT_LSTI_22IT115
  as select from zcit_lcs_22it115
  association to parent ZCIT_PRDI_22IT115 as _ProductHeader
    on $projection.ProductId = _ProductHeader.ProductId
{
  key productid          as ProductId,
  key stagenum           as StageNum,
      stagename          as StageName,
      phase              as Phase,
      start_date         as StartDate,
      end_date           as EndDate,
  @Semantics.quantity.unitOfMeasure: 'ProgUnit'
      progress_pct       as ProgressPct,
      prog_unit          as ProgUnit,
      owner              as Owner,
      stage_notes        as StageNotes,
  @Semantics.user.createdBy: true
      local_created_by   as LocalCreatedBy,
  @Semantics.systemDateTime.createdAt: true
      local_created_at   as LocalCreatedAt,
  @Semantics.user.lastChangedBy: true
      local_last_changed_by  as LocalLastChangedBy,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at  as LocalLastChangedAt,

 _ProductHeader
 }
