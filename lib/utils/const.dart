enum GoodsStatus {
  all,
  brandNew,
  almostNew,
  usedButGood,
  usedAndSlightlyDamaged,
  usedAndDamaged,
  severelyDamaged
}

class GoodsStatusValue {
  const GoodsStatusValue({ required this.displayName, required this.paramValue });
  final String displayName;
  final String paramValue;
}

const Map<GoodsStatus, GoodsStatusValue> GoodsStatusMap = {
  GoodsStatus.all: GoodsStatusValue(displayName: "すべて", paramValue: "1,2,3,4,5,6"),
  GoodsStatus.brandNew: GoodsStatusValue(displayName: "新品、未使用", paramValue: "1"),
  GoodsStatus.almostNew: GoodsStatusValue(displayName: "未使用に近い", paramValue: "2"),
  GoodsStatus.usedButGood: GoodsStatusValue(displayName: "目立った傷や汚れなし", paramValue: "3"),
  GoodsStatus.usedAndSlightlyDamaged: GoodsStatusValue(displayName: "やや傷や汚れあり", paramValue: "4"),
  GoodsStatus.usedAndDamaged: GoodsStatusValue(displayName: "傷や汚れあり", paramValue: "5"),
  GoodsStatus.severelyDamaged: GoodsStatusValue(displayName: "全体的に状態が悪い", paramValue: "6")
};
