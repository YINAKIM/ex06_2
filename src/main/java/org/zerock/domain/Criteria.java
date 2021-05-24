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

    /*
            Lombok @Data 안쓰고 @Getter @Setter @ToString 쓰는이유??
            @Data는
            @Data = @RequiredArgsConstructor + @Getter + @Setter + @ToString + @EqualsAndHashCode
            인데

            1. @RequriedArgsConstructor 의경우
               초기화 되지 않은 모든 final 필드,
               @NonNull과 같이 제약조건이 설정되어있는 모든 필드들에 대한 생성자를 자동으로 생성한다.
               => 발생할 수 있는 문제점 :
                    예로 들어, 두 개의 같은 타입 인스턴스 멤버를 선언 > 나중에 개발자가 선언된 인스턴스 멤버의 순서를 바꾸면,
                    개발자도 인식하지 못하는 사이에 lombok이 생성자의 파라미터 순서를 필드 선언 순서에 따라 변경

                    이때, IDE가 제공해주는 리팩토링은 전혀 동작하지 않고,
                    두 필드가 동일 타입이기 때문에 기존 소스에서도 오류가 발생하지 않아
                    아무런 문제없이 동작하는 것으로 보이지만,
                    #### 실제로 입력된 값이 바뀌어 들어가는 상황 #### 이 발생한다.

            2. @EqualsAndHashCode : equals 메소드와 hashcode 메소드를 생성한다
            => 발생할 수 있는 문제상황 :
             객체를 Set에 저장한 뒤 필드 값을 변경하면 hashCode가 변경되면서
             이전에 저장한 객체를 찾을 수 없는 문제가 발생한다.


            [SOL] ===>  각각   @Getter @Setter @ToString 쓰는것을 권장!

    */
}
