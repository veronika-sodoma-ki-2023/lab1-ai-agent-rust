# Лабораторна робота: проєктування AI-агента для автоматизації розробки та CI/CD

**Студент:** Содома Вероніка Мар'янівна  
**Група:** КІ-409  
**Варіант:** 4  

## Опис

У роботі проєктується AI-агент **build-engineer** для GitHub Copilot у VS Code.
Агент автоматизує створення кросплатформного проєкту **Hello World** мовою Rust
із системою складання Cargo, тестом `BasicAddition`, скриптами `ci.sh` і
`ci.bat`, а також GitHub Actions для Windows, Linux і macOS.

На цьому етапі гілка `develop` містить лише агента та документацію. Файли
Rust-проєкту, `Cargo.toml`, CI-скрипти та workflow створюються агентом під час
виконання відповідних команд.

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
├── .github/
│   ├── agents/
│   │   └── build-engineer.agent.md
│   ├── prompts/
│   │   └── (commands створюються агентом)
│   └── skills/
│       ├── project-scaffold/
│       │   └── (SKILL.md створюється агентом)
│       ├── build-and-test/
│       │   └── (SKILL.md створюється агентом)
│       └── github-actions/
│           └── (SKILL.md створюється агентом)
└── docs/
    ├── architecture.md
    └── ai-log.md
```
