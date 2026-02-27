/**
 * Плагин Superpowers-RU для OpenCode.ai
 *
 * Внедряет bootstrap-контекст superpowers через трансформацию системного промпта.
 * Скиллы обнаруживаются встроенным инструментом skill из директории симлинков.
 */

import path from 'path';
import fs from 'fs';
import os from 'os';
import { fileURLToPath } from 'url';

const __dirname = path.dirname(fileURLToPath(import.meta.url));

// Простое извлечение frontmatter (без зависимости от skills-core для bootstrap)
const extractAndStripFrontmatter = (content) => {
  const match = content.match(/^---\n([\s\S]*?)\n---\n([\s\S]*)$/);
  if (!match) return { frontmatter: {}, content };

  const frontmatterStr = match[1];
  const body = match[2];
  const frontmatter = {};

  for (const line of frontmatterStr.split('\n')) {
    const colonIdx = line.indexOf(':');
    if (colonIdx > 0) {
      const key = line.slice(0, colonIdx).trim();
      const value = line.slice(colonIdx + 1).trim().replace(/^["']|["']$/g, '');
      frontmatter[key] = value;
    }
  }

  return { frontmatter, content: body };
};

// Нормализация пути: убрать пробелы, развернуть ~, привести к абсолютному
const normalizePath = (p, homeDir) => {
  if (!p || typeof p !== 'string') return null;
  let normalized = p.trim();
  if (!normalized) return null;
  if (normalized.startsWith('~/')) {
    normalized = path.join(homeDir, normalized.slice(2));
  } else if (normalized === '~') {
    normalized = homeDir;
  }
  return path.resolve(normalized);
};

export const SuperpowersPlugin = async ({ client, directory }) => {
  const homeDir = os.homedir();
  const superpowersSkillsDir = path.resolve(__dirname, '../../skills');
  const envConfigDir = normalizePath(process.env.OPENCODE_CONFIG_DIR, homeDir);
  const configDir = envConfigDir || path.join(homeDir, '.config/opencode');

  // Генерация bootstrap-контента
  const getBootstrapContent = () => {
    // Загрузка скилла using-superpowers
    const skillPath = path.join(superpowersSkillsDir, 'using-superpowers', 'SKILL.md');
    if (!fs.existsSync(skillPath)) return null;

    const fullContent = fs.readFileSync(skillPath, 'utf8');
    const { content } = extractAndStripFrontmatter(fullContent);

    const toolMapping = `**Маппинг инструментов для OpenCode:**
Когда скиллы ссылаются на инструменты, которых у вас нет, используйте эквиваленты OpenCode:
- \`TodoWrite\` → \`update_plan\`
- \`Task\` с субагентами → система \`@mention\` в OpenCode
- \`Skill\` → встроенный инструмент \`skill\` в OpenCode
- \`Read\`, \`Write\`, \`Edit\`, \`Bash\` → ваши стандартные инструменты

**Расположение скиллов:**
Скиллы Superpowers находятся в \`${configDir}/skills/superpowers/\`
Используйте встроенный инструмент \`skill\` в OpenCode для просмотра и загрузки скиллов.`;

    return `<EXTREMELY_IMPORTANT>
У вас есть суперспособности.

**ВАЖНО: Содержимое скилла using-superpowers включено ниже. Оно УЖЕ ЗАГРУЖЕНО — вы сейчас следуете ему. НЕ используйте инструмент skill для повторной загрузки "using-superpowers" — это будет избыточно.**

${content}

${toolMapping}
</EXTREMELY_IMPORTANT>`;
  };

  return {
    // Трансформация системного промпта для внедрения bootstrap
    'experimental.chat.system.transform': async (_input, output) => {
      const bootstrap = getBootstrapContent();
      if (bootstrap) {
        (output.system ||= []).push(bootstrap);
      }
    }
  };
};
