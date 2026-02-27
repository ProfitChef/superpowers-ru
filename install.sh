#!/usr/bin/env bash
set -euo pipefail

# ============================================================================
# Superpowers-RU — Установщик
# Русская версия фреймворка навыков для ИИ-агентов
# https://github.com/anthropics/superpowers-ru
# ============================================================================

REPO_URL="https://github.com/anthropics/superpowers-ru.git"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Цвета
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

info()    { echo -e "${BLUE}[INFO]${NC} $*"; }
success() { echo -e "${GREEN}[OK]${NC} $*"; }
warn()    { echo -e "${YELLOW}[!]${NC} $*"; }
error()   { echo -e "${RED}[ОШИБКА]${NC} $*"; }

echo ""
echo -e "${BOLD}${CYAN}  Superpowers-RU — Установка${NC}"
echo -e "${CYAN}  Русская версия фреймворка навыков для ИИ-агентов${NC}"
echo ""

# ============================================================================
# Определение платформ
# ============================================================================

CLAUDE_CODE=false
OPENCODE=false

# Claude Code: проверяем наличие директории ~/.claude
if [ -d "$HOME/.claude" ]; then
    CLAUDE_CODE=true
fi

# OpenCode: проверяем наличие директории ~/.config/opencode
if [ -d "$HOME/.config/opencode" ]; then
    OPENCODE=true
fi

# Если ничего не найдено, спрашиваем
if [ "$CLAUDE_CODE" = false ] && [ "$OPENCODE" = false ]; then
    warn "Не найдены установленные платформы (Claude Code, OpenCode)"
    echo ""
    echo "  Для какой платформы установить?"
    echo "  1) Claude Code"
    echo "  2) OpenCode"
    echo "  3) Обе"
    echo ""
    read -rp "  Выбор [1/2/3]: " choice
    case "$choice" in
        1) CLAUDE_CODE=true ;;
        2) OPENCODE=true ;;
        3) CLAUDE_CODE=true; OPENCODE=true ;;
        *) error "Неверный выбор"; exit 1 ;;
    esac
fi

# Показываем что нашли
echo -e "  Обнаруженные платформы:"
[ "$CLAUDE_CODE" = true ] && echo -e "    ${GREEN}✓${NC} Claude Code"
[ "$OPENCODE" = true ]    && echo -e "    ${GREEN}✓${NC} OpenCode"
echo ""

# ============================================================================
# Определение источника скиллов
# ============================================================================

# Если скрипт запущен из клонированного репо — используем его
if [ -d "$SCRIPT_DIR/skills" ] && [ -f "$SCRIPT_DIR/skills/using-superpowers/SKILL.md" ]; then
    SKILLS_SOURCE="$SCRIPT_DIR/skills"
    info "Используем скиллы из текущей директории: $SCRIPT_DIR"
else
    error "Запустите скрипт из директории репозитория superpowers-ru"
    echo ""
    echo "  git clone $REPO_URL"
    echo "  cd superpowers-ru"
    echo "  ./install.sh"
    echo ""
    exit 1
fi

# ============================================================================
# Установка для Claude Code
# ============================================================================

if [ "$CLAUDE_CODE" = true ]; then
    info "Установка для Claude Code..."

    CLAUDE_SKILLS_DIR="$HOME/.claude/skills"
    CLAUDE_SP_DIR="$CLAUDE_SKILLS_DIR/superpowers"

    mkdir -p "$CLAUDE_SKILLS_DIR"

    # Удаляем старую установку если есть
    if [ -e "$CLAUDE_SP_DIR" ]; then
        warn "Найдена предыдущая установка, заменяем..."
        rm -rf "$CLAUDE_SP_DIR"
    fi

    # Создаём симлинк
    ln -s "$SKILLS_SOURCE" "$CLAUDE_SP_DIR"
    success "Claude Code: скиллы подключены → $CLAUDE_SP_DIR"
fi

# ============================================================================
# Установка для OpenCode
# ============================================================================

if [ "$OPENCODE" = true ]; then
    info "Установка для OpenCode..."

    OC_CONFIG_DIR="$HOME/.config/opencode"
    OC_PLUGINS_DIR="$OC_CONFIG_DIR/plugins"
    OC_SKILLS_DIR="$OC_CONFIG_DIR/skills"

    mkdir -p "$OC_PLUGINS_DIR" "$OC_SKILLS_DIR"

    # Скиллы
    if [ -e "$OC_SKILLS_DIR/superpowers" ]; then
        warn "Найдена предыдущая установка скиллов, заменяем..."
        rm -rf "$OC_SKILLS_DIR/superpowers"
    fi
    ln -s "$SKILLS_SOURCE" "$OC_SKILLS_DIR/superpowers"
    success "OpenCode: скиллы подключены → $OC_SKILLS_DIR/superpowers"

    # Плагин
    PLUGIN_SOURCE="$SCRIPT_DIR/.opencode/plugins/superpowers.js"
    if [ -f "$PLUGIN_SOURCE" ]; then
        rm -f "$OC_PLUGINS_DIR/superpowers.js"
        ln -s "$PLUGIN_SOURCE" "$OC_PLUGINS_DIR/superpowers.js"
        success "OpenCode: плагин подключён → $OC_PLUGINS_DIR/superpowers.js"
    else
        warn "Файл плагина не найден: $PLUGIN_SOURCE"
    fi
fi

# ============================================================================
# Готово
# ============================================================================

echo ""
echo -e "${BOLD}${GREEN}  Установка завершена!${NC}"
echo ""
echo -e "  Перезапустите ваш ИИ-агент и проверьте:"
echo -e "  ${CYAN}«У тебя есть суперспособности?»${NC}"
echo ""
echo -e "  Обновление: ${YELLOW}cd $(pwd) && git pull${NC}"
echo ""
