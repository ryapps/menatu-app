import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:menatu_app/controllers/auth_service.dart';
import 'package:menatu_app/controllers/send_otp.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  final formKey = GlobalKey<FormState>();

  TextEditingController _phoneController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 80,
        backgroundColor: Theme.of(context).primaryColor,
        leading: IconButton(
            style: ButtonStyle(
                padding: WidgetStatePropertyAll(EdgeInsets.all(10)),
                backgroundColor: WidgetStatePropertyAll(Colors.white)),
            onPressed: Navigator.of(context).pop,
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            )),
      ),
      backgroundColor: Theme.of(context).primaryColor,
      body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 220,
                child: Text(
                  'Lupa Password',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 22),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Container(
                width: 230,
                child: Text(
                  'Masukkan nomor telepon anda dengan benar',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.normal,
                      fontSize: 12),
                ),
              ),
              SizedBox(
                height: 25,
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15)),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 30),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Nomor telepon',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * .9,
                        child: TextFormField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(10)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Theme.of(context).primaryColor,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(10)),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey.shade300,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(10)),
                              hintText: 'Masukkan nomor telepon',
                              hintStyle: TextStyle(
                                color: Colors.grey.shade400,
                              )),
                          validator: (value) {
                            // Validasi nomor telepon harus dimulai dengan +62
                            if (value == null || value.isEmpty) {
                              return 'Nomor telepon tidak boleh kosong';
                            } else if (!value.startsWith('+62')) {
                              return 'Nomor harus dimulai dengan +62';
                            } else if (value.length < 10 || value.length > 15) {
                              return 'Nomor telepon tidak valid';
                            }
                            return null; // Nomor valid
                          },
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                              onPressed: () {},
                              child: Text(
                                'Lupa password?',
                                style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600),
                              ))
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                          width: MediaQuery.of(context).size.width * .9,
                          child: ElevatedButton(
                            style: ButtonStyle(
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadiusDirectional.circular(
                                                10))),
                                backgroundColor: MaterialStateProperty.all(
                                    Theme.of(context).primaryColor)),
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                // Jika valid, kirim OTP ke nomor telepon
                                sendOTP(_phoneController.text, context);
                              }
                            },
                            child: Text(
                              'Kirim Kode OTP',
                              style: TextStyle(color: Colors.white),
                            ),
                          )),
                      SizedBox(
                        height: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Belum Punya Akun?",
                            style: TextStyle(fontSize: 12),
                          ),
                          TextButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/signup');
                              },
                              child: Text(
                                'Daftar',
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.bold),
                              ))
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
