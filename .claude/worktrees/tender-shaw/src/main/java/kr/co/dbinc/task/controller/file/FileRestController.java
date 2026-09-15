package kr.co.dbinc.task.controller.file;

import com.microsoft.azure.storage.blob.CloudBlobClient;
import com.microsoft.azure.storage.blob.CloudBlobContainer;
import com.microsoft.azure.storage.blob.CloudBlockBlob;
import jakarta.validation.Valid;
import kr.co.dbinc.task.dto.file.DownloadFileRequest;
import kr.co.dbinc.task.dto.file.SaveFileResponse;
import kr.co.dbinc.task.service.file.FileService;
import kr.co.dbinc.task.util.AzureStorageUtil;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.InputStreamResource;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.net.URLEncoder;
import java.util.List;

@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping(value = "/rest")
public class FileRestController
{
  private final FileService fileService;
  private final AzureStorageUtil azureStorageUtil;

  @Value("${storageContainerName}")
  String strgContainerName;

  // 파일서버에 저장
  @PostMapping(value = "/files/disk")
  public ResponseEntity<List<SaveFileResponse>> uploadFile(@RequestParam List<MultipartFile> file)  throws Exception
  {
    List<SaveFileResponse> response = fileService.uploadFile(file);
    return ResponseEntity.ok(response);
  }

  // Azure Storage에 저장
  @PostMapping(value = "/files/azure")
  public ResponseEntity<List<SaveFileResponse>> uploadFileToAzure(@RequestParam List<MultipartFile> file)  throws Exception
  {
    List<SaveFileResponse> response = fileService.uploadFileToAzure(file);
    return ResponseEntity.ok(response);
  }

  // 파일 다운로드 (Azure)
  @GetMapping(value = "/files/azure")
  public ResponseEntity<Resource> fileDownloadFromAzure(@Valid DownloadFileRequest request)  throws Exception
  {
    String fileNm = request.getFileNm();
    String fileDispNm = request.getFileDispNm();
    CloudBlobClient blobClient = azureStorageUtil.getBlobClientReference();
    CloudBlobContainer container = blobClient.getContainerReference(strgContainerName);
    CloudBlockBlob blob = container.getBlockBlobReference(fileNm);

    HttpHeaders headers = new HttpHeaders();
    fileDispNm = fileDispNm.replace(" ", "");
    fileDispNm = URLEncoder.encode(fileDispNm, "UTF-8");
    headers.add(HttpHeaders.CONTENT_TYPE, blob.getProperties().getContentType());
    headers.add(HttpHeaders.CONTENT_DISPOSITION, "attachment;filename=" + fileDispNm + ";");

    Resource resource = new InputStreamResource(blob.openInputStream());
    return new ResponseEntity<>(resource, headers, HttpStatus.OK);
  }
}
