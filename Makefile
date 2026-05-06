# اسم التويك
TWEAK_NAME = jokdpool

# الملفات المراد بناؤها
jokdpool_FILES = Tweak.x
jokdpool_CFLAGS = -fobjc-arc

# المعماريات المستهدفة (64 بت للأجهزة الحديثة)
ARCHS = arm64 arm64e

# إصدار الـ iOS الأدنى
TARGET = iphone:clang:latest:14.0

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/tweak.mk

# بعد الانتهاء، سيتم توليد ملف dylib في مجلد .theos/obj
