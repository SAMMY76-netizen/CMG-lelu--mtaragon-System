# Windows Desktop Build Instructions

## Building Windows Desktop Executable

### Prerequisites
- Flutter 3.16.0+
- Windows SDK
- Visual Studio Build Tools

### Build Steps

```bash
# Navigate to project
cd CMG-lelu--mtaragon-System
cd feature/flutter-rebuild

# Enable Windows Desktop
flutter config --enable-windows-desktop

# Get dependencies
flutter pub get

# Build Windows app
flutter build windows --release

# Output location:
# build/windows/runner/Release/cmg_system.exe
```

### Windows Installer with NSIS

After building:
1. Download NSIS from: https://nsis.sourceforge.io/
2. Create installer script
3. Build MSI installer
4. Distribute to users

