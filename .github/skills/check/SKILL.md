---
name: check
description: Перевірити повноту Rust-проєкту, CI та документації без виправлення помилок
disable-model-invocation: true
---
# check

## Призначення

Виконати повний контроль лабораторної та вивести таблицю
`№ | Перевірка | Команда | PASS/FAIL | Деталі`. Команда не виправляє
помилки й не змінює файли проєкту; дозволено лише створювати артефакти в
ігнорованих `target/` і `dist/`.

## Передумови

- Доступні `git`, `cargo`, `python`.
- Команда виконується з кореня репозиторію.
- Для YAML доступний Python-модуль `yaml`.

## Дії (покроково)

1. Перевірити manifest `.github/agents/build-engineer.agent.md`: секції
   `Роль`, `Заборонені дії`, `Критерії успішного завершення`.
2. Для кожного `.github/skills/*/SKILL.md` перевірити секції `Призначення`,
   `Вхідні дані`, `Результати`, `Перевірки`.
3. Перевірити всі шість command-skills за шляхами
   `.github/skills/<command>/SKILL.md` і порядок команд у
   `.github/skills/init/SKILL.md`.
4. Перевірити існування `Cargo.toml`, `src/lib.rs`, `src/main.rs`,
   `tests/basic_addition.rs`, `ci.sh`, `ci.bat`, `.github/workflows/ci.yml`.
5. Валідовати YAML, три ОС і відсутність прямого `cargo` у `ci.yml`.
6. Виконати `cargo build --release` та `cargo test --release`, зафіксувати
   наявність `BasicAddition ... ok`.
7. Запустити CI-скрипт поточної ОС, перевірити `dist/hello(.exe)` і вивід
   `Hello, World!`.
8. Перевірити, що `git ls-files target dist` порожній, а `git check-ignore
   target dist` спрацьовує.
9. Виконати `git grep` для `ghp_`, `github_pat_`, `BEGIN PRIVATE KEY`,
   `password=` і не вважати знайдені секрети успішним результатом.
10. Вивести всі результати й завершити `CHECK PASSED` або
    `CHECK FAILED: N помилок` із переліком.

## Очікувані файли

Файли не створювати й не виправляти. Дозволені лише збіркові артефакти
`target/` і `dist/`, які мають залишатися ігнорованими Git.

## Команди перевірки

```text
Test-Path .github/agents/build-engineer.agent.md
Get-ChildItem .github/skills/*/SKILL.md
Get-ChildItem .github/skills/*/SKILL.md
Test-Path Cargo.toml; Test-Path src/lib.rs; Test-Path src/main.rs
Test-Path tests/basic_addition.rs; Test-Path ci.sh; Test-Path ci.bat
Test-Path .github/workflows/ci.yml
python -c "import yaml; yaml.safe_load(open('.github/workflows/ci.yml', encoding='utf-8'))"
cargo build --release
cargo test --release
git ls-files target dist
git check-ignore target dist
git grep -n -e 'ghp_' -e 'github_pat_' -e 'BEGIN PRIVATE KEY' -e 'password='
```

Для поточної ОС запустити `ci.bat` у Windows або `bash ./ci.sh` в
Linux/macOS. Кожен рядок таблиці має містити PASS або FAIL і деталі.

## Повідомлення про помилку (точний текст і що робити)

- `CHECK FAILED: N помилок` — після цього перелічити кожну перевірку зі статусом FAIL, командою та деталями; нічого автоматично не виправляти.
- `ПОМИЛКА: check не змінює файли проєкту. Усуньте проблему окремою командою, потім повторіть check.`
- `ПОМИЛКА: знайдено можливий секрет у git grep. Негайно видаліть секрет без публікації, перевірте історію й повторіть check.`

## Повторний запуск (не руйнує створені файли і не дублює конфігурації)

Повторний запуск лише читає файли та запускає перевірки, повторно використовуючи
`target/` і `dist/`; він не редагує конфігурації, не виправляє помилки й не
дублює артефакти поза стандартним результатом скрипта.
