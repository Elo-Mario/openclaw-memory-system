# OpenClaw 记忆和进化系统

> 一个自动化的个人知识管理和自我进化系统

---

## 快速开始

```bash
# 1. 克隆项目
git clone https://github.com/your-username/openclaw-memory-system.git

# 2. 复制示例配置到 OpenClaw workspace
cp -r example/* ~/Dropbox/workspace/openclaw/workspace/

# 3. 复制 Hook 脚本
cp hooks/knowledge-sedimentation.sh ~/.openclaw/hooks/

# 4. 配置 cron（参考 config/cron-jobs.json）
```

---

## 核心架构

**两层存储 + 一层治理**：

```
短期记忆 (OpenClaw Builtin)
    ↓ Dream 提升 (每日 03:00)
长期知识 (~/Dropbox/agent-knowledge/)
    ↓ Heartbeat 维护 (每日 22:00)
自我进化 (~/self-improving/)
```

---

## 目录结构

```
.
├── README.md                 # 本文件
├── PROJECT.md                # 项目主文档（待办、日志）
├── docs/                     # 文档
│   ├── architecture.md       # 架构设计
│   ├── heartbeat.md          # Heartbeat 机制
│   ├── dreaming.md           # Dream 机制
│   └── sedimentation.md      # 知识沉淀 Hook
├── example/                  # 示例配置
│   ├── USER.md               # 示例用户画像
│   ├── SOUL.md               # 示例人格
│   └── IDENTITY.md           # 示例身份
├── self-improving/           # 行为规则
│   ├── memory.md             # HOT 规则
│   ├── corrections.md        # 纠正日志（示例）
│   ├── validated-patterns.md # 成功经验（示例）
│   └── index.md              # 索引
├── hooks/
│   └── knowledge-sedimentation.sh  # 沉淀 Hook
├── config/
│   └── cron-jobs.json        # cron 配置示例
└── memory/                   # 每日日记（运行时生成）
```

---

## 核心机制

### 1. Self-Improving（自我进化）

**三层自动化**：
| 层级 | 风险 | 处理方式 |
|------|------|---------|
| L1 | 低 | 格式、错别字 → 自动修正 |
| L2 | 中 | 规则补充、流程细化 → 自动更新 |
| L3 | 高 | 人格/核心原则 → 等确认 |

**知识沉淀五问**（任务完成后）：
1. 踩坑了吗？→ `experience/`
2. 可复用流程？→ `skills/`
3. 抽象准则？→ `principles/`
4. 跨场景泛化？→ `insights/`
5. 问答值得留存？→ `queries/`

### 2. Heartbeat（心跳维护）

**触发时机**：每日 22:00

**执行内容**：
- 扫描 `self-improving/` 变化
- 刷新 `index.md`
- 压缩超大文件
- 检查 30 天/90 天未用模式 → 降级/归档
- 更新 `heartbeat-state.md`

### 3. Dream（梦境提升）

**触发时机**：每日 03:00

**执行内容**：
- 排序、去重短期记忆
- 基础提升（短期 → MEMORY.md）
- 写 DREAMS.md 日记

### 4. Knowledge Sedimentation（知识沉淀 Hook）

**触发时机**：每日 22:00（Heartbeat 后）

**执行内容**：
- 扫描当日会话历史
- 查询任务执行记录
- 识别重复模式、失败根因、用户纠正
- 生成沉淀候选到 `pending/`

---

## 配置说明

### cron 配置

位置：`~/.openclaw/cron/jobs.json`

参考：`config/cron-jobs.json`

### Dream 配置

位置：`~/.openclaw/openclaw.json`

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

## 许可证

MIT License

---

## 参考

- OpenClaw 文档：https://docs.openclaw.ai
- GitHub: https://github.com/openclaw/openclaw
