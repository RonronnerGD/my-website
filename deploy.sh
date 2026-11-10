#!/bin/bash
# 一句命令发布个人主页：同时更新 GitHub Pages 和东京服务器
# 用法：在 my-website 文件夹里敲 ./deploy.sh

set -e # 任何一步出错就立刻停下，不再往下做

cd "$(dirname "$0")" # 先走进脚本所在的文件夹，这样从哪里运行都一样

# 1. 检查：还有没存档的改动，就不发布（保证发出去的东西 GitHub 上都有备份）
if [ -n "$(git status --porcelain)" ]; then
  echo "❌ 还有改动没存档，请先 git add 和 git commit："
  git status --short
  exit 1
fi

# 2. 发布到 GitHub Pages
echo "📤 [1/2] 上传到 GitHub..."
git push

# 3. 发布到东京服务器（排除点开头的隐藏文件，和这个脚本本身）
echo "📤 [2/2] 传到东京服务器..."
rsync -av --exclude '.*' --exclude deploy.sh ./ tokyo:/var/www/html/

echo ""
echo "✅ 发布完成，请打开看看："
echo "   东京服务器：http://43.133.7.130 （马上生效）"
echo "   GitHub Pages：https://ronronnergd.github.io/my-website/ （约 1 分钟后生效）"
