ARCHS = arm64 arm64e
TARGET = iphone:clang:latest:14.0
THEOS_PLATFORM_SDK_ROOT = $(THEOS)/sdks

include $(THEOS)/makefiles/common.mk

# ثبتنا الاسم هنا على Pool8Mod
TWEAK_NAME = Pool8Mod

# هذا السطر يقرا ملفك Tweak.xm تلقائياً مهما كان مكانه
Pool8Mod_FILES = Tweak.xm
Pool8Mod_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
