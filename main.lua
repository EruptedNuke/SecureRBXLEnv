local ScriptContextService = game:GetService("ScriptContext")
local ContentProvider = game:GetService("ContentProvider")
local CoreGuiService = game:GetService("CoreGui")


local SecurePrint = secureprint or print 
local GetActors = getactors or syn.getactors
local RunOnActor = run_on_actor or syn.run_on_actor

local OldPreloadAsync

for i,v in pairs(getconnections(ScriptContextService.Error)) do 
    v:Disable()
end

OldPreloadAsync = hookfunction(ContentProvider.PreloadAsync, function(self, ...)
    local args = {...}

    if not args[1] or typeof(args[1]) ~= "table" then 
        return OldPreloadAsync(self, ...)
    end

    local OriginalThreadIdentity = getthreadidentity()

    if(OriginalThreadIdentity~=4) then 
      setthreadidentity(4)
    end

    local TryingToAccessCoreGui = false 

    for i,v in pairs(args[1]) do 
      if typeof(v) == "Instance" and v == CoreGuiService then 
          TryingToAccessCoreGui = true --// ok dude 
        end
    end

    setthreadidentity(OriginalThreadIdentity)
    
    if TryingToAccessCoreGui == true then 
      local CallingScript = getcallingscript()
      SecurePrint("Game tried to access coregui ",CallingScript.Name)
       return {}
    end

    return OldPreloadAsync(self, ...)
end)


