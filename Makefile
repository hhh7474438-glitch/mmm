# تسريع البناء باستخدام أنوية المعالج المتوفرة
MAKEFLAGS += -j$(shell sysctl -n hw.ncpu)

# المعماريات المطلوبة للحقن في IPA للأجهزة الحديثة
ARCHS = arm64 arm64e
TARGET := iphone:clang:latest:14.0

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Follwerk
Follwerk_FILES = Tweak.x
Follwerk_FRAMEWORKS = UIKit CoreGraphics Foundation
Follwerk_CFLAGS = -fobjc-arc
Follwerk_LDFLAGS = -Wl,-segalign,4000

include $(THEOS_MAKE_PATH)/tweak.mk
