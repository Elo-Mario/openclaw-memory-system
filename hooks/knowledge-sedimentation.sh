#!/bin/bash
# Knowledge Sedimentation Hook v2
# 扫描当日会话历史，生成待分析清单
# 触发时机：每日 22:00 Heartbeat（AI 随后分析）

set -e

KNOWLEDGE_BASE="$HOME/Dropbox/agent-knowledge"
PENDING_DIR="$KNOWLEDGE_BASE/pending"
SESSIONS_DIR="$HOME/.openclaw/agents/main/sessions"
TASKS_DB="$HOME/.openclaw/tasks/runs.sqlite"
TODAY=$(date +%Y-%m-%d)
TODAY_FILE=$(date +%Y%m%d)
TIMESTAMP=$(date +%Y%m%d-%H%M%S)

# 确保 pending 目录存在
mkdir -p "$PENDING_DIR"

# 输出文件
SESSION_LIST="$PENDING_DIR/sedimentation-sessions-$TIMESTAMP.txt"
TASK_SUMMARY="$PENDING_DIR/sedimentation-tasks-$TIMESTAMP.txt"

echo "📊 扫描会话历史..."

# 1. 找出今日更新的会话文件
echo "# 今日会话文件清单 - $TODAY" > "$SESSION_LIST"
echo "# 生成时间：$(date '+%Y-%m-%d %H:%M:%S')" >> "$SESSION_LIST"
echo "# 格式：路径" >> "$SESSION_LIST"
echo "" >> "$SESSION_LIST"

find "$SESSIONS_DIR" -name "*.jsonl" -type f -newermt "$TODAY" 2>/dev/null | head -50 >> "$SESSION_LIST"

SESSION_COUNT=$(grep -c "^/" "$SESSION_LIST" 2>/dev/null || echo 0)
echo "发现 $SESSION_COUNT 个今日会话文件"

# 2. 查询今日任务执行记录
echo "📋 查询任务记录..."

echo "# 今日任务执行摘要 - $TODAY" > "$TASK_SUMMARY"
echo "# 生成时间：$(date '+%Y-%m-%d %H:%M:%S')" >> "$TASK_SUMMARY"
echo "" >> "$TASK_SUMMARY"

if [ -f "$TASKS_DB" ]; then
    # 获取今日任务（按 created_at  timestamp 转换）
    echo "## 任务状态统计" >> "$TASK_SUMMARY"
    echo "" >> "$TASK_SUMMARY"
    
    sqlite3 "$TASKS_DB" "SELECT status, COUNT(*) FROM task_runs WHERE created_at >= strftime('%s', '$TODAY') GROUP BY status;" 2>/dev/null >> "$TASK_SUMMARY" || echo "查询失败" >> "$TASK_SUMMARY"
    
    echo "" >> "$TASK_SUMMARY"
    echo "## 失败/异常任务" >> "$TASK_SUMMARY"
    echo "" >> "$TASK_SUMMARY"
    
    sqlite3 "$TASKS_DB" "SELECT task_id, substr(task, 1, 80), status, error FROM task_runs WHERE created_at >= strftime('%s', '$TODAY') AND status IN ('lost', 'timed_out', 'failed') LIMIT 20;" 2>/dev/null >> "$TASK_SUMMARY" || echo "查询失败" >> "$TASK_SUMMARY"
    
    echo "" >> "$TASK_SUMMARY"
    echo "## 高频任务类型（按 task 前缀分组）" >> "$TASK_SUMMARY"
    echo "" >> "$TASK_SUMMARY"
    
    sqlite3 "$TASKS_DB" "SELECT substr(task, 1, instr(task, ' ') - 1) as task_prefix, COUNT(*) as cnt FROM task_runs WHERE created_at >= strftime('%s', '$TODAY') AND task_prefix != '' GROUP BY task_prefix ORDER BY cnt DESC LIMIT 20;" 2>/dev/null >> "$TASK_SUMMARY" || echo "查询失败" >> "$TASK_SUMMARY"
else
    echo "任务数据库不存在：$TASKS_DB" >> "$TASK_SUMMARY"
fi

echo "" >> "$TASK_SUMMARY"
echo "---" >> "$TASK_SUMMARY"
echo "" >> "$TASK_SUMMARY"
echo "# AI 分析指令：" >> "$TASK_SUMMARY"
echo "# 1. 读取 $SESSION_LIST 中的会话文件（每个读取最后 20 条消息）" >> "$TASK_SUMMARY"
echo "# 2. 结合本文件的任务统计，识别：" >> "$TASK_SUMMARY"
echo "#    - 重复任务模式（同一类型任务出现≥3 次）" >> "$TASK_SUMMARY"
echo "#    - 失败任务根因（error 字段 + 会话上下文）" >> "$TASK_SUMMARY"
echo "#    - 用户纠正/反馈（会话中用户说'不对'、'错了'等）" >> "$TASK_SUMMARY"
echo "# 3. 生成沉淀候选到：$PENDING_DIR/sedimentation-candidates-$TODAY_FILE.md" >> "$TASK_SUMMARY"

echo "✅ 扫描完成："
echo "   会话清单：$SESSION_LIST"
echo "   任务摘要：$TASK_SUMMARY"
echo ""
echo "📝 AI 下一步：分析上述文件，生成沉淀候选"
