import 'package:fl_centro_fluid/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:fl_centro_fluid/models/models.dart';
import 'package:fl_centro_fluid/providers/providers.dart';
import 'package:fl_centro_fluid/services/services.dart';
import 'package:fl_centro_fluid/widgets/widgets.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registro'),
      ),
      // drawer: MiMenuDesplegable(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            child: Center(
              child: ChangeNotifierProvider(
                create: (_) => RegisterFormProvider(),
                child: _RegisterForm(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RegisterForm extends StatelessWidget {
  void register(RegisterFormProvider registerForm, context) async {
    if (registerForm.isLoading) return;
    FocusScope.of(context).unfocus();
    final authService = Provider.of<AuthService>(context, listen: false);
    Provider.of<UsuariosService>(context, listen: false);
    if (!registerForm.isValidForm()) return;

    registerForm.isLoading = true;

    final String? errorMessage =
        await authService.createUser(registerForm.email, registerForm.password);
    if (errorMessage == null) {
      // String response = await usuariosService.saveUsuario(generateUsuario(registerForm));
      registerForm.isLoading = false;
      Navigator.pushReplacementNamed(context, 'login');
    } else {
      //print(errorMessage);
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('No se ha podido crear la cuenta, $errorMessage'),
          );
        },
      );
      registerForm.isLoading = false;
    }
  }

  Usuario generateUsuario(RegisterFormProvider registerForm) {
    return Usuario(
      email: registerForm.email,
      nombre: registerForm.nombre,
      apellido: registerForm.apellido,
      telefono: registerForm.telefono,
      direccion: registerForm.direccion,
      codigoPostal: registerForm.codigoPostal,
    );
  }

  const _RegisterForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final RegisterFormProvider registerForm =
        Provider.of<RegisterFormProvider>(context);
    return Form(
      key: registerForm.formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: [
          const SizedBox(height: 40),
          // Logo
          Image.asset(
            'assets/logo-centro.png',
            width: 180,
            height: 180,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 40),
          Text(
            "Bienvenido/a a Centro Fluid",
            style: TextStyle(
                fontSize: 24,
                color: AppTheme.primary,
                fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 40),
          // Nombre
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: TextFormField(
              keyboardType: TextInputType.name,
              textCapitalization: TextCapitalization.words,
              obscureText: false,
              decoration: const InputDecoration(
                hintText: "Nombre",
                suffixIcon: Icon(Icons.person),
              ),
              onChanged: (value) => registerForm.nombre = value,
              validator: (value) {
                return (value ?? '').length >= 2
                    ? null
                    : "Introduce un nombre válido";
              },
            ),
          ),

          const SizedBox(height: 10),
          // Apellido
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: TextFormField(
              keyboardType: TextInputType.name,
              textCapitalization: TextCapitalization.words,
              obscureText: false,
              decoration: const InputDecoration(
                hintText: "Apellido",
                suffixIcon: Icon(Icons.person),
              ),
              onChanged: (value) => registerForm.apellido = value,
              validator: (value) {
                return (value ?? '').isNotEmpty
                    ? null
                    : "Introduce un apellido válido";
              },
            ),
          ),

          const SizedBox(height: 10),
          // Password
          PasswordTextField(
            onChanged: (value) => registerForm.password = value,
            validator: (value) {
              return (value != null && value.length >= 6)
                  ? null
                  : "La contraseña debe tener al menos 6 caracteres";
            },
            style: const TextStyle(),
            decoration: InputDecoration(),
          ),

          const SizedBox(height: 10),

          // Email
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: TextFormField(
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              obscureText: false,
              decoration: const InputDecoration(
                hintText: "Email",
                suffixIcon: Icon(Icons.mail_rounded),
              ),
              onChanged: (value) => registerForm.email = value,
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

          const SizedBox(height: 10),

          // Teléfono
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: TextFormField(
              keyboardType: TextInputType.phone,
              obscureText: false,
              decoration: const InputDecoration(
                hintText: "Teléfono",
                suffixIcon: Icon(Icons.phone),
              ),
              onChanged: (value) => registerForm.telefono = value,
              validator: (value) {
                return (value != null && value.length >= 9)
                    ? null
                    : "Introduce un número de teléfono válido";
              },
            ),
          ),

          const SizedBox(height: 10),
          // Direccion
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: TextFormField(
              keyboardType: TextInputType.streetAddress,
              obscureText: false,
              decoration: const InputDecoration(
                hintText: "Dirección",
                suffixIcon: Icon(Icons.location_on),
              ),
              onChanged: (value) => registerForm.direccion = value,
              validator: (value) {
                return (value ?? '').isNotEmpty
                    ? null
                    : "Introduce una dirección válida";
              },
            ),
          ),

          const SizedBox(height: 10),

          // Codigo Postal
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: TextFormField(
              keyboardType: TextInputType.number,
              obscureText: false,
              decoration: const InputDecoration(
                hintText: "Código Postal",
                suffixIcon: Icon(Icons.code),
              ),
              onChanged: (value) => registerForm.codigoPostal = value,
              validator: (value) {
                return (value != null && value.length == 5)
                    ? null
                    : "Introduce un código postal válido";
              },
            ),
          ),
          const SizedBox(height: 10),
          // Sign in
          SimpleButton(
            onTap: () => register(registerForm, context),
            text: registerForm.isLoading ? "Espere" : "Registrarse",
          ),
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Expanded: Ocupa Toda la fila
                Expanded(
                  child: Divider(
                    thickness: 0.5,
                    color: Colors.grey[400],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    "¿Ya tienes cuenta?",
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pushReplacementNamed(context, 'login'),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      "Inicia sesión",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Divider(
                    thickness: 0.5,
                    color: Colors.grey[400],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
