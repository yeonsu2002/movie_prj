package kr.co.yeonflix.util;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.Properties;

import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.AddressException;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import javax.servlet.ServletContext;

public class MailUtil {

  public static void sendEmail(ServletContext context, String toEmail, String number, String mailType) throws IOException {
    
    String user = "sinseogyoung@naver.com"; //서비스 제공자의 이메일 예: sinseogyoung@naver.com
    String password = "QCYHRFH636JN"; //네이버 앱에서 받은 2단계 보안앱 비밀번호 (이메일 전송을 위해 필요)

    Properties prop = new Properties();
    prop.put("mail.smtp.host", "smtp.naver.com");
    prop.put("mail.smtp.port", "587");  // 네이버 공식 포트
    prop.put("mail.smtp.auth", "true");
    
    // TLS 설정 (네이버 587포트는 TLS 사용)
    prop.put("mail.smtp.starttls.enable", "true");
    prop.put("mail.smtp.starttls.required", "true");
    prop.put("mail.smtp.ssl.trust", "smtp.naver.com");
    
    // 추가 보안 설정
    prop.put("mail.smtp.ssl.protocols", "TLSv1.2");
    
    // 디버그 모드 활성화 (문제 해결을 위해)
    //prop.put("mail.debug", "true");
    
    //세션에 해도 되는데, 그건 연습용에 적합함. 실무는 무조건 DB적용
    Session session = Session.getInstance(prop, new javax.mail.Authenticator() {
      protected PasswordAuthentication getPasswordAuthentication() {
        return new PasswordAuthentication(user, password);
      }
    });
    
    // 디버그 출력 활성화
    //session.setDebug(true);
    
    try {
      MimeMessage message = new MimeMessage(session);
      message.setFrom(new InternetAddress(user));
      
      //수신자 메일 주소
      message.addRecipient(Message.RecipientType.TO, new InternetAddress(toEmail));
      
      if("tempPassword".equals(mailType)) {
        //제목
        message.setSubject("yeonflix 임시 비밀번호 발급 ");
        
        String htmlContent = buildHtmlEmail_2(context, number);
        message.setContent(htmlContent, "text/html; charset=UTF-8");
      }
      
      if("authCode".equals(mailType)) {
        //제목
        message.setSubject("yeonflix 인증 코드 발급 ");
        
        //message.setText("인증 코드는: " + authCode + "입니다.");
        String htmlContent = buildHtmlEmail(context, number);
        message.setContent(htmlContent, "text/html; charset=UTF-8");
      }
      
      Transport.send(message);
      
    }  catch (AddressException e) {
      System.err.println("주소 오류: " + e.getMessage());
      e.printStackTrace();
    } catch (MessagingException me) {
      System.err.println("메시징 오류: " + me.getMessage());
      me.printStackTrace();
      throw new RuntimeException("이메일 전송 실패", me);
    }
  }
  
  static String buildHtmlEmail(ServletContext context, String authcode) throws IOException {
    String templatePath = context.getRealPath("/common/html/sendEmail_verificationCode.html");
    StringBuilder sb = new StringBuilder();

    try (BufferedReader br = new BufferedReader(new FileReader(templatePath))) {
        String line;
        while ((line = br.readLine()) != null) {
            sb.append(line);
        }
    }

    // 예를 들어 템플릿에 {{authCode}} 라는 플레이스홀더가 있다면
    String content = sb.toString().replace("{authCode}", authcode);

    return content;
  }
  
  static String buildHtmlEmail_2(ServletContext context, String temporaryPassword) throws IOException {
    String templatePath = context.getRealPath("/common/html/sendEmail_tempPwd.html");
    StringBuilder sb = new StringBuilder();

    try (BufferedReader br = new BufferedReader(new FileReader(templatePath))) {
        String line;
        while ((line = br.readLine()) != null) {
            sb.append(line);
        }
    }

    // 예를 들어 템플릿에 {{authCode}} 라는 플레이스홀더가 있다면
    String content = sb.toString().replace("{temporaryPassword}", temporaryPassword);

    return content;
  }
  
}
