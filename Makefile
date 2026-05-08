DEBUG = 0
FINAL_PACKAGE = 1

# استهداف المعماريات الحديثة للآيفون
TARGET := iphone:clang:latest:14.0
ARCHS = arm64 arm64e

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = SecurityHussein

SecurityHussein_FILES = Tweak.x
# السطر التالي يمنع تحول التحذيرات إلى أخطاء ويسمح بالكود القديم
SecurityHussein_CFLAGS = -fobjc-arc -Wno-deprecated-declarations -Wno-unused-variable -Wno-error

SecurityHussein_FRAMEWORKS = UIKit Foundation

include $(THEOS_MAKE_PATH)/tweak.mk
