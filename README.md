# Zent Scanner

## Tổng quan

Zent Scanner là ứng dụng di động hỗ trợ quá trình học tập tại trung tâm Zent. Sử dụng Zent Scanner để quét mã QR code và trả lời câu hỏi, câu hỏi có thể ở dạng trắc nghiệm hoặc tự luận.  
Ví dụ chúng ta có mã QR code sau:

![](srcs/qrcode.png)

Sau khi sử dụng ứng dụng Zent Scanner trên iOS hoặc Android để quét mã QR code trên, câu hỏi sẽ xuất hiện và học viên sẽ lựa chọn câu trả lời.

![](srcs/rendered.png)

## Cấu trúc QR Code

Mã QR code trên được tạo ra bởi đoạn json sau:

```json
{
  "questionId": "16",
  "metaData": "base64String"
}
```
Ứng dụng sau đó sẽ gửi 1 request để lấy thông tin câu hỏi chi tiết:

```bash
$ curl --location --request GET 'https://stag.devmind.edu.vn/api/questions/get/16' \
--header 'Content-Type: application/json' \
```

> TRONG ĐÓ:
> ***https://stag.devmind.edu.vn/api/questions/get/{{questionId}}*** là địa chỉ để lấy thông tin câu hỏi chi tiết, địa chỉ này được hardcode giá trị mặc định trong App, khi App khởi động sẽ lấy giá trị mới nhất từ Remote Config.
> ***metaData***  sẽ được dùng để gửi lên server sau này, lúc lấy thông tin câu hỏi không sử dụng đến giá trị này.

Sau khi gửi request, server sẽ trả về câu hỏi chi tiết như sau:

```bash
{
    "status": {
        "code": 0,
        "message": "success"
    },
    "data": {
        "metaData": "base64String",
        "qr_json": {
            "questionId": "abc1234xyz",
            "questionType": "input",
            "questionTitle": "Phản hồi",
            "questionMessage": "Chúng tôi muốn lắng nghe ý kiến phản hồi của bạn về trung tâm để cải thiện và nâng cao chất lượng dịch vụ, bạn vui lòng dành ít phút để điền vào ô phía dưới nhé:",
            "imageUrl": "https://larryferlazzo.edublogs.org/files/2020/03/feedback_1583238216.png",
            "answersSuccess": "Cảm ơn bạn dành thời gian cho chúng tôi!",
            "requestUrl": "https://stag.devmind.edu.vn/api/login"
        }
    }
}
```

Phía App sẽ render câu hỏi dựa trên giá trị json của key `qr_json`:

| từ khoá | mô tả | yêu cầu |
| ----- | ----- | ----- |
| questionId | Mã định danh câu hỏi được Backend định nghĩa. Giá trị này sẽ được gửi lên server khi học viên trả lời câu hỏi | bắt buộc |
| questionType | Kiểu câu hỏi, chỉ được chọn 1 trong các giá trị sau: <br> `singleChoice`: Câu hỏi trắc nghiệm chỉ có 1 đáp án đúng <br> `multiChoice`: Câu hỏi trắc nghiệm có nhiều đáp án <br> `input`: Câu hỏi tự luận | bắt buộc |
| questionTitle | Tiêu đề ngắn ngọn của câu hỏi, thường là chủ đề của câu hỏi | tuỳ chọn |
| questionMessage | Nội dung câu hỏi | bắt buộc |
| imageUrl | Đường dẫn tới hình ảnh sẽ hiển thị ngay dưới nội dung câu hỏi | tuỳ chọn |
| options | Mảng các câu trả lời. Nếu là câu hỏi tự luận, vui lòng bỏ trống trường này | tuỳ chọn |
| answers | Mảng các câu trả lời đúng. <br> Mảng có 1 giá trị nếu là câu hỏi trắc nghiệm chỉ có 1 đáp án đúng. <br> Mảng có nhiều giá trị nếu là câu hỏi trắc nghiệm có nhiều đáp án đúng. <br> Nếu là câu hỏi tự luận, vui lòng bỏ qua trường này. | tuỳ chọn |
| answersSuccess | Nội dung sẽ xuất hiện khi học viên trả lời đúng câu hỏi trắc nghiệm hoặc hoàn thành câu hỏi tự luận | bắt buộc |
| answersFail | Nội dung sẽ xuất hiện khi học viên trả lời sai câu hỏi trắc nghiệm. Vui lòng bỏ qua trường này nếu là câu hỏi tự luận | tuỳ chọn |
| requestUrl | Ứng dụng sử dụng giá trị này để gửi kết quả lên server, nếu trường này trống, ứng dụng sẽ hiển thị `answersSuccess` ngay lập tức | tuỳ chọn |

## Gửi kết quả lên server

Sau khi học viên trả lời câu hỏi, nếu giá trị `requestUrl` được cung cấp, ứng dụng sẽ gửi 1 request lên server:

```bash
$ curl --location --request POST {{requestUrl}} \
--header 'Content-Type: application/json' \
--data-raw '{
  "userEmail": "user@email.com",
  "questionId": "16",
  "answers": ["answer here", "and here"],
  "isCorrectAnswer": 1,
  "metaData": "base64String"
}'
```

> Trong đó:
> `userEmail`: email mà học viên đã đăng nhập vào ứng dụng trên mobile.
> `questionId`: mã định danh câu hỏi lấy từ QR code.
> `answers` Mảng string các câu trả lời của học viên.
> Trường hợp câu hỏi trắc nghiệm chỉ có 1 đáp án đúng, mảng này chỉ có 1 giá trị.
> Trường hợp câu hỏi trắc nghiệm có nhiều đáp án đúng, mảng này có nhiều giá trị.
> Trường hợp câu hỏi tự luận, mảng này chỉ có 1 giá trị.
> `isCorrectAnswer` Nếu câu hỏi tự luận sẽ không có trường này.
> `isCorrectAnswer` Bằng 1 nếu học viên trả lời đúng và bằng 0 nếu trả lời sai.
> `metaData`: Được lấy lúc quét mã QR code.

Sau khi phía server xử lý xong phải trả về HTTP Code như sau:
* 200: Đã xử lý câu trả lời thành công, mobile app sẽ hiện nội dung của `answersSuccess` lấy từ QR code.
* khác 200: mobile app sẽ hiện thông báo lỗi.
