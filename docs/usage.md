# Використання агента

## Запуск агента

1. Відкрийте **Copilot Chat** у VS Code.
2. Виберіть custom agent **build-engineer**.
3. У списку команд `/` виберіть `/init` з українським описом
   **«Послідовно виконати повну ініціалізацію Rust-проєкту…»**.

Команда `/init` послідовно виконує `git-init`, `create-project`,
`create-build`, `create-actions` і `check`, зупиняючись на першій помилці.

Окремо можна викликати `/check` для read-only перевірки вже створеного
проєкту або інші command-skills: `/git-init`, `/create-project`,
`/create-build` і `/create-actions`. Reusable skills
`project-scaffold`, `build-and-test` та `github-actions` використовуються
відповідними command-skills.

## Локальна збірка

У корені проєкту виконайте:

- Windows: `ci.bat`;
- Linux/macOS: `bash ./ci.sh`;
- окремо тест release-режиму: `cargo test --release`.

Після успішної збірки виконуваний файл шукайте в каталозі `dist/`:
`dist/hello.exe` у Windows або `dist/hello` у Linux/macOS.
