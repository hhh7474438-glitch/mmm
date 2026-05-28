#include <substrate.h>
#include <mach-o/dyld.h>
#include <dlfcn.h>
#include <string>

// 1. الأوفستس الحقيقية المستخرجة من فحصك
#define OFFSET_BALL_BALL_COLLISION    0x323d214
#define OFFSET_BALL_LINE_COLLISION    0x323d18c
#define OFFSET_SHOW_TRAJECTORY         0x389b9ea

// حجز العناوين الأصلية لتمرير البيانات بدون كراش
static void* (*orig_BallBallCollision)(void* instance, void* arg1, void* arg2);
static void* (*orig_BallLineCollision)(void* instance, void* arg1, void* arg2);
static void (*orig_setShowCueBallTrajectory)(void* instance, bool value);

// دالة جلب الـ Base Address للعبة بشكل آمن
uintptr_t get_BaseAddress() {
    return (uintptr_t)_dyld_get_image_header(0);
}

// الدوال البديلة (Hooks)
void* hk_BallBallCollision(void* instance, void* arg1, void* arg2) {
    // تمرير البيانات بشكل طبيعي للحماية
    return orig_BallBallCollision(instance, arg1, arg2);
}

void* hk_BallLineCollision(void* instance, void* arg1, void* arg2) {
    return orig_BallLineCollision(instance, arg1, arg2);
}

void hk_setShowCueBallTrajectory(void* instance, bool value) {
    // إجبار اللعبة على تفعيل الخطوط دائماً (true) حتى لو كانت مغلقة بالإعدادات
    orig_setShowCueBallTrajectory(instance, true);
}

// دالة التشغيل التلقائي عند إقلاع اللعبة
__attribute__((constructor))
static void initialize() {
    uintptr_t base = get_BaseAddress();
    
    // عملية الحقن الفعلي في الذاكرة
    MSHookFunction((void*)(base + OFFSET_BALL_BALL_COLLISION), 
                   (void*)&hk_BallBallCollision, 
                   (void**)&orig_BallBallCollision);
                   
    MSHookFunction((void*)(base + OFFSET_BALL_LINE_COLLISION), 
                   (void*)&hk_BallLineCollision, 
                   (void**)&orig_BallLineCollision);

    MSHookFunction((void*)(base + OFFSET_SHOW_TRAJECTORY), 
                   (void*)&hk_setShowCueBallTrajectory, 
                   (void**)&orig_setShowCueBallTrajectory);
}
