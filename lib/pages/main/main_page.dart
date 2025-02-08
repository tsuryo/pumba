import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pumba_project/dao/shared_prefs.dart';
import 'package:pumba_project/pages/main/main_page_viewmodel.dart';
import 'package:pumba_project/utils/notifications_manager.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MainViewModel(
        Provider.of<SharedPrefs>(context, listen: false),
      ),
      child: MainPage(),
    );
  }
}

class MainPage extends StatelessWidget {
  static const SPACE = 50.0;
  static const TITLE_TXT_SIZE = 24.0;
  static const SUB_TITLE_TXT_SIZE = 20.0;

  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: [
          Consumer<MainViewModel>(
            builder: (context, vm, child) {
              return vm.helloText != null
                  ? Text(
                      vm.helloText!,
                      style: TextStyle(fontSize: TITLE_TXT_SIZE),
                    )
                  : Center(
                      child: CircularProgressIndicator(),
                    );
            },
          ),
          SizedBox(
            height: SPACE,
          ),
          Consumer<MainViewModel>(
            builder: (context, vm, child) {
              return AnimatedSwitcher(
                duration: Duration(milliseconds: 300),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(opacity: animation, child: child);
                },
                child: vm.isLoadingGeo
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : vm.locationText != null
                        ? Text(
                            vm.locationText!,
                            style: TextStyle(fontSize: SUB_TITLE_TXT_SIZE),
                          )
                        : ElevatedButton(
                            onPressed: () {
                              vm.fetchLocation();
                            },
                            child: Text("Allow location"),
                          ),
              );
            },
          ),
          SizedBox(
            height: SPACE,
          ),
          Consumer<MainViewModel>(
            builder: (context, vm, child) {
              return vm.isDeleting
                  ? Center(
                      child: CircularProgressIndicator(
                        color: Colors.red,
                      ),
                    )
                  : ElevatedButton(
                      onPressed: () {
                        vm.deleteUser();
                      },
                      child: Text(
                        "Delete",
                        style: TextStyle(color: Colors.red),
                      ),
                    );
            },
          ),
          Expanded(
            child: Align(
              alignment: FractionalOffset.bottomCenter,
              child: Consumer<MainViewModel>(
                builder: (context, vm, child) {
                  return vm.shouldShowNotificationBtn
                      ? ElevatedButton(
                          onPressed: () {
                            vm.showNotification();
                          },
                          child: Text("Start"),
                        )
                      : SizedBox.shrink();
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
