# إعدادات الهدف: نستخدم إصدار 14.5 لضمان التوافق مع الـ SDK المحملة في الـ Action
TARGET := iphone:clang:latest:14.5
INSTALL_TARGET_PROCESSES = Instagram

# استدعاء ملفات ذايوس الأساسية
include $(THEOS)/makefiles/common.mk

# اسم التويك (الدايلب الناتج سيكون بهذا الاسم)
TWEAK_NAME = jokdinstagram

# ملفات السورس (تأكد أن ملف الكود اسمه Tweak.x)
jokdinstagram_FILES = Tweak.x

# إعدادات المترجم: 
# 1. تفعيل ARC لإدارة الذاكرة تلقائياً
# 2. تجاهل التنبيهات التي توقف البناء (Deprecated & Unused)
jokdinstagram_CFLAGS = -fobjc-arc -Wno-deprecated-declarations -Wno-unused-variable -Wno-unused-function

# المكتبات البرمجية المطلوبة للواجهة والرسومات
jokdinstagram_FRAMEWORKS = UIKit Foundation CoreGraphics QuartzCore

# استدعاء ملف بناء التويك
include $(THEOS)/makefiles/tweak.mk
