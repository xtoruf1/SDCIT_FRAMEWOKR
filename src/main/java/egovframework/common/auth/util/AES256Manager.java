package egovframework.common.auth.util;

import java.io.UnsupportedEncodingException;
import java.security.GeneralSecurityException;
import java.security.Key;
import java.security.NoSuchAlgorithmException;

import javax.crypto.Cipher;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;

import org.apache.commons.codec.binary.Base64;
import org.springframework.stereotype.Component;

/**
 * <pre>
 * com.innotree.innoquartz.server.license.util
 * AES256Utils.java
 * </pre>
 * 
 * @Author   : hoony
 * @Date     : 2018. 1. 16.
 * @Version  :
 */
@Component
public class AES256Manager {
	private String iv;
    private Key keySpec;
 
    /**
     * 16자리의 키값을 입력하여 객체를 생성한다.
     * @param key 암/복호화를 위한 키값
     * @throws UnsupportedEncodingException 키값의 길이가 16이하일 경우 발생
     */
    private void init(String key) throws UnsupportedEncodingException {
        this.iv = key.substring(0, 16);
        byte[] keyBytes = new byte[16];
        byte[] b = key.getBytes("UTF-8");
        int len = b.length;
        
        if (len > keyBytes.length) {
            len = keyBytes.length;
        }
        
        System.arraycopy(b, 0, keyBytes, 0, len);
        SecretKeySpec keySpec = new SecretKeySpec(keyBytes, "AES");
 
        this.keySpec = keySpec;
    }
 
    /**
     * AES256 으로 암호화 한다.
     * @param data 암호화할 문자열
     * @return
     * @throws NoSuchAlgorithmException
     * @throws GeneralSecurityException
     * @throws UnsupportedEncodingException
     */
    public String encrypt(String key, String data) throws NoSuchAlgorithmException, GeneralSecurityException, UnsupportedEncodingException {
    	init(key);
        Cipher c = Cipher.getInstance("AES/CBC/PKCS5Padding");
        c.init(Cipher.ENCRYPT_MODE, keySpec, new IvParameterSpec(iv.getBytes()));
        byte[] encrypted = c.doFinal(data.getBytes("UTF-8"));
        String enStr = new String(Base64.encodeBase64(encrypted));
        
        return enStr;
    }
 
    /**
     * AES256으로 암호화된 txt 를 복호화한다.
     * @param data 복호화할 문자열
     * @return
     * @throws NoSuchAlgorithmException
     * @throws GeneralSecurityException
     * @throws UnsupportedEncodingException
     */
    public String decrypt(String key, String data) throws NoSuchAlgorithmException, GeneralSecurityException, UnsupportedEncodingException {
    	init(key);
        Cipher c = Cipher.getInstance("AES/CBC/PKCS5Padding");
        c.init(Cipher.DECRYPT_MODE, keySpec, new IvParameterSpec(iv.getBytes()));
        byte[] byteStr = Base64.decodeBase64(data.getBytes());
        
        return new String(c.doFinal(byteStr), "UTF-8");
    }
}