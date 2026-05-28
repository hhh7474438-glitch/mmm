ARCHS = arm64 arm64e
TARGET = iphone:clang:latest:14.0
# سطر إضافي لضمان عمل المترجم على لينكس بدون مشاكل
THEOS_PLATFORM_SDK_ROOT = $(THEOS)/sdks

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Pool8Mod

Pool8Mod_FILES = Tweak.xm
Pool8Mod_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
