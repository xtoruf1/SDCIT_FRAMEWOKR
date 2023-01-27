package egovframework.common.service;

import egovframework.attach.dao.AttachDAO;
import egovframework.attach.vo.AttachVO;
import egovframework.common.dao.CocCommonDAO;
import egovframework.common.util.AttachUtil;
import egovframework.common.util.StringUtil;
import egovframework.common.vo.CommonHashMap;
import egovframework.commoncode.dao.PortalDAO;
import egovframework.commoncode.vo.CommonCodeVO;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.util.List;

@Service
public class CommonService {
	private static final Logger LOGGER = LoggerFactory.getLogger(CommonService.class);

	@Autowired
	private AttachDAO attachDAO;

	@Autowired
	private PortalDAO portalDAO;

	@Autowired
	private CocCommonDAO cocCommonDAO;

	@Transactional
	public void fileDownload(HttpServletRequest request, HttpServletResponse response, AttachVO attachVO) throws Exception {
		if (!StringUtil.isEmpty(attachVO.getAttachSeq())) {
    		if (!StringUtil.isEmpty(String.valueOf(attachVO.getFileSeq()))) {
    			AttachUtil attachUtil = new AttachUtil(attachDAO);
	    		attachVO = attachUtil.download(attachVO);

	    		if (attachVO != null) {
					String savePath = (String)attachVO.getSavePath();
					String saveFileNm = (String)attachVO.getSaveFileNm();
					String fileName = (String)attachVO.getFileNm();

					if (fileName.length() > 0) {
						fileName.replaceAll(" ", "_");
					}

					fileName = new String(fileName.getBytes("KSC5601"), "ISO8859_1");

					File file = new File(savePath + saveFileNm);

					String strClient = request.getHeader("User-Agent");
					if( strClient == null ) {strClient = "";}
					response.reset();
					if (strClient.indexOf("MSIE 5.5") != -1 || strClient.indexOf("MSIE 6.0") != -1) {
						response.setHeader("Content-Type", "application/x-msdownload");
						response.setHeader("Content-Disposition", "attachment;filename=\"" + fileName + "\";");
					} else {
						response.setHeader("Content-Type", "application/x-msdownload");
						response.setHeader("Content-Disposition", "attachment;filename=\"" + fileName + "\";");
					}

					response.setHeader("Content-Length", Long.toString(file.length()));

					BufferedInputStream fin = null;
					ServletOutputStream outx = null;

					try {
						byte b[] = new byte[1024];

						fin = new BufferedInputStream(new FileInputStream(file));

						int numRead = fin.read(b);
						outx = response.getOutputStream();
						while (numRead > 0) {
							outx.write(b, 0, numRead);
							numRead = fin.read(b);
						}
						outx.flush();
					} catch (Exception e) {
						LOGGER.debug(e.getMessage());
					} finally {
						 if (outx != null) {
							 outx.close();
						 }
						 if (fin != null) {
							 fin.close();
						 }
					}
				}
    		}
		}
    }

	@Transactional
	public void fileDelete(HttpServletRequest request, AttachVO attachVO) throws Exception {
    	if (!StringUtil.isEmpty(attachVO.getAttachSeq())) {
    		if (!StringUtil.isEmpty(String.valueOf(attachVO.getFileSeq()))) {
	    		AttachUtil attachUtil = new AttachUtil(attachDAO);
	    		attachUtil.delete(attachVO);
			}
    	}
    }

	public List<CommonHashMap<String, Object>> getPageUnitList() throws Exception {
		// 페이지 사이즈
		CommonCodeVO ccVO = new CommonCodeVO();
		ccVO.setCodeId("COM080");

		return portalDAO.selectPortalCodeListOrderByNumber(ccVO);
	}


}