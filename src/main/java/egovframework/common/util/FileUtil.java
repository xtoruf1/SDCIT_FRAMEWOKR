package egovframework.common.util;

import java.awt.Color;
import java.awt.Graphics2D;
import java.awt.image.BufferedImage;
import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.sql.Timestamp;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;

import javax.imageio.ImageIO;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.pdmodel.PDPage;
import org.apache.poi.xssf.streaming.SXSSFWorkbook;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;
import org.springframework.web.multipart.MultipartFile;

import net.coobird.thumbnailator.Thumbnails;

public class FileUtil {
	private static final Logger LOGGER = LoggerFactory.getLogger(FileUtil.class);

	/** Buffer Size */
	public static final int BUFFER_SIZE = 8192;

	/**
	 * 일반 파일 업로드
	 *
	 * @param multipartFile
	 * @param uploadPath
	 * @return
	 * @throws FileNotFoundException
	 * @throws IOException
	 */
	public static final String upload(MultipartFile file, String uploadPath) throws FileNotFoundException, IOException {
		String fileName = null;

		File path = new File(uploadPath);
    	if (!path.exists()) {
    		path.mkdirs();
    	}

    	fileName = getUniquFileName(uploadPath, file.getOriginalFilename());

    	InputStream stream = null;
		OutputStream bos = null;

        int bytesRead = 0;
        byte[] buffer = new byte[BUFFER_SIZE];

        try {
        	stream = file.getInputStream();
			bos = new FileOutputStream(uploadPath + fileName);

			while ((bytesRead = stream.read(buffer, 0, 8192)) != -1) {
				bos.write(buffer, 0, bytesRead);
			}
        } finally {
        	if (bos != null) {
        		bos.close();
        	}
			if (stream != null) {
				stream.close();
			}
        }

		return fileName;
	}

	/**
	 * 포상 신청서 첨부파일 업로드
	 *
	 * @param multipartFile
	 * @param uploadPath
	 * @return
	 * @throws FileNotFoundException
	 * @throws IOException
	 */
	public static final String applicationUpload(MultipartFile file, String uploadPath) throws FileNotFoundException, IOException {
		String fileName = null;

		File path = new File(uploadPath);
    	if (!path.exists()) {
    		path.mkdirs();
    	}

    	fileName = getApplicationFileName(uploadPath, file.getOriginalFilename());

    	InputStream stream = null;
		OutputStream bos = null;

        int bytesRead = 0;
        byte[] buffer = new byte[BUFFER_SIZE];

        try {
        	stream = file.getInputStream();
			bos = new FileOutputStream(uploadPath + File.separator + fileName);

			while ((bytesRead = stream.read(buffer, 0, 8192)) != -1) {
				bos.write(buffer, 0, bytesRead);
			}
        } finally {
        	if (bos != null) {
        		bos.close();
        	}
			if (stream != null) {
				stream.close();
			}
        }

		return fileName;
	}

	/**
	 * PDF파일에서 썸네일 추출
	 *
	 * @param file
	 * @param uploadPath
	 * @param fileName
	 * @throws FileNotFoundException
	 * @throws IOException
	 */
	public static final String convertPDFToThumbnail(MultipartFile file, String fileName) throws FileNotFoundException, IOException {
		String extension = fileName.substring(fileName.lastIndexOf(".") + 1);

		// 파일 확장자가 PDF일 경우만 실행
		if ("pdf".equals(extension)) {
			PDDocument document = PDDocument.load(file.getInputStream());
			PDPage pdPage = (PDPage)document.getDocumentCatalog().getAllPages().get(0);
			BufferedImage bim = pdPage.convertToImage(BufferedImage.TYPE_INT_RGB, 300);

			int width = bim.getWidth();
			int height = bim.getHeight();

			BufferedImage image = new BufferedImage(width, height, BufferedImage.TYPE_INT_RGB);
			Graphics2D graphics = (Graphics2D)image.getGraphics();

			graphics.setBackground(Color.WHITE);
			graphics.drawImage(bim, 0, 0, null);

			extension = "jpg";
			String onlyFileName = fileName.substring(0, fileName.lastIndexOf("."));

			HttpServletRequest request =((ServletRequestAttributes)RequestContextHolder.getRequestAttributes()).getRequest();
			// 파일 기본경로
    		String defaultFilePath = request.getSession().getServletContext().getRealPath("/");

    		// 썸네일 파일 상세경로
    		String thumbPath = defaultFilePath + "images" + File.separator + "upload" + File.separator + "thumbnail" + File.separator;

    		File filePath = new File(thumbPath);
    		if (!filePath.exists()) {
    			filePath.mkdirs();
    		}
    		// 썸네일 파일명
    		String thumbName = onlyFileName + "_thumb." + extension;

			File thumbnail = new File(thumbPath + thumbName);

			ImageIO.write(image, extension, thumbnail);

			graphics.dispose();

			// 썸네일 비율 생성
			double ratio = (double)100 / (double)width;
			int w = (int)(width * ratio);
			int h = (int)(height * ratio);

			if (thumbnail.exists()) {
				Thumbnails
				.of(thumbnail)
				.outputQuality(1.0)
				.size(w, h)
				.toFile(thumbnail);
			}

			return thumbName;
		}

		return null;
	}

	/**
	 * 파일명 생성
	 *
	 * @param filePath
	 * @param fileNm
	 * @return
	 */
	public static final String getUniquFileName(String filePath, String fileNm) {
		File file = new File(filePath + fileNm);
		String extention = fileNm.substring(fileNm.lastIndexOf("."));
		String fileName = AttachUtil.newAttachIdx();

		file = new File(filePath + fileName + extention);

		return file.getName();
    }

	/**
	 * 파일명 생성
	 *
	 * @param filePath
	 * @param fileNm
	 * @return
	 */
	public static final String getApplicationFileName(String filePath, String fileNm) {
		File file = new File(filePath + fileNm);

		Date d = new Date();
		DateFormat format = new SimpleDateFormat("yyyyMMddHHmmssSSS");
		String time = format.format(d);

		String fileName = "AWARD_FILE" + time;

		file = new File(filePath + File.separator + fileName);

		return file.getName();
    }

	/**
	 * 엑셀파일 다운로드
	 *
	 * @param workbook
	 * @param response
	 * @param mimeTypeParam
	 * @param fileName
	 * @param drmYn
	 * @throws IOException
	 */
	public static void downloadExcelFile(SXSSFWorkbook workbook, HttpServletResponse response, String mimeTypeParam, String fileName, String drmYn) throws IOException {
		String mimeType = mimeTypeParam;
		if (mimeType == null) {
			mimeType = "application/octet-stream;";
		}

		response.setContentType(WebUtil.removeCRLF(mimeType));
		response.setHeader("Content-Disposition", "filename=" + fileName + ".xlsx;");

		try {
			workbook.write(response.getOutputStream());
		} finally {
			workbook.dispose();
			workbook.close();
		}
	}

	/**
	 * 파일 확장자 체크
	 *
	 * @param fileExt
	 * @return
	 */
	public static boolean checkExt(String fileExt) {
		if (
			"doc".equals(fileExt)
			|| "docx".equals(fileExt)
			|| "hwp".equals(fileExt)
			|| "pdf".equals(fileExt)
			|| "jpg".equals(fileExt)
			|| "jpeg".equals(fileExt)
			|| "gif".equals(fileExt)
			|| "png".equals(fileExt)
			|| "bmp".equals(fileExt)
		) {
			return true;
		}

		return false;
	}

	/**
	 * 디렉토리가 존재하지 않을 시 디렉토리 생성
	 * @param str
	 * @throws Exception
	 */
	public static void makeFolder(String str) throws Exception{
		File folder = new File(str);

		if (folder.isDirectory() == false) {
			folder.mkdirs();
		}
	}

	// 타임스탬프 생성
	public static String getTimeStamp() {
		String rtnStr = null;

		// 문자열로 변환하기 위한 패턴 설정(년도-월-일 시:분:초:초(자정이후 초))
		String pattern = "yyyyMMddhhmmssSSS";

		SimpleDateFormat sdfCurrent = new SimpleDateFormat(pattern, Locale.KOREA);
		Timestamp ts = new Timestamp(System.currentTimeMillis());

		rtnStr = sdfCurrent.format(ts.getTime());

		return rtnStr;
	}

	/**
	 * 이미지에 대한 미리보기 기능을 제공한다.
	 *
	 * mimeType의 경우는 JSP 상에서 다음과 같이 얻을 수 있다.
	 * getServletConfig().getServletContext().getMimeType(name);
	 *
	 * @param response
	 * @param where
	 * @param serverSubPath
	 * @param physicalName
	 * @param mimeType
	 * @throws Exception
	 */
	public static void viewFile(HttpServletResponse response, String where, String serverSubPath, String physicalName, String mimeTypeParam) throws Exception {
		String mimeType = mimeTypeParam;
		String downFileName = where + File.separator + serverSubPath + File.separator + physicalName;

		File file = new File(WebUtil.filePathBlackList(downFileName));

		if (!file.exists()) {
			throw new FileNotFoundException(downFileName);
		}

		if (!file.isFile()) {
			throw new FileNotFoundException(downFileName);
		}

		byte[] b = new byte[BUFFER_SIZE];

		if (mimeType == null) {
			mimeType = "application/octet-stream;";
		}

		response.setContentType(WebUtil.removeCRLF(mimeType));
		response.setHeader("Content-Disposition", "filename=image;");

		BufferedInputStream fin = null;
		BufferedOutputStream outs = null;

		try {
			fin = new BufferedInputStream(new FileInputStream(file));
			outs = new BufferedOutputStream(response.getOutputStream());

			int read = 0;

			while ((read = fin.read(b)) != -1) {
				outs.write(b, 0, read);
			}
		} finally {
			ResourceCloseHelper.close(outs, fin);
		}
	}

	public static String getPhysicalFileName() {
		return EgovFormBasedUUID.randomUUID().toString().replaceAll("-", "").toUpperCase();
	}

	// 현재일자를 문자열로 조회
	public static String getTodayString() {
		SimpleDateFormat format = new SimpleDateFormat("yyyyMMdd", Locale.getDefault());

		return format.format(new Date());
	}

	/**
	 * 파일 확장자 확인
	 *
	 * @param multipartFile
	 * @return
	 */
	public static boolean isValidMimeType(MultipartFile multipartFile) {
		String accessFileExtension = PropertyUtil.getProperty("globals.accessFileExtension");

		String Filename = multipartFile.getOriginalFilename();
		String extention = Filename.substring(Filename.lastIndexOf(".") + 1);

		if (StringUtil.isNotEmpty(extention)) {
			extention = extention.toLowerCase();
		}

		if (!isPermittedMimeType(extention, accessFileExtension)) {
			return false;
		}

		return true;
	}

	/**
	 * 파일 확장자 확인
	 *
	 * @param multipartFile
	 * @return
	 */
	public static boolean isValidImageType(MultipartFile multipartFile) {
		String accessFileExtension = PropertyUtil.getProperty("globals.accessImageExtension");

		String Filename = multipartFile.getOriginalFilename();
		String extention = Filename.substring(Filename.lastIndexOf(".") + 1);

		if (StringUtil.isNotEmpty(extention)) {
			extention = extention.toLowerCase();
		}

		if (!isPermittedMimeType(extention, accessFileExtension)) {
			return false;
		}

		return true;
	}

	/**
	 * 파일 확장자 확인
	 *
	 * @param extention
	 * @param accessFileExtension
	 * @return
	 */
	private static boolean isPermittedMimeType(String extention, String accessFileExtension) {
		String[] extentionTypes = accessFileExtension.split(",");

		for (String extentionType : extentionTypes) {
			String type = extentionType.toLowerCase();

			if (type.equals(extention)) {
				return true;
			}
		}

		return false;
	}

	/**
	 * 일반 파일 업로드(공지사항 & F&Q)
	 * @param file
	 * @param uploadPath
	 * @param groupId
	 * @param fileId
	 * @return
	 * @throws FileNotFoundException
	 * @throws IOException
	 */
	public static final String noticeUpload(MultipartFile file, String uploadPath, String groupId, String fileId) throws FileNotFoundException, IOException {
		String fileName = null;

		File path = new File(uploadPath);
    	if (!path.exists()) {
    		path.mkdirs();
    	}

    	fileName = groupId + "_" + fileId;

    	InputStream stream = null;
		OutputStream bos = null;

        int bytesRead = 0;
        byte[] buffer = new byte[BUFFER_SIZE];

        try {
        	stream = file.getInputStream();
			bos = new FileOutputStream(uploadPath + fileName);

			while ((bytesRead = stream.read(buffer, 0, 8192)) != -1) {
				bos.write(buffer, 0, bytesRead);
			}
        } finally {
        	if (bos != null) {
        		bos.close();
        	}
			if (stream != null) {
				stream.close();
			}
        }

		return fileName;
	}
}