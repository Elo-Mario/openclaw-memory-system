# 知识沉淀 Hook

> 每日 22:00 自动扫描会话和任务记录，生成沉淀候选

---

## 触发时机

每日 22:00（Heartbeat 后自动执行）

---

## 执行流程

```
1. 扫描会话历史 → sessions/*.jsonl
2. 查询任务记录 → runs.sqlite
3. 生成待分析清单 → pending/
4. AI 分析 → 识别模式、失败根因、用户纠正
5. 生成沉淀候选 → sedimentation-candidates-*.md
```

---

## 沉淀分类

| 分类 | 用途 |
|------|------|
| experience | 踩坑经验、失败根因 |
| skills | 可复用流程（≥3 次） |
| principles | 抽象原则 |
| insights | 跨场景洞见 |

---

## 使用方法

### 手动触发
```bash
bash ~/.openclaw/hooks/knowledge-sedimentation.sh
```

### 写入正式知识库
```
"把候选 1 写成 experience"
"把候选 2 写成 skills"
```

---

## 与 auto-evolution 的关系

| 维度 | auto-evolution | Hook |
|------|----------------|------|
| 触发时机 | 每次任务后（实时） | 每日 22:00（批量） |
| 定位 | 主流程 | 补充（扫遗漏） |

---
