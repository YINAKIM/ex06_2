package org.zerock.domain;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.Getter;

import java.util.List;

@Data
@AllArgsConstructor
@Getter
public class ReplyPageDTO {  //댓글페이징 필요한 경우 사용

    private int replyCnt;   // 댓글의 수
    private List<ReplyVO> list;
}
