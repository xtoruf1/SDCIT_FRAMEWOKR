package egovframework.common.util;

import org.springframework.util.StringUtils;

import javax.mail.MessagingException;
import javax.mail.internet.MimeUtility;
import java.io.*;
import java.nio.charset.Charset;

/**
 * Created by jwsong on 2021-11-26 0026.
 */

public class TradeSosUtil extends StringUtils{

    private static char[] alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=".toCharArray();
    private static byte[] codes = new byte[256];

    /**
     * UTF-8환경에서 EUC-KR로 변환한다
     * @param str
     * @return
     * @throws Exception
     */
    public static String decodedStr(String str) throws Exception{
        String decode_str = "";
        if ((str != null) && (!"".equals(str))) {
            ByteArrayInputStream bais = new ByteArrayInputStream(str.getBytes("euc-kr"));
            InputStream is = MimeUtility.decode(bais, "base64");
            byte[] tmp = new byte[str.length()];
            int i = is.read(tmp);
            byte[] res = new byte[i];
            System.arraycopy(tmp, 0, res, 0, i);
            decode_str = new String(res, Charset.forName("euc-kr"));
        }
        return decode_str;
    }

    /**
     * UTF-8환경에서 EUC-KR로 변환하여 저장한다.
     * @param str
     * @return
     * @throws Exception
     */
    public static String encodedStr(String str) throws Exception{
        String encode_str = "";
        if ((str != null) && (!"".equals(str))){
            ByteArrayOutputStream baos = new ByteArrayOutputStream();
            try{
                OutputStream os = MimeUtility.encode(baos, "base64");
                os.write(str.getBytes("euc-kr"));
                os.close();
                encode_str = baos.toString();
            }catch (MessagingException e){
                e.printStackTrace();
            }catch (IOException e){
                e.printStackTrace();
            }
        }
        return encode_str;
    }

    /**
     * 외국어 통번역의 경우 계좌번호가 euc-kr로 인코딩되어있음
     * utf-8환경에서 디코딩 하기 위해 사용함
     * @param str
     * @return
     */
    public static String changeEncoding(String str) throws Exception{
        //String 을 euc-kr 로 인코딩.
        byte[] euckrStringBuffer = str.getBytes(Charset.forName("euc-kr"));
        String decodedFromEucKr = new String(euckrStringBuffer, "euc-kr");

        // String 을 utf-8 로 인코딩.
        byte[] utf8StringBuffer = decodedFromEucKr.getBytes("utf-8");
        String decodedFromUtf8 = new String(utf8StringBuffer, "utf-8");

        return decodedFromUtf8;
    }

    public static String commanum(String inNum) {
        String str = "0";
        if (inNum != null && inNum != "") {
            double d_num = Double.parseDouble(inNum);
            int i_num = (new Double(d_num)).intValue();
            if (i_num == 0) {
                if (d_num / 1.0D == 0.0D) {
                    str = String.valueOf(i_num);
                } else {
                    str = String.valueOf(d_num);
                }
            } else if (d_num / (double)i_num != 0.0D && d_num / (double)i_num != 1.0D) {
                str = String.valueOf(d_num);
            } else {
                str = String.valueOf(i_num);
            }
        }

        return str;
    }
}
