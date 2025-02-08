import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:provider/provider.dart';
import 'package:pumba_project/dao/shared_prefs.dart';
import 'package:pumba_project/pages/login/login_view_model.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LoginViewModel(
        Provider.of<SharedPrefs>(context, listen: false),
      ),
      child: const LoginPage(),
    );
  }
}

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<LoginViewModel>(context);

    const formFieldPaddingEI = EdgeInsets.all(8.0);
    const errStyle = TextStyle(fontSize: 18.0);
    const borderStyle = OutlineInputBorder(
      borderSide: BorderSide(color: Colors.red),
      borderRadius: BorderRadius.all(Radius.circular(9.0)),
    );

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: vm.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: formFieldPaddingEI,
                child: TextFormField(
                  controller: vm.firstNameController,
                  validator: MultiValidator(
                    [
                      RequiredValidator(
                        errorText: 'First name is mandatory',
                      ),
                      MinLengthValidator(
                        3,
                        errorText: 'Minimum 3 characters',
                      ),
                    ],
                  ).call,
                  decoration: InputDecoration(
                    hintText: 'John',
                    labelText: 'First name',
                    prefixIcon: Icon(
                      Icons.person,
                      color: Colors.green,
                    ),
                    errorStyle: errStyle,
                    border: borderStyle,
                  ),
                ),
              ),
              Padding(
                padding: formFieldPaddingEI,
                child: TextFormField(
                  controller: vm.lastNameController,
                  validator: MultiValidator(
                    [
                      RequiredValidator(
                        errorText: 'Last name is mandatory',
                      ),
                      MinLengthValidator(
                        3,
                        errorText: 'Minimum 3 characters',
                      ),
                    ],
                  ).call,
                  decoration: InputDecoration(
                    hintText: 'Doe',
                    labelText: 'Last name',
                    prefixIcon: Icon(
                      Icons.person,
                      color: Colors.blueAccent,
                    ),
                    errorStyle: errStyle,
                    border: borderStyle,
                  ),
                ),
              ),
              Padding(
                padding: formFieldPaddingEI,
                child: TextFormField(
                  controller: vm.emailController,
                  validator: MultiValidator(
                    [
                      RequiredValidator(
                        errorText: 'Enter email address',
                      ),
                      EmailValidator(
                        errorText: 'Please enter a valid email address',
                      ),
                    ],
                  ).call,
                  decoration: InputDecoration(
                    hintText: 'email@gmail.com',
                    labelText: 'Email',
                    prefixIcon: Icon(
                      Icons.email,
                      color: Colors.lightBlue,
                    ),
                    errorStyle: errStyle,
                    border: borderStyle,
                  ),
                ),
              ),
              Padding(
                padding: formFieldPaddingEI,
                child: DropdownButtonFormField<String>(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select gender';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: 'Select Gender',
                    labelText: 'Gender',
                    prefixIcon: Icon(
                      Icons.transgender,
                      color: Colors.purpleAccent,
                    ),
                    errorStyle: errStyle,
                    border: borderStyle,
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'Male',
                      child: Text('Male'),
                    ),
                    DropdownMenuItem(
                      value: 'Female',
                      child: Text('Female'),
                    ),
                  ],
                  onChanged: (value) {
                    vm.selectedGender = value;
                  },
                ),
              ),
              Padding(
                padding: formFieldPaddingEI,
                child: vm.isLoading
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : Column(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: 40,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueAccent,
                              ),
                              child: Text(
                                'SIGN UP',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22.0,
                                ),
                              ),
                              onPressed: () {
                                vm.registerUser();
                              },
                            ),
                          ),
                          if (vm.errorMsg != null)
                            Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Text(
                                vm.errorMsg!,
                                style: TextStyle(
                                  color: Colors.red,
                                ),
                              ),
                            )
                          else
                            SizedBox.shrink(),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
