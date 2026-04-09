# Heartbeat 机制

> 每日 22:00 自动维护 self-improving 系统

---

## 触发时机

每日 22:00（cron）

---

## 执行内容

1. **扫描变化** - 扫描 `self-improving/` 自上次以来的变化
2. **刷新索引** - 更新 `index.md` 文件计数
3. **压缩文件** - 合并重复条目
4. **冷热分级** - 30 天未用→WARM，90 天未用→归档
5. **更新状态** - 更新 `heartbeat-state.md`
6. **触发 Hook** - 执行 `knowledge-sedimentation.sh`

---

## 配置示例

`~/.openclaw/cron/jobs.json`:

```json
{
  "jobs": [{
    "name": "Self-Improving Heartbeat",
    "schedule": {
      "kind": "cron",
      "expr": "0 22 * * *",
      "tz": "Asia/Shanghai"
    },
    "payload": {
      "kind": "systemEvent",
      "text": "🧠 Self-Improving Heartbeat 触发..."
    }
  }]
}
```

---
