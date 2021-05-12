import 'package:credit_card_input_form/constants/constanst.dart';
import 'package:credit_card_input_form/credit_card_input_form.dart';
import 'package:credit_card_input_form/model/card_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutterwave/core/flutterwave.dart';
import 'package:flutterwave/models/responses/charge_response.dart';
import 'package:flutterwave/utils/flutterwave_constants.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:glider/bloc/PaymentBloc.dart';
import 'package:glider/config/app_config.dart' as config;
import 'package:glider/event/FeatureSubscriptionEvent.dart';
import 'package:glider/event/PaymentEvent.dart';
import 'package:glider/event/UserSubscriptionEvent.dart';
import 'package:glider/generated/l10n.dart';
import 'package:glider/model/FeatureSubscriptionList.dart';
import 'package:glider/screen/payment/SelectPaymentMethodScreen.dart'
    as payment;
import 'package:glider/state/DoneState.dart';
import 'package:glider/state/ErrorState.dart';
import 'package:glider/state/GatewayPaymentState.dart';
import 'package:glider/state/OtpState.dart';
import 'package:glider/util/CommonConstant.dart';
import 'package:glider/util/Utils.dart';
import 'package:glider/widget/ProgressDialog.dart';
import 'package:stripe_payment/stripe_payment.dart';

class PaymentScreen extends StatefulWidget {
  final Feature feature;
  final payment.PaymentMethod type;

  final String productId;

  PaymentScreen(this.productId, this.feature, this.type);

  @override
  State<StatefulWidget> createState() {
    return PaymentScreenState();
  }
}

class PaymentScreenState extends State<PaymentScreen> {
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;
  final buttonStyle = BoxDecoration(
      borderRadius: BorderRadius.circular(30.0),
      color: config.Colors().orangeColor);

  final buttonTextStyle =
      TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18);

  var paymentBloc = PaymentBloc();

  ProgressDialog dialog;
  Razorpay _razorpay;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.type == payment.PaymentMethod.Stripe) {
      initStripe();
    } else if (widget.type == payment.PaymentMethod.RazorPay) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        startRazorPay();
      });
    } else if (widget.type == payment.PaymentMethod.Flutterwave) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        startFlutterwave();
      });
    }

    paymentBloc.listen((state) {
      if (state is ProgressDialogState) {
        dialog = ProgressDialog(context, isDismissible: true);
        dialog.show();
      } else {
        if (dialog != null && dialog.isShowing()) {
          dialog.hide();
        }
        if (state is DoneState) {
          Fluttertoast.showToast(msg: state.home.message);
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        } else if (state is GatewayPaymentState) {
          updateToServer(state.result);
        } else if (state is ErrorState) {
          Fluttertoast.showToast(msg: state.home);
        }
      }
    });
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void updateToServer(String msg) {
    if (widget.productId != null) {
      paymentBloc.add(
          FeatureSubscriptionEvent(widget.productId, widget.feature.id, msg));
    } else {
      paymentBloc.add(UserSubscriptionEvent(widget.feature.id, msg));
    }
  }

  void initStripe() {
    StripePayment.setOptions(
        StripeOptions(publishableKey: CommonConstant.STRIPE_KEY));
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.all(10),
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: CreditCardInputForm(
                showResetButton: true,
                onStateChange: (currentState, CardInfo cardInfo) {
                  if (currentState == InputState.DONE) {
                    stripPayment(cardInfo);
                  }
                },
                resetButtonDecoration: buttonStyle,
                resetButtonTextStyle: buttonTextStyle,
                nextButtonDecoration: buttonStyle,
                prevButtonDecoration: buttonStyle,
                prevButtonTextStyle: buttonTextStyle,
                nextButtonTextStyle: buttonTextStyle,
              ),
            ),
          )
        ],
      ),
    );
  }

  void stripPayment(CardInfo cardInfo) {
    var paymentEvent = PaymentEvent(payment.PaymentMethod.Stripe,
        cardInfo: cardInfo,
        packageId: widget.feature.id,
        note: "For product " + DateTime.now().toString());
    paymentBloc.add(paymentEvent);
  }

  void startRazorPay() async {
    var user = await Utils.getUser();
    var options = {
      'key': CommonConstant.RAZOR_PAY_KEY,
      'amount': int.parse(widget.feature.price) * 100,
      'currency': "INR",
      'name': "glider",
      'payment_capture': true,
      'description': 'Order for product' + widget.feature.title,
      'prefill': {'contact': '', 'email': user.data.email},
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint(e);
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    Fluttertoast.showToast(
        msg: "SUCCESS: " + response.paymentId, timeInSecForIosWeb: 4);
    updateToServer(response.paymentId);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(
        msg: "ERROR: " + response.code.toString() + " - " + response.message,
        timeInSecForIosWeb: 4);
    Navigator.of(context).pop();
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
        msg: "EXTERNAL_WALLET: " + response.walletName, timeInSecForIosWeb: 4);
  }

  void startFlutterwave() async {
    var user = await Utils.getUser();

    try {
      var txRefId;
      txRefId = DateTime.now().toString();
      Flutterwave flutterwave = Flutterwave.forUIPayment(
          context: this.context,
          encryptionKey: CommonConstant.FLUTTER_WAVE_ENCRYPTION_KEY,
          publicKey: CommonConstant.FLUTTER_WAVE_PUBLIC_KEY,
          amount: widget.feature.price,
          email: user.data.email,
          currency: "USD",
          txRef: txRefId,
          fullName: user.data.name,
          isDebugMode: true,
          phoneNumber: "",
          narration: S.of(context).subscription,
          acceptCardPayment: true,
          acceptUSSDPayment: false,
          acceptAccountPayment: true,
          acceptFrancophoneMobileMoney: false,
          acceptGhanaPayment: false,
          acceptMpesaPayment: false,
          acceptRwandaMoneyPayment: false,
          acceptUgandaPayment: false,
          acceptZambiaPayment: false);

      final ChargeResponse response =
          await flutterwave.initializeForUiPayments();
      if (checkPaymentIsSuccessful(response)) {
        updateToServer(response.data.toString());
      } else {
        Navigator.of(context).pop();
        Fluttertoast.showToast(msg: response.message);
      }
    } catch (error) {
      Navigator.of(context).pop();
      Fluttertoast.showToast(msg: error.toString());
    }
  }

  bool checkPaymentIsSuccessful(final ChargeResponse response) {
    return response.data.status == FlutterwaveConstants.SUCCESSFUL;
  }
// startPayment();
}
