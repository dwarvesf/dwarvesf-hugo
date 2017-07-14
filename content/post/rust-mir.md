---

title: MIR - Sự tinh túy của chú cua bé nhỏ Rust
draft: false
date: "2017-04-05T14:36:15+07:00"
categories: rust, programming, safe

coverimage: 2015-02-05-revel-installation-banner.png

excerpt: "Dạo này Rust đang nổi lên như một thế lực khiến một hispter như mình không thể không để tâm. Sau vài ngày dig deeper vào Rust, mình cho rằng Rust là một ngôn ngữ khá hay để học"

authorname: RuniVn
authorlink: https://www.facebook.com/lnthach
authorgithub: RuniVN
authorbio: Backend Engineer
authorimage: cotton.png

---
Dạo này Rust đang nổi lên như một thế lực khiến một hispter như mình không thể không để tâm. Sau vài ngày dig deeper vào Rust, mình cho rằng Rust là một ngôn ngữ khá hay để "học".
![alt text](https://s3-ap-southeast-1.amazonaws.com/kipalog.com/cxmz5ldc6t_blob)

Lý do:

- Rust giống C/C++, học Rust các bạn có thể giải các bài toán liên quan tới vùng nhớ- điều mà các Rubylist, Pythonist không quan tâm.
- Có ownership + borrow system để hỗ trợ memory safety.
- Traits để generic.

Và đặc biệt là, Rust là một ngôn ngữ _compiler driven_, tức là khi cái app bạn build nó không bị compiler nhả lỗi, bạn đã có một chương trình safe + performance. Suy ra cái đáng để tìm hiểu ở đây là compiler :troll:

Vì vậy mình sẽ giới thiệu các bạn một chút về cái làm nên tên tuổi của và chỉ có ở Rust -  MIR.

Cơ mà để hiểu được, cần có một số kiến thức căn bản.
# Compiler là gì
Như các bạn đã biết, mã máy(machine code) là một loại ngôn ngữ lập trình mà chỉ bao gồm hai con số 0 và 1. Với khả năng readable gần như bằng 0, ngôn ngữ máy không thể dùng phổ biến cho việc lập trình. Điều này dẫn tới việc ra đời của các ngôn ngữ cấp cao. Đặc điểm của hướng tiến hóa là càng ngày càng gần với ngôn ngữ tự nhiên. Tuy nhiên, machine code là thứ duy nhất mà CPU có thể hiểu được. Vì vậy, với mỗi loại ngôn ngữ sinh ra, đều có đi kèm song song một công cụ để biên dịch từ mã nguồn cấp cao sang mã nguồn cấp thấp có thể execute được. Đó là compiler.
![alt text](https://s3-ap-southeast-1.amazonaws.com/kipalog.com/7s2d1eww19_blob)

Vậy định nghĩa compiler là gì? Là một chương trình giúp biên dịch từ một ngôn ngữ bậc cao xuống một ngôn ngữ cấp thấp(thường là machine code).
Ngược lại với compiler là decompiler, giúp dịch ngược từ một ngôn ngữ bậc thấp lên một ngôn ngữ bậc cao. Nghe giống reverse engineering? Chính xác thì decompilation chỉ là một kĩ thuật trong reverse engineering.
Ngoài ra còn có transpiler – dịch từ một ngôn ngữ bậc cao sang một ngôn ngữ bậc cao khác. Ví dụ như babel trong JS, là một trình giúp dịch từ ES6 xuống ES5.

# Cách hoạt động của một compiler
Một compiler khi hoạt động sẽ có 2 phases: frontend và backend. Theo một số tài liệu thì họ chia ra thêm 1 phase là middle end nằm chính giữa nhưng theo mình thì 2 phases là đủ.

![alt text](https://s3-ap-southeast-1.amazonaws.com/kipalog.com/a4x6hpr62u_blob)

Frontend compiler: Ở phase này, mã nguồn cấp cao sẽ được transform thành IR(Intermediate Representation). **Nhớ IR này nha**. Các bạn tạm hiểu đây là một data structure  nằm trung gian giữa front end và backend compiler, mà được thiết kế để dễ dàng hơn trong việc optimize và translate. Một IR phải có độ chính xác tuyệt đối(có thể represent mã nguồn mà không mất thông tin). Các công việc sẽ làm ở front end bao gồm:

-	Phân tích mã nguồn, kiểm tra cú pháp và ngữ nghĩa
-	Type checking
-	Sinh ra error và warning nếu có.

Backend compiler sẽ nhận vào output của front end. Công việc chính của backend sẽ là code optimization và code generation. Backend phần nhiều sẽ hỗ trợ các nền tảng(CPU) khác nhau. Các bước optimization của backend sẽ dựa trên tập lệnh của chip.
Ví dụ:
Một số chip khi thực hiện phép chia nó sẽ trả về kết quả ở một register, và số dư ở một register khác. Nên nếu trong chương trình có 2 lệnh kế nhau
```
c = a/b
d = a%b
```
=> Backend compiler optimization sẽ hiểu điều này chỉ thực hiện một operation.

Vậy output của backend compiler là gì?

Backend compiler của các ngôn ngữ sẽ produce ra các loại output khác nhau. Có 3 loại output chính:

-	Assembly code.(gcc của C)
-	Bytecodes. (javac của Java, Smalltalk)
-	Machine code. (Go compiler, Rust compiler)

Sở dĩ có sự khác nhau này là do cách tiếp cận của các ngôn ngữ. Ví dụ Java compiler(javac) sau khi compile xong, JVM sẽ nhận input là java bytecodes từ javac, sau đó tiến hành các bước optimization bằng JIT(Just in time compiler) và translation qua machine code(ở runtime).

Còn với C, output của gcc sẽ là assembly code. Để chuyển hóa thành machine code cần thêm một utility tool gọi là assembler. (Với MS compiler thì trực tiếp build ra machine code luôn). Lí do để chỉ produce ra assembly code là để chia nhỏ công việc, dễ debug compiler. Nếu so với compilation thì việc translate từ assembly qua machine code khá đơn giản.

# MIR thì có gì khác biệt?

Kiến thức cơ bản đã xong, giờ thì chúng ta sẽ đi sâu vào MIR trong Rust.

![alt text](https://s3-ap-southeast-1.amazonaws.com/kipalog.com/8w0o9dboed_blob)

Ở trên mình có giới thiệu về IR. MIR là mid-level IR, trên hình trên nó nằm giữa 2 cái là HIR - cái này thường là cây AST, và LIR hay là LLVM, cái IR magic nhất mọi thời đại. :lol:

Vậy MIR trong Rust được sinh ra để làm gì?
MIR là key của các việc sau:

- Compile nhanh hơn: MIR được thiết kế để giúp compiler của Rust có thể _incremental_. Tức là nó sẽ calculate được phần nào mới và chỉ build lại phần đó, giúp cut down được một khoản thời gian đáng kể.
- Execute nhanh hơn: Các bạn nhìn vào hình bên trái, khi mà lúc trước chỉ có một mình thằng LLVM làm nhiệm vụ optimization, thì với MIR, một số bước optimization cho riêng Rust sẽ được thực thi.
- Type checking chính xác hơn.

Ở trên chỉ là những cái mà developers có thể thấy. Vậy behind the scene thì sao?

# Behind the sence

## MIR biến Rust thành đơn nhân

MIR sẽ remove toàn bộ keywords `for`,  `match` dùng trong loop và expression, và cả method call. Sau đó thay thế bằng primitive objects.

Ví dụ, một đoạn code Rust như sau:
```
for elem in vec {
    process(elem);
}
```
Việc gọi `for` chỉ đơn giản là iterator gọi next liên tục cho tới khi hết phần tử. Nên nó sẽ được viết lại như này:

```
let mut iterator = vec.into_iter();
while let Some(elem) = iterator.next() {
    process(elem);
}
```
và cuối cùng được tranlaste bởi MIR thành:

```
    let mut iterator = IntoIterator::into_iter(vec);

loop:
    match Iterator::next(&mut iterator) {
        Some(elem) => { process(elem); goto loop; }
        None => { goto break; }
    }

break:
    ...
```

Vậy thì tại sao?

Thứ nhất, đích đến tiếp theo của MIR sẽ là LLVM, mục tiêu là để:

- Borrow checking
- Optimize performance

MIR primitive sau khi thay thế sẽ xịn hơn các construct ban đầu. Điểm đặc biệt ở đây là, `for` và `match` sẽ được replace thành `goto`. Việc đưa xuống LLVM với số lượng construct càng ít sẽ được quy về các pattern càng nhỏ, dẫn đến việc optimize dễ dàng hơn.

Thứ hai, cấu trúc trong MIR là type driven. Ví dụ `iterator.next()` sẽ được desugar thành `Iterator::next(&mut iterator)`.  Các bạn có thể thấy, MIR sẽ provide thêm đầy đủ trait và type information cho `interator` để biết được hàm next() từ đâu gọi.

Thứ ba, MIR làm tường minh mọi type trong Rust. Việc tường minh này giúp LLVM analyse borrow checking tốt hơn.

## Khái niệm control-flow graph.

Nhìn ở trên ta thấy MIR được translate ra dưới dạng text, nhưng thực tế bên trong compiler, MIR được biểu diễn thành một luồng điều khiển ở dạng graph, gọi tắt là CFG.

Ví dụ trên sẽ được vẽ thành:

![alt text](https://s3-ap-southeast-1.amazonaws.com/kipalog.com/9nzjunthry_blob)

Thực ra, bất kì compiler nào cũng đều translate ra CFG và đưa xuống cho LLVM, nhưng MIR khác ở chỗ: cái CFG mà nó translate ra match một cách hoàn hảo với cấu trúc của LLVM IR(cũng là CFG), trong khi các compiler khác không chú trọng chuyện này => có thể xảy ra sự không chính xác.

## Tối giản biểu thức `match`

MIR sẽ đơn giản hóa biểu thức `match` ở trên thành những operations nhỏ. Cụ thể:
```
match Iterator::next(&mut iterator) {
    Some(elem) => process(elem),
    None => break,
}
```
Ở đoạn code trên khi nó đã wrap lại 2 bước thành 1 bước, một là check xem thử có `Some`(tức là còn elem nào không), hai là extract cái giá trị của elem đó ra(trong Rust gọi là downcasting).

Khi qua MIR, nó sẽ trở thành:
```
loop:
    // Put the value we are matching on into a temporary variable.
    let tmp = Iterator::next(&mut iterator);

    // Next, we "switch" on the value to determine which it has.
    switch tmp {
        Some => {
            // If this is a Some, we can extract the element out
            // by "downcasting". This effectively asserts that
            // the value `tmp` is of the Some variant.
            let elem = (tmp as Some).0;

            // The user's original code:
            process(elem);

            goto loop;
        }
        None => {
            goto break;
        }
    }

break:
    ....
 ```
 Các bạn có thể thấy, `match` đã bị replace thành `switch` và `downcasting`
 Tại sao lại tách ra? Lí do là vì match quá phức tạp, và mục tiêu vẫn là làm sao để LLVM có thể phát huy tối đa khả năng optimization, nên dùng switch sẽ đơn giản hơn.

## Drops và Panic tường minh

 Trên ví dụ trên, ta đã vô hình assume rằng mọi chuyện đều xảy ra như ý muốn. Nhưng trong thực tế thì... hên xui. Đừng lo, MIR sẽ thêm thắt vào các drops(hay còn gọi là destruction) và panic operation vào trong CFG.

 Nó thành thế này đây
 ![alt text](https://s3-ap-southeast-1.amazonaws.com/kipalog.com/hb5e7si3o_blob)


# Conclusion

Trên đây là overview thiết kế của MIR. Các bạn có thể thấy, MIR có ý nghĩa trong việc giảm độ phức tạp của từng câu lệnh, lại gần với LLVM IR hơn. Việc này giúp dễ phát triển các pattern cho việc optimize.

Tóm lại thì, MIR được Rust đầu tư với hi vọng trở thành một ngọn cờ đầu của compiler evolution, khi mà tất cả các lý thuyết của nó đều quá hoàn hảo. Mục tiêu ban đầu của MIR là sẽ ôm xô một số công việc từ HIR và LLVM.


MIR sắp ra đời rồi, mọi người đón chờ xem nhé :laclac:

Nguồn tham khảo: https://blog.rust-lang.org/2016/04/19/MIR.html









