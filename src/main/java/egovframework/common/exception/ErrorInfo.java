package egovframework.common.exception;

import org.apache.commons.lang3.builder.ToStringBuilder;

import lombok.Data;

/**
 * @FileName : ErrorInfo.java
 * @Date : 2020. 4. 24.
 * @작성자 : yilee
 * @프로그램 설명 : 에러 발생 내용을 client로 전달
 */
@Data
public class ErrorInfo {
	private String errCode;
    private String message;
    private String errortype;
    
    @Override
	public String toString() {
		return ToStringBuilder.reflectionToString(this);
	}
}