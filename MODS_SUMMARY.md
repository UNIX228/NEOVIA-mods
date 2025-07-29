# NEOVIA Graphics Mods - Summary

## Созданные моды

### 1. TOTK - Ultra Graphics Pack
**Путь:** `TOTK/UltraGraphicsPack_TOTK/`
**Game ID:** TOTK (The Legend of Zelda: Tears of the Kingdom)

**Файлы:**
- `modinfo.json` - Метаданные мода
- `layeredFS/romfs/effects/lighting.fx` - Улучшенный шейдер освещения
- `layeredFS/romfs/effects/weather_shader.glsl` - Шейдер погоды
- `layeredFS/romfs/effects/enhanced_shadows.bnp` - Настройки теней
- `extras/overlay_config.ini` - Конфигурация оверлея

**Улучшения:**
- Повышенное разрешение теней (4096x4096)
- Улучшенное освещение с PBR
- Динамические эффекты погоды
- Увеличенная дальность прорисовки
- Улучшенные шейдеры

### 2. BOTW - Visual Enhance Pack
**Путь:** `BOTW/VisualEnhancePack_BOTW/`
**Game ID:** BOTW (The Legend of Zelda: Breath of the Wild)

**Файлы:**
- `modinfo.json` - Метаданные мода
- `layeredFS/romfs/effects/enhanced_lighting.fx` - Улучшенное освещение
- `layeredFS/romfs/effects/texture_upscale.bnp` - Апскейл текстур
- `extras/overlay_config.ini` - Конфигурация оверлея

**Улучшения:**
- Динамическое освещение дня/ночи
- Апскейл текстур 2x с ESRGAN
- Улучшенные тени и AO
- Оптимизированная производительность

### 3. BAYO3 - Combat Graphics Pack
**Путь:** `BAYO3/CombatGraphicsPack_BAYO3/`
**Game ID:** BAYO3 (Bayonetta 3)

**Файлы:**
- `modinfo.json` - Метаданные мода
- `layeredFS/romfs/effects/particle_enhancement.fx` - Улучшенные частицы
- `layeredFS/romfs/effects/combat_effects.bnp` - Боевые эффекты
- `extras/overlay_config.ini` - Конфигурация оверлея

**Улучшения:**
- Улучшенная система частиц (2048 частиц)
- Динамические боевые эффекты
- Bloom и glow эффекты
- Оптимизированная производительность

### 4. SMO - Visual Enhance Pack
**Путь:** `SMO/VisualEnhancePack_SMO/`
**Game ID:** SMO (Super Mario Odyssey)

**Файлы:**
- `modinfo.json` - Метаданные мода
- `layeredFS/romfs/effects/enhanced_lighting.fx` - Улучшенное освещение
- `layeredFS/romfs/effects/texture_enhancement.bnp` - Улучшение текстур
- `extras/overlay_config.ini` - Конфигурация оверлея

**Улучшения:**
- Освещение специфичное для каждого королевства
- Улучшенные текстуры для всех миров
- Динамический туман по мирам
- Оптимизированная производительность

## Структура каждого мода

```
[MOD_NAME]/
├── modinfo.json              # Метаданные мода
├── layeredFS/               # LayeredFS структура
│   └── romfs/
│       └── effects/         # Шейдеры и эффекты
│           ├── *.fx         # Шейдеры освещения
│           ├── *.glsl       # GLSL шейдеры
│           └── *.bnp        # Бинарные настройки
└── extras/                  # Дополнительные файлы
    ├── overlay_config.ini   # Конфигурация оверлея
    └── perf_patch.nro      # Патчи производительности
```

## Технические особенности

### Шейдеры
- **PBR освещение** с Cook-Torrance BRDF
- **Динамические тени** с каскадными картами
- **Bloom эффекты** для улучшения визуала
- **Погодные эффекты** с дождем, снегом, ветром

### Производительность
- **Оптимизированные настройки** для 60 FPS
- **Управление памятью** с кэшированием текстур
- **LOD система** для дальних объектов
- **Пул частиц** для эффективности

### Совместимость
- **LayeredFS** для замены ресурсов
- **SaltyNX** для шейдеров
- **NEOVIA** для автоматического применения
- **Atmosphere** для работы на CFW

## Автор

Все моды созданы **Unix228**

## Лицензия

MIT License - свободное использование и модификация