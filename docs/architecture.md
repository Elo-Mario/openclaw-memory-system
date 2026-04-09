# 架构设计

> 记忆和进化系统的核心架构

---

## 设计原则

**主动推送，而非被动查询。** 信息应该在合适的时间主动流向你，不需要你去找。

**两层维护，各司其职**：
- **Heartbeat**（22:00）— 管 self-improving 日常维护
- **Dream**（03:00）— 管短期记忆→长期知识的提升和治理

---

## 核心架构

```
短期记忆 (OpenClaw Builtin)
    ↓ Dream 提升 (每日 03:00)
长期知识 (~/Dropbox/agent-knowledge/)
    ↓ Heartbeat 维护 (每日 22:00)
自我进化 (~/self-improving/)
```

---

## 目录结构

### agent-knowledge/

| 目录 | 用途 | 说明 |
|------|------|------|
| `self-improving/` | 行为规则 | HOT/WARM/COLD 三层 |
| `memory/` | 每日日记 | Dream 输出 |
| `base/` | 跨角色知识 | experience/insights/principles/skills/queries |
| `roles/` | 角色知识 | 按角色分类的专属知识 |
| `log.md` | 变更时间线 | 知识库变更历史 |

### self-improving/

| 文件 | 用途 | 读取时机 |
|------|------|---------|
| `memory.md` | HOT 规则 | 每次任务前 |
| `corrections.md` | 纠正日志 | 按需 |
| `validated-patterns.md` | 成功经验 | 按需 |
| `index.md` | 文件索引 | 按需 |

---

## 数据流

```
用户任务
    ↓
AI 执行 → 实时沉淀 (auto-evolution L1/L2)
    ↓
任务记录 → runs.sqlite
会话历史 → sessions/*.jsonl
    ↓
Heartbeat (22:00)
    ↓
Hook 扫描 → pending/候选
    ↓
AI 分析 → 用户确认
    ↓
正式写入 → base/roles/
```

---

## 关键决策

### 1. 为什么分两层存储？

- **短期记忆**：OpenClaw builtin，会话级，自动清理
- **长期知识**：文件系统，持久化，可版本控制

### 2. 为什么 Hook 输出到 pending/？

- 避免 AI 乱写正式知识库
- 用户确认环节，保证质量

---
