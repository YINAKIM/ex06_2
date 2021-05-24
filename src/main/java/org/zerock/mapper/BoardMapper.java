package org.zerock.mapper;



import org.apache.ibatis.annotations.Param;
import org.zerock.domain.BoardVO;
import org.zerock.domain.Criteria;

import java.util.List;

public interface BoardMapper {

    //@Service 패키지 주의! org.apache.ibatis.annotations.Select
    //@Select("SELECT * FROM TBL_BOARD WHERE BNO>0")
    // 페이징처리안된 CRUD테스트용 getList -  public List<BoardVO> getList();

    public List<BoardVO> getList(Criteria cri);

    //-------- 페이징처리를 위한 파라미터들을 모아둔 Creteria를 받아서 페이징을 위한 리스트를 만드는 메서드 --------
    public List<BoardVO> getListWithPaging(Criteria cri);


    // 전체 데이터 수 구하기
    public int getTotal(Criteria cri);


    // 1. insert만 처리, 생성된 PK값을 알 필요가 없는 경우
    public void insert(BoardVO board);

    // 2. insert실행 후 생성된 PK값을 알아야 하는 경우
    public void insertSelectKey(BoardVO board);

    // 3. select 처리 - PK의 데이터타입 정보를 이용
    public BoardVO read(Long bno);


    // DML작업은 몇 건의 데이터를 manipulation했는지를 반환할 수 있다 : 리턴타입 int ( 정상실행은  > 0 값 )
    // 4. delete처리
    public int delete(Long bno);

    // 5. update처리
    public int update(BoardVO board);


    //[part5-20] 댓글 수
    // amount : bno에 해당되는 댓글의 증감을 나타내는 변수
    public void updateReplyCnt(@Param("bno") Long bno, @Param("amount") int amount);





}

