local k = StaticFindObject("/Script/Engine.Default__KismetSystemLibrary")
local w = FindFirstOf("World")
k:ExecuteConsoleCommand(w, "hs:ai_place sq_bridge_keyes", nil)
return "placed"
