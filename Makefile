# تفعيل البناء المتوازي لتسريع العملية في GitHub Actions
MAKEFLAGS += -j$(shell sysctl -n hw.ncpu)

# المعماريات المطلوبة لأجهزة الآيفون الحديثة
ARCHS = arm64 arm64e

# استهداف نظام iOS 14 لضمان توافق arm64e
TARGET := iphone:clang:latest:14.0

include $(THEOS)/makefiles/common.mk

# اسم مشروعك المميز
TWEAK_NAME = Follwerk

# ربط الملفات البرمجية والمكتبات
Follwerk_FILES = Tweak.x
Follwerk_FRAMEWORKS = UIKit CoreGraphics Foundation

# إعدادات المترجم المتقدمة
Follwerk_CFLAGS = -fobjc-arc
Follwerk_LDFLAGS = -Wl,-segalign,4000

include $(THEOS_MAKE_PATH)/tweak.mk

# تنظيف الكاش وإعادة تشغيل اللعبة عند التثبيت
after-install::
	install.exec "killall -9 8BallPool"
