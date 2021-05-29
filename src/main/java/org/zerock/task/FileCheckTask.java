package org.zerock.task;

import lombok.Setter;
import lombok.extern.log4j.Log4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;
import org.zerock.domain.BoardAttachVO;
import org.zerock.mapper.BoardAttachMapper;

import java.io.File;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.List;
import java.util.stream.Collectors;

@Log4j
@Component
public class FileCheckTask {

    @Setter(onMethod_ = {@Autowired})
    private BoardAttachMapper attachMapper;

    private String getFolderYesterDay(){
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        Calendar cal = Calendar.getInstance();

        cal.add(Calendar.DATE,-1);
        String str = sdf.format(cal.getTime());
        return  str.replace("-", File.separator);
    }

    //cron 매일새벽2시에 동작하도록 설정

    @Scheduled(cron = "0 * 1 * * *")
    public void checkFiles() throws Exception{

        log.info("========파일체크테스크 Scheduled 언제 도나========");
        log.warn("File check task run............");



        // DB에 있는 파일목록
        List<BoardAttachVO> fileList = attachMapper.getOldFiles();

        // DB에서 가져온 fileList랑 폴더에있는 파일리스트 비교해서 체크할 준비
        List<Path> fileListPaths
                = fileList.stream()
                .map( vo -> Paths.get("/Users/kim-yina/Desktop/upload/tmp/",vo.getUploadPath(), vo.getUuid()+"_"+vo.getFileName()) )
                .collect(Collectors.toList());

        //이미지파일은 s_붙은 썸넬있으니까
        fileList.stream().filter( vo -> vo.isFileType() == true )
                .map( vo -> Paths.get("/Users/kim-yina/Desktop/upload/tmp/",vo.getUploadPath(), "s_"+vo.getUuid()+"_"+vo.getFileName()) )
                .forEach(p -> fileListPaths.add(p));

        log.warn("===============================================");

        fileListPaths.forEach( p -> log.warn(p) );

        // 어제자 폴더 디렉토리
        File targetDir = Paths.get("/Users/kim-yina/Desktop/upload/tmp/",getFolderYesterDay()).toFile();

        File[] removeFiles = targetDir.listFiles( file -> fileListPaths.contains(file.toPath()) == false );

        log.warn("+++++++++++++++++++++++++++++++++++++++++++++++");
        for (File file : removeFiles){
            if(fileList == null || fileList.size() == 0) {
                return ;
            }
            log.warn(file.getAbsolutePath());
            file.delete();//물리경로 폴더에서 파일삭제
        }//for

    }

}
