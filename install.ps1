# 把本衍生版装回 DSH profile（Windows 一键）
#
# 用法：
#   .\install.ps1                                  # 装到 %DSH_HOME%\profiles\web\node_modules\dsh-whale-widget
#   .\install.ps1 -ProfileDir "$env:USERPROFILE\.dsh\profiles\web"
#   .\install.ps1 -NoBackup                        # 不备份（默认备份成 .bak-时间戳）
#
# 执行策略拦截时：
#   powershell -ExecutionPolicy Bypass -File .\install.ps1
#   pwsh -File .\install.ps1
#
# 装完：浏览器硬刷新（Ctrl+Shift+R）→ 前端功能即生效；
#       宿主路由（lib/index.js）需要重启一次 DSH 才生效。

[CmdletBinding()]
param(
  [string]$ProfileDir = '',
  [switch]$NoBackup
)

$ErrorActionPreference = 'Stop'
$here = Split-Path -Parent $MyInvocation.MyCommand.Path

# 本脚本必须和 lib/ assets/ 放在同一层（仓库根目录）
if (-not (Test-Path (Join-Path $here 'lib/index.js'))) {
  throw "请在仓库根目录运行（找不到 lib/index.js）：$here"
}
if (-not $ProfileDir) {
  if ($env:DSH_HOME) { $dshHome = $env:DSH_HOME } else { $dshHome = Join-Path $HOME '.dsh' }
  $ProfileDir = Join-Path $dshHome 'profiles/web'
}
$target = Join-Path $ProfileDir 'node_modules/dsh-whale-widget'
Write-Host "仓库: $here"
Write-Host "目标: $target"

if (-not (Test-Path $target)) {
  Write-Host "目标不存在，直接创建（相当于首次安装这个包）"
  New-Item -ItemType Directory -Force -Path $target | Out-Null
} elseif (-not $NoBackup) {
  $stamp = Get-Date -Format 'yyyyMMdd-HHmmss'
  $bak = "$target.bak-$stamp"
  Write-Host "备份现有包 -> $bak"
  Copy-Item -LiteralPath $target -Destination $bak -Recurse -Force
}

$items = @('lib', 'assets', 'cordis.patch.yml', 'package.json', 'LICENSE', 'PROVENANCE.md')
foreach ($item in $items) {
  $src = Join-Path $here $item
  if (-not (Test-Path $src)) { Write-Host "  跳过（不存在）：$item"; continue }
  $dst = Join-Path $target $item
  if ((Get-Item $src).PSIsContainer) {
    if (-not (Test-Path $dst)) { New-Item -ItemType Directory -Force -Path $dst | Out-Null }
    Get-ChildItem -LiteralPath $src -Recurse -File | ForEach-Object {
      $rel = $_.FullName.Substring($src.Length).TrimStart('\')
      $out = Join-Path $dst $rel
      $outDir = Split-Path -Parent $out
      if (-not (Test-Path $outDir)) { New-Item -ItemType Directory -Force -Path $outDir | Out-Null }
      if (Test-Path $out) { try { (Get-Item -LiteralPath $out -Force).IsReadOnly = $false } catch {} }
      Copy-Item -LiteralPath $_.FullName -Destination $out -Force
    }
    Write-Host "  + $item\"
  } else {
    if (Test-Path $dst) { try { (Get-Item -LiteralPath $dst -Force).IsReadOnly = $false } catch {} }
    Copy-Item -LiteralPath $src -Destination $dst -Force
    Write-Host "  + $item"
  }
}

Write-Host ""
Write-Host "完成。接下来：" -ForegroundColor Green
Write-Host "  1) 浏览器硬刷新（Ctrl+Shift+R）——前端功能立刻生效"
Write-Host "  2) 重启一次 DSH ——宿主路由 /dsh-whale/pet-image.png、/dsh-whale/feed-image.png 生效"
