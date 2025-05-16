import 'package:flutter/material.dart';
import '../utils/dialog_utils.dart';
import '../utils/routes.dart';

class FormScreen extends StatefulWidget {
  const FormScreen({super.key});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  
  String _selectedOption = 'Opción 1';
  final List<String> _options = ['Opción 1', 'Opción 2', 'Opción 3', 'Opción 4'];
  
  bool _acceptTerms = false;
  
  int _selectedRadio = 1;
  
  double _sliderValue = 50;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<bool> _onWillPop() async {
    final shouldPop = await DialogUtils.showExitConfirmationDialog(context);
    if (shouldPop) {
      if (!mounted) return false;
      Navigator.pushReplacementNamed(context, AppRoutes.home);
      return false;
    }
    return false;
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Formulario enviado correctamente'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Formulario'),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nombre completo',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese su nombre';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                
                // Selector desplegable
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Seleccione una opción',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.list),
                  ),
                  value: _selectedOption,
                  items: _options.map((String option) {
                    return DropdownMenuItem<String>(
                      value: option,
                      child: Text(option),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        _selectedOption = newValue;
                      });
                    }
                  },
                ),
                const SizedBox(height: 20),
                
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Checkbox(
                          value: _acceptTerms,
                          onChanged: (bool? value) {
                            setState(() {
                              _acceptTerms = value ?? false;
                            });
                          },
                        ),
                        const Expanded(
                          child: Text('Acepto los términos y condiciones'),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Seleccione una categoría:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        RadioListTile<int>(
                          title: const Text('Categoría 1'),
                          value: 1,
                          groupValue: _selectedRadio,
                          onChanged: (int? value) {
                            setState(() {
                              _selectedRadio = value ?? 1;
                            });
                          },
                        ),
                        RadioListTile<int>(
                          title: const Text('Categoría 2'),
                          value: 2,
                          groupValue: _selectedRadio,
                          onChanged: (int? value) {
                            setState(() {
                              _selectedRadio = value ?? 2;
                            });
                          },
                        ),
                        RadioListTile<int>(
                          title: const Text('Categoría 3'),
                          value: 3,
                          groupValue: _selectedRadio,
                          onChanged: (int? value) {
                            setState(() {
                              _selectedRadio = value ?? 3;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                
                // Slider
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Nivel de satisfacción:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Row(
                          children: [
                            const Icon(Icons.sentiment_very_dissatisfied),
                            Expanded(
                              child: Slider(
                                value: _sliderValue,
                                min: 0,
                                max: 100,
                                divisions: 10,
                                label: _sliderValue.round().toString(),
                                onChanged: (double value) {
                                  setState(() {
                                    _sliderValue = value;
                                  });
                                },
                              ),
                            ),
                            const Icon(Icons.sentiment_very_satisfied),
                          ],
                        ),
                        Center(
                          child: Text(
                            '${_sliderValue.round()}%',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                
                // Botón de enviar
                ElevatedButton.icon(
                  onPressed: _submitForm,
                  icon: const Icon(Icons.send),
                  label: const Text('Enviar Formulario'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                ),
                const SizedBox(height: 10),
                
                // Botón de salir
                OutlinedButton.icon(
                  onPressed: () async {
                    final shouldExit = await DialogUtils.showExitConfirmationDialog(context);
                    if (shouldExit && mounted) {
                      Navigator.pushReplacementNamed(context, AppRoutes.home);
                    }
                  },
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Regresar a Inicio'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
