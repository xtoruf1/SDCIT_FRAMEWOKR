package egovframework.common.web;

import egovframework.attach.dao.AttachDAO;
import egovframework.attach.vo.AttachVO;
import egovframework.common.exception.CommonException;
import egovframework.common.service.CommonService;
import egovframework.common.util.*;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.apache.commons.io.FileUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.*;

/**
 * @author 이승준
 *
 * 공통 Controller
 */
@Controller
public class CommonController {
	private static final Logger LOGGER = LoggerFactory.getLogger(CommonController.class);
	
	@Autowired
	private CommonService commonService;
	
	@Autowired
	private AttachDAO attachDAO;
	
	// 첨부파일 위치 지정
    private final String uploadDir = PropertyUtil.getProperty("Globals.fileStorePath");
	
	/**
	 * 공통 선택팝업(샘플)
	 * 
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/common/popup/commonSearch.do")
	public ModelAndView commonSearch(HttpServletRequest request, ModelMap model) throws Exception {
		ModelAndView mav = new ModelAndView();
		
		mav.setViewName("common/popup/commonSearch");
		
		return mav;
	}
	
	/**
	 * 공통 선택팝업1(샘플)
	 * 
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/common/popup/searchPopup1.do")
	public ModelAndView searchPopup1(HttpServletRequest request, ModelMap model) throws Exception {
		ModelAndView mav = new ModelAndView();
		
		mav.setViewName("layer/common/popup/searchPopup1");
		
		return mav;
	}
	
	/**
	 * 공통 선택팝업2(샘플)
	 * 
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/common/popup/searchPopup2.do")
	public ModelAndView searchPopup2(HttpServletRequest request, ModelMap model) throws Exception {
		ModelAndView mav = new ModelAndView();
		
		mav.setViewName("layer/common/popup/searchPopup2");
		
		return mav;
	}
	
	/**
	 * 첨부파일 다운로드
	 * 
	 * @param request
	 * @param response
	 * @param attachVO
	 * @param model
	 * @throws Exception
	 */
	@RequestMapping(value = "/common/fileDownload.do")
	@ResponseBody
    public void fileDownload(HttpServletRequest request, HttpServletResponse response, @ModelAttribute("attachVO")AttachVO attachVO, ModelMap model) throws Exception {
		try {
			commonService.fileDownload(request, response, attachVO);
		} catch (Exception e) {
			LOGGER.debug(e.getMessage());
		} 
    }
	
	/**
	 * 첨부파일 삭제
	 * 
	 * @param request
	 * @param attachVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/common/fileDelete.do")
    public ModelAndView fileDelete(HttpServletRequest request, @ModelAttribute("attachVO")AttachVO attachVO, ModelMap model) throws Exception {
    	ModelAndView mav = new ModelAndView();
		
		try {
			commonService.fileDelete(request, attachVO);
		} catch (Exception e) {
			LOGGER.debug(e.getMessage());
		}
		
		mav.setViewName("jsonView");
		
		return mav;
    }
	
	/**
	 * CHUNKED 업로드
	 * 
	 * @param request
	 * @param response
	 * @param file
	 * @param guid
	 * @param chunks
	 * @param chunk
	 * @return
	 */
	@RequestMapping(value = "/common/chunkedUpload.do")
	public ModelAndView chunkedUpload(HttpServletRequest request, HttpServletResponse response, MultipartFile file, String guid, Integer chunks, Integer chunk) {
		ModelAndView mav = new ModelAndView();
		
		try {
			String savePath = PropertyUtil.getProperty("variables.uploadPath").replaceAll("\\\\", "/");
			
			boolean isMultipart = ServletFileUpload.isMultipartContent(request);
			
			if (isMultipart) {
				if (chunk == null) {
					chunk = 0;
				}
					
				// 임시 디렉토리는 모든 조각난 파일을 저장하는 데 사용
				String tempFilePath = savePath + File.separator + "chunked" + File.separator + guid;
				File parentFilePath = new File(tempFilePath);
				if (!parentFilePath.exists()) {
					parentFilePath.mkdirs();
				}
				
				// 분열 과정은, 프론트 데스크가 인터페이스를 업로드 할 여러 번 호출하면 파일의 각 부분은 배경에 업로드됩니다.
				File tempPartFile = new File(parentFilePath, guid + "_" + chunk + ".part");
				FileUtils.copyInputStreamToFile(file.getInputStream(), tempPartFile);
			}
		} catch (Exception e) {
			LOGGER.debug(e.getMessage());
			
			mav.addObject("code", HttpStatus.BAD_REQUEST.value());
			mav.addObject("message", HttpStatus.BAD_REQUEST.name());
		}
		
		mav.addObject("code", HttpStatus.OK.value());
		mav.addObject("message", HttpStatus.OK.name());
		
		mav.setViewName("jsonView");
		
		return mav;
	}

	/**
	 * 업로드 된 CHUNKED 병합
	 * 	
	 * @param name
	 * @param guid
	 * @return
	 */
	@RequestMapping(value = "/common/chunkedFileMerge.do")
	public ModelAndView chunkedFileMerge(String name, String guid) {
		ModelAndView mav = new ModelAndView();
		
		// 최종 문서는 destTempFile를 얻는 것입니다
		String savePath = PropertyUtil.getProperty("variables.uploadPath").replaceAll("\\\\", "/");
		
		String path = savePath + File.separator + "chunked" + File.separator;
		
		File parentPath = new File(path + guid);
		
		try {
			if (parentPath.isDirectory()) {
				File destTempFile = new File(savePath, name);
				
				if (!destTempFile.exists()) {
					// 상위 디렉토리의 파일을 얻고, 부모 디렉토리를 만들려면 파일을 생성
					destTempFile.getParentFile().mkdir();
					
					try {
						destTempFile.createNewFile();
					} catch (IOException e) {
						LOGGER.debug(e.getMessage());
					}
				}
				
				for (int i = 0; i < parentPath.listFiles().length; i++) {
					File partFile = new File(parentPath, guid + "_" + i + ".part");
					FileOutputStream destTempStream = new FileOutputStream(destTempFile, true);
					
					// "최종 문서"에서에 "모든 조각난 파일"을 한 파일로 복사한다.
					FileUtils.copyFile(partFile, destTempStream);
					destTempStream.close();
				}
				
				// 조각난 파일은 임시 디렉토리를 삭제합니다
				FileUtils.deleteDirectory(parentPath);
				
				mav.addObject("code", HttpStatus.OK.value());
				mav.addObject("message", "병합 성공");
				
				LOGGER.debug("병합 성공");
			} else {
				mav.addObject("code", HttpStatus.BAD_REQUEST.value());
				mav.addObject("message", "디렉토리를 찾을 수 없습니다.");
				
				LOGGER.debug("디렉토리를 찾을 수 없습니다.");
			}
		} catch (Exception e1) {
			try {
				// 조각난 파일은 임시 디렉토리를 삭제합니다
				FileUtils.deleteDirectory(parentPath);
			} catch (Exception e2) {
				LOGGER.debug(e2.getMessage());
				
				mav.addObject("code", HttpStatus.BAD_REQUEST.value());
				mav.addObject("message", "에러");
				
				LOGGER.debug("에러");
			}
						
			LOGGER.debug(e1.getMessage());
			
			mav.addObject("code", HttpStatus.BAD_REQUEST.value());
			mav.addObject("message", "에러");
			
			LOGGER.debug("에러");
		}
		
		mav.setViewName("jsonView");
		
		return mav;
	}
	
	/**
	 * 네이버 에디터 사진 업로드
	 * 
	 * @param request
	 * @param response
	 * @param model
	 * @throws Exception
	 */
	@RequestMapping(value = "/utl/wed/insertSmartEditorImage.do")
    public void photoUpload(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		try {
			// 파일정보
    		String fileInfo = "";
    		// 파일명을 받는다. - 일반 원본파일명
    		String fileName = request.getHeader("file-name");
    		// 컨텐츠 타입
    		String contentType = request.getHeader("Content-Type");
    		// 파일 서브디렉토리
    		String serverSubPath = FileUtil.getTodayString();
    		
    		// 파일 상세경로
    		String filePath = uploadDir + File.separator + serverSubPath + File.separator;
    		File file = new File(filePath);
    		if (!file.exists()) {
    			file.mkdirs();
    		}
    		
    		String realFileName = FileUtil.getPhysicalFileName();
    		String saveFileName = filePath + realFileName;
    		
    		// 서버에 파일 쓰기
    		InputStream is = request.getInputStream();
    		OutputStream os = new FileOutputStream(saveFileName);
    		
    		int nr;
    		int fileSize = Integer.parseInt(request.getHeader("file-size"));
    		
    		byte b[] = new byte[fileSize];
    		while ((nr = is.read(b, 0, b.length)) != -1) {
    			os.write(b, 0, nr);
    		}
    		
    		if (is != null) {
    			is.close();
    		}
    		os.flush();
    		os.close();
    		
    		// 정보 출력
    		fileInfo += "&bNewLine=true";
    		// 이미지 태그의 타이틀 속성을 원본 파일명으로 적용시켜주기 위함
    		fileInfo += "&sFileName=" + fileName;
    		fileInfo += "&sFileURL=" + StringUtil.encodeURIComponent(
    			"/utl/web/imageSrc.do?path=" + serverSubPath
    			+ "&physical=" + realFileName 
    			+ "&contentType=" + contentType);
    		
    		PrintWriter print = response.getWriter();
    		print.print(fileInfo);
    		print.flush();
    		print.close();
		} catch (Exception e) {
			LOGGER.debug(e.getMessage());
		}
    }
	
	@RequestMapping(value = "/utl/web/imageSrc.do", method=RequestMethod.GET)
    public void download(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String subPath = request.getParameter("path");
		String physical = request.getParameter("physical");
		String mimeType = request.getParameter("contentType");

		FileUtil.viewFile(response, uploadDir, subPath, physical, mimeType);
    }
	
	/**
	 * 에러 내용 처리
	 * 
	 * @param request
	 * @param errorType
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/common/error/{errorType}.do", method = RequestMethod.GET)
    public ModelAndView error(HttpServletRequest request, @PathVariable String errorType, ModelMap model) throws Exception {
    	ModelAndView mav = new ModelAndView();
		
    	String uri = (String)request.getAttribute("javax.servlet.error.request_uri");
    	
    	if (errorType.equals("throwable")) {
    		LOGGER.info("Throwable");
    		mav.addObject("msg", "예외가 발생하였습니다.");
    	} else if (errorType.equals("exception")) {
    		LOGGER.info("Exception");
    		mav.addObject("msg", "예외가 발생하였습니다.");
    	// 400
    	} else if (Integer.parseInt(errorType) == HttpStatus.BAD_REQUEST.value()) {
    		LOGGER.info("Page Error Code {}", errorType);
    		mav.addObject("msg", "잘못된 요청입니다.");
    	// 403
    	} else if (Integer.parseInt(errorType) == HttpStatus.FORBIDDEN.value()) {
    		LOGGER.info("Page Error Code {}", errorType);
    		mav.addObject("msg", "접근이 금지되었습니다.");
    	// 404
    	} else if (Integer.parseInt(errorType) == HttpStatus.NOT_FOUND.value()) {
    		if (!uri.endsWith("/null")) {
    			LOGGER.info("Page Error Code {}", errorType);
        		mav.addObject("msg", "요청하신 페이지를 찾을 수 없습니다.");
    		}
    	// 405
    	} else if (Integer.parseInt(errorType) == HttpStatus.METHOD_NOT_ALLOWED.value()) {
    		LOGGER.info("Page Error Code {}", errorType);
    		mav.addObject("msg", "요청된 메소드가 허용되지 않습니다.");
    	// 500
    	} else if (Integer.parseInt(errorType) == HttpStatus.INTERNAL_SERVER_ERROR.value()) {
    		LOGGER.info("Page Error Code {}", errorType);
    		mav.addObject("msg", "서버에 오류가 발생하였습니다.");
    	// 503
    	} else if (Integer.parseInt(errorType) == HttpStatus.SERVICE_UNAVAILABLE.value()) {
    		LOGGER.info("Page Error Code {}", errorType);
    		mav.addObject("msg", "서비스를 사용할 수 없습니다.");
    	}
    	
    	mav.addObject("errorType", errorType);
    	
    	if (!uri.endsWith("/null")) {
			pageErrorLog(request);
		}
    	    	
		mav.setViewName("common/error/error");
		
		return mav;
	}
	
	/**
	 * 메뉴 접근권한 에러
	 * 
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/common/error/auth.do", method = RequestMethod.GET)
    public ModelAndView authError(HttpServletRequest request, ModelMap model) throws Exception {
    	ModelAndView mav = new ModelAndView();
		    	
		mav.setViewName("common/error/authError");
		
		return mav;
	}
	
	
	
	/**
	 * 공통 사진 이미지
	 * 
	 * @param request
	 * @param response
	 * @param attachVO
	 * @throws Exception
	 */
	@RequestMapping(value = "/common/getFileImage.do")
	public void getFileImage(HttpServletRequest request, HttpServletResponse response, @ModelAttribute("attachVO")AttachVO attachVO) throws Exception {
		
		
		AttachUtil attachUtil = new AttachUtil(attachDAO);
		AttachVO resultVO = attachUtil.info(attachVO);

		File file = null;
		FileInputStream fis = null;

		BufferedInputStream in = null;
		ByteArrayOutputStream bStream = null;

		try {
			if (new File(resultVO.getSavePath(), resultVO.getSaveFileNm()).isFile()) {
				file = new File(resultVO.getSavePath(), resultVO.getSaveFileNm());
			} else {
				throw new CommonException("이미지를 찾을 수 없습니다.");
			}
			
			fis = new FileInputStream(file);

			in = new BufferedInputStream(fis);
			bStream = new ByteArrayOutputStream();

			int imgByte;
			while ((imgByte = in.read()) != -1) {
				bStream.write(imgByte);
			}

			String type = "";
			int index = resultVO.getSaveFileNm().lastIndexOf(".");

			if (resultVO.getSaveFileNm() != null && !"".equals(resultVO.getSaveFileNm())) {
				String fileExt = resultVO.getSaveFileNm().substring(index + 1);
				if ("jpg".equals(fileExt.toLowerCase())) {
					type = "image/jpeg";
				}
				
				type = "image/" + fileExt.toLowerCase();
			} else {
				LOGGER.debug("Image fileType is null.");
			}

			response.setHeader("Content-Type", type);
			response.setContentLength(bStream.size());

			bStream.writeTo(response.getOutputStream());

			response.getOutputStream().flush();
			response.getOutputStream().close();

		} catch (Exception e) {
			LOGGER.error("Error : ", e);
		} finally {
			ResourceCloseHelper.close(bStream, in, fis);
		}
	}
	
	
	private void pageErrorLog(HttpServletRequest request) {
		LOGGER.info("STATUS CODE : {}", request.getAttribute("javax.servlet.error.status_code"));
		LOGGER.info("EXCEPTION TYPE : {}", request.getAttribute("javax.servlet.error.exception_type"));
		LOGGER.info("MESSAGE : {}", request.getAttribute("javax.servlet.error.message"));
		LOGGER.info("REQUEST URI : {}", request.getAttribute("javax.servlet.error.request_uri"));
		LOGGER.info("EXCEPTION : {}", request.getAttribute("javax.servlet.error.exception"));
		LOGGER.info("SERVLET NAME : {}", request.getAttribute("javax.servlet.error.servlet_name"));
	}
}