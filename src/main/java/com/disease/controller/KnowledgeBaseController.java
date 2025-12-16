package com.disease.controller;

import com.disease.domain.*;
import com.disease.service.KnowledgeBaseService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpSession;
import java.util.List;

@Controller
@RequestMapping("/expert/knowledge")
public class KnowledgeBaseController {

    private final KnowledgeBaseService knowledgeBaseService;

    public KnowledgeBaseController(KnowledgeBaseService knowledgeBaseService) {
        this.knowledgeBaseService = knowledgeBaseService;
    }

    @GetMapping("")
    public String knowledgeBase(@RequestParam(value = "type", defaultValue = "crop") String type,
                               Model model, HttpSession session) {
        Expert expert = (Expert) session.getAttribute("currentExpert");
        if (expert == null) {
            return "redirect:/login";
        }

        model.addAttribute("currentExpert", expert);
        model.addAttribute("currentType", type);

        // 根据类型加载数据
        switch (type) {
            case "crop":
                model.addAttribute("items", knowledgeBaseService.getAllCrops());
                break;
            case "disease":
                model.addAttribute("items", knowledgeBaseService.getAllDiseases());
                break;
            case "pesticide":
                model.addAttribute("items", knowledgeBaseService.getAllPesticides());
                break;
            case "treatment":
                model.addAttribute("items", knowledgeBaseService.getAllDiseasePesticides());
                model.addAttribute("diseases", knowledgeBaseService.getAllDiseasesForSelect());
                model.addAttribute("pesticides", knowledgeBaseService.getAllPesticidesForSelect());
                break;
        }

        return "expert_knowledge_base";
    }

    // ========== Crop CRUD ==========
    @GetMapping("/crop/add")
    public String addCropForm(Model model, HttpSession session) {
        Expert expert = (Expert) session.getAttribute("currentExpert");
        if (expert == null) {
            return "redirect:/login";
        }
        model.addAttribute("currentExpert", expert);
        model.addAttribute("crop", new Crop());
        return "expert_knowledge_crop_form";
    }

    @GetMapping("/crop/edit/{id}")
    public String editCropForm(@PathVariable Long id, Model model, HttpSession session) {
        Expert expert = (Expert) session.getAttribute("currentExpert");
        if (expert == null) {
            return "redirect:/login";
        }
        Crop crop = knowledgeBaseService.getCropById(id);
        if (crop == null) {
            return "redirect:/expert/knowledge?type=crop";
        }
        model.addAttribute("currentExpert", expert);
        model.addAttribute("crop", crop);
        return "expert_knowledge_crop_form";
    }

    @PostMapping("/crop/save")
    public String saveCrop(Crop crop, RedirectAttributes redirectAttributes) {
        knowledgeBaseService.saveCrop(crop);
        redirectAttributes.addFlashAttribute("message", "农作物保存成功");
        return "redirect:/expert/knowledge?type=crop";
    }

    @PostMapping("/crop/delete/{id}")
    public String deleteCrop(@PathVariable Long id, RedirectAttributes redirectAttributes) {
        knowledgeBaseService.deleteCrop(id);
        redirectAttributes.addFlashAttribute("message", "农作物删除成功");
        return "redirect:/expert/knowledge?type=crop";
    }

    // ========== Disease CRUD ==========
    @GetMapping("/disease/add")
    public String addDiseaseForm(Model model, HttpSession session) {
        Expert expert = (Expert) session.getAttribute("currentExpert");
        if (expert == null) {
            return "redirect:/login";
        }
        model.addAttribute("currentExpert", expert);
        model.addAttribute("disease", new Disease());
        return "expert_knowledge_disease_form";
    }

    @GetMapping("/disease/edit/{id}")
    public String editDiseaseForm(@PathVariable Long id, Model model, HttpSession session) {
        Expert expert = (Expert) session.getAttribute("currentExpert");
        if (expert == null) {
            return "redirect:/login";
        }
        Disease disease = knowledgeBaseService.getDiseaseById(id);
        if (disease == null) {
            return "redirect:/expert/knowledge?type=disease";
        }
        model.addAttribute("currentExpert", expert);
        model.addAttribute("disease", disease);
        return "expert_knowledge_disease_form";
    }

    @PostMapping("/disease/save")
    public String saveDisease(Disease disease, HttpSession session, RedirectAttributes redirectAttributes) {
        Expert expert = (Expert) session.getAttribute("currentExpert");
        if (disease.getId() == null && expert != null) {
            disease.setCreatedBy(expert.getId());
        }
        knowledgeBaseService.saveDisease(disease);
        redirectAttributes.addFlashAttribute("message", "病毒种类保存成功");
        return "redirect:/expert/knowledge?type=disease";
    }

    @PostMapping("/disease/delete/{id}")
    public String deleteDisease(@PathVariable Long id, RedirectAttributes redirectAttributes) {
        knowledgeBaseService.deleteDisease(id);
        redirectAttributes.addFlashAttribute("message", "病毒种类删除成功");
        return "redirect:/expert/knowledge?type=disease";
    }

    // ========== Pesticide CRUD ==========
    @GetMapping("/pesticide/add")
    public String addPesticideForm(Model model, HttpSession session) {
        Expert expert = (Expert) session.getAttribute("currentExpert");
        if (expert == null) {
            return "redirect:/login";
        }
        model.addAttribute("currentExpert", expert);
        model.addAttribute("pesticide", new Pesticide());
        return "expert_knowledge_pesticide_form";
    }

    @GetMapping("/pesticide/edit/{id}")
    public String editPesticideForm(@PathVariable Long id, Model model, HttpSession session) {
        Expert expert = (Expert) session.getAttribute("currentExpert");
        if (expert == null) {
            return "redirect:/login";
        }
        Pesticide pesticide = knowledgeBaseService.getPesticideById(id);
        if (pesticide == null) {
            return "redirect:/expert/knowledge?type=pesticide";
        }
        model.addAttribute("currentExpert", expert);
        model.addAttribute("pesticide", pesticide);
        return "expert_knowledge_pesticide_form";
    }

    @PostMapping("/pesticide/save")
    public String savePesticide(Pesticide pesticide, RedirectAttributes redirectAttributes) {
        knowledgeBaseService.savePesticide(pesticide);
        redirectAttributes.addFlashAttribute("message", "药物保存成功");
        return "redirect:/expert/knowledge?type=pesticide";
    }

    @PostMapping("/pesticide/delete/{id}")
    public String deletePesticide(@PathVariable Long id, RedirectAttributes redirectAttributes) {
        knowledgeBaseService.deletePesticide(id);
        redirectAttributes.addFlashAttribute("message", "药物删除成功");
        return "redirect:/expert/knowledge?type=pesticide";
    }

    // ========== DiseasePesticide CRUD ==========
    @GetMapping("/treatment/add")
    public String addTreatmentForm(Model model, HttpSession session) {
        Expert expert = (Expert) session.getAttribute("currentExpert");
        if (expert == null) {
            return "redirect:/login";
        }
        model.addAttribute("currentExpert", expert);
        model.addAttribute("treatment", new DiseasePesticide());
        model.addAttribute("diseases", knowledgeBaseService.getAllDiseasesForSelect());
        model.addAttribute("pesticides", knowledgeBaseService.getAllPesticidesForSelect());
        return "expert_knowledge_treatment_form";
    }

    @GetMapping("/treatment/edit/{id}")
    public String editTreatmentForm(@PathVariable Long id, Model model, HttpSession session) {
        Expert expert = (Expert) session.getAttribute("currentExpert");
        if (expert == null) {
            return "redirect:/login";
        }
        DiseasePesticide treatment = knowledgeBaseService.getDiseasePesticideById(id);
        if (treatment == null) {
            return "redirect:/expert/knowledge?type=treatment";
        }
        model.addAttribute("currentExpert", expert);
        model.addAttribute("treatment", treatment);
        model.addAttribute("diseases", knowledgeBaseService.getAllDiseasesForSelect());
        model.addAttribute("pesticides", knowledgeBaseService.getAllPesticidesForSelect());
        return "expert_knowledge_treatment_form";
    }

    @PostMapping("/treatment/save")
    public String saveTreatment(DiseasePesticide treatment, RedirectAttributes redirectAttributes) {
        knowledgeBaseService.saveDiseasePesticide(treatment);
        redirectAttributes.addFlashAttribute("message", "治疗方案保存成功");
        return "redirect:/expert/knowledge?type=treatment";
    }

    @PostMapping("/treatment/delete/{id}")
    public String deleteTreatment(@PathVariable Long id, RedirectAttributes redirectAttributes) {
        knowledgeBaseService.deleteDiseasePesticide(id);
        redirectAttributes.addFlashAttribute("message", "治疗方案删除成功");
        return "redirect:/expert/knowledge?type=treatment";
    }
}
