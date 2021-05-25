package org.zerock.mapper;

import org.zerock.domain.BoardAttachVO;

import java.util.List;

public interface BoardAttachMapper {
    //첨부파일은 수정이 없다 ---> 등록 삭제만 있다.

    public void insert(BoardAttachVO vo);
    public void delete(String uuid);
    public List<BoardAttachVO> findByBno(Long bno);

}
