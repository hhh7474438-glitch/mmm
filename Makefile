# المعماريات المطلوبة
ARCHS = arm64 arm64e

# استهدف نظام iOS 14 كحد أدنى للبناء
TARGET := iphone:clang:latest:14.0

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = HusseinSecurity

# سطر مهم جداً: تفعيل الـ ARC وتجاهل تحذيرات الأكواد القديمة
HusseinSecurity_CFLAGS = -fobjc-arc -Wno-deprecated-declarations

HusseinSecurity_FILES = Tweak.x
HusseinSecurity_FRAMEWORKS = UIKit

include $(THEOS_MAKE_PATH)/tweak.mk
