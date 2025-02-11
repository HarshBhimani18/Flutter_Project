import 'package:flutter/material.dart';
import 'package:flutter_app/user.dart'; // Import the User model

class AddUserPage extends StatefulWidget {
  final User? user; // Nullable User for both add and edit
  final Function(User) onUserAdded;

  const AddUserPage({this.user, required this.onUserAdded, Key? key})
      : super(key: key);

  @override
  _AddUserPageState createState() => _AddUserPageState();
}

class _AddUserPageState extends State<AddUserPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  DateTime? _selectedDate;
  String _gender = "Male";
  final List<String> _hobbies = [];
  final List<String> _hobbyOptions = ["Reading", "Traveling", "Gaming", "Music"];

  // Country code list
  final List<String> _countryCodes = ["+1", "+91", "+44", "+81", "+86"];
  String _selectedCountryCode = "+1"; // Default country code

  @override
  void initState() {
    super.initState();

    if (widget.user != null) {
      _nameController.text = widget.user!.name;
      _emailController.text = widget.user!.email;

      List<String> mobileParts = widget.user!.mobile.split(' ');
      if (mobileParts.length >= 2) {
        _selectedCountryCode = mobileParts[0]; // Extract country code
        _mobileController.text = mobileParts.sublist(1).join(' '); // Extract mobile number
      } else {
        _mobileController.text = widget.user!.mobile;
      }

      _selectedDate = widget.user!.dob;
      _gender = widget.user!.gender;
      _hobbies.clear();
      _hobbies.addAll(widget.user!.hobbies);
      _passwordController.text = '';
      _confirmPasswordController.text = '';
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isEditing = widget.user != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? "Edit User" : "Add User"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildTextField(_nameController, "Name", "Enter your name", TextInputType.text),
                const SizedBox(height: 16),
                _buildTextField(_emailController, "Email", "Enter your email", TextInputType.emailAddress),
                const SizedBox(height: 16),
                _buildMobileNumberField(),
                const SizedBox(height: 16),
                _buildDatePicker(context),
                const SizedBox(height: 16),
                _buildGenderDropdown(),
                const SizedBox(height: 16),
                _buildHobbiesSection(),
                const SizedBox(height: 16),
                if (!isEditing) ...[
                  _buildTextField(_passwordController, "Password", "Enter your password", TextInputType.text, isPassword: true),
                  const SizedBox(height: 16),
                  _buildTextField(_confirmPasswordController, "Confirm Password", "Confirm your password", TextInputType.text, isPassword: true),
                  const SizedBox(height: 16),
                ],

                ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: Text(isEditing ? "Update" : "Submit", style: const TextStyle(fontSize: 16)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, String hint, TextInputType keyboardType, {bool isPassword = false}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      keyboardType: keyboardType,
      obscureText: isPassword,
      validator: (value) {
        if (value!.isEmpty) return '$label is required';
        if (label == "Email" && !RegExp(r"^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+$").hasMatch(value)) {
          return 'Enter a valid email';
        }
        if (label == "Password" && value.length < 6) {
          return 'Password must be at least 6 characters long';
        }
        if (label == "Confirm Password" && value != _passwordController.text) {
          return 'Passwords do not match';
        }
        return null;
      },
    );
  }

  Widget _buildMobileNumberField() {
    return Row(
      children: [
        Expanded(flex: 2, child: _buildCountryCodeDropdown()),
        const SizedBox(width: 16),
        Expanded(flex: 5, child: _buildTextField(_mobileController, "Mobile Number", "Enter your mobile number", TextInputType.phone)),
      ],
    );
  }

  Widget _buildCountryCodeDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedCountryCode,
      decoration: InputDecoration(
        labelText: "Country Code",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      items: _countryCodes.map((code) => DropdownMenuItem(value: code, child: Text(code))).toList(),
      onChanged: (value) => setState(() => _selectedCountryCode = value!),
    );
  }

  Widget _buildDatePicker(BuildContext context) {
    return InkWell(
      onTap: () => _selectDate(context),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: "Date of Birth",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(_selectedDate == null ? "Select Date" : "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}", style: const TextStyle(fontSize: 16)),
            const Icon(Icons.calendar_today, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildGenderDropdown() {
    return DropdownButtonFormField<String>(
      value: _gender,
      decoration: InputDecoration(labelText: "Gender", border: OutlineInputBorder(borderRadius: BorderRadius.circular(8))),
      items: ["Male", "Female", "Other"].map((gender) => DropdownMenuItem(value: gender, child: Text(gender))).toList(),
      onChanged: (value) => setState(() => _gender = value!),
    );
  }

  Widget _buildHobbiesSection() {
    return Wrap(
      spacing: 8,
      children: _hobbyOptions.map((hobby) {
        return FilterChip(label: Text(hobby), selected: _hobbies.contains(hobby), onSelected: (selected) {
          setState(() => selected ? _hobbies.add(hobby) : _hobbies.remove(hobby));
        });
      }).toList(),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      widget.onUserAdded(User(name: _nameController.text, email: _emailController.text, mobile: '$_selectedCountryCode ${_mobileController.text}', dob: _selectedDate!, gender: _gender, hobbies: _hobbies));
      Navigator.pop(context);
    }
  }
}
