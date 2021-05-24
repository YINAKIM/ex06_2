package org.zerock.domain;

import lombok.Data;

import java.util.Date;

@Data
public class BoardVO {
    private Long bno;
    private String title;
    private String content;
    private String writer;
    private Date regdate;
    private Date updateDate;

    //댓글의 수
    private int replyCnt;
}
