import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glider/event/BaseEvent.dart';
import 'package:glider/event/FeatureSubscriptionEvent.dart';
import 'package:glider/event/PaymentEvent.dart';
import 'package:glider/event/UserSubscriptionEvent.dart';
import 'package:glider/repo/PaymentRepo.dart';
import 'package:glider/state/BaseState.dart';
import 'package:glider/state/DoneState.dart';
import 'package:glider/state/ErrorState.dart';
import 'package:glider/state/GatewayPaymentState.dart';
import 'package:glider/state/OtpState.dart';
import 'package:stripe_payment/stripe_payment.dart';

class PaymentBloc extends Bloc<BaseEvent, BaseState> {
  @override
  // TODO: implement initialState
  BaseState get initialState => LoadingState();

  @override
  Stream<BaseState> mapEventToState(BaseEvent event) async* {
    if (event is PaymentEvent) {
      yield ProgressDialogState();

      var cardInfo = event.cardInfo;
      var card = CreditCard();
      card.name = cardInfo.name;
      card.number = cardInfo.cardNumber;
      card.cvc = cardInfo.cvv;
      card.expMonth = int.parse(cardInfo.validate.split("/")[0]);
      card.expYear = int.parse(cardInfo.validate.split("/")[1]);
      var paymentSecret =
          await getStripePaymentSecret(event.packageId, event.note);
      String clientSecret = paymentSecret.data.clientSecret;
      try {
        var paymentMethod = await StripePayment.createPaymentMethod(
            PaymentMethodRequest(card: card));
        var result = await StripePayment.confirmPaymentIntent(PaymentIntent(
            clientSecret: clientSecret, paymentMethodId: paymentMethod.id));
        yield GatewayPaymentState(result.toJson().toString());
      } catch (ex) {
        yield ErrorState(ex.toString());
      }
    } else if (event is FeatureSubscriptionEvent) {
      yield ProgressDialogState();
      var res = await subscribeFeatureGlider(
          event.productId, event.subscriptionid, event.details);
      yield DoneState(res);
    } else if (event is UserSubscriptionEvent) {
      yield ProgressDialogState();
      var res = await subscribeUser(event.subscriptionid, event.details);
      yield DoneState(res);
    }
  }
}
