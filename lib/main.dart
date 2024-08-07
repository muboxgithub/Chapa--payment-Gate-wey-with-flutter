import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:chapa_unofficial/chapa_unofficial.dart';

void main() {
  Chapa.configure(privateKey: 'CHASECK_TEST-W6aIJp8ll6ylh37XekxotZyENKaawDQA');
  runApp(
    MaterialApp(
      title: 'chapa paymnet',
      home: Paymnetpage(),
    ),
  );
}

class Paymnetpage extends StatefulWidget {
  const Paymnetpage({super.key});

  @override
  State<Paymnetpage> createState() => _PaymnetpageState();
}

class _PaymnetpageState extends State<Paymnetpage> {
  Future<void> pay() async {
    try {
      // Generate a random transaction reference with a custom prefix
      String txRef = TxRefRandomGenerator.generate(prefix: 'linat');

      // Access the generated transaction reference
      String storedTxRef = TxRefRandomGenerator.gettxRef;

      // Print the generated transaction reference and the stored transaction reference
      if (kDebugMode) {
        print('Generated TxRef: $txRef');
        print('Stored TxRef: $storedTxRef');
      }
      await Chapa.getInstance.startPayment(
          context: context,
          onInAppPaymentSuccess: (successMsg) {
            print('the user sucessfully payed');
          },
          onInAppPaymentError: (errorMsg) {
            // Handle error
            print('error ocurred during the pyment process');
          },
          amount: '200',
          currency: 'ETB',
          txRef: storedTxRef,
          firstName: 'Mubarek',
          lastName: 'Muhammed');
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

//verify the user after paymnt is sucessfull
  Future<void> verify() async {
    Map<String, dynamic> verificationResult =
        await Chapa.getInstance.verifyPayment(
      txRef: TxRefRandomGenerator.gettxRef,
    );
    if (kDebugMode) {
      print(verificationResult);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'pay to linat416',
            ),
            ElevatedButton(
                onPressed: () async {
                  await pay();
                },
                child: const Text("Pay")),
            ElevatedButton(
                onPressed: () async {
                  await verify();
                },
                child: const Text("Verify")),
          ],
        ),
      ),
    );
  }
}
