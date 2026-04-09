# Dream 机制

> 每日 03:00 自动提升短期记忆到长期知识

---

## 触发时机

- **Light Dream**: 每日 03:00
- **Deep Dream**: 每周
- **REM Dream**: 每月

---

## 执行内容

### Light Dream（每日）
1. 排序去重短期记忆
2. 基础提升（短期 → MEMORY.md）
3. 写 DREAMS.md 日记

---

## 配置

`~/.openclaw/openclaw.json`:

```json
{
  "plugins": {
    "entries": {
      "memory-core": {
        "config": {
          "dreaming": { "enabled": true }
        }
      }
    }
  }
}
```

---
