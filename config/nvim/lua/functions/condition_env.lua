local M = {}
M.enabled_llm = function(hostname)
    return exist_llm_envvar
end
