# Установка Superpowers-RU для OpenCode

## Требования

- [OpenCode.ai](https://opencode.ai) установлен
- Git установлен

## Шаги установки

### 1. Клонируйте репозиторий

```bash
git clone https://github.com/anthropics/superpowers-ru.git ~/.config/opencode/superpowers
```

### 2. Зарегистрируйте плагин

Создайте симлинк, чтобы OpenCode нашёл плагин:

```bash
mkdir -p ~/.config/opencode/plugins
rm -f ~/.config/opencode/plugins/superpowers.js
ln -s ~/.config/opencode/superpowers/.opencode/plugins/superpowers.js ~/.config/opencode/plugins/superpowers.js
```

### 3. Подключите скиллы

Создайте симлинк на директорию скиллов:

```bash
mkdir -p ~/.config/opencode/skills
rm -rf ~/.config/opencode/skills/superpowers
ln -s ~/.config/opencode/superpowers/skills ~/.config/opencode/skills/superpowers
```

### 4. Перезапустите OpenCode

Перезапустите OpenCode. Плагин автоматически внедрит контекст superpowers.

Проверьте, спросив: «у тебя есть суперспособности?»

## Использование

### Поиск скиллов

Используйте встроенный инструмент `skill` в OpenCode:

```
используй инструмент skill чтобы показать список скиллов
```

### Загрузка скилла

```
используй инструмент skill чтобы загрузить superpowers/brainstorming
```

## Обновление

```bash
cd ~/.config/opencode/superpowers
git pull
```

## Устранение проблем

### Плагин не загружается

1. Проверьте симлинк: `ls -l ~/.config/opencode/plugins/superpowers.js`
2. Проверьте источник: `ls ~/.config/opencode/superpowers/.opencode/plugins/superpowers.js`
3. Посмотрите логи OpenCode

### Скиллы не найдены

1. Проверьте симлинк: `ls -l ~/.config/opencode/skills/superpowers`
2. Убедитесь, что он указывает на: `~/.config/opencode/superpowers/skills`
3. Используйте инструмент `skill` для проверки

### Маппинг инструментов

Если скиллы ссылаются на инструменты Claude Code:
- `TodoWrite` → `update_plan`
- `Task` с субагентами → система `@mention` в OpenCode
- `Skill` → встроенный инструмент `skill` в OpenCode
- Файловые операции → ваши стандартные инструменты
