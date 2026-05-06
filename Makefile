ARCHS = arm64 arm64e
TARGET = iphone:clang:latest:14.0

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = HussainTweak
HussainTweak_FILES = Tweak.x
HussainTweak_CFLAGS = -fobjc-arc -Wno-deprecated-declarations # أضف هذا الجزء لتجاهل تحذيرات الكود القديم

include $(THEOS_MAKE_PATH)/tweak.mk
