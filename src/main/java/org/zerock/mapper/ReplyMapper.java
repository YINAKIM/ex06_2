package org.zerock.mapper;

import org.apache.ibatis.annotations.Param;
import org.zerock.domain.Criteria;
import org.zerock.domain.ReplyVO;

import java.util.List;

public interface ReplyMapper {

    public int insert(ReplyVO vo);
    public ReplyVO read(Long bno);
    public int delete(Long rno);
    public int update(ReplyVO vo);

    // @Param 이용, 2개 이상의 파라미터 처리할 떄 MyBatis에서 SQL을 #{}로 읽게하기위해 사용
    // mapper.xml에서는 cri, bno 둘다 사용가능한 것
    public List<ReplyVO> getListWithPaging(
            @Param("cri") Criteria cri, @Param("bno") Long bno);

    //댓글 페이징을 위해 [글번호bno기준] 전체 댓글 숫자 가져오기
    public int getcountByBno(Long bno);


}
