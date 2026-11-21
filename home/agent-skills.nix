{ inputs, lib, ... }:
{
  imports = [ inputs.agent-skills.homeManagerModules.default ];

  programs.agent-skills = {
    enable = true;
    # Selection below is explicit; avoid scanning unrelated/vendor skill trees.
    sources = lib.mapAttrs (_: source: source // { filter.maxDepth = 0; }) {
      mattpocock = {
        input = "mattpocock-skills";
        subdir = "skills";
      };
      mattpocock-legacy = {
        input = "mattpocock-skills-legacy";
        subdir = "skills";
      };
      vercel = {
        input = "vercel-skills";
        subdir = "skills";
      };
      ui = {
        input = "ui-skills";
        subdir = "skills";
      };
      tui = {
        input = "tui-design-skills";
        subdir = "plugins/tui-design/skills";
      };
      # Keep the repository root: skill data/scripts may link into src/.
      ui-ux-pro-max = {
        input = "ui-ux-pro-max-skills";
      };
      # herdr = {
      #   input = "herdr";
      # };
    };

    # Explicit flat names preserve cross-skill references and avoid collisions.
    skills.explicit = {
      ask-matt = {
        from = "mattpocock";
        path = "engineering/ask-matt";
      };
      baseline-ui = {
        from = "ui";
        path = "baseline-ui";
      };
      code-review = {
        from = "mattpocock";
        path = "engineering/code-review";
      };
      codebase-design = {
        from = "mattpocock";
        path = "engineering/codebase-design";
      };
      diagnosing-bugs = {
        from = "mattpocock";
        path = "engineering/diagnosing-bugs";
      };
      domain-modeling = {
        from = "mattpocock";
        path = "engineering/domain-modeling";
      };
      find-skills = {
        from = "vercel";
        path = "find-skills";
      };
      grill-me = {
        from = "mattpocock";
        path = "productivity/grill-me";
      };
      grill-with-docs = {
        from = "mattpocock";
        path = "engineering/grill-with-docs";
      };
      grilling = {
        from = "mattpocock";
        path = "productivity/grilling";
      };
      handoff = {
        from = "mattpocock";
        path = "productivity/handoff";
      };
      # herdr = {
      #   from = "herdr";
      #   path = "skills/herdr";
      # };
      # herdr-pre-release-audit = {
      #   from = "herdr";
      #   path = ".agents/skills/herdr-pre-release-audit";
      # };
      # herdr-throwaway-repro = {
      #   from = "herdr";
      #   path = ".agents/skills/herdr-throwaway-repro";
      # };
      implement = {
        from = "mattpocock";
        path = "engineering/implement";
      };
      improve-codebase-architecture = {
        from = "mattpocock";
        path = "engineering/improve-codebase-architecture";
      };
      prototype = {
        from = "mattpocock";
        path = "engineering/prototype";
      };
      research = {
        from = "mattpocock";
        path = "engineering/research";
      };
      resolving-merge-conflicts = {
        from = "mattpocock-legacy";
        path = "engineering/resolving-merge-conflicts";
      };
      setup-matt-pocock-skills = {
        from = "mattpocock";
        path = "engineering/setup-matt-pocock-skills";
      };
      tdd = {
        from = "mattpocock";
        path = "engineering/tdd";
      };
      teach = {
        from = "mattpocock";
        path = "productivity/teach";
      };
      to-questionnaire = {
        from = "mattpocock";
        path = "productivity/to-questionnaire";
      };
      to-spec = {
        from = "mattpocock";
        path = "engineering/to-spec";
      };
      to-tickets = {
        from = "mattpocock";
        path = "engineering/to-tickets";
      };
      # triage = {
      #   from = "herdr";
      #   path = ".agents/skills/triage";
      # };
      tui-design = {
        from = "tui";
        path = "tui-design";
      };
      ui-ux-pro-max = {
        from = "ui-ux-pro-max";
        path = ".claude/skills/ui-ux-pro-max";
      };
      wait-what = {
        from = "mattpocock";
        path = "productivity/wait-what";
      };
      wayfinder = {
        from = "mattpocock";
        path = "engineering/wayfinder";
      };
      wizard = {
        from = "mattpocock";
        path = "engineering/wizard";
      };
      writing-for-agents = {
        from = "mattpocock";
        path = "productivity/writing-for-agents";
      };
    };

    # Codex reads the shared directory directly; no duplicate codex target.
    # Individual links preserve app-generated skills and Claude's synced folder.
    targets = {
      agents = {
        enable = true;
        dest = ".agents/skills";
        structure = "link";
      };
      claude = {
        enable = true;
        dest = ".claude/skills";
        structure = "link";
      };
    };
  };
}
