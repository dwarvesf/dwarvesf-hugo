

---

date: "2015-10-16T13:09:56+07:00"
draft: false
title: "Vim kết hợp cùng Go lang"

description: "Giới thiệu Vim và cách sử dụng Vim với Go lang"
categories: intro, go, hugo, vim

coverimage: blog-cover.jpg

excerpt: "Vim là một text-editor khá mạnh, được sử dụng trong môi trường máy chủ không có giao diện đồ họa. Trong bài này mình sẽ hướng dẫn các bạn sử dụng Vim như một IDE dành cho Go"

authorname: Lê Ngọc Thạch
authorlink: http://runikitkat.com
authortwitter: runivn
authorgithub: RuniVN
authorbio: Unknown
authorimage: gancho.png

---

- Vim là một text-editor khá mạnh, được sử dụng trong môi trường máy chủ không có giao diện đồ họa. Trong bài này mình sẽ giới thiệu Vim căn bản và hướng dẫn các bạn sử dụng Vim như một IDE dành cho Go

## Vim là gì?

  * Vim là text editor cao cấp, phiên bản sau của Vi(Vim = Vi Improved), được viết bởi Bram Moolenaar, lần đầu tiên được đưa ra vào năm 1991.
  * Vim thường được gọi à "editor dành cho dân lập trình", tuy nhiên nó có thể hầu hết các công việc liên quan tới văn bản như sửa chữa văn bản, soạn thảo email hay sửa file configs.
  * Vim có thể sử dụng làm IDE nhờ các plugins
  * Vim hỗ trợ đa nền tảng.

## Cài đặt và config     

  * Vim có thể được download tại trang [vim homepage](http://www.vim.org/download.php) hoặc cài đặt bằng [brew](http://brew.sh/)

      ```
         brew install vim
      ```
    Vì một số plugins phía sau có thể cần tới lua nên các bạn nên cài với câu lệnh:

      ```
         brew install vim --with-lua
      ```

  * Sau khi cài đặt xong, các bạn tạo một file .vimrc ở ~/ (file này không tự động tạo). File .vimrc này sẽ là nơi chứa toàn bộ config, plugins hay bundle cũng như các function liên quan tới vim.
  * Tiếp theo là cài vim plugins manager. Hiện tại mình đang sử dụng [Vundle](https://github.com/VundleVim/Vundle.vim), các bạn có thể sử dụng [panthogen](https://github.com/tpope/vim-pathogen) nếu thích.    
    Vundle sẽ giúp các bạn trong việc config các plugins trong .vimrc, install hay update và một số việc khác.         
    Để cài đặt, các bạn clone vundle vào thư mục ~/.vim/bundle/ (thư mục .vim sẽ có sau khi cài đặt vim xong)

    ```
       git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
    ```
    
    Copy vào .vimrc một số configs và các plugin cơ bản (chú ý dấu " trong vim là comment)

        set nocompatible              " be iMproved, required
        filetype off                  " required

        " set the runtime path to include Vundle and initialize
        set rtp+=~/.vim/bundle/Vundle.vim
        call vundle#begin()
        " alternatively, pass a path where Vundle should install plugins
        "call vundle#begin('~/some/path/here')

        " let Vundle manage Vundle, required
        Plugin 'VundleVim/Vundle.vim'

        " The following are examples of different formats supported.
        " Keep Plugin commands between vundle#begin/end.
        " plugin on GitHub repo
        Plugin 'tpope/vim-fugitive'
        " plugin from http://vim-scripts.org/vim/scripts.html
        Plugin 'L9'
        " Git plugin not hosted on GitHub
        Plugin 'git://git.wincent.com/command-t.git'
        " git repos on your local machine (i.e. when working on your own plugin)
        Plugin 'file:///home/gmarik/path/to/plugin'
        " The sparkup vim script is in a subdirectory of this repo called vim.
        " Pass the path to set the runtimepath properly.
        Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
        " Avoid a name conflict with L9
        Plugin 'user/L9', {'name': 'newL9'}

        " All of your Plugins must be added before the following line
        call vundle#end()            " required
        filetype plugin indent on    " required
        " To ignore plugin indent changes, instead use:
        "filetype plugin on
        "
        " Brief help
        " :PluginList       - lists configured plugins
        " :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
        " :PluginSearch foo - searches for foo; append `!` to refresh local cache
        " :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
        "
        " see :h vundle for more details or wiki for FAQ
        " Put your non-Plugin stuff after this line
        ```

      Tiếp theo để install plugins, các bạn mở vim lên và chạy command sau(bằng cách nhấn Esc):

      ```
          :PluginInstall
      ```
      Để update plugins, các bạn sử dụng 

      ```
          :PluginUpdate
      ```

      Như vậy là đủ đồ chơi để các bạn có thể sử dụng Vim rồi.

## Hướng dẫn sử dụng căn bản.
  Vim là một chương trình soạn thảo được build lần đầu tiên trên UNIX, dùng để làm việc trên môi trường ko có UI. Lúc này bàn phím chưa cũng khá thô sơ, nên các bước di chuyển trên vim hơi khác với bình thường:

    {{% img src="/images/hjkl.png" class="third right" %}}

  Các bạn có thể tự tập luyện việc sử dụng các phím này bằng [vim game](http://vim-adventures.com/)       

  Để mở một file với vim, các bạn dùng câu lệnh: 
        ```vim file_name```

  Trong vim có 3 mode:      
 -- Normal mode - xuất hiện khi bạn ấn Ecs, thường đi kèm đầu tiên bởi dấu ":". Ở đây vim sẽ hiểu những gì bạn gõ vào là câu lệnh cho vim. Ví dụ:```:w``` là save văn bản, ```:q``` là thoát một văn bản.         
       Vim có ngôn ngữ riêng dành cho mình, đó là Vim script. Vim script có thể được execute ở normal mode, ví dụ, để in ra Hello world chúng ta dùng:       
       
          :echo "Hello world"
       


-- Insert mode - xuất hiện khi bạn nhấn một trong các nút sau :
          
          a: Insert vào phía sau con trỏ hiện tại
          A: Insert vào cuối hàng
          i: Insert vào phía trước con trỏ hiện tại
          I: Insert vào đầu hàng
          o: Insert và mở một hàng trống phía dưới
          O: Insert và mở một hàng trống phía trên       


-- Visual mode -- xuất hiện khi bạn ấn nút v, được dùng cho việc chọn một mảng block text lớn, có thể sử dụng vào việc copy paste hoặc comment...

   Các bạn có thể đọc [vim command](http://bullium.com/support/vim.html) để biết thêm về các command trong vim.
## Sử dụng Vim như Go IDE

   Để sử dụng Vim như một IDE cho Go, chúng ta cần cài đặt một số plugins cho go.     

   Quan trọng nhất là [vim go](https://github.com/fatih/vim-go/). Vim go bao gồm tập hợp các thư viện hỗ trợ Go cho vim, ví dụ ```godef``` 
   ```gofmt``` ```go test ```

   Để cài đặt vim go, các bạn copy plugin vào file .vimrc

   ```
   Plugin 'fatih/vim-go'
   ```

   Sau đó vào normal mode bằng cách nhấn ```Esc``` và gõ command:
   
   ```
   :PluginInstall
   ```

   Xong, lại tiếp tục gõ command để install Go binaries

   ```
    :GoInstallBinaries 
   ```

   Chỉ với Vim-go các bạn đã có thể code Go được rồi, nhưng để mọi thứ dễ nhìn hơn cũng như tăng độ hiệu quả, các bạn nên tìm và cài thêm các plugin sau

  ```
    ack.vim
    bclose.vim
    bufexplorer
    nerdtree
    nerdcommenter
    csapprox
    vim-fugitive
    gitv
    vim-gitgutter
    syntastic
    neocomplete.vim
    neosnippet.vim
    auto-pairs
  ```
  Trong số này:

  -- nerdtree: Giúp bạn tổ chức folder trong vim dưới dạng cây thư mục, dễ dàng hơn trong việc mở file và folder. Sau khi cài đặt:
  {{% img src="/images/nerdtree.png" class="third right" %}}

  Nhờ plugin của git, các bạn có thể biết file nào đang sửa, thêm mới và chưa được commit.

  -- neocomplete: Hỗ trợ auto complete trong vim. 
   {{% img src="/images/neocomplete.png" class="third right" %}}

  -- autopair: Plugin giúp bạn gõ nhanh khi sử dụng các dấu " ( ' [ < bằng cách thêm vào thành một pair "" () '' [] <>

## Cơ chế mapping trong Vim

Vim có một khái niệm là mapping, cho phép người dùng mode lại các tổ hợp phím để phục vụ các mục đích cá nhân.   

```
Khi tôi nhấn key này, tôi muốn bạn làm hành động này thay vì những gì bạn hay thường làm  
``` 
Ví dụ: 
  Gõ vài dòng trên văn bản bằng vim, sau đó chạy command:

```
:map - x
```
Đặt con trỏ của bạn lên văn bản và nhấn ```-```. Vim lập tức delete kí tự tại vị trí con trỏ, như là bạn đã nhấn ```x```       

Lúc này mapping của bạn chỉ có hiệu quả trên file text mà bạn đang edit, để mapping hoạt động trên toàn bộ các file khác, bạn cần đặt mapping vào trong file .vimrc    
Một số loại mapping thường dùng:

```
  nmap    : sử dụng khi ở chế độ normal
  imap    : sử dụng trong chế độ insert
  vmap    : sử dụng trong chế độ visual
  noremap : không thể bị override bởi mapping khác
```
Ví dụ, khi code Go chúng ta hay dùng godef để tìm định nghĩa của hàm(biến) đó. Để sử dụng với vim-go chúng ta cần vào normal mode và gõ ```:GoDef```      
Thay vì vậy, mình mapping lại như sau

```
nnoremap <silent> df :GoDef<cr>

```

Có nghĩa là, khi mình ở chế độ normal, ấn tổ hợp df sẽ thực hiện command ```:GoDef```. Map này không bị override bởi bất kì normal map nào khác.    
Như vậy, khi bạn muốn tìm kiếm định nghĩa một hàm hay một biến nào đó, bạn sử dụng tổ hợp phím ```df```. Việc này giảm thiểu quá trình typing đi khá nhiều.

Một ví dụ về mapping khác, ví dụ mình hay sử dụng thư viện [print](https://github.com/k0kubun/pp) để in ra result ở terminal đẹp hơn. Việc log để debug trong Go diễn ra khá thường xuyên, vì vậy mình đặt một map như sau:

```
inoremap <silent> pp pp.Println("")
```
Tức là khi mình gõ trong insert mode ```pp``` nó sẽ tự chuyển thành ```pp.Println("")```, điều này giúp mình code nhanh hơn.

Các bạn có thể đọc thêm về [mapping in vim ](http://vimdoc.sourceforge.net/htmldoc/map.html)

## Lời kết
Tất cả mọi thứ dường như đã sẵn sàng! Việc còn lại của bạn là tập luyện:

* Sử dụng nhuần nhuyễn cách di chuyển trong vim bằng các nút hjkl, cũng như các command cơ bản trong vim.
* Tìm thêm các plugins để hỗ trợ thêm cho vim. Một trang mình thấy khá hay và bổ ích về [plugins cho vim](http://vimawesome.com)
* Điểm mạnh của vim chính là customization, các bạn nên tìm cách tạo những mapping hay function giúp tăng tốc độ code.
   
Trên đây là những gì mình tìm hiểu được về Vim và cách sử dụng Vim để code Go. Thế giới của Vim có rất nhiều điều để có thể tìm hiểu, mong nhận được sự đóng góp của mọi người.
Nếu có điều gì muốn trao đổi, liên hệ qua mail thach@dwarvesf.com với mình nha.
