package kr.co.dbinc.task.service.file;

import com.microsoft.azure.storage.blob.CloudBlobClient;
import com.microsoft.azure.storage.blob.CloudBlobContainer;
import com.microsoft.azure.storage.blob.CloudBlockBlob;
import kr.co.dbinc.task.dto.file.SaveFileResponse;
import kr.co.dbinc.task.exception.CommonException;
import kr.co.dbinc.task.exception.ErrorCode;
import kr.co.dbinc.task.util.AzureStorageUtil;
import kr.co.dbinc.task.util.Util;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

@Slf4j
@Service
@Transactional
@RequiredArgsConstructor
public class FileService
{
  private final AzureStorageUtil azureStorageUtil;

  @Value("${storageContainerName}")
  String strgContainerName;

  @Deprecated
  public List<SaveFileResponse> uploadFile(List<MultipartFile> file) throws Exception
  {
    List<SaveFileResponse> response = new ArrayList<>();

    for(int i = 0; i < file.size(); i++)
    {
      this.fileValidation(file.get(i));

      String fileDispName = file.get(i).getOriginalFilename();
      String fileName = Util.getGuid() + Util.getExtension(fileDispName);
      String directory = "D:/home/uploadFiles";
      String filePath = Paths.get(directory, fileName).toString();

      try (BufferedOutputStream stream = new BufferedOutputStream(new FileOutputStream(new File(filePath))))
      {
        SaveFileResponse res = new SaveFileResponse();
        res.setFileNm(fileName);
        res.setFileDispNm(fileDispName);
        response.add(res);
        // 파일 서버에 쓰기
        stream.write(file.get(i).getBytes());
      }
      catch (Exception e)
      {
        e.printStackTrace();
        throw new Exception();
      }
    }

    return response;
  }

  public List<SaveFileResponse> uploadFileToAzure(List<MultipartFile> file) throws Exception
  {
    List<SaveFileResponse> response = new ArrayList<>();

    for(int i = 0; i < file.size(); i++)
    {
      this.fileValidation(file.get(i));

      String fileDispName = file.get(i).getOriginalFilename();
      String fileName = Util.getGuid() + Util.getExtension(fileDispName);

      SaveFileResponse res = new SaveFileResponse();
      res.setFileNm(fileName);
      res.setFileDispNm(fileDispName);
      response.add(res);

      // Azure 파일 서버에 쓰기
      CloudBlobClient blobClient = azureStorageUtil.getBlobClientReference();
      CloudBlobContainer container = blobClient.getContainerReference(strgContainerName);
      CloudBlockBlob blob = container.getBlockBlobReference(fileName);
      blob.upload(file.get(i).getInputStream(), file.get(i).getSize());
    }

    return response;
  }

  public void fileValidation(MultipartFile file)
  {
    String[] fileTypes =  {"bmp" , "hwp", "jpg", "pdf", "png", "xls", "zip", "pptx", "xlsx", "jpeg", "doc", "gif", "csv", "tif", "txt", "docx"};
    String fileName = file.getOriginalFilename();
    String fileType = fileName.substring(fileName.lastIndexOf(".")+1, fileName.length()).toLowerCase();

    if (fileName.length() > 100) { //파일명 길이 제한
      throw new CommonException(ErrorCode.FILE_NAME_ERROR);
    } else if (file.getSize() > (20 * 1024 * 1024)) { //파일 크기 제한
      throw new CommonException(ErrorCode.FILE_VOL_ERROR);
    } else if (fileName.lastIndexOf(".") == -1) { //파일 확장자 체크
      throw new CommonException(ErrorCode.FILE_TYPE_ERROR);
    } else if (!Arrays.asList(fileTypes).contains(fileType)) { //파일 타입 체크
      throw new CommonException(ErrorCode.FILE_TYPE_ERROR);
    }
  }
}
