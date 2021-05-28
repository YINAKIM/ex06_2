package org.zerock.domain;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
// 팁, @ToString(exclude={"제외할필드1","제외할필드2"}) : 이렇게 toString에서 제외할 필드도 지정할 수 있다.
public class Criteria {
    private int pageNum;   // 페이지번호
    private int amount;    // 한페이지에 보여줄 row 수

    // 검색조건용 필드 추가
    private String type;
    private String keyword;

    // 맨첫페이지, 테스트용
    public Criteria(){
        this(1,10);
    }

    // 값 받아서 처리할 생성자
    public Criteria(int pageNum, int amount){
        this.pageNum=pageNum;
        this.amount=amount;
    }

    // 검색조건 : 각 글자 {T,W,C}로 구성된 배열로 만들어서 한번에 getTypeArr()로 처리
    public String[] getTypeArr(){
        return type == null ? new String[] {} : type.split("");
    }

    // 게시물 삭제작업 후, 페이지번호 + 검색조건 유지하면서 이동하려면 redirect로 뒤에 파라미터 연결해야되서 불편
    // ---> getListLink()만들어서 한번에 처리 : UriComponentsBuilder




}
