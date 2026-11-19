/*
 * OpenVALive FM-1 - the app's half of the contract with fm1-base (device/unity.c on the FM-1,
 * host/plat_host.c in the simulator). The app itself is OpenVALive CORE's (va/app/).
 */
#pragma once
#include "../../va/app/openvalive_app.h"

#define APP_NAME "OPENVALIVE"
#define APP_SPLASH_RGB RGB(90, 200, 160)
#define APP_TOUCH               /* key velocity (and pressure): lib/touch.h */
#define APP_OVERLOAD            /* rendering over 90 % of its time: app_overload() sheds a voice */
#define APP_SPLASH              /* the boot screen: the logo and the version (va/app/src/splash.c) */
#define APP_DIM_LEVELS          /* the dim lights at any brightness (plat_dim_ns): brighter, and breathing under a layer */
void app_splash(void);

/* where each flash object lives (openvalive_app.h: settings, the panel calibration, the live set in two objects,
 * the 8 user sounds, the CONTROL MAP) */
#define APP_STORE_MAP {0xFC000u, 0xDC000u, 0xD8000u, 0xDA000u, 0xD6000u, 0xD4000u}

/* simulator checks (host/plat_host.c "expect") */
#define APP_HOST_EXPECT
int app_expect(const char *what, int *got);
