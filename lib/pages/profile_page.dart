import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trade/UIs/custom_button.dart';
import 'package:trade/UIs/custom_tabs.dart';
import 'package:trade/UIs/custom_textfield.dart';
import 'package:trade/colors.dart';
import 'package:trade/firebase/auth.dart';
import 'package:trade/providers/provider_auth.dart';
import 'package:trade/simple_uis.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with AutomaticKeepAliveClientMixin<ProfilePage> {
  bool? isUser;
  User? user;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Auth().getUserToProvider(context);
      setState(() {
        isUser = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    user = Provider.of<ProviderAuth>(context).user;
    if (isUser == null) {
      return SimpleUIs.progressIndicator();
    } else if (user != null) {
      return WidgetUser(
        user: user!,
      );
    } else {
      return const WidgetSignInUp();
    }
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

class WidgetUser extends StatelessWidget {
  const WidgetUser({
    Key? key,
    required this.user,
  }) : super(key: key);

  final User user;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          widgetProfilePhoto(context),
          Text(
            user.displayName ?? "User Name and Surname",
            style: Theme.of(context)
                .textTheme
                .headline5!
                .copyWith(fontWeight: FontWeight.w600),
          ),
          const Spacer(),
          TextButton.icon(
            onPressed: () => Auth().logOut(context),
            icon: const Icon(Icons.logout),
            label: const Text("Log Out"),
          ),
        ],
      ),
    );
  }

  Container widgetProfilePhoto(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 4,
      height: MediaQuery.of(context).size.width / 4,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color3,
        border: Border.all(color: Colors.black),
      ),
      child: const FittedBox(
        fit: BoxFit.cover,
        child: Padding(
          padding: EdgeInsets.all(4.0),
          child: Text(
            "A",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}

class WidgetSignInUp extends StatefulWidget {
  const WidgetSignInUp({
    Key? key,
  }) : super(key: key);

  @override
  State<WidgetSignInUp> createState() => _WidgetSignInUpState();
}

class _WidgetSignInUpState extends State<WidgetSignInUp> {
  TextEditingController tECEmail = TextEditingController();
  TextEditingController tECPassword = TextEditingController();
  TextEditingController tECDisplayName = TextEditingController();

  int selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomTabs(
                onChange: (val) {
                  setState(() {
                    selectedTab = val;
                  });
                },
                titles: const ['Sign In', 'Sign Up']),
          ),
          CustomTextField(
            labelText: "Email",
            controller: tECEmail,
          ),
          Visibility(
            visible: selectedTab == 1,
            child: CustomTextField(
              labelText: "Name & Surname",
              controller: tECDisplayName,
            ),
          ),
          CustomTextField(
            controller: tECPassword,
            labelText: "Password",
          ),
          Visibility(
            visible: selectedTab == 0,
            child: CustomButton(
                text: "SIGN IN",
                onTap: () => Auth.logIn(
                    context: context,
                    emailAddress: tECEmail.text.trim(),
                    password: tECPassword.text.trim())),
          ),
          Visibility(
            visible: selectedTab == 1,
            child: CustomButton.outlined(
              textOutlined: "SIGN UP",
              onTap: () {
                Auth.signUp(
                    context: context,
                    displayName: tECDisplayName.text.trim(),
                    emailAddress: tECEmail.text.trim(),
                    password: tECPassword.text.trim());
              },
            ),
          ),
        ],
      ),
    );
  }
}
