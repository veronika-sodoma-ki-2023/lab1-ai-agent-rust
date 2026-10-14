# Лабораторна робота: проєктування AI-агента для автоматизації розробки та CI/CD

**Студент:** Содома Вероніка Мар'янівна  
**Група:** КІ-409  
**Варіант:** 4  

## Опис

У роботі проєктується AI-агент **build-engineer** для GitHub Copilot у VS Code.
Агент автоматизує створення кросплатформного проєкту **Hello World** мовою Rust
із системою складання Cargo, тестом `BasicAddition`, скриптами `ci.sh` і
`ci.bat`, а також GitHub Actions для Windows, Linux і macOS.

## Запуск агента

1. Відкрити **Copilot Chat** у VS Code.
2. Перейти в режим **Agent**.
3. Вибрати агента **build-engineer**.
4. Виконати команду `/init`.

Порядок оркестрації команд і передавання даних описано в
[архітектурі агента](docs/architecture.md).

## Структура репозиторію

```text
lab1-ai-agent-rust/
├── README.md
├── .gitignore
├── .gitattributes
├── Cargo.toml
├── Cargo.lock
├── ci.sh
├── ci.bat
├── src/
│   ├── lib.rs
│   └── main.rs
├── tests/
│   └── basic_addition.rs
├── .github/
│   ├── agents/
│   │   └── build-engineer.agent.md
│   ├── workflows/
│   │   └── ci.yml
│   └── skills/
│       ├── git-init/
│       │   └── SKILL.md
│       ├── create-project/
│       │   └── SKILL.md
│       ├── create-build/
│       │   └── SKILL.md
│       ├── create-actions/
│       │   └── SKILL.md
│       ├── check/
│       │   └── SKILL.md
│       ├── init/
│       │   └── SKILL.md
│       ├── project-scaffold/
│       │   └── SKILL.md
│       ├── build-and-test/
│       │   └── SKILL.md
│       └── github-actions/
│           └── SKILL.md
└── docs/
    ├── architecture.md
    ├── usage.md
    └── ai-log.md
```
