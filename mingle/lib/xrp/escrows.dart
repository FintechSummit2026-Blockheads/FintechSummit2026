import 'package:xrpl_dart/xrpl_dart.dart';
import 'package:mingle/xrp/quick_wallet.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mingle/config/api_config.dart';



/// Converts a DateTime to Ripple epoch time (seconds since January 1, 2000)
int dateTimeToRippleTime(DateTime dateTime) {
  final rippleEpoch = DateTime.utc(2000, 1, 1);
  return dateTime.difference(rippleEpoch).inSeconds;
}

/// Converts XRP to drops (1 XRP = 1,000,000 drops)
String xrpToDrops(double xrp) {
  return (xrp * 1000000).toInt().toString();
}

/// Creates an escrow transaction on the XRP Ledger

Future<void> escrowCreate({
  required int dateID,
  required QuickWallet yourWallet, 
  required String dateAddr,
  required String dateCondition,
  required int stake,
  required int startTimeEpoch,
  required int endTimeEpoch,
}) async {
  final prefs = await SharedPreferences.getInstance();

  final DateTime finishAfterOneHours = DateTime.fromMillisecondsSinceEpoch(startTimeEpoch);
  final DateTime cancelAfterOnDay = DateTime.fromMillisecondsSinceEpoch(endTimeEpoch);

  final escrowCreate = EscrowCreate(
    account: yourWallet.address,
    destination: dateAddr,
    cancelAfterTime: cancelAfterOnDay,
    finishAfterTime: finishAfterOneHours,
    amount: XRPAmount(BigInt.from(1200)),
    condition: dateCondition,
    signer: XRPLSignature.signer(yourWallet.pubHex),
  );

  print("autfil trnsction");
  await XRPHelper.autoFill(yourWallet.rpc, escrowCreate);
  final blob = escrowCreate.toSigningBlobBytes(yourWallet.toAddress);
  print("sign transction");
  final sig = yourWallet.privateKey.sign(blob);
  print("Set transaction signature");
  escrowCreate.setSignature(sig);
  final trhash = escrowCreate.getHash();
  print("transaction hash: $trhash");
  final sequence = escrowCreate.sequence;
  print("escrow sequence $sequence");

  //// CALL TO DB TO UPDATE THAT I HAVE CREATED ESCROW
  print("regenarate transaction blob with exists signatures");
  print("broadcasting signed transaction blob");
  final trBlob = escrowCreate.toTransactionBlob();
  final result = await yourWallet.rpc.request(XRPRequestSubmit(txBlob: trBlob));
  print("transaction hash: ${result.txJson.hash}");
  print("engine result: ${result.engineResult}");
  print("engine result message: ${result.engineResultMessage}");
  print("is success: ${result.isSuccess}");

  final response = await http.post(
    Uri.parse("${ApiConfig.loginUrl}/acceptDate"),
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'person_email': prefs.getString('email'),
      'date_id': dateID,
      'seq': sequence
    }
  ));
  print("Response $response");
}


/// Finishes an escrow by providing the fulfillment
Future<void> finishEscrow({
  required QuickWallet yourWallet, 
  required String dateAddr,
  required String dateCondition,
  required String dateFulfillment,
  required int sequence
}) async {
  final escrowFinish = EscrowFinish(
    offerSequence: sequence,
    account: yourWallet.address,
    condition: dateCondition,
    fulfillment: dateFulfillment,
    signer: XRPLSignature.signer(yourWallet.pubHex),
    owner: dateAddr,
  );
  await XRPHelper.autoFill(yourWallet.rpc, escrowFinish);

  /// show fee of transaction
  print("fee with fulfillment ${escrowFinish.fee}");
  final blob = escrowFinish.toSigningBlobBytes(yourWallet.toAddress);
  print("sign transction");
  final sig = yourWallet.privateKey.sign(blob);
  print("Set transaction signature");
  escrowFinish.setSignature(sig);
  final trhash = escrowFinish.getHash();
  print("transaction hash: $trhash");
  final trBlob = escrowFinish.toTransactionBlob();
  print("regenarate transaction blob with exists signatures");
  print("broadcasting signed transaction blob");
  final result = await yourWallet.rpc.request(XRPRequestSubmit(txBlob: trBlob));
  print("transaction hash: ${result.txJson.hash}");
  print("engine result: ${result.engineResult}");
  print("engine result message: ${result.engineResultMessage}");
  print("is success: ${result.isSuccess}");
}



Future<void> cancelScrow({
  required QuickWallet yourWallet,
  required int sequence
}
) async {
  final escrowCanncel = EscrowCancel(
    owner: yourWallet.address,
    offerSequence: sequence, 
    account: yourWallet.address,
    signer: XRPLSignature.signer(yourWallet.pubHex),
  );
  print("autfil trnsction");
  await XRPHelper.autoFill(yourWallet.rpc, escrowCanncel);

  final blob = escrowCanncel.toSigningBlobBytes(yourWallet.toAddress);
  print("sign transction");
  final sig = yourWallet.privateKey.sign(blob);
  print("Set transaction signature");
  escrowCanncel.setSignature(sig);
  final trhash = escrowCanncel.getHash();
  print("transaction hash: $trhash");

  print("regenarate transaction blob with exists signatures");
  final trBlob = escrowCanncel.toTransactionBlob();

  print("broadcasting signed transaction blob");
  final result = await yourWallet.rpc.request(XRPRequestSubmit(txBlob: trBlob));
  print("transaction hash: ${result.txJson.hash}");
  print("engine result: ${result.engineResult}");
  print("engine result message: ${result.engineResultMessage}");
  print("is success: ${result.isSuccess}");

  /// https://devnet.xrpl.org/transactions/5524E4376A5066A44747E2764CAEC92379B42B213E2CF1D46880EF0B931DCB41
}