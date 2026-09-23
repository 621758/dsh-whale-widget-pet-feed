# 小鲸鱼挂件 · 衍生版（摸头 / 互动统计 / 投喂）
<p align="center">
<img width="480" height="588" alt="demo" src="https://github.com/user-attachments/assets/c28573c0-3662-4b61-bc1b-fe840eab03ee" />

> **非官方衍生版（unofficial fork）** —— 本仓库 `dsh-whale-widget-pet-feed`，基于
> [`MeteorNOX/DeepSeek-Balance-Whale-Widget`](https://github.com/MeteorNOX/DeepSeek-Balance-Whale-Widget)
> 的 **0.3.9**（DeepSeek Harness Web 界面右下角的余额小鲸鱼挂件）。上游原有的余额 / 今日已用 /
> 峰谷定价 / 自定义泡泡 / 角色 / 音效等全部功能**原样保留**，本仓库只在其之上追加下面 4 组功能。

---

## 一、这个衍生版加了什么

| 功能 | 一句话说明 |
| --- | --- |
| **摸头切图 + 摸头音效** | 鼠标在角色上来回划 → 角色图切成「摸头图」，停手 0.7 秒切回；可开/关，可换图，音效跟现有音效系统联动 |
| **互动统计** | 菜单里的二级面板：今日 / 本月 / 总**点击**数 + 今日 / 本月 / 总**摸头**数，可一键清空 |
| **投喂按钮** | 点一下角色 → 左侧展开 🍚 / 🥤 / 🪙 三个 Emoji 按钮，按下会把角色图切成对应的食物图（2.2 秒后切回） |
| **内置兜底图** | 摸头图 / 投喂图都随包带一份，工作区或 `$DSH_HOME` 下那几张图被删/改名也不会切出裂图 |
<p align="center">
<img width="420" height="336" alt="demo-feed" src="https://github.com/user-attachments/assets/3538bf0c-23aa-4ac3-a655-fd25603adbcc" />

改动逐文件清单（与官方 0.3.9 SHA256 比对）：**改动 2 个文件、新增 4 张图，官方文件一个不少**
—— 见下面第五节。

---

## 二、安装

### 前置

- 已装好 DSH，profile 目录默认是 `%DSH_HOME%\profiles\web`（Windows 上通常是 `%USERPROFILE%\.dsh\profiles\web`）；
- 该 profile 的 `package.json` 里 `dsh.profile.bundles` 已包含 `dsh-whale-widget`（装过官方版就有）。

### 方式 A：一键脚本（Windows）

```powershell
# 把整个仓库放到任意目录后执行
.\install.ps1
# 自定义 profile / 跳过备份：
.\install.ps1 -ProfileDir "$env:USERPROFILE\.dsh\profiles\web"
.\install.ps1 -NoBackup
```

脚本会把仓库里的 `lib/ assets/ cordis.patch.yml package.json` 覆盖到
`<profile>\node_modules\dsh-whale-widget\`，并先把现有包备份成 `dsh-whale-widget.bak-时间戳`。
（执行策略拦截时用 `powershell -ExecutionPolicy Bypass -File .\install.ps1` 或 `pwsh -File .\install.ps1`。）

### 方式 B：手动复制

把仓库根目录的 **`lib\`、`assets\`、`cordis.patch.yml`、`package.json`** 覆盖到
`%DSH_HOME%\profiles\web\node_modules\dsh-whale-widget\` 对应位置（覆盖前去掉只读属性）。

### 方式 C：从 Git 仓库 / tarball 安装

```powershell
cd %DSH_HOME%\profiles\web
npm i "https://github.com/621758/dsh-whale-widget-pet-feed"    # 或
npm i "D:\path\to\dsh-whale-widget-0.3.9-fork.tgz"
```

### 生效条件

| 改动部分 | 生效方式 |
| --- | --- |
| 前端（挂件界面、摸头、投喂、统计） | 浏览器**硬刷新 Ctrl+Shift+R** |
| 宿主 `lib/index.js`（新增两条图片路由） | **重启一次 DSH**（`dsh web`） |

> 摸头图 / 投喂图都走宿主路由；宿主路由里带了「工作区 / `$DSH_HOME` 同名图 → 随包内置图」的回退，
> 所以即使本地没有那几张图，也一定拿得到图。

---

## 三、怎么用

菜单 = 角色右上方那个 **☰** 按钮（若关过，右键角色 / 手机长按角色可唤出）。

### 1. 摸头切图 + 摸头音效

鼠标在角色身上**左右来回划**（累计 3 次有效方向反转、1.4 秒内完成、每一笔 ≥12px）→ 切到摸头图；
**停手约 0.7 秒**切回当前角色图。

| 菜单项 | 说明 |
| --- | --- |
| `摸头切图` | 总开关，关掉后怎么划都不切图（也不出摸头音效） |
| `摸头音效` | 播当前**音效组的「按下」音**，跟音量条 / 音效开关联动；点击优先，点按角色时不会和摸头音叠成两遍 |
| `摸头图` | 填本地图片绝对路径（png/jpg/gif/webp）；**留空 = 自动**：工作区里的 `jjii.png` → `$DSH_HOME\jjii.png` → 随包内置图 |

防误触发参数在 `assets/whale-widget.js` 顶部（数字越小越灵敏）：
`PET_MIN_FLIPS=3`、`PET_WINDOW_MS=1400`、`PET_MIN_SEG_PX=12`、`PET_MAX_TILT=1.8`、`PET_FLIP_GAP_MS=50`、`PET_IDLE_MS=700`。

### 2. 互动统计

菜单 → **`互动统计` [查看]**：

```
- = 互动统计 = -
今日点击 / 本月点击 / 点击总数
今日摸头 / 本月摸头 / 摸头总数
[ 清空统计 ]
```

- **点击** = 鼠标点在角色上那一下（拖动角色、长按唤菜单不算）；
- **摸头** = 每次**真的触发切图**算一次（继续摸着不重复计数）；
- **清空统计** 会把两组数据一起归零，先弹确认框。

数据存 `localStorage['dshw-click']`（逐日明细保留最近 400 天，总数单独存；坏数据自动归零）。

### 3. 投喂按钮

**点一下角色** → 角色左侧展开三个 Emoji 按钮（**无操作约 4.2 秒自动收起**，鼠标停在按钮上会暂停计时）：

| 按钮 | 作用 |
| --- | --- |
| 🍚 米饭 / 🥤 可乐 / 🪙 token | 播当前音效组的「按下」音 → Emoji 飞进角色 → 角色抖一下 → 冒一句台词 → **角色图切成对应的食物图**，2.2 秒后切回 |

菜单里的 `投喂按钮` 开关默认开；关掉后点角色也不再出现（等于把投喂收起来）。
与摸头图互不抢占：谁后发生谁显示，各自停够时长再切回。

### 4. 图从哪来（删图不裂）

| 用途 | 取图顺序（宿主路由内完成） |
| --- | --- |
| 摸头图 | 菜单里填的路径 → 工作区 `jjii.png` → `$DSH_HOME\jjii.png` → `assets/pet-default.png` |
| 投喂图 | 工作区 `米饭.png`/`可乐.png`/`硬币.png`（也接受 `rice.png`/`cola.png`/`token.png`/`coin.png`）→ `$DSH_HOME` 下同名文件 → `assets/feed-*.png` |

想换成自己的图：直接把同名文件放进工作区或 `%DSH_HOME%`，或在菜单「摸头图」里填绝对路径。

---

## 四、可调参数

`assets/whale-widget.js` 顶部常量：

```js
var PET_MIN_FLIPS = 3       // 摸头：累计几次有效反转（越小越灵敏）
var PET_WINDOW_MS = 1400    // 这些反转要在多久内完成
var PET_MIN_SEG_PX = 12     // 一笔（同方向）至少划多长才算数
var PET_MAX_TILT = 1.8      // 竖直分量超过水平分量几倍就不算左右滑动
var PET_FLIP_GAP_MS = 50    // 两次反转最小间隔
var PET_IDLE_MS = 700       // 停手多久切回角色图
var PET_SOUND_GAP_MS = 220  // 连续摸头时音效最小间隔
var PET_CLICK_MUTE_MS = 400 // 点按后多久内不补摸头音（避免响两遍）
var FEED_SHOW_MS = 2200     // 投喂：食物图停留时长
var FEED_HIDE_MS = 4200     // 投喂按钮：无操作多久自动收起
```

CSS（同文件 `css = [...]`）：`.dshwv-feed` 的 `right: calc(59.45% + 12%)` 控制投喂按钮**离角色图的远近**
（数字越大越远），`bottom: 8%` 控制高低，`.dshwv-feed-btn` 控制按钮大小。

---

## 五、与上游 0.3.9 的差异（SHA256 逐文件比对）

上游 0.3.9 共 **20** 个文件，本仓库 **24** 个（+ 仓库级文档/脚本）—— 上游文件**一个不少**（SHA256 逐文件实测）：

| 类别 | 数量 | 文件 |
| --- | --- | --- |
| **代码改动** | 2 | `assets/whale-widget.js`（前端：四组新功能全部在这）、`lib/index.js`（宿主：新增两条图片路由） |
| **文档/许可改动** | 3 | `LICENSE`（追加本衍生版的版权行）、`PROVENANCE.md`（追加第五节：本衍生版新增素材）、`README.md`（换成本发布说明；上游原文另存 `README.upstream.md`） |
| **新增图片** | 4 | `assets/pet-default.png`、`assets/feed-rice.png`、`assets/feed-cola.png`、`assets/feed-token.png` |
| **仓库级新增** | 3 | `install.ps1`（一键安装）、`.gitignore`、`README.upstream.md`（上游 README 原文） |
| **原样保留** | 15 | `lib/accounting.mjs`、`cordis.patch.yml`、`package.json`，以及 `assets/` 下原有 12 个素材（DSniang1/02.png、DSH2.png、rua.gif、bubble-*.gif、D1/D2/Ya1/Ya2.mp3、minecraft-exp-orb.wav、task-end-a.wav） |
| **缺失** | 0 | ✅ |

新增的两条宿主路由：

| 路由 | 说明 |
| --- | --- |
| `GET /dsh-whale/pet-image.png?p=<绝对路径>` | 按路径现读现发本地图片（只放行 png/jpg/jpeg/gif/webp/bmp/avif，≤32MB）；`p` 为空或读不到时按上面的候选顺序回退 |
| `GET /dsh-whale/feed-image.png?kind=rice\|cola\|token` | 投喂图；kind 对应工作区/`$DSH_HOME` 下的同名图，缺失回退 `assets/feed-*.png` |

两条路由都沿用上游插件的「信任栅栏」（`connection.requestRejection`）与 `registerRoute` 包装。

`localStorage` 键：`dshw-pet`（摸头：开关/路径/音效）、`dshw-feed`（投喂按钮开关）、`dshw-click`（互动统计）。

---

## 六、许可与素材

本仓库**两段版权、两种范围**，`LICENSE` 里已经写好两行版权：

| 范围 | 文件 | 许可 |
| --- | --- | --- |
| 上游代码 | `lib/accounting.mjs`、`lib/index.js` 的上游部分、`cordis.patch.yml`、`package.json` | **MIT**，`Copyright (c) 2026 MeteorNOX` |
| **本衍生版新增/修改的代码** | `assets/whale-widget.js`（全部新功能）、`lib/index.js` 里新增的两条图片路由 | **MIT**，`Copyright (c) 2026 ZJJ` |
| 美术 / 音效素材 | `assets/**`（含上游 12 个素材 + 本衍生版新增的 4 张兜底图） | **不适用 MIT**，按 **as-is** 提供（见 `PROVENANCE.md`） |

- **本衍生版新增/修改的代码同样按 MIT 授权**：任何人可以自由使用/修改/再分发，只要保留 `LICENSE` 里的版权声明（两行都要留）。
- `LICENSE` 头部第二行 = **ZJJ**，代表本衍生版新增/修改部分的版权；上游那行（MeteorNOX）必须保留。
- `LICENSE` = **纯 MIT**（标题 + 两行版权 + 逐字正文，正文之后没有其它内容）——
  这样 GitHub 才能自动识别成 MIT；衍生声明单独放在 [`NOTICE.md`](NOTICE.md)。
- 素材为什么不套 MIT：美术素材若套 MIT，等于允许他人任意转卖/再许可；本仓库沿用上游惯例，以 **AS-IS + 保留权利** 提供
  （如需变更，改 `PROVENANCE.md` 第五节即可）。
- **上游仓库**：<https://github.com/MeteorNOX/DeepSeek-Balance-Whale-Widget>
- 若你是权利人并认为素材有问题，请在本仓库开 issue，我们会立即替换或移除。
- 素材中出现的第三方商标、品牌标识与角色形象（例如可乐罐身上的标识）归其各自权利人所有，
  此处仅作表达性使用，不表示任何关联、赞助或背书。

> ⚠️ 本仓库是**非官方衍生版**，与上游作者无关；请勿把它当作官方版本，也不要发布同名 npm 包
> （`dsh-whale-widget` 已被上游占用）。问题 / 建议 / 权利主张请提到本仓库 Issues：
> <https://github.com/621758/dsh-whale-widget-pet-feed/issues>

---

## 七、卸载 / 回滚

```powershell
# 用安装脚本生成的备份回滚
Remove-Item "$env:DSH_HOME\profiles\web\node_modules\dsh-whale-widget" -Recurse -Force
Rename-Item "$env:DSH_HOME\profiles\web\node_modules\dsh-whale-widget.bak-<时间戳>" dsh-whale-widget
# 或者直接装回官方版
cd "$env:DSH_HOME\profiles\web"; npm i dsh-whale-widget@0.3.9
```

> 上游 `dsh plugin` 升级会覆盖本衍生版（整个包被替换），升级后重跑一次 `install.ps1` 即可。

---

## 八、已知限制

- 首次打开页面会后台预载摸头图与三张投喂图（1.4MB + 3×1.6MB，本地读取）；预载未完成时不会硬切图（避免切出空白），音效与台词照常。
- 自 0.3.9 起上游的宿主代码改动都需要重启 DSH 才会加载（前端刷新即可）。
- 本衍生版未新增任何音频素材，音效全部复用上游的音效组机制。
