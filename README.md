# Leap (formerly JobProgress) Mobile App

Flutter mobile application for job management and field operations.

## 📱 iOS Development Setup

### 1. Install Xcode 16.2
1. Download [Xcode 16.2](https://developer.apple.com/services-account/download?path=/Developer_Tools/Xcode_16.2/Xcode_16.2.xip)
2. Double-click to extract (takes 10-15 minutes)
3. Drag `Xcode.app` to `/Applications` folder
4. Launch Xcode and accept license agreement
5. Install additional components when prompted

### 2. Install Flutter 3.27.1 (Manual Setup)
1. **Download Flutter SDK**:
   - Go to [Flutter 3.27.1 Download](https://storage.googleapis.com/flutter_infra_release/releases/stable/macos/flutter_macos_arm64_3.27.1-stable.zip)
   - Save to `~/Downloads/`

2. **Extract Flutter**:
   - Double-click `flutter_macos_arm64_3.27.1-stable.zip` to extract
   - Move extracted `flutter` folder to `/Users/[username]/development/`

3. **Add Flutter to PATH**:
   - Open Terminal
   - Edit shell profile: `nano ~/.zshrc`
   - Add line: `export PATH="$HOME/development/flutter/bin:$PATH"`
   - Save and exit (Ctrl+X, Y, Enter)
   - Reload: `source ~/.zshrc`

4. **Verify Installation**:
   ```bash
   flutter --version
   # Should show: Flutter 3.27.1
   ```

### 3. Install VS Code
1. Download [Visual Studio Code](https://code.visualstudio.com/download)
2. Open DMG file and drag VS Code to Applications
3. Launch VS Code

### 4. Configure VS Code for Flutter
1. **Install Flutter Extension**:
   - Open VS Code
   - Go to Extensions (⌘+Shift+X)
   - Search "Flutter" by Dart Code
   - Click "Install" (this will also install Dart extension automatically)

2. **Install Dart Extension** (if not auto-installed):
   - Search "Dart" by Dart Code
   - Click "Install"

3. **Configure Flutter SDK Path**:
   - Open Command Palette (⌘+Shift+P)
   - Type "Flutter: Change SDK"
   - Select Flutter SDK path: `/Users/[username]/development/flutter`

### 5. Install CocoaPods
```bash
sudo gem install cocoapods
```

### 6. Setup iOS Simulator (iOS 18.3 - 18.4)
1. **Open Xcode**
2. **Install Simulator**:
   - Xcode → Settings → Platforms
   - Download "iOS 18.3 Simulator" or "iOS 18.4 Simulator"
3. **Create iOS Simulator**:
   - Open Simulator app
   - Device → Manage Devices → "+"
   - Select iOS 18.3 or 18.4
   - Choose iPhone 15 Pro or iPhone 16

### 7. Setup UI Kit Repository Access
1. **Generate SSH Key** (if not already done):
   ```bash
   ssh-keygen -t ed25519 -C "your-email@example.com"
   ```

2. **Add SSH Key to GitHub**:
   - Copy public key: `cat ~/.ssh/id_ed25519.pub`
   - Go to GitHub → Settings → SSH Keys → Add Key
   - Paste the public key

3. **Test UI Kit Access**:
   ```bash
   ssh -T git@github.com
   # Should show: Hi username! You've successfully authenticated
   ```

4. **Verify UI Kit Repository Access**:
   ```bash
   git ls-remote git@github.com:JobProgress-Org/jp_mobile_main_v2_uikit.git
   # Should list repository branches if access is granted
   ```

### 8. Project Setup
1. **Clone Main Repository**:
   ```bash
   git clone git@github.com:JobProgress-Org/jp_mobile_main_v2.git
   cd jp_mobile_main_v2
   ```

2. **Open Project in VS Code**:
   ```bash
   code .
   ```
   Or: VS Code → File → Open Folder → Select `jp_mobile_main_v2`

3. **Install Dependencies**:
   - VS Code will show "Get Packages" notification
   - Click "Get Packages" or run in terminal:
   ```bash
   flutter pub get
   ```

4. **Install iOS Pods**:
   ```bash
   cd ios
   pod install
   cd ..
   ```

### 9. Run App from VS Code
1. **Select Device**:
   - Open Command Palette (⌘+Shift+P)
   - Type "Flutter: Select Device"
   - Choose "iOS Simulator (iOS 18.3)" or "iOS Simulator (iOS 18.4)"

2. **Run Configuration**:
   - Open `lib/main.dart`
   - Press F5 or click "Run" in top menu
   - Or use Command Palette: "Flutter: Run Flutter App"

3. **Debug Mode**:
   - App will build and launch on selected iOS device
   - Debug console will show in VS Code terminal
   - Use VS Code's debugging tools and breakpoints

### 10. VS Code Flutter Commands
- **⌘+Shift+P** → "Flutter: Hot Reload" (or save file)
- **⌘+Shift+P** → "Flutter: Hot Restart"
- **⌘+Shift+P** → "Flutter: Select Device"
- **⌘+Shift+P** → "Flutter: Run Flutter Doctor"
- **F5** → Start Debugging
- **⌘+F5** → Start Without Debugging

### 11. Device Selection Options
- **iOS Simulator**: iPhone 15 Pro (iOS 18.3/18.4), iPhone 16 (iOS 18.3/18.4)
- **Physical Device**: Connect via USB, trust computer, enable Developer Mode

## ✅ Setup Verification
- [ ] Xcode 16.2 installed and launched
- [ ] Flutter 3.27.1 installed (`flutter --version`)
- [ ] VS Code with Flutter and Dart extensions installed
- [ ] iOS 18.3 or 18.4 Simulator available in device selection
- [ ] SSH access to UI Kit repository configured
- [ ] Project opens in VS Code
- [ ] F5 successfully launches app on iOS simulator

## 🐛 Common Issues
- **Flutter not found**: Check Flutter SDK path in VS Code settings
- **iOS Simulator not showing**: Ensure iOS 18.3/18.4 Simulator is installed and running
- **UI Kit access denied**: Verify SSH key is added to GitHub and repository access granted
- **Build errors**: Run `flutter clean` and `flutter pub get`
- **Pod issues**: Delete `ios/Pods` folder and run `pod install`
- **Extensions not working**: Reload VS Code window (⌘+R)

## 🎯 Next Steps
Once setup is complete:
1. Open `lib/main.dart` in VS Code
2. Select iOS 18.3/18.4 device (⌘+Shift+P → "Flutter: Select Device")
3. Press F5 to run in debug mode
4. Use VS Code's integrated terminal and debugging features

## 🔗 Resources
- [Figma Designs](https://www.figma.com/file/FF8gqNuivALigMbjHEuk15/JP-Flutter-App-2021?node-id=6%3A30)
- [JSON to Dart Converter](https://javiercbk.github.io/json_to_dart/)
