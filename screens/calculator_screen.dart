import 'package:flutter/material.dart';
import '../utils/dialog_utils.dart';
import '../utils/routes.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  final TextEditingController _numero1Controller = TextEditingController();
  final TextEditingController _numero2Controller = TextEditingController();
  String _operacion = 'Suma';
  String _resultado = '';
  bool _operacionSeleccionada = false;

  Future<bool> _onWillPop() async {
    final shouldPop = await DialogUtils.showExitConfirmationDialog(context);
    if (shouldPop) {
      if (!mounted) return false;
      Navigator.pushReplacementNamed(context, AppRoutes.home);
      return false;
    }
    return false;
  }

  void _calcular(String operacion) {
    setState(() {
      _operacionSeleccionada = true;
      _operacion = operacion;

      if (_numero1Controller.text.isEmpty || _numero2Controller.text.isEmpty) {
        _resultado = 'Ingrese ambos números';
        return;
      }

      double num1 = double.tryParse(_numero1Controller.text) ?? 0;
      double num2 = double.tryParse(_numero2Controller.text) ?? 0;
      double result = 0;

      switch (operacion) {
        case 'Suma':
          result = num1 + num2;
          break;
        case 'Resta':
          result = num1 - num2;
          break;
        case 'Multiplicación':
          result = num1 * num2;
          break;
        case 'División':
          if (num2 != 0) {
            result = num1 / num2;
          } else {
            _resultado = 'Error: No se puede dividir entre cero';
            return;
          }
          break;
      }

      if (result == result.toInt()) {
        _resultado = result.toInt().toString();
      } else {
        _resultado = result.toString();
      }
    });
  }

  void _limpiar() {
    setState(() {
      _numero1Controller.clear();
      _numero2Controller.clear();
      _resultado = '';
      _operacion = 'Suma';
      _operacionSeleccionada = false;
    });
  }

  @override
  void dispose() {
    _numero1Controller.dispose();
    _numero2Controller.dispose();
    super.dispose();
  }

  Widget _buildInputField(String label, TextEditingController controller) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).colorScheme.primary),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 6,
            offset: const Offset(2, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 18,
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              style: TextStyle(
                fontSize: 24,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOperationButton(String symbol, String operation) {
    return ElevatedButton(
      onPressed: () => _calcular(operation),
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.primary,
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(16),
        elevation: 6,
        shadowColor: Colors.black.withOpacity(0.2),
      ),
      child: Text(
        symbol,
        style: TextStyle(
          fontSize: 30,
          color: Theme.of(context).colorScheme.onPrimary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Calculadora'),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        body: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background,
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  _buildInputField('Número 1: ', _numero1Controller),
                  const SizedBox(height: 20),
                  _buildInputField('Número 2: ', _numero2Controller),
                  const SizedBox(height: 30),
                  if (_resultado.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surfaceVariant,
                        border: Border.all(color: Theme.of(context).colorScheme.primary),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 6,
                            offset: const Offset(2, 4),
                          ),
                        ],
                      ),
                      width: double.infinity,
                      child: Text(
                        _operacionSeleccionada
                            ? 'Resultado [$_operacion]: $_resultado'
                            : 'Resultado: $_resultado',
                        style: TextStyle(
                          fontSize: 20,
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildOperationButton('+', 'Suma'),
                      _buildOperationButton('-', 'Resta'),
                      _buildOperationButton('×', 'Multiplicación'),
                      _buildOperationButton('÷', 'División'),
                    ],
                  ),
                  const SizedBox(height: 25),
                  ElevatedButton(
                    onPressed: _limpiar,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 6,
                      shadowColor: Colors.black.withOpacity(0.2),
                    ),
                    child: Text(
                      'Limpiar',
                      style: TextStyle(
                        fontSize: 20, 
                        color: Theme.of(context).colorScheme.onPrimary
                      ),
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
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
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}