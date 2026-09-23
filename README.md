# dotvimrc

个人 Vim 配置（Vim 9，插件用 [vim-plug](https://github.com/junegunn/vim-plug) 管理，快捷键提示用 vim-which-key）。

- 仓库地址：`git@github.com:chenquanquan/dotvimrc.git`
- 仓库根目录就是 `~/.vim`，`~/.vimrc` 是指向 `~/.vim/vimrc` 的符号链接
- 修改 `vimrc` 保存后自动重新加载；也可以用 `;lp` 手动加载

## 目录结构

```
~/.vim/
├── vimrc              # 主配置（唯一需要手工维护的文件）
├── setup.sh           # 一键部署：软链接、目录、vim-plug、系统依赖
├── test.sh            # 冒烟测试（37 项检查，改完配置跑一下）
├── after/plugin/
│   └── unmap.vim      # 屏蔽 LeaderF 默认的 <Leader>f / <Leader>b
├── plugged/           # vim-plug 安装的插件（不进 git，:PlugInstall 重建）
├── autoload/plug.vim  # vim-plug 本体（不进 git）
├── files/             # backup / swap / undo / viminfo（不进 git）
└── README.md
```

## 部署（新机器）

```bash
# 1. 安装依赖（setup.sh 会自动检测并调用 apt，也可手动执行）
sudo apt install git curl ripgrep universal-ctags cscope

# 2. 取仓库到 ~/.vim（已有 ~/.vim 先备份）
mv ~/.vim ~/.vim.bak 2>/dev/null || true
git clone git@github.com:chenquanquan/dotvimrc.git ~/.vim

# 3. 一键部署（建软链接/目录，装 vim-plug，补齐系统依赖）
cd ~/.vim && ./setup.sh

# 4. 安装插件（非交互）
vim +PlugInstall +qall

# 5. 验证
~/.vim/test.sh
```

用 HTTPS 且不想配 SSH key 的话，把 clone 地址换成
`https://github.com/chenquanquan/dotvimrc.git`。

## 依赖

| 工具 | 版本/说明 | 用途 | 安装 |
|------|-----------|------|------|
| git | 必需 | vim-plug / fugitive | `apt install git` |
| curl | 仅首次部署 | 下载 vim-plug | `apt install curl` |
| ripgrep (`rg`) | ≥ 13 | LeaderF `rg` 搜索、CtrlSF 后端 | `apt install ripgrep` |
| universal-ctags | 提供 `ctags-universal` | tagbar 符号大纲 | `apt install universal-ctags` |
| cscope | ≥ 15 | cscope 跳转 | `apt install cscope` |
| python3-dev + gcc | 仅在重建 LeaderF C 扩展时 | 加速模糊匹配 | `apt install python3-dev build-essential` |
| rustfmt | 可选 | `:RustFmt` | `rustup component add rustfmt` |

> 注意：Ubuntu 里 `ctags` 可能仍指向旧的 Exuberant Ctags。
> 本配置通过 `g:tagbar_ctags_bin = 'ctags-universal'` 显式指定，tagbar 不受影响。
> 如果命令行手动生成 tags，请用 `ctags-universal -R .`。

## 快捷键总览

### 怎么快速查快捷键

| 方式 | 说明 |
|------|------|
| 按 `;` | 弹出 which-key 菜单，显示所有分组和键位；按分组字母（如 `s`）继续下钻；`<Esc>` 退出 |
| `;H` 或 `:Cheat` | **全量速查表**：把当前所有 `;` 开头的映射实时导出到临时缓冲区，按 `q` 关闭（内容永远和实际配置一致） |
| `:nmap ;` | 列出所有以 `;` 开头的普通模式映射（含插件注册的） |
| `:verbose nmap ;hs` | 查看某个键最终绑定到什么、由哪个文件哪一行设置（排查冲突神器） |
| `:e ~/.vim/README.md` | 打开本文件，用 `/` 或 `;sr` 搜索键位说明 |
| `:help index` | Vim 内置键位手册（跟自定义配置无关） |

> 说明：`;?` 已被 vim-mark 占用（`MarkSearchAnyPrev`），所以速查表用 `;H`。

按 `;`（leader）会弹出 which-key 提示，下面是按分组的速查。

### 基础 / UI

| 键 | 功能 |
|----|------|
| `jj`（插入模式） | 回到 Normal 模式 |
| `;w` / `;wa` / `;q` | 保存 / 全部保存 / 退出 |
| `;ep` / `;lp` | 编辑 vimrc / 重新加载 vimrc |
| `;a` / `<C-n>` / `<C-p>` | 关闭 quickfix / 下一条 / 上一条 |
| `//`（可视模式） | 搜索选中文本 |
| `;ll` | 高亮当前行 |
| `;k` / `;K` | 高亮光标词 / 清除所有高亮词 |
| `;uc` | 切换 cursorline + cursorcolumn |
| `;ul` / `;un` | 显示 / 隐藏不可见字符（tab、行尾等） |
| `;bm` / `;bu` | 显示 / 取消 80 列标尺（按窗口生效） |
| `;H` / `:Cheat` | 生成全部 leader 快捷键速查表 |

### Git（vim-gitgutter + vim-fugitive）

| 键 | 功能 |
|----|------|
| `]c` / `[c` | 跳到下 / 上一个改动 hunk |
| `;hs` / `;hu` / `;hp` | stage / 撤销 / 预览当前 hunk |
| `;gg` | `:Git`（git 任意子命令） |
| `;gd` | 与索引对比当前文件（`:Gdiffsplit`） |
| `;gb` | `:Git blame` |
| `;gl` | `:Git log --oneline` |

### Buffer / 文件

| 键 | 功能 |
|----|------|
| `;bb` | 列出 buffer 并切换 |
| `;bl` | LeaderF buffer 搜索 |
| `;be` / `;bt` / `;bs` / `;bv` | bufexplorer / 切换 / 水平分屏 / 垂直分屏 |
| `;ff` | LeaderF 文件搜索 |
| `;fe` | 目录浏览（`:Sexplore!`） |
| `;fl` / `;fF` | NERDTree 开关 / 定位当前文件 |
| `;tl` | tagbar 符号大纲 |

### 搜索

| 键 | 功能 |
|----|------|
| `;sr` | LeaderF + ripgrep 交互搜索（推荐） |
| `;sf` | CtrlSF 输入关键字搜索 |
| `;sn` / `;sp` | 用光标下词 / 上次搜索词搜索 |
| `;sF`（可视模式） | 直接搜索选中文本 |
| `;so` / `;st` | 打开 / 显示隐藏 CtrlSF 结果窗口 |
| `;jf{char}` / `;js{char}{char}` | easymotion 跳到字符 / 双字符 |
| `;jL` / `;jw` | easymotion 跳到行 / 词 |

### 标签 / 符号（ctags + cscope）

| 键 | 功能 |
|----|------|
| `;lt` | `set tags=tags`（加载当前目录 tags） |
| `;lc` | `cs add cscope.out`（加载 cscope 数据库） |
| `;cs` / `;cg` / `;cc` | 查找符号 / 定义 / 调用者 |
| `;ct` / `;ce` / `;cf` | 文本 / 正则 / 文件 |
| `;ci` / `;cd` | include 该文件的 / 被谁调用 |
| `<C-\>s` 等 | 同上，cscope 默认风格快捷键 |

生成索引（在项目根目录）：

```bash
ctags-universal -R .
cscope -Rbq          # 生成 cscope.out
```

### 其它

| 键 | 功能 |
|----|------|
| `;M` / `;N` | vim-mark：切换标记 / 清除全部 |
| `;ih` / `;is` / `;ihn` | a.vim：C/C++ 头文件/源文件互跳（插入、普通模式都有） |
| `m` 系列、`]'`、`` ]` ``、`]-`、`]=` | vim-signature 的 mark 管理（默认键） |

## 插件管理

```bash
vim +PlugInstall +qall   # 安装 vimrc 中新增的插件
vim +PlugUpdate  +qall   # 更新全部插件
vim +PlugClean!  +qall   # 删除 vimrc 中已移除的插件目录
vim +PlugStatus          # 查看状态（交互）
```

### LeaderF C 扩展（重要）

LeaderF 的模糊匹配 C 扩展是**按 Python ABI 编译**的。只要 Vim 内嵌的
Python 大版本变了（例如系统从 3.11 升到 3.13），旧 `.so` 就无法加载，
LeaderF 会退化成纯 Python 模式（大项目明显变慢）。重建：

```bash
cd ~/.vim/plugged/LeaderF && ./install.sh
# 或者 vim 里执行 :LeaderfInstallCExtension
```

`test.sh` 会检查该扩展是否可导入。

## 验证

```bash
~/.vim/test.sh
```

共 37 项检查，覆盖：外部依赖、启动无报错、关键映射归属、`n`/`N` 计数、
gitgutter 跳转、插件命令存在性、LeaderF C 扩展、tagbar 解析 C++ 符号。
全部 PASS 退出码为 0，否则非 0，可直接用于 CI 或改配置后的自检。

单独查看某个映射的最终来源：

```bash
vim -Nu ~/.vim/vimrc --not-a-term -es \
  +'redir! > /tmp/maps.txt' +'silent verbose nmap <C-p>' +'redir END' +qa!
cat /tmp/maps.txt
```

## 故障排查

| 症状 | 原因 | 处理 |
|------|------|------|
| `;sf` 报找不到后端 | 没装 rg/ag/ack | `sudo apt install ripgrep`，`:echo ctrlsf#backend#Detect()` 应输出 `rg` |
| `]c` 提示 `Please change your map ...` | 映射用了废弃的 `<Plug>` 名 | 已修复为 `<Plug>(GitGutterNextHunk)` 等 |
| `3n` 报 `E16: Invalid range` | vim-interestingwords 默认劫持了 `n`/`N` | 已修复：`g:interestingWordsDefaultMappings = 0` |
| 大项目 LeaderF 卡顿 | C 扩展与 Vim 的 Python 版本不匹配 | 重建：`cd ~/.vim/plugged/LeaderF && ./install.sh` |
| tagbar 报找不到 ctags | 只有 Exuberant Ctags | `sudo apt install universal-ctags`；配置已指定 `ctags-universal` |
| 系统 Python 升级后 LeaderF 变慢 | 同上 | 同上重建 |
| `:PlugInstall` 后命令仍不存在 | 插件没装全 | `vim +PlugInstall +qall`，看 `:PlugStatus` |
| 启动提示 swap 文件已存在 | Vim 异常退出 | 删除 `~/.vim/files/swap/` 下对应文件 |
| 升级 Vim 后 tagbar 报错 | tagbar 版本过旧 | `:PlugUpdate` 后再重建 LeaderF 扩展 |

## 设计取舍（改之前先看）

- **缩进**：`noexpandtab` + `softtabstop=8 shiftwidth=8`（Tab 缩进，按 8 对齐）。
- **`backupskip=` 为空**：`/tmp` 下的文件也会产生备份。若常用 `crontab -e`
  需要留意，可自行加回 `/tmp/*`。
- **`n`/`N` 不再轮询高亮词**：vim-interestingwords 的默认映射会导致计数搜索
  `3n` 报 E16，因此关闭默认映射，只用 `;k` 加词、`;K` 清空。
- **LeaderF 默认键被屏蔽**：`after/plugin/unmap.vim` 去掉 `;f`/`;b`，
  统一使用 `;ff` / `;bb` / `;bl`。
- **80 列标尺**用 `:match` 实现，只对执行时所在的窗口生效；新窗口里按
  `;bm` 重新应用。
- **`set list` 默认开启**：tab 显示为 `▸`，不习惯就用 `;un` 关闭。
- **已移除的插件**：`ctrlp.vim`（停更、被 LeaderF 取代）、`ack.vim`
  （依赖未安装的 ack）、`vim-grepper`（无后端、无映射）。

## 本次修复记录

- gitgutter 4 个映射改用 `<Plug>(...)` 形式，`]c`/`[c` 恢复可用，另加 `;hp` 预览
- 删除失效插件 ack.vim / ctrlp.vim / vim-grepper 并清理目录
- vim-interestingwords 关闭默认映射，修复 `3n` 的 E16，新增 `;k`/`;K`
- `;uc`/`;ul`/`;un` 独立 UI 组，解决 `;bl`、`;cc` 映射冲突
- `;eL` 笔误修正为 `;jL`
- `;bl` 保持 LeaderF buffer，list 开关迁移到 `;ul`/`;un`
- `<C-m>`（等于回车）改为 `<C-p>`；`imap` 改 `inoremap`
- 新增 vim-fugitive 映射 `;gg/;gd/;gb/;gl`，NERDTree `;fF`
- 新增 `;H` / `:Cheat` 实时速查表（`;?` 已被 vim-mark 占用）
- tagbar 改用 universal-ctags，删除过时的 `g:tagbar_type_cpp` 覆盖
- 新增 `test.sh`、`.gitignore`，README 重写
