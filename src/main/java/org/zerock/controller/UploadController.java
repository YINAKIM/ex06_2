package org.zerock.controller;

import lombok.extern.log4j.Log4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;

@Controller
@Log4j
public class UploadController {
    @GetMapping("/uploadForm")
    public void uploadForm(){
        log.info("upload form----------------------");
    }

    @PostMapping("/uploadFormAction")
    public void uploadFormPost(MultipartFile[] uploadFile, Model model){
        String uploadFolder = "/Users/kim-yina/Desktop/upload/tmp";

        for (MultipartFile multipartFile : uploadFile){
            log.info("***************************");
            log.info("Upload File Name : "+ multipartFile.getOriginalFilename());
            log.info("Upload File Name : "+ multipartFile.getSize());
            // p497. 아직 파일이름 한글일 경우의 설정은 안했음, 영문명 파일로만 테스트할 것
            /*
            결과 log
            INFO : org.zerock.controller.UploadController - ***************************
            INFO : org.zerock.controller.UploadController - Upload File Name : PagingVO.java
            INFO : org.zerock.controller.UploadController - Upload File Name : 2244
            INFO : org.zerock.controller.UploadController - ***************************
            INFO : org.zerock.controller.UploadController - Upload File Name : Utility.java
            INFO : org.zerock.controller.UploadController - Upload File Name : 1022
            아직 저장은 안되는 상태
            */

            //p499. 업로드된 파일저장 : transferTo()
            File saveFile = new File(uploadFolder, multipartFile.getOriginalFilename()); //일단 오리지널네임으로 저장부터 테스트

            try{
                multipartFile.transferTo(saveFile);
                log.info("transferTo--------");
            }catch(Exception e){
                log.info("transferTo 하다가 Exception발생--------");
                e.printStackTrace();
            }//

        }//for
            /*
            결과
            INFO : org.zerock.controller.UploadController - ***************************
            INFO : org.zerock.controller.UploadController - Upload File Name : ConnectionPoolMgr.java
            INFO : org.zerock.controller.UploadController - Upload File Name : 1593
            INFO : org.zerock.controller.UploadController - transferTo--------
            INFO : org.zerock.controller.UploadController - ***************************
            INFO : org.zerock.controller.UploadController - Upload File Name : ConnectionPoolMgr1.java
            INFO : org.zerock.controller.UploadController - Upload File Name : 4569
            INFO : org.zerock.controller.UploadController - transferTo--------
            */
    }

    @GetMapping("/uploadAjax")
    public void uploadAjax(){
        log.info("upload ajax------");
    }


    @PostMapping("/uploadAjaxAction")
    public void uploadAjaxPost(MultipartFile[] uploadFile){ // Ajax방식을 사용하면 Model필요없음
        log.info("============ upload ajax post ============");
        String uploadFolder = "/Users/kim-yina/Desktop/upload/tmp";

        for(MultipartFile multipartFile : uploadFile){
            log.info("--------------------------");
            log.info("upload File Name : "+multipartFile.getOriginalFilename());
            log.info("upload File Size : "+multipartFile.getSize());

            String uploadFileName = multipartFile.getOriginalFilename();

            // IE는 패스가 나오니까 마지막 "\"를 기준으로 잘라낸 문자열이 실제 파일이름
            uploadFileName = uploadFileName.substring(uploadFileName.lastIndexOf("\\")+1);
            log.info("only file name ::: "+uploadFileName);

            File saveFile = new File(uploadFolder, uploadFileName);

            try{
                multipartFile.transferTo(saveFile);
               log.info("transferTo------");
            }catch(Exception e){
               log.info("catch------");
                e.printStackTrace();
            }//
        }


        }//for
    }

