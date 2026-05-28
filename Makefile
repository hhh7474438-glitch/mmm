# إعدادات معمارية آيفون الحديثة
ARCHS = arm64 arm64e
TARGET = iphone:clang:latest:14.0

include $(THEOS)/makefiles/common.mk

# اسم الـ dylib النهائي الذي سيتم توليده
TWEAK_NAME = Pool8Mod

Pool8Mod_FILES = Tweak.xm
Pool8Mod_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
