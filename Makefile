# إعدادات معمارية الجهاز المستهدف (تدعم الأجهزة الحديثة)
ARCHS = arm64 arm64e

# استهداف الحد الأدنى من إصدار iOS (يفضل 13.0 وما فوق للألعاب الحديثة)
TARGET := iphone:clang:latest:13.0

# ربط أداة الـ Theos بسيرفرك
include $(THEOS)/makefiles/common.mk

# اسم التويك (اسم مشروعك)
TWEAK_NAME = Follwerk

# الملفات البرمجية التي سيتم بناؤها (تأكد من مطابقة اسم الملف لديك)
Follwerk_FILES = Tweak.x

# المكتبات البرمجية المطلوبة لرسم الخطوط والتعامل مع الواجهة
Follwerk_FRAMEWORKS = UIKit CoreGraphics Foundation

# إعدادات المترجم لضمان الدقة العالية (Segalign ضروري للألعاب الضخمة)
Follwerk_CFLAGS = -fobjc-arc
Follwerk_LDFLAGS = -Wl,-segalign,4000

# دمج ملفات البناء
include $(THEOS_MAKE_PATH)/tweak.mk

# أمر لتنظيف الملفات المؤقتة بعد البناء
after-install::
	install.exec "killall -9 8BallPool"
