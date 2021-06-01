package org.zerock.domain;

import lombok.Getter;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.User;

import java.util.stream.Collectors;

@Getter
public class CustomUser extends User {
//  org.springframework.security.core.userdetails.User를 상속받아 MemberVO를 UserDetails로 변환할 수 있도록 한다

    private static final long serialVersionUID = 1L;

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
