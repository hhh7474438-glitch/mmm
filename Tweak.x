name: Build Hussein Dylib
on: [push, workflow_dispatch]

jobs:
  build:
    runs-on: macos-latest
    steps:
      - name: Checkout Code
        uses: actions/checkout@v4

      - name: Setup Dependencies
        run: |
          brew install ldid

      - name: Setup Theos
        run: |
          git clone --recursive https://github.com/theos/theos.git ~/theos
          echo "THEOS=~/theos" >> $GITHUB_ENV

      - name: Setup iOS SDK (Stable & Fast)
        run: |
          mkdir -p ~/theos/sdks
          git clone --depth=1 https://github.com/theos/sdks.git ~/theos/sdks-temp
          mv ~/theos/sdks-temp/iPhoneOS14.5.sdk ~/theos/sdks/
          rm -rf ~/theos/sdks-temp

      - name: Build Dylib
        run: |
          export THEOS=~/theos
          # بناء المشروع بدون توقيع ليتجاوز مرحلة الـ ldid
          make all FINALPACKAGE=1 ARCHS="arm64 arm64e" codesign=0

      - name: Save Dylib Artifact
        uses: actions/upload-artifact@v4
        with:
          name: Hussein-Memory-Dylib
          # هذا هو المسار الصحيح والمضمون للبحث عن الملف بعد تغيير الاسم
          path: .theos/obj/*.dylib
