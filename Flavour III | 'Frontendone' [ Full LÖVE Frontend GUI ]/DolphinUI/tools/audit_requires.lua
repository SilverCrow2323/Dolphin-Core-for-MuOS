local function file_exists(p)
  local f = io.open(p, "r"); if f then f:close(); return true end; return false
end
local function is_dir(p)
  local h = io.popen('[ -d "' .. p .. '" ] && echo 1 2>/dev/null')
  if not h then return false end
  local r = h:read("*a"); h:close(); return r:match("1") ~= nil
end

local h = io.popen('find frontend -name "*.lua" -type f 2>/dev/null')
local files = {}
for line in h:lines() do files[#files+1] = line end
h:close()

local missing = {}
local total = 0
local skip = { love = true, lua = true, json = true }

for _, file in ipairs(files) do
  local f = io.open(file, "r")
  if f then
    for line in f:lines() do
      for mod in line:gmatch('require%s*%(%s*["\']([^"\']+)["\']%s*%)') do
        local first = mod:match("^([^.]+)")
        if not skip[first] then
          total = total + 1
          local path1 = mod:gsub("%.", "/") .. ".lua"
          local path2 = mod:gsub("%.", "/") .. "/init.lua"
          local found = false
          for _, base in ipairs({ "frontend/", "" }) do
            if file_exists(base .. path1) or file_exists(base .. path2) then
              found = true; break
            end
            if is_dir(base .. mod:gsub("%.", "/")) then
              found = true; break
            end
          end
          if not found then
            missing[#missing+1] = { file = file, mod = mod }
          end
        end
      end
    end
    f:close()
  end
end

print(("Checked %d require() across %d files"):format(total, #files))
if #missing == 0 then print("OK: no missing requires"); os.exit(0) end
print("")
print("MISSING REQUIRES:")
for _, m in ipairs(missing) do
  print(("  %s  ->  %s"):format(m.file, m.mod))
end
os.exit(1)
