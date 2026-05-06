# اسم التويك
TWEAK_NAME = jokdpool

# ملفات المشروع
jokdpool_FILES = Tweak.x
jokdpool_CFLAGS = -fobjc-arc -Wno-deprecated-declarations

# المعماريات المستهدفة
ARCHS = arm64 arm64e

# إعدادات النظام المستهدف
TARGET = iphone:clang:latest:14.0

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/tweak.mk
