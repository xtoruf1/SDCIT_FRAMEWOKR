package egovframework.common.util;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.io.InputStream;
import java.nio.charset.StandardCharsets;

public class MailTemplate {
    private static final Logger LOGGER = LoggerFactory.getLogger(MailTemplate.class);

    public String getMailTemplateContents(String fileName) {
        InputStream test = this.getClass().getClassLoader().getResourceAsStream("/egovframework/mailTemplate/"+fileName);
        StringBuffer sb = new StringBuffer();
        byte[] b = new byte[4096];
        try {
            for (int n; (n = test.read(b)) != -1; ) {
                sb.append(new String(b, 0, n, StandardCharsets.UTF_8));
            }
        } catch (IOException e) {
            LOGGER.error(e.getMessage());
            try {
                throw e;
            } catch (IOException ioException) {
                LOGGER.error(e.getMessage());
            }
        }
        return sb.toString();
    }
}
