package egovframework.common.auth.service;

import org.apache.commons.codec.binary.Base64;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import egovframework.common.auth.util.AES256Manager;

@Component
public class TokenManager {
	@Autowired
    private AES256Manager aes256Manager;
	
	private Logger logger = LoggerFactory.getLogger(this.getClass());
	
	private String aesKey = "governmentJJJinSSS1976AAAfor";
	
	public String getTargetSsoServerIp(String token) throws Exception {		
		String oriToken = new String(Base64.decodeBase64(token.getBytes()));
		
		String encIp = oriToken.substring(0, oriToken.indexOf("."));
		
		if (null == encIp || "".equals(encIp)) {
			logger.error("Invalid token value.");
			
			throw new IllegalArgumentException("Invalid token value.");
		}
		
		return getDecPlanTxt(encIp);
	}
	
	public String getEncCipherTxt(String planTxt) throws Exception {
        return aes256Manager.encrypt(aesKey, planTxt);
    }
	
	public String getDecPlanTxt(String cipherTxt) throws Exception {
        return aes256Manager.decrypt(aesKey, cipherTxt);
    }
}