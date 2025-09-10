import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dynamic_icon_plus/flutter_dynamic_icon_plus.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dynamic Icon Plus Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: DynamicIconDemo(),
    );
  }
}

class DynamicIconDemo extends StatefulWidget {
  const DynamicIconDemo({super.key});

  @override
  _DynamicIconDemoState createState() => _DynamicIconDemoState();
}

class _DynamicIconDemoState extends State<DynamicIconDemo> {
  int _batchIconNumber = 0;
  String _currentIconName = "Default";
  bool _isSupported = true;
  bool _loading = false;
  final TextEditingController _badgeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _checkSupport();
    _getCurrentIcon();
    _getBadgeNumber();
  }

  @override
  void dispose() {
    _badgeController.dispose();
    super.dispose();
  }

  // Check if dynamic icon changing is supported on this device
  Future<void> _checkSupport() async {
    try {
      bool isSupported = await FlutterDynamicIconPlus.supportsAlternateIcons;
      setState(() {
        _isSupported = isSupported;
      });
    } catch (e) {
      print('Error checking support: $e');
    }
  }

  // Get current icon information
  Future<void> _getCurrentIcon() async {
    try {
      String? iconName = await FlutterDynamicIconPlus.alternateIconName;
      setState(() {
        _currentIconName = iconName ?? "Default";
      });
    } catch (e) {
      print('Error getting current icon: $e');
    }
  }

  // Get current badge number (iOS only)
  Future<void> _getBadgeNumber() async {
    if (Platform.isIOS) {
      try {
        int badgeNumber =
            await FlutterDynamicIconPlus.applicationIconBadgeNumber;
        setState(() {
          _batchIconNumber = badgeNumber;
        });
      } catch (e) {
        print('Error getting badge number: $e');
      }
    }
  }

  // Change app icon
  Future<void> _changeIcon(String iconName, String displayName) async {
    try {
      if (_isSupported) {
        setState(() {
          _loading = true;
        });

        await FlutterDynamicIconPlus.setAlternateIconName(
          iconName: iconName,
          blacklistBrands: ['Redmi'],
          blacklistManufactures: ['Xiaomi'],
          blacklistModels: ['Redmi 200A'],
        );

        setState(() {
          _currentIconName = iconName;
          _loading = false;
        });
        _showSnackBar('Icon changed to: $displayName');
      } else {
        _showSnackBar('Dynamic icons not supported on this device');
      }
    } catch (e) {
      setState(() {
        _loading = false;
      });
      _showSnackBar('Error changing icon: $e');
      print('Error changing icon: $e');
    }
  }

  // Set badge number (iOS only)
  Future<void> _setBadgeNumber() async {
    if (Platform.isIOS && _badgeController.text.isNotEmpty) {
      try {
        setState(() {
          _loading = true;
        });

        int badgeNumber = int.parse(_badgeController.text);
        await FlutterDynamicIconPlus.setApplicationIconBadgeNumber(badgeNumber);

        int newBadgeNumber =
            await FlutterDynamicIconPlus.applicationIconBadgeNumber;
        setState(() {
          _batchIconNumber = newBadgeNumber;
          _loading = false;
        });
        _showSnackBar('Badge number updated successfully');
      } on PlatformException {
        setState(() {
          _loading = false;
        });
        _showSnackBar('Failed to change badge number');
      } catch (e) {
        setState(() {
          _loading = false;
        });
        _showSnackBar('Failed to change badge number');
      }
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: Duration(seconds: 3)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Dynamic Icon Plus Demo'), centerTitle: true),
      body: Container(
        padding: EdgeInsets.all(20),
        child: ListView(
          children: [
            // Support Status Card
            Card(
              elevation: 4,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Icon(
                      _isSupported ? Icons.check_circle : Icons.error,
                      color: _isSupported ? Colors.green : Colors.red,
                      size: 48,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Dynamic Icons: ${_isSupported ? "Supported" : "Not Supported"}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 20),

            // iOS Badge Number Section
            if (Platform.isIOS) ...[
              Card(
                elevation: 4,
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(
                        'Current Badge Number: $_batchIconNumber',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16),
                      TextField(
                        controller: _badgeController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'\d+')),
                        ],
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Set Badge Number",
                          suffixIcon: _loading
                              ? Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: CircularProgressIndicator(),
                                )
                              : IconButton(
                                  icon: Icon(Icons.send),
                                  onPressed: _setBadgeNumber,
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
            ],

            // Current Icon Info Card
            Card(
              elevation: 4,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      'Current Icon',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      _currentIconName == "Default" || _currentIconName.isEmpty
                          ? "Default"
                          : _currentIconName,
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 30),

            Text(
              'Choose an Icon:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 20),

            // Icon Selection Buttons
            GridView.count(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
                _buildIconButton(
                  "com.example.dynamic_icon.DefaultIcon",
                  "Default",
                  Icons.smartphone,
                  Colors.blue,
                ),
                _buildIconButton(
                  "com.example.dynamic_icon.DarkIcon",
                  "Dark",
                  Icons.dark_mode,
                  Colors.lightBlue,
                ),
                _buildIconButton(
                  "com.example.dynamic_icon.ChristmasIcon",
                  "Christmas",
                  Icons.star,
                  Colors.orange,
                ),
                _buildIconButton(
                  "com.example.dynamic_icon.SummerIcon",
                  "Summer",
                  Icons.wb_sunny,
                  Colors.amber,
                ),
              ],
            ),

            SizedBox(height: 20),

            // Restore Icon Button
            ElevatedButton.icon(
              icon: Icon(Icons.restore_outlined),
              label: Text("Restore Default Icon"),
              onPressed: _isSupported && !_loading
                  ? () => _changeIcon("", "Default")
                  : null,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 12),
              ),
            ),

            SizedBox(height: 20),

            // Info Text
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: Text(
                'Note: After changing the icon, you might need to close and reopen the app to see the changes in the launcher. Badge numbers are only available on iOS.',
                style: TextStyle(fontSize: 14, color: Colors.blue[800]),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconButton(
    String iconName,
    String displayName,
    IconData icon,
    Color color,
  ) {
    bool isSelected =
        (_currentIconName == iconName) ||
        (_currentIconName == "Default" && iconName == "DefaultIcon") ||
        (_currentIconName.isEmpty && iconName == "DefaultIcon");

    return Material(
      elevation: isSelected ? 8 : 4,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: _isSupported && !_loading
            ? () => _changeIcon(iconName, displayName)
            : null,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: isSelected
                ? Border.all(color: Colors.blue, width: 3)
                : null,
            color: _isSupported && !_loading ? null : Colors.grey[300],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_loading)
                SizedBox(
                  width: 48,
                  height: 48,
                  child: CircularProgressIndicator(),
                )
              else
                Icon(icon, size: 48, color: _isSupported ? color : Colors.grey),
              SizedBox(height: 8),
              Text(
                displayName,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: _isSupported && !_loading
                      ? Colors.black87
                      : Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              if (isSelected)
                Container(
                  margin: EdgeInsets.only(top: 4),
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    'Active',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
