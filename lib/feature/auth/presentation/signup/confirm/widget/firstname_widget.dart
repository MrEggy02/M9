// lib/presentation/widgets/phone_input_field.dart
// ຮັກສາຄວາມສອດຄ່ອງຂອງຄອມໂພເນັນ

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m9/feature/auth/cubit/auth_cubit.dart';
import 'package:m9/feature/auth/cubit/auth_state.dart';

class FirstnameWidget extends StatefulWidget {
  const FirstnameWidget({super.key});

  @override
  State<FirstnameWidget> createState() => _FirstnameWidgetState();
}

class _FirstnameWidgetState extends State<FirstnameWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state.authStatus == AuthStatus.failure) {
          print('login error=>${state.error}');
        }
      },
      builder: (context, state) {
        var cubit = context.read<AuthCubit>();

        return Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8),
                    bottomLeft: Radius.circular(8),
                  ),
                ),
                child: const Icon(Icons.person, color: Colors.black),
              ),
              const SizedBox(width: 10),
            
            
              Expanded(
                child: TextFormField(
                  controller: cubit.firstName,
                 
                
                  decoration: InputDecoration(
                    hintText: 'ປ້ອນຊື່',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 10,
                    ),
                    
                  ),
                  keyboardType: TextInputType.name,
                ),
              ),
            ],
          ),
        );
     
      },
    );
  }
}
