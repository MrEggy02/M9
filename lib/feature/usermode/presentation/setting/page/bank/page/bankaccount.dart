import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m9/core/constants/app_constants.dart';
import 'package:m9/feature/auth/cubit/auth_cubit.dart';
import 'package:m9/feature/auth/cubit/auth_state.dart';
import 'package:m9/feature/usermode/presentation/setting/page/bank/page/addbank.dart';
import 'package:m9/feature/usermode/presentation/setting/page/bank/page/editbank.dart';
import 'package:m9/feature/usermode/presentation/setting/page/bank/widget/bankheader.dart';
import 'package:m9/feature/usermode/presentation/setting/page/bank/widget/detail.dart';


class BankAccountsPage extends StatefulWidget {
  const BankAccountsPage({super.key});

  @override
  State<BankAccountsPage> createState() => _BankAccountsPageState();
}

class _BankAccountsPageState extends State<BankAccountsPage> {
  final String baseImageUrl = AppConstants.imageUrl;
  @override
  void initState() {
    super.initState();
    _loadBankAccount();
  }

  Future<void> _loadBankAccount() async {
    await context.read<AuthCubit>().fetchBankAccount();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leadingWidth: 120,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Row(
            children: [
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: () => Navigator.pop(context),
              ),
              const Text(
                'ກັບຄືນ',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ],
          ),
        ),
        title: const Text(
          'ບັນຊີທະນາຄານ',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: _loadBankAccount,
        child: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state.authStatus == AuthStatus.failure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error ?? 'Unknown error')),
              );
            }
          },
          builder: (context, state) {
            if (state.authStatus == AuthStatus.loading &&
                state.bankAccount == null) {
              return const Center(child: CircularProgressIndicator());
            }

            final account = state.bankAccount;

            // Show empty state if no account exists
            if (account == null) {
              return _buildEmptyState(context);
            }

            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  BankAccountHeader(account: account),
                  const SizedBox(height: 16),
                  BankAccountDetails(
                    account: account,
                    onEdit: () => _navigateToEditPage(context, account),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/usermode/car.png',
            width: 120,
            height: 120,
            color: const Color(0xFFFECE0C),
          ),
          const SizedBox(height: 20),
          const Text(
            'ຍັງບໍ່ມີບັນຊີທະນາຄານ',
            style: TextStyle(fontSize: 16, color: Colors.black54),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddBankAccountPage(),
                ),
              );
              if (result == true && context.mounted) {
                await _loadBankAccount();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFECE0C),
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('ເພີ່ມບັນຊີໃໝ່'),
          ),
        ],
      ),
    );
  }

  void _navigateToEditPage(BuildContext context, account) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditBankAccountPage(account: account),
      ),
    );

    if (result == true && context.mounted) {
      await _loadBankAccount();
    }
  }
}
