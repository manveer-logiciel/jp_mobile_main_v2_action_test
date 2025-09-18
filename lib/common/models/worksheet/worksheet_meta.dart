class WorksheetMeta {
  late num materialsCostTotal;
  late num materialsSellingPriceTotal;
  late num laborCostTotal;
  late num laborSellingPriceTotal;
  late num noChargeCostTotal;
  late num noChargeSellingPriceTotal;
  late num overheadCostTotal;
  late num overheadSellingPriceTotal;
  late num costTotal;
  late num sellingPriceTotal;
  late num totalLineTax;
  late num totalLineProfit;
  late num noChargeAmount;

  WorksheetMeta({
    this.materialsCostTotal = 0,
    this.materialsSellingPriceTotal = 0,
    this.laborCostTotal = 0,
    this.laborSellingPriceTotal = 0,
    this.noChargeCostTotal = 0,
    this.noChargeSellingPriceTotal = 0,
    this.overheadCostTotal = 0,
    this.overheadSellingPriceTotal = 0,
    this.costTotal = 0,
    this.sellingPriceTotal = 0,
    this.totalLineTax = 0,
    this.totalLineProfit = 0,
    this.noChargeAmount = 0,
  });

  WorksheetMeta.fromJson(Map<String, dynamic> json) {
    materialsCostTotal = num.tryParse(json['materials_cost_total'].toString()) ?? 0;
    materialsSellingPriceTotal = num.tryParse(json['materials_selling_price_total'].toString()) ?? 0;
    laborCostTotal = num.tryParse(json['labor_cost_total'].toString()) ?? 0;
    laborSellingPriceTotal = num.tryParse(json['labor_selling_price_total'].toString()) ?? 0;
    noChargeCostTotal = num.tryParse(json['no_charge_cost_total'].toString()) ?? 0;
    noChargeSellingPriceTotal = num.tryParse(json['no_charge_selling_price_total'].toString()) ?? 0;
    overheadCostTotal = num.tryParse(json['overhead_cost_total'].toString()) ?? 0;
    overheadSellingPriceTotal = num.tryParse(json['overhead_selling_price_total'].toString()) ?? 0;
    costTotal = num.tryParse(json['cost_total'].toString()) ?? 0;
    sellingPriceTotal = num.tryParse(json['selling_price_total'].toString()) ?? 0;
    totalLineTax = num.tryParse(json['total_line_tax'].toString()) ?? 0;
    totalLineProfit = num.tryParse(json['total_line_profit'].toString()) ?? 0;
    noChargeAmount = num.tryParse(json['no_charge_amount'].toString()) ?? 0;
  }

}
