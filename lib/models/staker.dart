import 'package:staking_test/logic/constants.dart';

class Staker {
  num amount;
  int stakingTime;
  int customStakeDuration;
  bool hasStakedBefore;

  Staker(this.amount, this.stakingTime, this.customStakeDuration,
      this.hasStakedBefore);

  // not including 18 zeroes
  factory Staker.from(List<dynamic> data) => Staker(
      BigInt.parse(data[0].toString()) / tenToEighteenZeroes,
      int.parse(data[1].toString()),
      int.parse(data[2].toString()),
      data[3] as bool);

  @override
  String toString() {
    return 'Staker{amount: $amount, stakingTime: $stakingTime, customStakeDuration: $customStakeDuration, hasStakedBefore: $hasStakedBefore}';
  }
}
