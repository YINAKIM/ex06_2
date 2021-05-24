package org.zerock.controller;

import lombok.Data;
import lombok.extern.log4j.Log4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.UUID;

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

        // 일자 별 폴더 만들기 :
        File uploadPath = new File(uploadFolder, getFolder());
        log.info("upload path :::::::::getFolder()::::::: "+uploadPath);

        if(uploadPath.exists() == false){
            log.info("upload path ---------- false");
            uploadPath.mkdirs(); //mkdir"s"
        }
        // 일자 별 폴더 만들기 : 끝

        for(MultipartFile multipartFile : uploadFile){
            log.info("--------------------------");
            log.info("upload File Name : "+multipartFile.getOriginalFilename());
            log.info("upload File Size : "+multipartFile.getSize());

            String uploadFileName = multipartFile.getOriginalFilename();

            // IE는 패스가 나오니까 마지막 "\"를 기준으로 잘라낸 문자열이 실제 파일이름
            uploadFileName = uploadFileName.substring(uploadFileName.lastIndexOf("\\")+1);
            log.info("only file name ::: "+uploadFileName);

            UUID uuid = UUID.randomUUID();  // 랜덤 UUID문자열 붙여서 파일명 중복방지 (파일명이 중복되면 업로드될 때 기존파일이 삭제되므로 )
            uploadFileName = uuid.toString()+"_"+uploadFileName;
            /*
            랜덤 UUID
            11_.pdf 파일 업로드 : 801f40f9-9521-4222-b948-02bd46a849a7_11_.pdf 로 업로드됨
            0518.pdf 파일업로드 : b6a19adb-4cf7-48b1-8a9d-9f835ba5789b_0518.pdf 로 업로드됨
            */


            //File saveFile = new File(uploadFolder, uploadFileName);
            File saveFile = new File(uploadPath, uploadFileName); // 일자별로 만들어지는 폴더에 저장

            try{
                multipartFile.transferTo(saveFile);
               log.info("transferTo------");
            }catch(Exception e){
               log.info("catch------");
                e.printStackTrace();
            }//
        }//for

        /*
        p.508)
        1. 중복된 파일명 문제 처리()
          1-1) 파일이름에 밀리세컨드까지 시간 붙이기
          1-2) UUID를 이용해서 중복발생가능성이 거의 없는 문자열 붙이기

        2. 한 폴더에 너무 많은 파일생성 문제 처리 (속도 저하와 개수 제한 문제 생김 방지)
          2-1) 'yy/MM/dd'단위의 폴더를 생성해서 저장하는 것 -> 일별 업로드 파일들 다른폴더에 저장되도록
        */

        }


        //폴더생성할 메서드
        public String getFolder(){
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

            Date date = new Date();
            String str = sdf.format(date);
            return str.replace("-",File.separator);
        }






    }

