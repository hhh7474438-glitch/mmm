ARCHS = arm64 arm64e
TARGET = iphone:clang:latest:14.0
THEOS_PLATFORM_SDK_ROOT = $(THEOS)/sdks

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Poolyyy8Mod

# أضفنا *.x هنا حتى يقرأ ملفك Tweak.x تلقائياً
Pool8Mod_FILES = $(wildcard *.x *.xm *.mm *.cpp)
Pool8Mod_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
