name: Build Dylib
on: [push, pull_request]

jobs:
  build:
    runs-on: macos-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v3

      - name: Setup Theos
        run: |
          bash -c "$(curl -fsSL https://raw.githubusercontent.com/theos/theos/master/bin/install-theos)"
          echo "THEOS=$HOME/theos" >> $GITHUB_ENV

      - name: Build Tweak
        run: |
          make package FINALPACKAGE=1
          
      - name: Upload Artifact
        uses: actions/upload-artifact@v3
        with:
          name: SecurityHussein-Dylib
          path: .theos/obj/install/Library/MobileSubstrate/DynamicLibraries/SecurityHussein.dylib
