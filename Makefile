# اسم الأداة
TWEAK_NAME = MyModMenu

# الملفات المراد جمعها
MyModMenu_FILES = Tweak.x

# المكاتب المطلوبة
MyModMenu_LIBRARIES = substrate
MyModMenu_FRAMEWORKS = UIKit Foundation

# إعدادات البناء بدون جيلبريك (Non-Jailbreak)
export TARGET = iphone:clang:latest:14.0
export ARCHS = arm64

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/tweak.mk
