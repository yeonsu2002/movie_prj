package kr.co.yeonflix.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

public class DbConnection {

    private static DbConnection dbCon;
    private static Context ctx;
    
    private DbConnection() {
        
    }//DbConnection
    
    public static DbConnection getInstance() {
        if(dbCon == null) {
            dbCon = new DbConnection();
            try {
                ctx = new InitialContext();
            } catch (NamingException e) {
                e.printStackTrace();
            }
        }
        
        return dbCon;
    }//getInstance
    
    public Connection getDbConn() {
        Connection con = null;
        
        DataSource ds;
        try {
            ds = (DataSource)ctx.lookup("java:comp/env/jdbc/dbcp/3");
            con = ds.getConnection();
        } catch (NamingException e) {
            e.printStackTrace();
        } catch (SQLException se) {
            se.printStackTrace();
        }
        
        return con;
    }//getDbConn
    
    // 단독 실행(main 테스트용) 직접 JDBC 연결 메서드 추가
    public Connection getTestConnection() {
        Connection con = null;
        try {
            Class.forName("oracle.jdbc.OracleDriver");  // Oracle 드라이버 로드
            String url = "jdbc:oracle:thin:@192.168.10.75:1521:orcl/3";  // 본인 DB URL로 수정
            String user = "team3";                    // 본인 DB 사용자명
            String password = "1234";                // 본인 DB 비밀번호
            con = DriverManager.getConnection(url, user, password);
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
        }
        return con;
    }
    
    public void dbClose(ResultSet rs, Statement stmt, Connection con) throws SQLException {
        try {
            if(rs != null) { rs.close(); }
            if(stmt != null) { stmt.close(); }
        } finally {
            if(con != null) { con.close(); }
        }
    }//dbClose
    
}
