# اسم المعماريات المدعومة
ARCHS = arm64 arm64e

# استهداف إصدارات iOS
TARGET := iphone:clang:latest:14.0

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = HusseinSecurity

# الملفات البرمجية المستخدمة
HusseinSecurity_FILES = Tweak.x
HusseinSecurity_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
