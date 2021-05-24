package org.zerock.domain;

import lombok.Getter;
import lombok.ToString;

@Getter
@ToString
public class PageDTO {
    private int startPage;
    private int endPage;
    private boolean prev, next;

    private int total;
    private Criteria cri;

    public PageDTO(Criteria cri, int total){
    /*
        페이징용 필드 계산하기

        1. 매 페이지의 끝번호 계산 => endPage
        2. 매 페이지의 시작번호 계산 : [1]에서 계산한 끝번호-(amount-1) => startPage
        3. 진짜 마지막페이지의 끝데이터 계산 : realEnd
        4. if( 마지막페이지가 amount만큼 딱 안떨어지는 경우 ) {
                진짜 마지막페이지는 출력되는 마지막데이터까지만 출력
           }
        5. 현재페이지의 이전 prev, 다음 next 계산

        * Math.ceil은 올림, int로 변환하기
    */
        this.cri=cri;       // pageNum, amount
        this.total=total;   // 총 데이터row

        // 여기서 정해둔 매 페이지의 마지막 데이터의 ROWNUM : 페이지버튼 번호의 마지막숫자
       // this.endPage=(int)(Math.ceil( cri.getPageNum() / (cri.getAmount() * 0.1) )) * cri.getAmount() ;

        // amount = 10 일때
          this.endPage=(int)(Math.ceil( cri.getPageNum() / 10.0 )) * 10;

        // 페이지버튼 번호의 시작숫자
        // this.startPage = this.endPage - (cri.getAmount()-1);

        this.startPage = this.endPage - 9 ; // amoun=10 일 때는 9를 빼야함

        // 마지막 페이지에서 amount보다 적은 데이터가 출력되는 경우 ( realEnd < this.endPage )
        int realEnd = (int)(Math.ceil( (total*1.0) / cri.getAmount() ) ); // realEnd : 출력되는 마지막 데이터의 ROWNUM이 속한 페이지
        // int realEnd = (int)(Math.ceil( total*1.0 ) / cri.getAmount() ); // --> (int)(Math.ceil()) 괄호확인
        if( realEnd < this.endPage ){
            this.endPage = realEnd; // 진짜마지막 페이지가 끝페이지가 되게 해라
        }

        this.prev = this.startPage > 1;         // 두번째 페이지블록 이상부터
        this.next = this.endPage < realEnd;     // 진짜 끝번째 페이지
    }

}
