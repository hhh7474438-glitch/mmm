# إعدادات المعالج والهدف
TARGET := iphone:clang:latest:14.0
ARCHS = arm64 arm64e

DEBUG = 0
FINALPACKAGE = 1

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Follwerk

# الملفات البرمجية التي سيتم بناؤها
Follwerk_FILES = Tweak.x
Follwerk_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
