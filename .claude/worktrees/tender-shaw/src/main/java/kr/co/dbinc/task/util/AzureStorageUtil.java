package kr.co.dbinc.task.util;

import com.microsoft.azure.storage.CloudStorageAccount;
import com.microsoft.azure.storage.StorageException;
import com.microsoft.azure.storage.blob.*;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.net.URISyntaxException;
import java.security.InvalidKeyException;

@Slf4j
@Component
public class AzureStorageUtil
{
  @Value("${storageConnectionString}")
  String storageConnectionString;
  
  /**
   * CloudBlobClient 개체 반환
   */
  public CloudBlobClient getBlobClientReference() throws IllegalArgumentException, URISyntaxException, InvalidKeyException
  {
    CloudStorageAccount storageAccount;

    try
    {
      storageAccount = CloudStorageAccount.parse(storageConnectionString);
    } 
    catch (IllegalArgumentException | URISyntaxException e)
    {
      if (log.isDebugEnabled())
      {
        log.debug("Connection string specifies an invalid URI.Please confirm the connection string is in the Azure connection string format.");
      }
      throw e;
    } 
    catch (InvalidKeyException e)
    {
      if (log.isDebugEnabled())
      {
        log.debug("Connection string specifies an invalid key.Please confirm the AccountName and AccountKey in the connection string are valid.");
      }
      throw e;
    }

    return storageAccount.createCloudBlobClient();
  }

  /**
   * 컨테이너 생성
   */
  public CloudBlobContainer createContainer(CloudBlobClient blobClient, String containerName) throws StorageException,
  RuntimeException, IllegalArgumentException, URISyntaxException, IllegalStateException
  {
    // Create a new container
    CloudBlobContainer container = blobClient.getContainerReference(containerName);
    
    try
    {
      if (!container.createIfNotExists())
      {
        throw new IllegalStateException(String.format("Container with name \"%s\" already exists.", containerName));
      }
    } catch (StorageException s)
    {
      if (s.getCause() instanceof java.net.ConnectException && log.isDebugEnabled())
      {
        log.debug("Caught connection exception from the client. If running with the default configuration please make sure you have started the storage emulator.");
      }
      throw s;
    }
    return container;
  }

  /**
   * 컨테이너에 Blob 업로드
   */
  public void uploadBlob(CloudBlobContainer container, String path, String blobFileName)
  {
    File source = new File(path);
    try (FileInputStream stream = new FileInputStream(source)) {
      CloudBlockBlob blob = container.getBlockBlobReference(blobFileName);
      blob.upload(stream, source.length());
    }
    catch (Exception e)
    {
      if (log.isDebugEnabled())
      {
        log.error("Error uploadBlob() :", e);
      }
    }
  }

  /**
   * 컨테이너에 Blob 다운로드
   */
  public void downloadBlob(CloudBlobContainer container, String path)
  {
    try
    {
      // Loop through each blob item in the container.
      for (ListBlobItem blobItem : container.listBlobs())
      {
        // If the item is a blob, not a virtual directory.
        if (blobItem instanceof CloudBlob)
        {
          // Download the item and save it to a file with the same name.
          CloudBlob blob = (CloudBlob) blobItem;
          blob.download(new FileOutputStream(path + blob.getName()));
        }
      }
    } 
    catch (Exception e)
    {
      if (log.isDebugEnabled())
      {
        log.error("Error downloadBlob() :", e);
      }
    }
  }

  /**
   * Blob 삭제
   */
  public void deleteBlob(CloudBlobContainer container, String blobName)
  {
    try
    {
      CloudBlockBlob blob = container.getBlockBlobReference(blobName);
      blob.deleteIfExists();
    } catch (Exception e)
    {
      if (log.isDebugEnabled())
      {
        log.error("Error deleteBlob() :", e);
      }
    }
  }

  /**
   * 컨테이너의 Blob 나열
   */
  public void listBlob(CloudBlobContainer container)
  {
    try
    {
      if (container.exists())
      {
        // Loop over blobs within the container and output the URI to each of them.
        for (ListBlobItem blobItem : container.listBlobs())
        {
          if (log.isDebugEnabled())
          {
            log.debug("Blob List : {}", blobItem.getUri());
          }
        }
      }
    } catch (Exception e)
    {
      e.printStackTrace();
    }
  }
}