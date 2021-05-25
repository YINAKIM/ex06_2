package org.zerock.controller;

import lombok.extern.log4j.Log4j;

import net.coobird.thumbnailator.Thumbnailator;
import org.springframework.core.io.FileSystemResource;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.zerock.domain.AttachFileDTO;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;

import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.UUID;

@Controller
@Log4j
public class UploadController {
    /*
    귀차나서 써놓는다 파일저장경로
    /Users/kim-yina/Desktop/upload/tmp/
    */

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


    @PostMapping(value = "/uploadAjaxAction",produces = {MediaType.APPLICATION_JSON_UTF8_VALUE})
    public ResponseEntity<List<AttachFileDTO>> uploadAjaxPost(MultipartFile[] uploadFile){ // Ajax방식을 사용하면 Model필요없음

        /*** 파일업로드 후 브라우저로 보내줄 정보들을 AttachFileDTO 로 묶어서 List로 보내준다 ***/
        List<AttachFileDTO> list = new ArrayList<>();

        /************** 파일업로드 작업 *********************************/

        log.info("============ upload ajax post ============");
        String uploadFolder = "/Users/kim-yina/Desktop/upload/tmp";

        // 일자 별 폴더 만들기 :
        String uploadFolderPath = getFolder();
        File uploadPath = new File(uploadFolder, uploadFolderPath);
        log.info("upload path :::::::::getFolder()::::::: "+uploadPath);

        if(uploadPath.exists() == false){
            log.info("upload path ---------- false");
            uploadPath.mkdirs(); //mkdir"s"
        }
        // 일자 별 폴더 만들기 : 끝

        for(MultipartFile multipartFile : uploadFile){

            AttachFileDTO attachFileDTO = new AttachFileDTO();

            log.info("--------------------------");
            log.info("upload File Name : "+multipartFile.getOriginalFilename());
            log.info("upload File Size : "+multipartFile.getSize());

            String uploadFileName = multipartFile.getOriginalFilename();

            // IE는 패스가 나오니까 마지막 "\"를 기준으로 잘라낸 문자열이 실제 파일이름
            uploadFileName = uploadFileName.substring(uploadFileName.lastIndexOf("\\")+1);
            log.info("only file name ::: "+uploadFileName);
            attachFileDTO.setFileName(uploadFileName);


            UUID uuid = UUID.randomUUID();  // 랜덤 UUID문자열 붙여서 파일명 중복방지 (파일명이 중복되면 업로드될 때 기존파일이 삭제되므로 )
            uploadFileName = uuid.toString()+"_"+uploadFileName;
            /*
            랜덤 UUID
            11_.pdf 파일 업로드 : 801f40f9-9521-4222-b948-02bd46a849a7_11_.pdf 로 업로드됨
            0518.pdf 파일업로드 : b6a19adb-4cf7-48b1-8a9d-9f835ba5789b_0518.pdf 로 업로드됨
            */

/*
try안에서 할일
[1] 파일저장 : neww File 객체 만들어서 transferTo()
[2] 이미지인지 if체크 : checkImageType ----> 이미지파일일 경우 썸네일만들어서 같이 저장
                                   ----> 일반파일이면 스킵
[3]  공격/성능저하 방지 : 중복파일명 방지처리 or 폴더 일자별로 나눠 저장처리
[4] 업로드 완료 후 브라우저로 보낼 정보 set하고 묶어서 보내기
브라우저에서 콘솔에 로그로 찍은 dataType : 'json'인 AttachFileDTO
{fileName: null, uuid: "8d684a57-9f1f-497a-86df-8611776e316c", uploadPath: "2021/05/25", image: false}

*/

            try{
                //File saveFile = new File(uploadFolder, uploadFileName);
                File saveFile = new File(uploadPath, uploadFileName); // 일자별로 만들어지는 폴더에 저장
                multipartFile.transferTo(saveFile);
                log.info("transferTo------");


                attachFileDTO.setUuid(uuid.toString());
                attachFileDTO.setUploadPath(uploadFolderPath);

               //image파일인지 체크
                if(checkImageType(saveFile)){
                    attachFileDTO.setImage(true); //이미지파일여부 true
                    log.info("###### image 체크 걸림 -> 썸넬생성 ######");

                    FileOutputStream thumbnail
                            = new FileOutputStream(new File(uploadPath,"s_"+uploadFileName));
                    log.info("###### 썸넬생성 할 예정: "+thumbnail+" ######");

                    Thumbnailator.createThumbnail(multipartFile.getInputStream(), thumbnail, 100,100);
                    log.info("###### 썸넬생성 후: "+thumbnail+" ######");
                    thumbnail.close();


                }// image file 만 썸넬 생성하는 if

                /******** 작업 다끝나면 꼭 list.add ********/
                list.add(attachFileDTO);
            }catch(Exception e){
                log.info("Ajax파일업로드 catch------");
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

        return new ResponseEntity<>(list, HttpStatus.OK);

    }


    //폴더생성할 메서드
    public String getFolder(){
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

        Date date = new Date();
        String str = sdf.format(date);
        return str.replace("-",File.separator);
    }

    /* 섬네일 생성
    [1] 업로드된 파일이 이미지종류의 파일인지 확인
    [2] 이미지 파일이면? 썸넬 생성 후 저장
    */
    private boolean checkImageType(File file){
        try{
            String contentType = Files.probeContentType(file.toPath());
            log.info("88888888 "+contentType);
            return contentType.startsWith("image");
        }catch(IOException e){
            log.info("IOException!!");
            e.printStackTrace();
        }

        return false;
    }


// 썸네일이미지 만들어서 보여주기
    @ResponseBody
    @GetMapping("/display")
    public ResponseEntity<byte[]> getFile(String fileName){

        log.info("썸넬만들 fileName"+fileName);

        File file = new File("/Users/kim-yina/Desktop/upload/tmp/"+fileName); // new File객체 (지금 업로드된 파일명 가져와서) 생성
//        File file = new File("/Users/kim-yina/Desktop/upload/tmp"+fileName); // new File객체 (지금 업로드된 파일명 가져와서) 생성
        log.info("업로드 경로에서 이미지파일 잘가져왔나 확인----->"+file);

        ResponseEntity<byte[]> result = null;

        try{

            HttpHeaders header = new HttpHeaders();           // java.net.http.HttpHeaders(X) org.springframework.http.HttpHeaders(O)

            header.add("Content-Type",Files.probeContentType(file.toPath()));

            // 결과에 담아
            result = new ResponseEntity<>(FileCopyUtils.copyToByteArray(file), header, HttpStatus.OK);

        }catch(IOException e){
            log.info("썸넬만들다가 IOException");
            e.printStackTrace();
        }


        return result;
    }

/*
/display
getFile() 테스트

[png테스트 : 이미지잘나옴 ]
http://localhost:8001/display?fileName=2021/05/25/ptest1.png
INFO : org.zerock.controller.UploadController - 썸넬만들 fileName2021/05/25/ptest1.png
INFO : org.zerock.controller.UploadController - 업로드 경로에서 이미지파일 잘가져왔나 확인----->/Users/kim-yina/Desktop/upload/tmp/2021/05/25/ptest1.png

[jpg테스트 : 이미지잘나옴 ]
http://localhost:8001/display?fileName=2021/05/25/jtest1.jpg
INFO : org.zerock.controller.UploadController - 썸넬만들 fileName2021/05/25/jtest1.jpg
INFO : org.zerock.controller.UploadController - 업로드 경로에서 이미지파일 잘가져왔나 확인----->/Users/kim-yina/Desktop/upload/tmp/2021/05/25/jtest1.jpg

근데 Header 보고싶은데 브라우저 네트워크에 아무것도 안나와서 안보임 ..
[주의]
 File file = new File("/Users/kim-yina/Desktop/upload/tmp/"+fileName);
                                  ---> 여기서 "/경로/경로/경로/" 경로 맨뒤에 / 꼭 붙여야됨, 안붙이면 폴더이름 그대로 이어짐
*/

/*************************** 다운로드 처리 ******************************/

    @ResponseBody
    @GetMapping(value = "/download"
            ,produces = MediaType.APPLICATION_OCTET_STREAM_VALUE)
                                   //--> 다운로드 MIME 타입 : application/octet-stream
    public ResponseEntity<Resource> downloadFile(String fileName){
            //org.springframework.core.io.Resource
        log.info("다운로드 파일 :::"+fileName);

        Resource resource = new FileSystemResource("/Users/kim-yina/Desktop/upload/tmp/"+fileName);
        // 500 에러 : file [/Users/kim-yina/Desktop/upload/tmpjtest1.jpg] cannot be resolved in the file system for checking its content length
        // --> /Users/kim-yina/Desktop/upload/tmp/ 여기도 맨끝에 슬래시 꼭붙일것
        log.info("다운로드 리소스 읽음------->"+resource);
        /*
        INFO : org.zerock.controller.UploadController - 다운로드 파일 :::jtest1.jpg
        INFO : org.zerock.controller.UploadController - 다운로드 리소스 읽음 :::file [/Users/kim-yina/Desktop/upload/tmpjtest1.jpg]
        */

        String resourceName = resource.getFilename();

        HttpHeaders headers = new HttpHeaders();
        try{
            log.info("다운로드 try-----");
            headers.add(
                    "Content-Disposition"
                    ,"attachment; filename="
                            + new String(resourceName.getBytes(StandardCharsets.UTF_8),"ISO-8859-1")
                    //ISO-8859-1 : get방식으로 보낼 때 기본인코딩
            );
        }catch(UnsupportedEncodingException e){
            log.info("다운로드 catch-----");
            e.printStackTrace();
        }//catch


        return new ResponseEntity<Resource>(resource, headers, HttpStatus.OK);
    }

    /*********************** 첨부파일삭제 ************************/
    @ResponseBody
    @PostMapping("/deleteFile")
    public ResponseEntity<String> deleteFile(String fileName, String type){
        log.info("첨부파일삭제 : "+fileName);

        File file;
        try{
            file = new File("/Users/kim-yina/Desktop/upload/tmp/"+ URLDecoder.decode(fileName,"UTF-8"));
                log.info(file.hashCode()+"  ************ 1");

            file.delete();

            //이미지파일일 경우 ----> 썸넬도 같이 삭제
            if(type.equals("image")){
                String largeFileName = file.getAbsolutePath().replace("s_","");
                log.info("원본파일(largeFileName)이름 : "+largeFileName);

                file = new File(largeFileName);
                log.info(file.hashCode() +" ************ 2");
                file.delete();
            }

        }catch(UnsupportedEncodingException e){
            e.printStackTrace();
            return new ResponseEntity<>(HttpStatus.NOT_FOUND);
        }//catch
        return new ResponseEntity<>("deleted",HttpStatus.OK);
    }
}

