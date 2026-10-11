---
description: "Створити кросплатформний GitHub Actions workflow через skill github-actions"
agent: "build-engineer"
---

# create-actions

## Призначення

Виконати skill `github-actions` і підготувати `.github/workflows/ci.yml`,
який делегує Cargo локальним `ci.sh` та `ci.bat`.

## Передумови

- Успішно виконано `create-build`.
- Існують працездатні `ci.sh`, `ci.bat` і `.gitattributes`.
- Доступний Python з модулем `yaml`.
- Наявний workflow не перезаписувати без явного дозволу.

## Дії (покроково)

1. Прочитати та виконати `.github/skills/github-actions/SKILL.md`.
2. Перевірити line endings локальних скриптів і наявність `.gitattributes`.
3. Створити каталог `.github/workflows/`, якщо його немає.
4. Створити сумісний `ci.yml` з `push`, `pull_request`, `workflow_dispatch`,
   матрицею `ubuntu-latest`, `windows-latest`, `macos-latest`,
   `actions/checkout@v4` та `actions/upload-artifact@v4`.
5. Налаштувати `bash ./ci.sh` для Linux/macOS і `ci.bat` з `shell: cmd` для
   Windows.
6. Перевірити YAML і переконатися, що прямого виклику `cargo` у workflow
   немає.

## Очікувані файли

- `.github/workflows/ci.yml` із валідним YAML, однією job `build`, matrix
  трьох ОС та artifact `hello-${{ matrix.os }}` з `path: dist/`.
- Наявні `ci.sh`, `ci.bat` і `.gitattributes` не змінені без потреби.

## Команди перевірки

```text
python -c "import yaml; yaml.safe_load(open('.github/workflows/ci.yml', encoding='utf-8'))"
```

Пошуком перевірити `ubuntu-latest`, `windows-latest`, `macos-latest`,
`actions/checkout@v4`, `actions/upload-artifact@v4` і відсутність прямого
виклику `cargo` у `.github/workflows/ci.yml`.

## Повідомлення про помилку (точний текст і що робити)

- `ПОМИЛКА: YAML workflow невалідний. Виправте структуру ci.yml відповідно до skill github-actions і повторіть команду.`
- `ПОМИЛКА: у ci.yml відсутня одна з цільових ОС або обов'язковий action. Додайте лише відсутню сумісну конфігурацію і повторіть перевірку.`
- `ПОМИЛКА: ci.yml містить прямий виклик cargo. Перенесіть Cargo-операції до ci.sh/ci.bat, потім повторіть команду.`
- `ПОМИЛКА: модуль yaml недоступний у Python. Встановіть PyYAML і повторіть перевірку.`

Конфліктний workflow не об’єднувати приховано та не переходити до `check`.

## Повторний запуск (не руйнує створені файли і не дублює конфігурації)

Сумісний `ci.yml` не перезаписувати. Не дублювати triggers, ОС, jobs або
кроки; при структурному конфлікті зупинитися й описати його.

