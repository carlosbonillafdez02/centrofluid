import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fl_centro_fluid/models/models.dart';
import 'package:fl_centro_fluid/providers/providers.dart';
import 'package:fl_centro_fluid/screens/register_screen.dart';
import 'package:fl_centro_fluid/services/services.dart';
import 'package:fl_centro_fluid/widgets/widgets.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.teal.shade900, Colors.teal.shade400],
            ),
          ),
          padding: EdgeInsets.all(20.0),
          child: Center(
            child: ChangeNotifierProvider(
              create: (_) => LoginFormProvider(),
              child: _LoginForm(),
            ),
          ),
        ),
      ),
    );
  }
}

class _LoginForm extends StatelessWidget {
  void login(LoginFormProvider loginForm, context) async {
    if (loginForm.isLoading) return;
    FocusScope.of(context).unfocus();
    if (!loginForm.isValidForm()) return;

    loginForm.isLoading = true;

    await tryLogin(loginForm, context);
  }

  Future<void> tryLogin(LoginFormProvider loginForm, context) async {
    final authService = Provider.of<AuthService>(context, listen: false);
    final usuariosService =
        Provider.of<UsuariosService>(context, listen: false);
    final conectadoProvider =
        Provider.of<ConnectedUserProvider>(context, listen: false);

    final String? errorMessage =
        await authService.login(loginForm.email, loginForm.password);

    if (errorMessage == null) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('user', loginForm.email);
      prefs.setString('password', loginForm.password);

      Usuario? activeUser =
          await usuariosService.getUsuarioByEmail(loginForm.email);

      if (activeUser != null) {
        conectadoProvider.activeUser = activeUser;
        Navigator.pushReplacementNamed(context, 'navbar');
      } else {
        // Handle case where activeUser is null
      }
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Usuario o contraseña incorrectos'),
          );
        },
      );
      loginForm.isLoading = false;
    }
  }

  void biometricLogin(LoginFormProvider loginForm, context) async {
    LocalAuthentication auth = LocalAuthentication();
    // bool deviceSupported = await auth.isDeviceSupported();

    //List<BiometricType> availableBiometrics = await auth.getAvailableBiometrics();

    try {
      bool authenticated = await auth.authenticate(
          localizedReason:
              'Bienvenido, puedes iniciar sesión con tu huella dactilar',
          options: const AuthenticationOptions(
            stickyAuth: true,
            biometricOnly: true,
          ));
      if (authenticated) {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        if (prefs.containsKey('user') && prefs.containsKey('password')) {
          loginForm.email = prefs.getString('user')!;
          loginForm.password = prefs.getString('password')!;
          await tryLogin(loginForm, context);
        } else {
          showDialog(
            context: context,
            builder: (context) {
              return const AlertDialog(
                title:
                    Text('No hay credenciales almacenadas en el dispositivo'),
              );
            },
          );
        }
      }
    } on PlatformException catch (e) {
      // Handle platform exceptions
      print(e);
    }
  }

  _LoginForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final LoginFormProvider loginForm = Provider.of<LoginFormProvider>(context);
    return Form(
      key: loginForm.formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: [
          const SizedBox(height: 40),
          Image.asset(
            'assets/logo-centro-invertido.png',
            width: 180,
            height: 180,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 40),
          const Text(
            "Centro Fluid",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 40),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.0),
            child: TextFormField(
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              obscureText: false,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Email",
                hintStyle: TextStyle(color: Colors.white),
                suffixIcon: Icon(Icons.person, color: Colors.white),
                filled: true,
                fillColor: Colors.white.withOpacity(0.3),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) => loginForm.email = value,
              validator: (value) {
                String pattern =
                    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                RegExp regExp = new RegExp(pattern);

                return regExp.hasMatch(value ?? '')
                    ? null
                    : 'Introduce un correo válido';
              },
            ),
          ),
          const SizedBox(height: 40),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.0),
            child: TextFormField(
              autocorrect: false,
              obscureText: true,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Contraseña",
                hintStyle: TextStyle(color: Colors.white),
                suffixIcon: Icon(Icons.lock, color: Colors.white),
                filled: true,
                fillColor: Colors.white.withOpacity(0.3),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) => loginForm.password = value,
              validator: (value) {
                return (value != null && value.length >= 6)
                    ? null
                    : 'La contraseña debe tener al menos 6 caracteres';
              },
            ),
          ),
          const SizedBox(height: 30),
          SimpleButton(
            onTap: () => login(loginForm, context),
            text: loginForm.isLoading ? "Espere" : "Iniciar sesión",
          ),
          /*const SizedBox(height: 10),
          SimpleButton(
            onTap: () => biometricLogin(loginForm, context),
            text: "Utilizar huella",
          ),
          const SizedBox(height: 10),
          SignInButton(
            Buttons.Google,
            text: "Iniciar sesión con Google",
            onPressed: () {
              // Agrega aquí la funcionalidad para iniciar sesión con Google
            },
          ),*/
          const SizedBox(height: 30),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Divider(
                    thickness: 0.5,
                    color: Colors.white,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    "¿No eres miembro?",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RegisterScreen(),
                      ),
                    );
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      "Regístrate",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Divider(
                    thickness: 0.5,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PasswordWidget extends StatelessWidget {
  const PasswordWidget({
    Key? key,
    required this.loginForm,
  }) : super(key: key);

  final LoginFormProvider loginForm;

  @override
  Widget build(BuildContext context) {
    return PasswordTextField(
      onChanged: (value) => loginForm.password = value,
      validator: (value) {
        return (value != null && value.length >= 6)
            ? null
            : "La contraseña debe tener como minimo 6 caracteres";
      },
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: "Contraseña",
        hintStyle: TextStyle(color: Colors.white),
        suffixIcon: Icon(Icons.lock, color: Colors.white),
        filled: true,
        fillColor: Colors.white.withOpacity(0.3),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
