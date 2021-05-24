package org.zerock.domain;

import lombok.Data;

@Data
public class AttachFileDTO {
/*
p516
파일업로드 후 브라우저로 전송해줄 데이터
1. 원본파일명
2. 업로드된 파일명 (fileName+uuid)
3. 저장된 경로
4. image파일인지 여부

=> 하나의 객체로 묶어서 보내기위해 AttachFileDTO 작성
UploadController에서 담당핸들러는 AttachFileDTO리스트를 반환해야한다.
*/

    private String fileName;
    private String uuid;
    private String uploadPath;
    private boolean image;
}
