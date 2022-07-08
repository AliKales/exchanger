import 'package:cloud_functions/cloud_functions.dart';

class Functions {
  Future<void> getFruit() async {
    final results =
        await FirebaseFunctions.instanceFor(region: 'us-central1')
            .httpsCallable('listFruit').call();

    print(results.data);
  }
}
