# Backend Recruitment Test
Welcome! This technical test is designed to assess your backend development skills, problem-solving abilities, and code quality.

## 🧪 Overview
This test is split into two stages:
- Stage 1: Ensure all tests pass.
- Stage 2: Start from stage_1 and ensure all tests pass.

Please read the instructions carefully and follow the steps in order.

```shell
bundle install
bundle exec rails db:create db:migrate
bundle exec rspec spec/stage_1
bundle exec rspec spec/stage_2
```