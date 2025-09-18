
enum WorksheetPercentAmountDialogType {
  overAllProfit,
  lineItemProfit,
  lineItemTax,
  commission,
  overhead,
  discount,
  /// [cardFee] is a use to handle percentage and amount for
  /// Credit Card Fee for PercentAmountDialog in worksheets
  cardFee
}

enum WorksheetMaterialPropType {
  unit,
  color,
  size,
  style,
  /// [variant] is a material property which is not shown in the form for material supplier
  /// eg. Beacon and SRS V2
  variant,
}

enum WorksheetFormType {
  add,
  edit
}