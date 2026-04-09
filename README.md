# OpenClaw 记忆和进化系统

> 一个自动化的个人知识管理和自我进化系统

---

## 快速开始

### 1. 安装

```bash
# 克隆项目
git clone https://github.com/Elo-Mario/openclaw-memory-system.git

# 复制示例配置到你的 OpenClaw workspace
cp -r openclaw-memory-system/example/* ~/Dropbox/workspace/openclaw/workspace/

# 复制 Hook 脚本
cp openclaw-memory-system/hooks/knowledge-sedimentation.sh ~/.openclaw/hooks/
chmod +x ~/.openclaw/hooks/knowledge-sedimentation.sh
```

### 2. 配置

**启用 Dream**（编辑 `~/.openclaw/openclaw.json`）：
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

**配置 cron**（参考 `config/cron-jobs.json`，合并到 `~/.openclaw/cron/jobs.json`）

### 3. 使用

- **日常**：正常和 AI 对话、执行任务
- **每日 22:00**：Heartbeat 自动维护 + Hook 自动生成沉淀候选
- **每日 03:00**：Dream 自动提升短期记忆
- **你看一眼**：`pending/` 目录的沉淀候选，告诉 AI 哪些要写进正式知识库

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

## 便利之处

| 问题 | 传统方式 | 这个系统 |
|------|---------|---------|
| 经验记不住 | 靠脑子/笔记，容易忘 | 自动沉淀到文件，永久保存 |
| 踩坑重复踩 | 下次还忘 | 写入 `experience/`，AI 自动读取 |
| 成功难复制 | "上次怎么做的来着？" | 写入 `skills/`，直接复用 |
| 知识散乱 | 到处是笔记，找不到 | 统一目录结构，按角色分类 |
| 维护麻烦 | 需要手动整理 | Heartbeat 自动维护（冷热分级、压缩） |
| 沉淀靠自觉 | 做着做着就忘了 | Hook 每日自动扫描，生成候选 |

**核心价值**：
1. **不靠自觉**——自动扫描、自动提醒、自动维护
2. **不依赖记忆**——知识写进文件，AI 每次任务前自动读取
3. **可积累**——越用知识越多，AI 越懂你的工作方式
4. **可迁移**——换设备、换 AI，知识文件带走就能用

---

## 适用人群

**适合**：
- 用 OpenClaw 日常协作，希望沉淀经验的
- 经常踩同样的坑，想避免重复的
- 有成功方法，但下次想不起来用的

**不适合**：
- 只用一两次，不长期用的
- 不想让 AI 自动写文件的（可以关闭自动沉淀）

---

## 常见问题

### Q: 会自动写我的知识库吗？

A: 不会直接写。Hook 生成候选到 `pending/`，需要你确认后 AI 才写入正式知识库。

### Q: 可以关闭自动沉淀吗？

A: 可以。删除 cron 配置中的 Heartbeat job，或者不复制 Hook 脚本。

### Q: 知识库文件在哪里？

A: `~/Dropbox/agent-knowledge/` 目录下，按角色和类型分类。

### Q: 可以同步到多台设备吗？

A: 可以。知识库放在 Dropbox/云盘，通过符号链接访问。

---

## 许可证

MIT License

---

## 参考

- OpenClaw 文档：https://docs.openclaw.ai
- GitHub: https://github.com/openclaw/openclaw
