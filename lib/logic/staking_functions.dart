import 'package:flutter/material.dart';
import 'package:flutter_web3/ethereum.dart';
import 'package:flutter_web3/ethers.dart';
import 'package:staking_test/models/staker.dart';

import '../pages/components/confirmation_dialog.dart';
import 'constants.dart';
import '../pages/components/helper_widgets.dart';

class StakingFunctions {
  Web3Provider? web3Provider;

  StakingFunctions() {
    if (ethereum != null) {
      web3Provider = Web3Provider(ethereum);
    }
  }

  setReferrer(String address, context) async {
    try {
      if (!(await verifyReferrerAddress(address, context))) {
        return null;
      }

      final writeContract = Contract(
        contractAddress,
        Interface(erc20Abi),
        web3Provider!.getSigner(),
      );

      final tx = await writeContract.send('setReferrer', [address]);

      return tx;
    } catch (e) {
      print(e);
      showToast(context, e.toString());
    }

    return null;
  }

  Future<TransactionResponse?> stake(
      String amountCntrlText, double daysToStake, num bal, context) async {
    try {
      if (!verifyStakeDetails(amountCntrlText, bal, context)) {
        return null;
      }

      bool? isAccepted = await showDialog<bool>(
          context: context,
          builder: (c) => ConfirmationDialog(
              BigInt.from(double.parse(amountCntrlText)), daysToStake));
      if (isAccepted == null || !isAccepted) {
        return null;
      }

      final writeContract = Contract(
        contractAddress,
        Interface(erc20Abi),
        web3Provider!.getSigner(),
      );

      // ignores the digits after the decimal
      BigInt amount =
          BigInt.from(double.parse(amountCntrlText)) * tenToEighteenZeroes;
      int timeInSeconds = daysToStake * 86400 as int;
      print("$amount, $timeInSeconds");

      final tx = await writeContract
          .send('stake', [amount.toString(), timeInSeconds.toString()]);

      return tx;
    } catch (e) {
      print(e);
      showToast(context, e.toString());
    }

    return null;
  }

  withdraw(String daysLeft, BuildContext context) async {
    // Use `Signer` for Read-write contract
    if (double.parse(daysLeft) > 0) {
      showToast(context, "Staking duration not over yet!");
      return null;
    }

    try {
      final writeContract = Contract(
        contractAddress,
        Interface(erc20Abi),
        web3Provider!.getSigner(),
      );

      final tx = await writeContract.send('withdraw', []);

      return tx;
    } catch (e) {
      print(e);
      showToast(context, e.toString());
    }

    return null;
  }

  getStakerInfo(String selectedAddress) async {
    try {
      final readContract = Contract(contractAddress, erc20Abi, web3Provider);
      var stakerInfo =
          await readContract.call<dynamic>('stakers', [selectedAddress]);

      return Staker.from(stakerInfo);
    } catch (e) {
      print(e);
    }

    return null;
  }

  Future<num> fetchBalance() async {
    try {
      print('fetch balance called');
      final readContract = Contract(contractAddress, erc20Abi, web3Provider);
      BigInt balance = await readContract
          .call<BigInt>('balanceOf', [ethereum!.selectedAddress]);

      return balance / tenToEighteenZeroes;
    } catch (e) {
      print(e);
    }

    return 0;
  }

  bool verifyStakeDetails(String amountCntrlText, num bal, context) {
    if (bal == 0) {
      showToast(context, "Insufficient funds");
      return false;
    }

    if (amountCntrlText == "") {
      showToast(context, "Enter the staking amount");
      return false;
    }

    try {
      num amount = double.parse(amountCntrlText);
      BigInt amountToStake =
          BigInt.from(double.parse(amountCntrlText)) * tenToEighteenZeroes;

      if (amount < 1) {
        showToast(context, "Staking amount must be greater than or equal to 1");
        return false;
      }

      if (amount > double.parse(bal.toStringAsFixed(2))) {
        showToast(context, "Insufficient balance");
        return false;
      }
    } catch (e) {
      print(e);
      showToast(context, "Enter valid staking amount");
      return false;
    }

    return true;
  }

  Future<bool> verifyReferrerAddress(String address, context) async {
    try {
      if (address.isEmpty) {
        showToast(context, "Address is empty");
        return false;
      }

      if (!EthUtils.isAddress(address)) {
        showToast(context, "Invalid address");
        return false;
      }

      if (address.toLowerCase() == ethereum!.selectedAddress!.toLowerCase()) {
        showToast(context, "Referrer cannot be self");
        return false;
      }

      // check if already has a referrer
      final readContract = Contract(contractAddress, erc20Abi, web3Provider);
      String referrer = await readContract
          .call<String>('referrers', [ethereum!.selectedAddress]);

      if (referrer != "0x0000000000000000000000000000000000000000") {
        showToast(context, "Referrer already set!");
        return false;
      }
    } catch (e) {
      print(e);
      showToast(context, "Invalid address");
      return false;
    }

    return true;
  }

  getStakerAddresses() async {
    try {
      List<String> stakerAddresses = [];
      final readContract = Contract(contractAddress, erc20Abi, web3Provider);
      var stakerInfo =
          await readContract.call<dynamic>('getAllStakedAddresses');

      for (var addr in stakerInfo) {
        stakerAddresses.add(addr.toString().toLowerCase());
      }

      return stakerAddresses;
    } catch (e) {
      print(e);
    }

    return [];
  }

  subscribeToEvents(connectWallet) {
    if (ethereum!.listenerCount('accountsChanged') == 0 &&
        ethereum!.listenerCount('chainChanged') == 0) {
      // Subscribe to `chainChanged` event
      ethereum!.onChainChanged((chainId) {
        print("Chain changed $chainId");
        connectWallet();
      });

      // Subscribe to `accountsChanged` event.
      ethereum!.onAccountsChanged((accounts) {
        print("Accounts changed $accounts");
        connectWallet();
      });

      // Subscribe to `message` event, need to convert JS message object to dart object.
      ethereum!.on('message', (message) {
        print("message event: ${dartify(message)}");
      });
    }
  }
}
