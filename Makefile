# اسم الأداة
TWEAK_NAME = MyModMenu

# إعدادات المعالج والنظام
export TARGET = iphone:clang:latest:14.0
export ARCHS = arm64

# ملفات المشروع
MyModMenu_FILES = Tweak.x
MyModMenu_CFLAGS = -fobjc-arc -Wno-deprecated-declarations -Wno-unused-variable -Wno-unused-function

# المكاتب والاطارات
MyModMenu_LIBRARIES = substrate
MyModMenu_FRAMEWORKS = UIKit Foundation

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/tweak.mk
