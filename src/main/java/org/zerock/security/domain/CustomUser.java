package org.zerock.security.domain;

import lombok.Getter;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.User;
import org.zerock.domain.MemberVO;

import java.util.stream.Collectors;

@Getter
public class CustomUser extends User {
//  org.springframework.security.core.userdetails.User를 상속받아 MemberVO를 UserDetails로 변환할 수 있도록 한다

    private static final long serialVersionUID = 1L;
    /*

    QQ. 코드에 보면 serialVersionUID 를 쓴적이 없는데 왜썼지????
    java_serialization_serialVersionUID.txt 참고

    => 자바 직렬화? Serializable인터페이스를 구현하면(또는 Serizlizable을 상속하는 class) serialVersionUID에 값을 할당하라고함 (누가? )
    코드(위의 조건에 해당하는 구현체 또는 서브클래스)에서 할당해두지 않으면
    컴파일러가 계산한 값을 임의로 부여하는데, Serializable 클래스나 Outer Class에 변경이 있으면(versioning)
    serialVersionUID가 값이 바뀌게 된다.

    Q1. 당장은 에러도 안나는데 어떻게 알 수 있지?
        "잠재적인" 문제는 Serialize할 때와 Deserialize할 때의 serizlVersionUID가 값이 다르면
    ---> InvalidClassException발생한다
    ---> 유효하지 않은 객체, 따라서 객체에 값을 Restore할 수 없다

    --> 지금 코드에서 보면 CustomUser는 생성자에서 MemberVO를 받아서 넣는다. (MemberVO의 값을 Restore한다)
        근데 serialVersionUID를 할당해두지 않으면 "나중에 언젠가 만약 Serializable 클래스나 Outer Class에 변경이 있으면"
        serialVersionUID의 값 자체가 컴파일러에의해 임의로 변경되어 InvalidClass가 되어 (MemberVO의 값을 Restore할 수 없는) Exception발생하는 것!


    Q2. 그럼 CustomUser는 User만 상속받는데 누가 Serializable인터페이스를 구현하면(또는 Serizlizable을 상속하는 class) 인건가?
    =>  CustomUser의 부모인 User는  java.io.Serializable 를 상속받는 UserDetails인터페이스의 구현체다
        ( public class User implements org.springframework.security.core.userdetails.UserDetails, org.springframework.security.core.CredentialsContainer )
        ( public interface UserDetails extends java.io.Serializable )

    Q3. 근데 User에도 상수로 선언되어있는데 CustomUser에도 직접 상수로 선언해야되는거면,
        원래 부모필드는 내가 쓸 수 있는데 상수는 서브클래스에서 못쓰나?

        일단 내가 아는건,
        상수(public static final)는 static이나까 static영역(class영역)에 올라가고, 프로그램 종료시까지 남아있는다.
        부모가 가진 일반 필드(상수 아닌)는 서브클래스의 인스턴스(의 멤버필드들이 객체로 생성된 것)가 Heap에 올라갈 때, 같이 올라간다. 생성자에 super()가 들어가니까.
        원래 상속받으면 서브는 슈퍼클래스의 private에 접근가능해진다.
        그런데 private static final로 정의된 멤버필드는?
        그럼 영역이 달라서 못쓰는건가?
-----------------------------------------------------------------------------------
final 키워드는 클래스, 필드, 메소드 선언 시에 사용할 수 있다. Final 키워드는 결코 수정될 수 없음을 뜻한다. --> 그건알아

상속할 수 없는 final 클래스
클래스를 선언할 때 final을 class앞에 붙이게 된다면, 최종적인 클래스이므로 상속할 수 없는 클래스가 된다 --> 그것도 알아, 근데 지금이건 필드잖아
-----------------------------------------------------------------------------------
Java 에서는 상수를 선언할 때 final을 이용하여 Read-Only 로 설정할 수 있습니다.
즉 한 번 선언한 뒤 변하지 않는 Immutable 형식이라는 것을 명시적으로 표현할 수 있습니다.
결국 Java에서의 final은 Immutable/Read-only 속성을 선언하는 지시어입니다.
클래스, 함수, 변수가 변하지 못하도록 의도하고 싶다면 final로 선언하자.
-------------------------------------------------------------------------------------
public static final
public 접근 제한자에 의해서 외부에서도 해당 오브젝트에 접근하여 값을 활용할 수 있다.
[vs]
private static final
private 접근 제한자에 의해서 외부에서는 접근이 불가능하고, 해당 클래스 내부에서만 값을 활용할 수 있다.

[+] 추가로
final 멤버 변수에 static을 사용하지 않는 경우가 있는가?
놀랍게도 DI기법을 사용하여 클래스 내부에 외부 클래스 의존성을 집어넣는 경우가 있다.
주입받을 Obj를 static final로 선언하게 되면, 선언과 동시에 초기화를 진행해야 하기 때문에
(나 생성시 Obj도 초기화, static에 올라감) ---> 외부 클래스의 의존성을 받을 수가 없다.
==> 스프링에서 생성자에 의존성을 주입받기 위해서는 주입받을 Obj를
    static final이 아니라 final로 선언해야만 (나 생성시 초기화되지 않고) 필요할 때
    applicationContext가 관리하는 스프링빈을 주입 받을 수 있다.
-----------------------------------------------------------------------------------
        다시 (QQ로) 돌아가서, serialVersionUID는 객체를 식별하기 위한 일련번호같은건데
        당장은 serialVersionUID를 안써도 지금당장은 문제가 안생기는데
        CustomUser를 만들기 위해 상속받은 User가  java.io.Serializable 를 상속받는 [UserDetails 인터페이스]의 구현체 이기때문에
        serialVersionUID에 고정값 (final, 딱1번 할당된 값을 수정하지 않겠다는 자바의 예약어)으로 할당해두지않으면
        상위클래스나 인터페이스에 수정이 생겼을 때, 컴파일러가 임의로 변경된 serialVersionUID 값을 부여하게되고, 그럼 JVM은 못알아보니까
        InvalidClassException으로 "값을 Restore"하는 이 객체의 생성 목적을 달성할 수 없다.

        그럼 어떤걸 상속받거나 구현할 때, 조상중에 java.io.Serializable 을 상속받거나 Serializable인터페이스의 구현체인지 확인하고
        만약 해당된다면 ===>  private static final long serialVersionUID = 1L;
        이런식으로 직접 고정값을 할당해줘야겠다.

        그리고 부모한테 있다 해도 private static final 가 붙은 필드는
        상속도 되지 않고, 딱1번만 값이 할당된 후 수정되지 않으며, "해당클래스 내부에서만" 그 값을 활용할 수 있다. ===> static이지만 private이 더 쎈듯

+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 java.io
 Interface Serializable

[serialVersionUID를 꼭 만들으라는 얘기]
 All subtypes of a serializable class are themselves serializable.
 The serialization interface has no methods or fields and serves only to identify the semantics of being serializable.

 However, it is strongly recommended that all serializable classes explicitly declare serialVersionUID values,
 since the default serialVersionUID computation is highly sensitive to class details that may vary depending on compiler implementations,
 and can thus result in unexpected InvalidClassExceptions during deserialization.

 Therefore, to guarantee a consistent serialVersionUID value across different java compiler implementations,
 a serializable class must declare an explicit serialVersionUID value.
 It is also strongly advised that explicit serialVersionUID declarations use the private modifier where possible,
 since such declarations apply only to the immediately declaring class--serialVersionUID fields are not useful as inherited members.
 Array classes cannot declare an explicit serialVersionUID, so they always have the default computed value,
 but the requirement for matching serialVersionUID values is waived for array classes.

 [serializable한 Obj는 어떤 목적을 가지는 Obj길래 serializeVersionUID가 있어야하나?]
◼︎︎ 자바 직렬화(Serialize)란?
 : 자바 시스템 내부에서 사용되는 Object 또는 Data를 외부의 자바 시스템에서도 사용할 수 있도록 byte 형태로 데이터를 변환하는 기술.
   JVM(Java Virtual Machine 이하 JVM)의 메모리에 상주(힙 또는 스택)되어 있는 객체 데이터를 바이트 형태로 변환하는 기술.

◼︎ 역직렬화(Deserialize)
: byte로 변환된 Data를 원래대로 Object나 Data로 변환하는 기술을 역직렬화(Deserialize)라고 부릅니다.
  직렬화된 바이트 형태의 데이터를 객체로 변환해서 JVM으로 상주시키는 형태.

◼︎ 자바의 직렬화 왜 사용하는가?
:복잡한 데이터 구조의 클래스의 객체라도 직렬화 기본 조건만 지키면 큰 작업 없이 바로 직렬화, 역직렬화가 가능합니다.
데이터 타입이 자동으로 맞춰지기 때문에 관련 부분을 큰 신경을 쓰지 않아도 됩니다.
◼︎ 어디에 사용되는가?
1. 서블릿 세션 (Servlet Session) : 세션을 서블릿 메모리 위에서 운용한다면 직렬화를 필요로 하지 않지만,
                                파일로 저장하거나 세션 클러스터링, DB를 저장하는 옵션 등을 선택하게 되면 세션 자체가 직렬화가 되어 저장되어 전달됩니다.
2. 캐시 (Cache) : Ehcache, Redis, Memcached 라이브러리 시스템을 많이 사용됩니다.
3. 자바 RMI(Remote Method Invocation) : 원격 시스템 간의 메시지 교환을 위해서 사용하는 자바에서 지원하는 기술.

+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
https://okky.kr/article/224715
 [serializable한 Obj는 어떤 목적을 가지는 Obj길래 serializeVersionUID가 있어야하나?]

"소스상에는 도메인 객체를 파일로 저장하거나 네트워크 전송하는 부분이 없어서 물어봅니다. "
실제 없는 경우가 많습니다.
해당 프로그램에서는 직열화할일이 (현 시점까지는) 없었던 거죠.
추후 프로그램을 확장할 때, 네트웍이나 파일저장일 필요할 경우 직열화된 클래스를 저장하거나
전송할 수 있겠죠.

직열화의 개념은 단순합니다. 메모리 상에 존재하는 클래스인스턴스를 어떻게 파일로 저장하거나,
외부로 보낼까에 대한 고민으로 나온 것입니다.
그리고 위 serialVersionUID의 경우

파일로 저장된 바이트 스트림을 읽어 해석할 경우를 생각해보세요.
읽은 바이트 스트림이 어떤 클래스에 매핑되어 인스턴스화 되어야 할지를요..
serialVersionUID 도 함께 바이트스트림으로 저장되기 때문에,
이를 읽은 후 정확한 해당클래스를 찾을 수 있지요.

serialVersionUID 사용하는 이유는 type safely 을 위해서에요

예를들어 직렬화한 객체를 원격지에 전송을 했다고 했을경우에
전송된 객체의 클래스와 원격지의 클래스와 동일한지 여부 체크를 해주는거에요.
serialVersionUID 다를경우 java.io.InvalidClassException 을 발생합니다.
(원격지에도 해당 클래스가 있어야지 객체를 사용할수있겠죠)

---------------------------------------------

간단하게 이야기 드리면

서버가 다중화(여러개존재) 되어 있고
세션 클러스터링을 통해 세션관리를 하는 환경에서

도메인 객체가 세션에 저장이 될때

도메인 객체에
Serializable 인터페이스 클래스를 구현하기(implements) 해야지
정상적으로 세션에 저장하고 꺼내올수 있기 때문입니다.

도메인 객체가 세션에 저장하지 않는 단순한 데이터 집합이고
컨트롤러에서 생성되어서 뷰에서 소멸하는 데이터의 전달체라면
객체 직렬화는 고려하지 않아도 되는 부분입니다.

그리고 중간에 패턴 이야기가 나왔는데
메멘토 나 프록시 패턴에서 사용하는 객체는
도메인 객체의 성격보다는

메소드와 데이터를 포함하는 일반적인 객체 형태라서
질문하신 도메인 객체의 직렬화와 다른 내용인것 같아서
덧 붙입니다.


그런 점에서 보면

생각하지 않고
다른 코드에 적용되어 있으니 관습적으로
Serializable 를 구현한 도메인 객체를 많이 보시게 될거에요.

==========> 내가 궁금한게 이거다!!

그런데

귀찮게 Serializable 인터페이스를 구현해야지만
객체 직렬화가 가능할까요?

모든
클래스와 그 클래스의 인스턴스, 데이터 집합은
컴퓨터 메모리에 잘 정렬되어
CPU 가 잘 사용하고 있고

메모리에 로드되어 있는 바이트 배열을
그대로 스토리지에 저장하거나
네트웍을 통해 다른 프로세스(JVM) 에 전달할 수 있는데

도대체 왜 Serializable 인터페이스가 필요한지 궁금해 하신분 계세요?


    */

    private MemberVO member;

    //생성자에서 MemberVO 받아서 넣어줌
    public CustomUser(MemberVO vo){
        super(vo.getUserid(),
              vo.getUserpw(),
              vo.getAuthList().stream().map(auth -> new SimpleGrantedAuthority(auth.getAuth())).collect(Collectors.toList()));
        this.member = vo;
    }

    /*
     CustomUser는
     org.springframework.security.core.userdetails.User를
     상속받기때문에 super()생성자를 호출해야만 정상적인 객체를 생성할 수 있다.

     ===> MemberVO를 파라미터로 받아서 User클래스에 맞게 생성자를 호출한다.
     이 과정에서 AuthVO 인스턴스는 GrantedAuthority로 변환해야하므로 stream().map()을 이용해서 처리한다
    */

}
