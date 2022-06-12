enum GoodsStatus {
  all,
  brandNew,
  almostNew,
  usedButGood,
  usedAndSlightlyDamaged,
  usedAndDamaged,
  severelyDamaged
}

class StatusValue {
  const StatusValue({ required this.displayName, required this.paramValue });
  final String displayName;
  final String paramValue;
}

const Map<GoodsStatus, StatusValue> GoodsStatusMap = {
  GoodsStatus.all: StatusValue(displayName: "すべて", paramValue: "1,2,3,4,5,6"),
  GoodsStatus.brandNew: StatusValue(displayName: "新品、未使用", paramValue: "1"),
  GoodsStatus.almostNew: StatusValue(displayName: "未使用に近い", paramValue: "2"),
  GoodsStatus.usedButGood: StatusValue(displayName: "目立った傷や汚れなし", paramValue: "3"),
  GoodsStatus.usedAndSlightlyDamaged: StatusValue(displayName: "やや傷や汚れあり", paramValue: "4"),
  GoodsStatus.usedAndDamaged: StatusValue(displayName: "傷や汚れあり", paramValue: "5"),
  GoodsStatus.severelyDamaged: StatusValue(displayName: "全体的に状態が悪い", paramValue: "6")
};

enum SalesStatus {
  all,
  onSale,
  soldOut,
}

const Map<SalesStatus, StatusValue> SalesStatusMap = {
  SalesStatus.all: StatusValue(displayName: "すべて", paramValue: "on_sale,sold_out|trading"),
  SalesStatus.onSale: StatusValue(displayName: "販売中", paramValue: "on_sale"),
  SalesStatus.soldOut: StatusValue(displayName: "売り切れ", paramValue: "sold_out|trading"),
};

enum DeliveryStatus {
  all,
  seller,
  buyer,
}

const Map<DeliveryStatus, StatusValue> DeliveryStatusMap = {
  DeliveryStatus.all: StatusValue(displayName: "すべて", paramValue: "1,2"),
  DeliveryStatus.seller: StatusValue(displayName: "送料込み(出品者負担)", paramValue: "2"),
  DeliveryStatus.buyer: StatusValue(displayName: "着払い(購入者負担)", paramValue: "1"),
};