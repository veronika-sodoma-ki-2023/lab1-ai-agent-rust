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

- Доступні `git`, `cargo`, `rustc`, `python`.
- Команда виконується з кореня репозиторію.
- Для YAML доступний Python-модуль `yaml`.
- Якщо `cargo` не знайдено в `PATH`, перевірити фізичну наявність
  `$env:USERPROFILE\.cargo\bin\cargo.exe`. Якщо файл існує, додати
  `$env:USERPROFILE\.cargo\bin` на початок `PATH` лише для поточної сесії та
  повторити `cargo --version`; нічого не встановлювати. Лише якщо
  `cargo.exe` фізично відсутній, вивести `FAIL: Rust не в PATH`.

## Дії (покроково)

Перед перевірками 8–10 виконати `cargo --version` і `rustc --version`. Якщо
`cargo` не знайдено, виконати сесійну fallback-послідовність:

```powershell
$cargoBin = Join-Path $env:USERPROFILE '.cargo\bin'
$cargoExe = Join-Path $cargoBin 'cargo.exe'
if (Test-Path $cargoExe) {
    $env:Path = "$cargoBin;$env:Path"
    cargo --version
}
```

Після цього повторити перевірку `cargo --version` і виконати
`rustc --version`. Не встановлювати Rust або інші залежності автоматично.
Лише якщо `$cargoExe` фізично не існує, вивести одним рядком
`FAIL: Rust не в PATH` та позначити перевірки 8–10 як `SKIP` із зазначенням
причини.

Для читання текстових файлів у PowerShell обов'язково використовувати
`Get-Content -Raw -Encoding UTF8`. Альтернатива — Python з
`open(..., encoding='utf-8')`. Заборонено читати ці файли через
`Get-Content` без `-Encoding UTF8`.

1. Перевірити manifest `.github/agents/build-engineer.agent.md`: секції
   `Роль`, `Заборонені дії`, `Критерії успішного завершення`.
2. Для кожного `.github/skills/*/SKILL.md` читати заголовки як UTF-8 і
   перевіряти відповідний тип skill:
   - reusable skills `project-scaffold`, `build-and-test`,
     `github-actions` мають містити заголовки `Призначення`, `Вхідні дані`,
     `Результати`, `Перевірки`;
   - command-skills `git-init`, `create-project`, `create-build`,
     `create-actions`, `check`, `init` мають містити заголовки `Призначення`,
     `Передумови`, `Дії`, `Очікувані файли`, `Команди перевірки`,
     `Повідомлення про помилку`, `Повторний запуск`.
   Назва секції зараховується лише коли це markdown-заголовок: рядок, що
   починається з `#` і містить потрібну назву. Не вимагати секції іншого типу.
3. Перевірити всі шість command-skills за шляхами
   `.github/skills/<command>/SKILL.md` і порядок команд у
   `.github/skills/init/SKILL.md`.
4. Перевірити наявність `Cargo.toml`, `src/lib.rs`, `src/main.rs`,
   `tests/basic_addition.rs`, `ci.sh`, `ci.bat`, `.github/workflows/ci.yml`.
5. Валідовати YAML, три ОС і відсутність прямого `cargo` у `ci.yml`.
   Перевірити, що `push` і `pull_request` мають `branches` з `develop` і
   `master` (PyYAML читає ключ `on` як `True`).
6. Перевірити, що в `ci.yml` використано лише
   `actions/checkout@v4` і `actions/upload-artifact@v4`, а збірка викликається
   лише через `bash ./ci.sh` та `ci.bat`.
7. Перевірити, що вивід CI-скрипта містить усі заголовки:
   `== Configure ==`, `== Build ==`, `== Test ==`, `== Package ==`.
8. Виконати `cargo build --release` і переконатися, що вивід не містить
    `warning:`.
9. Виконати `cargo test --release`, зафіксувати наявність
    `BasicAddition ... ok` і переконатися, що вивід не містить `warning:`.
10. Запустити CI-скрипт поточної ОС, перевірити `dist/hello(.exe)` і вивід
    `Hello, World!`.
11. Перевірити, що `git ls-files target dist` порожній, а `git check-ignore
    target dist` спрацьовує.
12. Виконати `git status --short` і переконатися, що не показує непередбачені
    файли `*.exe`, `*.msi`, `*.zip` поза `target/` і `dist/`.
13. Повторно перевірити, що кожен результат має однозначний статус `PASS`,
    `FAIL` або `SKIP`. `SKIP` не є успіхом і рахується як помилка в підсумку.
14. Виконати secret scan лише для реальних форм секретів регулярними
     виразами:
     `ghp_[A-Za-z0-9]{36}`,
     `github_pat_[A-Za-z0-9_]{50,}`,
     `-----BEGIN [A-Z ]*PRIVATE KEY-----`,
     `password\s*=\s*\S+`.
     Використати
     `git grep -nE 'ghp_[A-Za-z0-9]{36}|github_pat_[A-Za-z0-9_]{50,}|-----BEGIN [A-Z ]*PRIVATE KEY-----|password\s*=\s*\S+' -- . ':!.github/skills' ':!.github/agents' ':!docs'`.
     Не шукати загальні слова на кшталт `ghp_`, `github_pat_`,
     `BEGIN PRIVATE KEY` або `password=` окремо.
15. Вивести всі результати й завершити `CHECK PASSED` лише якщо всі перевірки
    мають статус `PASS`, без жодного `FAIL` або `SKIP`. Інакше завершити
    `CHECK FAILED: N помилок`, де кожен `FAIL` і `SKIP` рахується окремою
    помилкою, із переліком перевірок та причин.

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
git status --short
git grep -nE 'ghp_[A-Za-z0-9]{36}|github_pat_[A-Za-z0-9_]{50,}|-----BEGIN [A-Z ]*PRIVATE KEY-----|password\s*=\s*\S+' -- . ':!.github/skills' ':!.github/agents' ':!docs'
```

Для поточної ОС запустити `ci.bat` у Windows або `bash ./ci.sh` в
Linux/macOS. Кожен рядок таблиці має містити PASS або FAIL і деталі.

## Повідомлення про помилку (точний текст і що робити)

- `CHECK FAILED: N помилок` — після цього перелічити кожну перевірку зі статусом FAIL,
  командою та деталями; нічого автоматично не виправляти.
- `ПОМИЛКА: check не змінює файли проєкту. Усуньте проблему окремою командою, потім
  повторіть check.`
- `ПОМИЛКА: знайдено можливий секрет у git grep. Негайно видаліть секрет без публікації,
  перевірте історію й повторіть check.`
- `ПОМИЛКА: git status --short показує сторонні файли поза target/ і dist/. Видаліть їх
  або додайте правильне ігнорування, потім повторіть check.`

## Повторний запуск (не руйнує створені файли і не дублює конфігурації)

Повторний запуск лише читає файли та запускає перевірки, повторно використовуючи
`target/` і `dist/`; він не редагує конфігурації, не виправляє помилки й не
дублює артефакти поза стандартним результатом скрипта.