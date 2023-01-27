package egovframework.common.util;

import com.pnalink.qrcode.QrCodeException;
import com.pnalink.qrcode.QrCodeGen;
import egovframework.common.bean.CommonMessageSource;
import egovframework.common.exception.CommonException;
import egovframework.common.vo.QrVO;
import egovframework.common.web.Aria;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;

import java.io.File;
import java.text.SimpleDateFormat;
import java.util.Calendar;

@Slf4j
public class TdQrMaker {

    @Autowired
    CommonMessageSource messageSource;

	public static final String QR_ARIA_KEY = "SDCITeGovFrameworkKitaEncryptionKey";

	public QrVO QRMaker(String data, String filePath, String fileName){
		QrVO result = new QrVO();
        //QR 저장 경로
        //String strDir = BmPropertyUtil.getProperty("qr.image.path");
        String strDir = PropertyUtil.getProperty("qr.image.path");

        strDir += filePath;
        try {
        	//저장 경로 생성
	        File saveFolder = new File(strDir);

	     /*   if(!saveFolder.getCanonicalPath().startsWith(saveFolder.getPath())) {
                throw new CommonException("허용되지 않은 경로의 접근입니다.");
			}*/

	        if (!saveFolder.exists() || saveFolder.isFile()) {
	            saveFolder.mkdirs();
	        }

            QrCodeGen qrCodeGen = new QrCodeGen();
            // path데이터를 포함한 QR 생성
            qrCodeGen.setData(data);
            qrCodeGen.setSize(350, 350);

            //생성 경로 설정 필요
            SimpleDateFormat sdf = new SimpleDateFormat("YYYYMMddhhmmss");
            Calendar cal = Calendar.getInstance();
            String today = sdf.format(cal.getTime());

            String qrFileName = "QR_"+fileName+"_"+ today;
            qrFileName = qrFileName.replaceAll("[:\\\\/*?|<>]", "");
            strDir+= qrFileName;

            //경로에 QR코드 이미지 생성
//            String QRLogoFile = propertiesService.getString("kita.crm.QRLogo.path");
//            qrCodeGen.setLogoFile(QRLogoFile);
            qrCodeGen.setOutputFile(strDir);
            qrCodeGen.generateQrCode();
            qrCodeGen.setOutputType(QrCodeGen.OUTPUT_TYPE_BASE64);

            //svgHTML
            String svgHTML = qrCodeGen.getQRCodeSvg(true);

            result.setQrSrcCntn(svgHTML);
            result.setQrUpldFileNm(qrFileName);
            result.setQrFileRuteCntn(PropertyUtil.getProperty("qr.image.path")+filePath);

        } catch (QrCodeException e) {
            log.error(e.getMessage(), e);
        } catch (Exception e) {
        	log.error(e.getMessage(), e);
        }
        return result;
    }

    /**
     * 참석 확인용 QR ( 무역의 날 기념식 관리 )
     * @param svrId
     * @param applySeq
     * @param attendId
     * @return
     */
    public QrVO attendQRMaker(String svrId, String applySeq,  String attendId){
    	QrVO result = new QrVO();
        String data = "";
        data = encryptQRString( svrId, applySeq, attendId);
        String filePath = "tradeDay/"+svrId+"/attend/"+applySeq+"/";

        result = this.QRMaker(data, filePath, attendId);

        return result;
    }

    /**
     * 무역의날 기념식 암호화 처리
     * @param svrId
     * @param applySeq
     * @param attendId
     * @return
     */
    public String encryptQRString(String svrId, String applySeq, String attendId){
        Aria aria = new Aria(this.QR_ARIA_KEY);
        //QR 값 생성 (JSON 생성 및 암호화 처리)
     /*   return aria.Encrypt("{\"svrId\":\""+svrId+"\",\"applySeq\":\""+applySeq+"\",\"attendId\":\""+attendId+"\"}");*/
        return aria.Encrypt("{\"svrId\":\""+svrId+"\",\"attendId\":\""+attendId+"\"}");
    }

    /**
     * 참석 확인용 QR ( Kita기술컨설팅 > 상담회 관리 )
     * @param devCfrcId
     * @param applId
     * @return
     * @throws Exception
     */
    public QrVO tcAttendQRMaker(String devCfrcId, String applId) throws Exception {
        QrVO result = new QrVO();
        String data = "";
        data = tcEncryptQRString( devCfrcId, applId);
        String filePath = "kitaTC/"+devCfrcId+"/attend/"+applId+"/";

        result = this.QRMaker(data, filePath, applId);

        return result;
    }

    /**
     * 상담회 관리 암호화 처리
     * @param devCfrcId
     * @param applId
     * @return
     */
    public String tcEncryptQRString(String devCfrcId, String applId){
        Aria aria = new Aria(this.QR_ARIA_KEY);
        //QR 값 생성 (JSON 생성 및 암호화 처리)
        return aria.Encrypt("{\"devCfrcId\":\""+devCfrcId+"\",\"applId\":\""+applId+"\"}");
    }
}

