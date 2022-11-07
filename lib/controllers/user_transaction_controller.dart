import 'package:get/get.dart';
import 'package:livrodin/controllers/auth_controller.dart';
import 'package:livrodin/controllers/book_controller.dart';
import 'package:livrodin/models/transaction.dart';
import 'package:livrodin/utils/state_machine.dart';

enum TransactionCategoryType {
  progress,
  ordersReceived,
  ordersMade,
  done,
  canceled;

  String get name {
    switch (this) {
      case TransactionCategoryType.progress:
        return "Andamento";
      case TransactionCategoryType.done:
        return "Concluido";
      case TransactionCategoryType.canceled:
        return "Cancelado";
      case TransactionCategoryType.ordersMade:
        return "Pedidos Feitos";
      case TransactionCategoryType.ordersReceived:
        return "Pedidos Recebidos";
    }
  }
}

class UserTransactionController extends GetxController {
  final _bookController = Get.find<BookController>();
  final _authController = Get.find<AuthController>();

  final Rx<FetchState> stateFetch = FetchState.loading.obs;

  RxMap<TransactionType, Map<TransactionCategoryType, List<Transaction>>>
      transactionsByCategory =
      <TransactionType, Map<TransactionCategoryType, List<Transaction>>>{
    TransactionType.donate: {
      TransactionCategoryType.progress: [],
      TransactionCategoryType.done: [],
      TransactionCategoryType.canceled: [],
      TransactionCategoryType.ordersMade: [],
      TransactionCategoryType.ordersReceived: [],
    },
    TransactionType.trade: {
      TransactionCategoryType.progress: [],
      TransactionCategoryType.done: [],
      TransactionCategoryType.canceled: [],
      TransactionCategoryType.ordersMade: [],
      TransactionCategoryType.ordersReceived: [],
    },
  }.obs;

  @override
  void onInit() {
    super.onInit();
    stateFetch.value = FetchState.loading;

    fetchTransactions();
  }

  Map<TransactionCategoryType, List<Transaction>> getTransactionsCategory(
      List<Transaction> transactions, TransactionType type) {
    var filteredTransactions =
        transactions.where((element) => element.type == type).toList();

    final inProgress = filteredTransactions
        .where((element) => element.status == TransactionStatus.inProgress)
        .toList();
    final done = filteredTransactions
        .where((element) => element.status == TransactionStatus.completed)
        .toList();

    final canceled = filteredTransactions
        .where((element) => element.status == TransactionStatus.canceled)
        .toList();

    final ordersMade = filteredTransactions
        .where(
          (element) =>
              element.status == TransactionStatus.pending &&
              element.user2.id == _authController.user.value!.uid,
        )
        .toList();

    final ordersReceived = filteredTransactions
        .where(
          (element) =>
              element.status == TransactionStatus.pending &&
              element.user1.id == _authController.user.value!.uid,
        )
        .toList();

    return <TransactionCategoryType, List<Transaction>>{
      TransactionCategoryType.progress: inProgress,
      TransactionCategoryType.done: done,
      TransactionCategoryType.canceled: canceled,
      TransactionCategoryType.ordersMade: ordersMade,
      TransactionCategoryType.ordersReceived: ordersReceived,
    };
  }

  void fetchTransactions() {
    _bookController.getTransactionsFromUser().then((transactions) {
      transactionsByCategory.value =
          <TransactionType, Map<TransactionCategoryType, List<Transaction>>>{
        TransactionType.donate: getTransactionsCategory(
          transactions,
          TransactionType.donate,
        ),
        TransactionType.trade: getTransactionsCategory(
          transactions,
          TransactionType.trade,
        ),
      };

      stateFetch.value = FetchState.success;
    }).onError((error, stackTrace) {
      stateFetch.value = FetchState.error;
    });
  }
}
