package com.disease.interceptor;

import org.springframework.web.servlet.HandlerInterceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.Arrays;
import java.util.List;

/**
 * 安全拦截器
 * 功能：
 * 1. 检测IP地址变化，防止会话劫持
 * 2. 当检测到IP地址变化时，强制用户重新登录
 */
public class SecurityInterceptor implements HandlerInterceptor {

    // 不需要登录验证的路径
    private static final List<String> EXCLUDE_PATHS = Arrays.asList(
            "/login",
            "/farmer/login",
            "/farmer/register",
            "/logout",
            "/farmer/logout",
            "/api/",
            "/assets/",
            "/uploads/"
    );

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        String requestPath = request.getRequestURI();
        String contextPath = request.getContextPath();
        
        // 移除contextPath前缀
        if (contextPath != null && !contextPath.isEmpty() && requestPath.startsWith(contextPath)) {
            requestPath = requestPath.substring(contextPath.length());
        }
        
        // 检查是否为排除路径
        if (isExcludePath(requestPath)) {
            return true;
        }

        HttpSession session = request.getSession(false);
        
        // 如果没有session，说明未登录，允许访问（由各控制器自行处理）
        if (session == null) {
            return true;
        }

        // 检查是否有用户登录信息
        boolean hasUser = session.getAttribute("currentFarmer") != null ||
                         session.getAttribute("currentExpert") != null ||
                         session.getAttribute("currentAdmin") != null;

        // 如果没有用户登录信息，允许访问
        if (!hasUser) {
            return true;
        }

        // 获取当前请求的IP地址
        String currentIp = getClientIpAddress(request);
        
        // 获取session中保存的IP地址
        String sessionIp = (String) session.getAttribute("userIpAddress");

        // 如果session中没有IP地址，说明是首次登录，保存IP地址
        if (sessionIp == null || sessionIp.isEmpty()) {
            session.setAttribute("userIpAddress", currentIp);
            return true;
        }

        // 检查是否为 Tailscale IP（100.x.x.x 网段）
        // 如果是 Tailscale 网络，允许不同设备访问（因为每个设备有自己的 Tailscale IP）
        boolean isTailscaleIp = currentIp != null && currentIp.startsWith("100.");
        boolean isSessionTailscaleIp = sessionIp != null && sessionIp.startsWith("100.");
        
        // 如果IP地址发生变化
        if (!sessionIp.equals(currentIp)) {
            // 如果都是 Tailscale IP，允许访问（不同设备在 Tailscale 网络中会有不同 IP）
            if (isTailscaleIp && isSessionTailscaleIp) {
                // 更新 session 中的 IP 地址，允许访问
                session.setAttribute("userIpAddress", currentIp);
                return true;
            }
            
            // 非 Tailscale 网络或混合情况，执行安全检查
            // 清除session中的所有用户信息
            session.removeAttribute("currentFarmer");
            session.removeAttribute("currentExpert");
            session.removeAttribute("currentAdmin");
            session.removeAttribute("userIpAddress");
            
            // 重定向到登录页面，并提示需要重新登录
            response.sendRedirect(request.getContextPath() + "/login?error=检测到IP地址变化，为了安全请重新登录");
            return false;
        }

        return true;
    }

    /**
     * 检查路径是否在排除列表中
     */
    private boolean isExcludePath(String path) {
        if (path == null || path.isEmpty()) {
            return true;
        }
        
        for (String excludePath : EXCLUDE_PATHS) {
            if (path.startsWith(excludePath)) {
                return true;
            }
        }
        return false;
    }

    /**
     * 获取客户端真实IP地址
     * 考虑代理服务器的情况（X-Forwarded-For, X-Real-IP等）
     */
    private String getClientIpAddress(HttpServletRequest request) {
        String ip = request.getHeader("X-Forwarded-For");
        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("X-Real-IP");
        }
        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("Proxy-Client-IP");
        }
        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("WL-Proxy-Client-IP");
        }
        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("HTTP_CLIENT_IP");
        }
        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("HTTP_X_FORWARDED_FOR");
        }
        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getRemoteAddr();
        }
        
        // 如果IP地址包含多个（通过代理），取第一个
        if (ip != null && ip.contains(",")) {
            ip = ip.split(",")[0].trim();
        }
        
        return ip != null ? ip : "unknown";
    }
}
