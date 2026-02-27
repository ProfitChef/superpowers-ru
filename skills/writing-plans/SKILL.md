---
name: writing-plans
description: Используй, когда есть спецификация или требования для многошаговой задачи, до написания кода
---

# Написание планов

## Обзор

Пиши исчерпывающие планы реализации, исходя из того, что инженер имеет нулевой контекст по нашей кодовой базе и сомнительный вкус. Документируй всё, что ему нужно знать: какие файлы затрагивать в каждой задаче, код, тестирование, документацию, которую стоит проверить, как это тестировать. Дай ему весь план в виде небольших задач. DRY. YAGNI. TDD. Частые commit'ы.

Предполагай, что это опытный разработчик, но он почти ничего не знает о наших инструментах и предметной области. Предполагай, что он не очень хорошо разбирается в дизайне тестов.

**Объяви в начале:** «Я использую навык writing-plans для создания плана реализации.»

**Контекст:** Это следует запускать в отдельном worktree (созданном навыком brainstorming).

**Сохраняй планы в:** `docs/plans/YYYY-MM-DD-<feature-name>.md`

## Гранулярность небольших задач

**Каждый шаг — одно действие (2-5 минут):**
- «Написать падающий тест» — шаг
- «Запустить его и убедиться, что падает» — шаг
- «Реализовать минимальный код для прохождения теста» — шаг
- «Запустить тесты и убедиться, что проходят» — шаг
- «Сделать commit» — шаг

## Заголовок документа плана

**Каждый план ОБЯЗАН начинаться с такого заголовка:**

```markdown
# [Feature Name] Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** [One sentence describing what this builds]

**Architecture:** [2-3 sentences about approach]

**Tech Stack:** [Key technologies/libraries]

---
```

## Структура задач

````markdown
### Task N: [Component Name]

**Files:**
- Create: `exact/path/to/file.py`
- Modify: `exact/path/to/existing.py:123-145`
- Test: `tests/exact/path/to/test.py`

**Step 1: Write the failing test**

```python
def test_specific_behavior():
    result = function(input)
    assert result == expected
```

**Step 2: Run test to verify it fails**

Run: `pytest tests/path/test.py::test_name -v`
Expected: FAIL with "function not defined"

**Step 3: Write minimal implementation**

```python
def function(input):
    return expected
```

**Step 4: Run test to verify it passes**

Run: `pytest tests/path/test.py::test_name -v`
Expected: PASS

**Step 5: Commit**

```bash
git add tests/path/test.py src/path/file.py
git commit -m "feat: add specific feature"
```
````

## Запомни
- Всегда точные пути к файлам
- Полный код в плане (не «добавь валидацию»)
- Точные команды с ожидаемым выводом
- Ссылки на релевантные навыки через синтаксис @
- DRY, YAGNI, TDD, частые commit'ы

## Передача на исполнение

После сохранения плана предложи выбор способа исполнения:

**«План готов и сохранён в `docs/plans/<filename>.md`. Два варианта исполнения:**

**1. Через subagent'ов (эта сессия)** — Отправляю свежего subagent'а на каждую задачу, ревью между задачами, быстрая итерация

**2. Параллельная сессия (отдельно)** — Открой новую сессию с executing-plans, пакетное исполнение с контрольными точками

**Какой подход?»**

**Если выбран вариант через subagent'ов:**
- **ОБЯЗАТЕЛЬНЫЙ НАВЫК:** Используй superpowers:subagent-driven-development
- Оставайся в этой сессии
- Свежий subagent на каждую задачу + код-ревью

**Если выбрана параллельная сессия:**
- Помоги открыть новую сессию в worktree
- **ОБЯЗАТЕЛЬНЫЙ НАВЫК:** Новая сессия использует superpowers:executing-plans
