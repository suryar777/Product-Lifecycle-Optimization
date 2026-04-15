@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Header Consumption View'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity ZCIT_PRDC_22IT115
  provider contract transactional_query
  as projection on ZCIT_PRDI_22IT115
{
  key ProductId,
      ProductName,
      Category,
  @Search.defaultSearchElement: true
      LifecycleStatus,
      LaunchYear,
  @Semantics.amount.currencyCode: 'Currency'
      UnitPrice,
      Currency,
      ResponsibleMgr,
      Description,
      LocalCreatedBy,
      LocalCreatedAt,
      LocalLastChangedBy,
      LocalLastChangedAt,

      /* Associations */
      _LifecycleStage : redirected to composition child ZCIT_LSTC_22IT115
}
