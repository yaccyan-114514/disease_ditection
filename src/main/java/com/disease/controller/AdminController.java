package com.disease.controller;

import com.disease.domain.Admin;
import com.disease.domain.Comment;
import com.disease.domain.Expert;
import com.disease.domain.Farmer;
import com.disease.domain.Post;
import com.disease.service.AdminManagementService;
import com.disease.service.AdminService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpSession;
import java.util.List;

@Controller
@RequestMapping("/admin")
public class AdminController {

    private final AdminService adminService;
    private final AdminManagementService adminManagementService;

    public AdminController(AdminService adminService, AdminManagementService adminManagementService) {
        this.adminService = adminService;
        this.adminManagementService = adminManagementService;
    }

    // 管理员登录
    @GetMapping("/login")
    public String loginPage() {
        return "admin/login";
    }

    @PostMapping("/login")
    public String doLogin(@RequestParam String username,
                          @RequestParam String password,
                          RedirectAttributes redirectAttributes,
                          HttpSession session) {
        // 支持用户名或手机号登录
        Admin admin = adminService.login(username, password);
        if (admin != null) {
            session.setAttribute("currentAdmin", admin);
            return "redirect:/admin/dashboard";
        }
        redirectAttributes.addFlashAttribute("error", "用户名/手机号或密码错误");
        return "redirect:/admin/login";
    }

    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.removeAttribute("currentAdmin");
        return "redirect:/admin/login";
    }

    // 管理员主页
    @GetMapping("/dashboard")
    public String dashboard(HttpSession session, Model model) {
        Admin admin = (Admin) session.getAttribute("currentAdmin");
        if (admin == null) {
            return "redirect:/admin/login";
        }
        model.addAttribute("admin", admin);
        return "admin/dashboard";
    }

    // 编辑个人信息
    @GetMapping("/profile/edit")
    public String editProfile(HttpSession session, Model model) {
        Admin admin = (Admin) session.getAttribute("currentAdmin");
        if (admin == null) {
            return "redirect:/admin/login";
        }
        // 从数据库重新获取最新信息
        admin = adminService.findById(admin.getId());
        model.addAttribute("admin", admin);
        return "admin/profile_edit";
    }

    @PostMapping("/profile/update")
    public String updateProfile(Admin adminForm,
                                HttpSession session,
                                RedirectAttributes redirectAttributes) {
        Admin admin = (Admin) session.getAttribute("currentAdmin");
        if (admin == null) {
            return "redirect:/admin/login";
        }
        
        // 从数据库获取最新信息
        Admin currentAdmin = adminService.findById(admin.getId());
        
        // 更新字段
        currentAdmin.setName(adminForm.getName());
        currentAdmin.setPhone(adminForm.getPhone());
        currentAdmin.setEmail(adminForm.getEmail());
        
        // 如果提供了新密码，则更新密码
        if (adminForm.getPassword() != null && !adminForm.getPassword().trim().isEmpty()) {
            currentAdmin.setPassword(adminForm.getPassword());
        }
        
        adminService.updateAdmin(currentAdmin);
        
        // 更新session中的管理员信息
        session.setAttribute("currentAdmin", currentAdmin);
        
        redirectAttributes.addFlashAttribute("message", "个人信息更新成功");
        return "redirect:/admin/dashboard";
    }

    // 农户管理
    @GetMapping("/farmers")
    public String farmersList(HttpSession session, Model model) {
        Admin admin = (Admin) session.getAttribute("currentAdmin");
        if (admin == null) {
            return "redirect:/admin/login";
        }
        List<Farmer> farmers = adminManagementService.getAllFarmers();
        model.addAttribute("farmers", farmers);
        return "admin/farmers";
    }

    @GetMapping("/farmers/{id}")
    public String farmerDetail(@PathVariable Long id, HttpSession session, Model model) {
        Admin admin = (Admin) session.getAttribute("currentAdmin");
        if (admin == null) {
            return "redirect:/admin/login";
        }
        Farmer farmer = adminManagementService.getFarmerById(id);
        model.addAttribute("farmer", farmer);
        return "admin/farmer_detail";
    }

    @GetMapping("/farmers/{id}/edit")
    public String farmerEditPage(@PathVariable Long id, HttpSession session, Model model) {
        Admin admin = (Admin) session.getAttribute("currentAdmin");
        if (admin == null) {
            return "redirect:/admin/login";
        }
        Farmer farmer = adminManagementService.getFarmerById(id);
        model.addAttribute("farmer", farmer);
        return "admin/farmer_edit";
    }

    @PostMapping("/farmers/{id}/edit")
    public String updateFarmer(@PathVariable Long id, Farmer farmer, HttpSession session, RedirectAttributes redirectAttributes) {
        Admin admin = (Admin) session.getAttribute("currentAdmin");
        if (admin == null) {
            return "redirect:/admin/login";
        }
        farmer.setId(id);
        adminManagementService.updateFarmer(farmer);
        redirectAttributes.addFlashAttribute("message", "农户信息更新成功");
        return "redirect:/admin/farmers/" + id;
    }

    @PostMapping("/farmers/{id}/delete")
    public String deleteFarmer(@PathVariable Long id, HttpSession session, RedirectAttributes redirectAttributes) {
        Admin admin = (Admin) session.getAttribute("currentAdmin");
        if (admin == null) {
            return "redirect:/admin/login";
        }
        adminManagementService.deleteFarmer(id);
        redirectAttributes.addFlashAttribute("message", "农户删除成功");
        return "redirect:/admin/farmers";
    }

    // 专家管理
    @GetMapping("/experts")
    public String expertsList(HttpSession session, Model model) {
        Admin admin = (Admin) session.getAttribute("currentAdmin");
        if (admin == null) {
            return "redirect:/admin/login";
        }
        List<Expert> experts = adminManagementService.getAllExperts();
        model.addAttribute("experts", experts);
        return "admin/experts";
    }

    @GetMapping("/experts/new")
    public String expertCreatePage(HttpSession session, Model model) {
        Admin admin = (Admin) session.getAttribute("currentAdmin");
        if (admin == null) {
            return "redirect:/admin/login";
        }
        model.addAttribute("expert", new Expert());
        return "admin/expert_create";
    }

    @PostMapping("/experts/new")
    public String createExpert(Expert expert, HttpSession session, RedirectAttributes redirectAttributes) {
        Admin admin = (Admin) session.getAttribute("currentAdmin");
        if (admin == null) {
            return "redirect:/admin/login";
        }
        adminManagementService.createExpert(expert);
        redirectAttributes.addFlashAttribute("message", "专家创建成功");
        return "redirect:/admin/experts";
    }

    @GetMapping("/experts/{id}")
    public String expertDetail(@PathVariable Long id, HttpSession session, Model model) {
        Admin admin = (Admin) session.getAttribute("currentAdmin");
        if (admin == null) {
            return "redirect:/admin/login";
        }
        Expert expert = adminManagementService.getExpertById(id);
        model.addAttribute("expert", expert);
        return "admin/expert_detail";
    }

    @GetMapping("/experts/{id}/edit")
    public String expertEditPage(@PathVariable Long id, HttpSession session, Model model) {
        Admin admin = (Admin) session.getAttribute("currentAdmin");
        if (admin == null) {
            return "redirect:/admin/login";
        }
        Expert expert = adminManagementService.getExpertById(id);
        model.addAttribute("expert", expert);
        return "admin/expert_edit";
    }

    @PostMapping("/experts/{id}/edit")
    public String updateExpert(@PathVariable Long id, Expert expert, HttpSession session, RedirectAttributes redirectAttributes) {
        Admin admin = (Admin) session.getAttribute("currentAdmin");
        if (admin == null) {
            return "redirect:/admin/login";
        }
        expert.setId(id);
        adminManagementService.updateExpert(expert);
        redirectAttributes.addFlashAttribute("message", "专家信息更新成功");
        return "redirect:/admin/experts/" + id;
    }

    @PostMapping("/experts/{id}/delete")
    public String deleteExpert(@PathVariable Long id, HttpSession session, RedirectAttributes redirectAttributes) {
        Admin admin = (Admin) session.getAttribute("currentAdmin");
        if (admin == null) {
            return "redirect:/admin/login";
        }
        adminManagementService.deleteExpert(id);
        redirectAttributes.addFlashAttribute("message", "专家删除成功");
        return "redirect:/admin/experts";
    }

    // 社区投稿管理
    @GetMapping("/posts")
    public String postsList(HttpSession session, Model model) {
        Admin admin = (Admin) session.getAttribute("currentAdmin");
        if (admin == null) {
            return "redirect:/admin/login";
        }
        List<Post> posts = adminManagementService.getAllPosts();
        model.addAttribute("posts", posts);
        return "admin/posts";
    }

    @GetMapping("/posts/{id}")
    public String postDetail(@PathVariable Long id, HttpSession session, Model model) {
        Admin admin = (Admin) session.getAttribute("currentAdmin");
        if (admin == null) {
            return "redirect:/admin/login";
        }
        Post post = adminManagementService.getPostById(id);
        model.addAttribute("post", post);
        return "admin/post_detail";
    }

    @PostMapping("/posts/{id}/delete")
    public String deletePost(@PathVariable Long id, HttpSession session, RedirectAttributes redirectAttributes) {
        Admin admin = (Admin) session.getAttribute("currentAdmin");
        if (admin == null) {
            return "redirect:/admin/login";
        }
        adminManagementService.deletePost(id);
        redirectAttributes.addFlashAttribute("message", "投稿删除成功");
        return "redirect:/admin/posts";
    }

    // 评论管理
    @GetMapping("/comments")
    public String commentsList(HttpSession session, Model model) {
        Admin admin = (Admin) session.getAttribute("currentAdmin");
        if (admin == null) {
            return "redirect:/admin/login";
        }
        List<Comment> comments = adminManagementService.getAllComments();
        model.addAttribute("comments", comments);
        return "admin/comments";
    }

    @GetMapping("/comments/{id}")
    public String commentDetail(@PathVariable Long id, HttpSession session, Model model) {
        Admin admin = (Admin) session.getAttribute("currentAdmin");
        if (admin == null) {
            return "redirect:/admin/login";
        }
        Comment comment = adminManagementService.getCommentById(id);
        model.addAttribute("comment", comment);
        return "admin/comment_detail";
    }

    @PostMapping("/comments/{id}/delete")
    public String deleteComment(@PathVariable Long id, HttpSession session, RedirectAttributes redirectAttributes) {
        Admin admin = (Admin) session.getAttribute("currentAdmin");
        if (admin == null) {
            return "redirect:/admin/login";
        }
        adminManagementService.deleteComment(id);
        redirectAttributes.addFlashAttribute("message", "评论删除成功");
        return "redirect:/admin/comments";
    }
}
