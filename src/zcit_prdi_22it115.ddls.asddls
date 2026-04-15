@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Root View Entity'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZCIT_PRDI_22IT115
  as select from zcit_pro_22it115 as ProductHeader
  composition [0..*] of ZCIT_LSTI_22IT115 as _LifecycleStage
{
  key productid            as ProductId,
      productname          as ProductName,
      category             as Category,
      lifecycle_status     as LifecycleStatus,
      launch_year          as LaunchYear,
  @Semantics.amount.currencyCode: 'Currency'
      unit_price           as UnitPrice,
      currency             as Currency,
      responsible_mgr      as ResponsibleMgr,
      description          as Description,
  @Semantics.user.createdBy: true
      local_created_by     as LocalCreatedBy,
  @Semantics.systemDateTime.createdAt: true
      local_created_at     as LocalCreatedAt,
  @Semantics.user.lastChangedBy: true
      local_last_changed_by as LocalLastChangedBy,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at as LocalLastChangedAt,

     
      _LifecycleStage
  }
